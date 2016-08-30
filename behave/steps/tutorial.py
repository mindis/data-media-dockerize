from behave import *

@given('we have behave installed')
def step_impl(context):
    context.browser.get('http://google.com')
    pass

@when('we implement a test')
def step_impl(context):
    elements = find_elements(context.browser, id='no-account')
    print(elements)
    assert True is not False

@then('behave will test it for us!')
def step_impl(context):
    assert context.failed is False
