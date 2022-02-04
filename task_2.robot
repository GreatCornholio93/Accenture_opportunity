*** Settings ***
Library  SeleniumLibrary
Suite Setup     Open browser    ${URL}   ${BROWSER}
Suite Teardown  Close All Browsers
*** Variables ***
${BROWSER}          chrome
${URL}       https://www.datart.cz/

${cookies_dialog}   id:cm
${cookies_dialog_accept}    id:c-p-bn

${shop_category}    link:Elektromobilita
${shop_subcategory}     link:Hoverboardy
${shop_add_to_cart}     //button[@class='btn btn-cart ajax']
${shop_cart}   xpath=//a[@href="/kosik"]
${shop_product_cart_item}   class:basket-product-wrap

# order by options:
# biggest sale - 9
# the most expensive - 4
# the most cheapest - 3
# bestsellers - 10
# recommended - 8
${shop_order_option}    4

${count_of_items_to_add}    2
${index}

*** Test Cases ***
Add most expensive items into cart
    Maximize Browser Window
    Handle cookies
    Go to category
    Go to subcategory
    Sort products
    Iterate through the product and add them into cart
    Validate cart

***Keywords***
    Handle cookies
        # Close cookies dialog by approving it
        Wait Until Element Is Visible   ${cookies_dialog}
        Click Button    ${cookies_dialog_accept}

    Go to category
        Click Element   ${shop_category}
    
    Go to subcategory
        # Just to be sure that subcategories were fetched from the API
        Wait Until Element Is Visible  class:category-tree-box-list
        Click Element   ${shop_subcategory}

    Sort products
        Select From List By Value   name:orderBy    ${shop_order_option}
        # Wait for data to be properly sorted
        BuiltIn.Sleep   1s

    Iterate through the product and add them into cart
        ${products}=    Get WebElements    ${shop_add_to_cart}
        ${index}=   BuiltIn.Set Variable    1
        FOR    ${product}    IN    @{products}
            Scroll Element Into View    ${product}
            Exit For Loop If    ${index} > ${count_of_items_to_add}
            Click Button    ${product}
            BuiltIn.Sleep   1s
            Press Keys    None    ESC
            ${index}=   Evaluate    ${index} + 1
        END

    Validate cart
        Click Element   ${shop_cart}
        # Get count of items from cart and compare it to the expected amount
        ${count}=  Get Element Count   ${shop_product_cart_item}
        Should Be True  ${count} == ${count_of_items_to_add}
