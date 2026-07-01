# import smtplib
# from email.mime.multipart import MIMEMultipart
# from email.mime.text import MIMEText
# import httpx
# from fastapi import FastAPI, Header, HTTPException
# from pydantic import BaseModel
# from pydantic_settings import BaseSettings, SettingsConfigDict
# from fastapi import FastAPI, Depends, HTTPException
# from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
# import resend



# # ==========================
# # Settings
# # ==========================

# security = HTTPBearer()

# class Settings(BaseSettings):

#     RESEND_API_KEY: str

#     FROM_EMAIL: str

#     APP_SECRET: str

#     model_config = SettingsConfigDict(
#         env_file=".env",
#         extra="ignore",
#     )


# settings = Settings()
# resend.api_key = settings.RESEND_API_KEY

# # ==========================
# # FastAPI
# # ==========================

# app = FastAPI(
#     title="Notification Forwarder API",
#     version="1.0.0",
# )

# # ==========================
# # Request Model
# # ==========================


# class NotificationRequest(BaseModel):
#     email: str
#     app: str
#     title: str
#     message: str


# # ==========================
# # Send Email
# # ==========================
# async def send_email(
#     to_email: str,
#     app_name: str,
#     title: str,
#     message: str,
# ):

#     response =resend.Emails.send({
#         "from": "onboarding@resend.dev",
#         "to": [to_email],
#         "subject": f"📲 {app_name}",

#         "html": f"""
#         <div style="font-family:Arial;padding:20px">

#             <h2>Notification Forwarded</h2>

#             <table border="1" cellpadding="10" cellspacing="0">

#                 <tr>
#                     <td><b>Application</b></td>
#                     <td>{app_name}</td>
#                 </tr>

#                 <tr>
#                     <td><b>Title</b></td>
#                     <td>{title}</td>
#                 </tr>

#                 <tr>
#                     <td><b>Message</b></td>
#                     <td>{message}</td>
#                 </tr>

#             </table>

#         </div>
#         """
#     })
#     print(response)
    


# # ==========================
# # Routes
# # ==========================

# @app.get("/")
# def home():
#     return {
#         "message": "Notification Forwarder API Running 🚀"
#     }
# @app.post("/forward")
# async def forward_notification(
#     data: NotificationRequest,
#     credentials: HTTPAuthorizationCredentials = Depends(security),
# ):

#     if credentials.credentials != settings.APP_SECRET:
#         raise HTTPException(
#             status_code=401,
#             detail="Unauthorized"
#         )

#     await send_email(
#         to_email=data.email,
#         app_name=data.app,
#         title=data.title,
#         message=data.message,
#     )
#     return {
#         "success": True
#     }
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel
from pydantic_settings import BaseSettings, SettingsConfigDict
import httpx


# ==========================
# Settings
# ==========================

class Settings(BaseSettings):
    BREVO_API_URL: str
    BREVO_API_KEY: str

    BREVO_SENDER_EMAIL: str
    BREVO_SENDER_NAME: str

    APP_SECRET: str

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
    )


settings = Settings()
print(settings.APP_SECRET)
security = HTTPBearer()


# ==========================
# FastAPI
# ==========================

app = FastAPI(
    title="Notification Forwarder API",
    version="1.0.0",
)


# ==========================
# Request Model
# ==========================

class NotificationRequest(BaseModel):
    email: str
    app: str
    title: str
    message: str


# ==========================
# Send Email
# ==========================

async def send_email(
    to_email: str,
    app_name: str,
    title: str,
    message: str,
):

    payload = {
        "sender": {
            "name": settings.BREVO_SENDER_NAME,
            "email": settings.BREVO_SENDER_EMAIL,
        },
        "to": [
            {
                "email": to_email,
            }
        ],
        "subject": f"📲 {app_name} Notification",
        "htmlContent": f"""
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
body {{
    font-family: Arial, Helvetica, sans-serif;
    background: #f5f5f5;
    padding: 30px;
}}

.card {{
    background: white;
    border-radius: 10px;
    padding: 24px;
    max-width: 650px;
    margin: auto;
    box-shadow: 0 2px 10px rgba(0,0,0,.1);
}}

table {{
    width:100%;
    border-collapse: collapse;
}}

td {{
    padding:12px;
    border:1px solid #ddd;
}}

h2 {{
    color:#2563eb;
}}
</style>
</head>

<body>

<div class="card">

<h2>📲 Notification Forwarded</h2>

<p>Your Android device forwarded the following notification.</p>

<table>

<tr>
<td><b>Application</b></td>
<td>{app_name}</td>
</tr>

<tr>
<td><b>Title</b></td>
<td>{title}</td>
</tr>

<tr>
<td><b>Message</b></td>
<td>{message}</td>
</tr>

</table>

<br>

<p style="color:gray;font-size:13px">
Generated automatically by PitWatch Notification Forwarder.
</p>

</div>

</body>

</html>
""",
    }

    async with httpx.AsyncClient(timeout=30) as client:

        response = await client.post(
            settings.BREVO_API_URL,
            headers={
                "accept": "application/json",
                "content-type": "application/json",
                "api-key": settings.BREVO_API_KEY,
            },
            json=payload,
        )

    print("Brevo Status:", response.status_code)
    print("Brevo Response:", response.text)

    response.raise_for_status()


# ==========================
# Routes
# ==========================

@app.get("/")
def home():
    return {
        "status": "running",
        "service": "Notification Forwarder API",
    }


@app.post("/forward")
async def forward_notification(
    data: NotificationRequest,
    credentials: HTTPAuthorizationCredentials = Depends(security),
):

    if credentials.credentials != settings.APP_SECRET:
        raise HTTPException(
            status_code=401,
            detail="Unauthorized",
        )

    await send_email(
        to_email=data.email,
        app_name=data.app,
        title=data.title,
        message=data.message,
    )

    return {
        "success": True,
        "message": "Notification forwarded successfully",
    }