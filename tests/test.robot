*** Settings ***
Library   Browser
Library   Collections
Variables    config.py


*** Keywords ***
open the page
    New Browser    chromium    headless=false
    New Context    viewport={'width': 1920, 'height': 1080}
    New Page       ${SEARCHING_LINK}
    Wait Until Network Is Idle
    accept cookies

accept cookies
    Wait For Elements State    ${ACCEPTING_COOKY}    state=visible
    Click                      ${ACCEPTING_COOKY} 

get items
    ${companies_name_list}    Create List
    ${companies_link_list}    Create List
    
    ${count}    Get Element Count    ${COMPANY_CLASS}
    FOR  ${x}  IN RANGE  ${count}

        ${companies}    Get Elements    ${COMPANY_CLASS}
        ${elem}    Get From List    ${companies}    ${x}
        ${value_caompany}    Get Text    ${elem}
        Append To List    ${companies_name_list}    ${value_caompany}

        ${links}    Get Elements    ${LINK_CLASS}
        ${elem}    Get From List    ${links}    ${x}
        ${value_url}    Get Property    ${elem}    href
        Append To List    ${companies_link_list}    ${value_url}
        
    END

    ${dict}    Evaluate    {index: [name,link] for index, (name,link) in enumerate(zip(${companies_name_list},${companies_link_list}))}
    
    [RETURN]    ${dict}
      
search for company
    [Arguments]    ${target}
    ${dictionary}    get items
    
    # Log    ${dictionary}
    FOR    ${key}    ${value}    IN    &{dictionary}
        
        ${condition} =    Run Keyword And Return Status    Should Contain    ${value}[0]    ${target}
        Run Keyword If    ${condition}    Log    The Company: ${value}[0] is looking for new chance at:\n${value}[1]    level=WARN 
    END


*** Test Cases ***

open page and detect company
    open the page
    search for company       <Target Company>

                                   
