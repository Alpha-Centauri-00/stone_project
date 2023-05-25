import config

from playwright.sync_api import Page
from winotify import Notification
from selectolax.parser import HTMLParser

def parsing_items(html_page):
    results = []
    html = HTMLParser(html_page)
    data = html.css(config.ARTICLE_CLASS)
    for item in data:
        collections = {
            "company":item.css_first(config.COMPANY_CLASS).text(),
            "title": item.css_first(config.TITLE_CLASS).text(),
            "link": item.css_first(config.LINK_CLASS).attributes["href"],

        }
        results.append(collections)
    return results

def test_open_stone(page:Page):
    
    page.goto(config.SEARCHING_LINK,wait_until="networkidle")
    page.get_by_text("Alles akzeptieren").click()

    Datas = parsing_items(page.content())
    for x in Datas:

        if config.TARGET_COMPANY in x["company"]:
            toast = Notification(
                app_id=config.APP_ID,
                title=x["title"],
                msg=f"{x['company']}{config.MESSAGE}",
                duration="long")
            toast.add_actions(label="Open it",launch=f"{config.MAIN_LINK}{x['link']}")
            toast.show()


