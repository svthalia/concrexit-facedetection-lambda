from io import BytesIO

import face_recognition
import requests


def handler(event, context):
    """Lambda function that will extract face encodings from a photo."""
    if not (
        isinstance(event.get("api_url"), str) and isinstance(event.get("sources"), list)
    ):
        raise ValueError("Bad event data.")

    api_url = event["api_url"]
    sources = event["sources"]

    for source in sources:
        if not (
            isinstance(source.get("pk"), int)
            and isinstance(source.get("token"), str)
            and isinstance(source.get("photo_url"), str)
            and source.get("type") in {"reference", "photo"}
        ):
            raise ValueError("Bad event data.")

    for source in sources:
        response = requests.get(source["photo_url"], timeout=15)
        response.raise_for_status()

        image = face_recognition.load_image_file(BytesIO(response.content))
        encodings = face_recognition.face_encodings(image)

        url = f"{api_url}api/facedetection/encodings/{source['type']}/{source['pk']}/"
        data = {
            "token": source["token"],
            "encodings": [list(encoding) for encoding in encodings],
        }

        requests.post(url, json=data, timeout=30)
