import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import httpx
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel
from pydantic_settings import BaseSettings, SettingsConfigDict
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
import resend



# ==========================
# Settings
# ==========================

security = HTTPBearer()

class Settings(BaseSettings):

    RESEND_API_KEY: str

    FROM_EMAIL: str

    APP_SECRET: str

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore",
    )


settings = Settings()
resend.api_key = settings.RESEND_API_KEY

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

    response =resend.Emails.send({
        "from": "onboarding@resend.dev",
        "to": [to_email],
        "subject": f"📲 {app_name}",

        "html": f"""
        <div style="font-family:Arial;padding:20px">

            <h2>Notification Forwarded</h2>

            <table border="1" cellpadding="10" cellspacing="0">

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

        </div>
        """
    })
    print(response)
    


# ==========================
# Routes
# ==========================

@app.get("/")
def home():
    return {
        "message": "Notification Forwarder API Running 🚀"
    }
@app.post("/forward")
async def forward_notification(
    data: NotificationRequest,
    credentials: HTTPAuthorizationCredentials = Depends(security),
):

    if credentials.credentials != settings.APP_SECRET:
        raise HTTPException(
            status_code=401,
            detail="Unauthorized"
        )

    await send_email(
        to_email=data.email,
        app_name=data.app,
        title=data.title,
        message=data.message,
    )
    return {
        "success": True
    }