*** Settings ***
Library   Browser
Library   Collections


*** Keywords ***
open the page
    New Browser    chromium    headless=false
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${URL}
    Wait Until Network Is Idle

accept cookies
    Wait For Elements State    ${accept_cookies}    state=visible
    Click                      ${accept_cookies} 

get items 
    
    ${companies_name_list}    Create List
    ${companies_link_list}    Create List

    ${count}    Get Element Count    ${company_classes}
    FOR  ${x}  IN RANGE  ${count}

        ${companies}    Get Elements    ${company_classes}
        ${elem}    Get From List    ${companies}    ${x}
        ${value_caompany}    Get Text    ${elem}
        Append To List    ${companies_name_list}    ${value_caompany}

        ${companies}    Get Elements    ${link_classes}
        ${elem}    Get From List    ${companies}    ${x}
        ${value_url}    Get Property    ${elem}    href
        Append To List    ${companies_link_list}    ${value_url}
        
    END

    ${dict}    Evaluate    {index: [name,link] for index, (name,link) in enumerate(zip(${companies_name_list},${companies_link_list}))}
    [RETURN]    ${dict}
    
search for company
    [Arguments]    ${target}
    
    ${dict}    get items
    ${result}    Evaluate    next((val for val in ${dict}.values() if "${target}" in val), None)
    
    IF  $result != ${None} and $result[0] == "${target}"
        Log    ${result}[0] is looking for a new job at: \n${result}[1]   level=WARN
    ELSE
        Log    Sh!t
    END


*** Test Cases ***

open page and detect company
    open the page
    accept cookies
    search for company       <Target Company>

                                   
