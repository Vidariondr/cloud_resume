import re
from playwright.sync_api import Page, expect

def test_has_title(page: Page):
    page.goto("https://jkaszczuk.com")
    expect(page).to_have_title(re.compile("Jakub Kaszczuk - Resume"))

def test_visitor_counter_value_changes(page: Page):
    page.goto("https://jkaszczuk.com")
    initial_value = int(page.locator("#counter").inner_text())

    page.goto("https://jkaszczuk.com")
    changed_value = page.locator("#counter")
    
    expect(changed_value).not_to_have_text(str(initial_value))