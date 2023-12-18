
from winotify import Notification


def show_message(company,link):

    toast = Notification(
        app_id="New Workplace",
        title=company,
        msg=f"This {company} is looking for new Job",
        duration="long")


    toast.add_actions(label="Open it",launch=link)
    toast.show()

