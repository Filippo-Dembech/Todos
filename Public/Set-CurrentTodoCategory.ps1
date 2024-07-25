<#
.SYNOPSIS
    Sets the current TODO category.

.DESCRIPTION
    The Set-CurrentTodoCategory function updates the current TODO category by saving the specified category to a JSON file. This category is used as the default category for new TODO items and for other operations that rely on the current category.
    To get the current todo category use the function 'Get-CurrentTodoCategory'.

.PARAMETER Category
    The category to set as the current TODO category. This parameter is mandatory.

.EXAMPLE
    Set-CurrentTodoCategory -Category "Work"

    Sets the current TODO category to "Work".

.EXAMPLE
    Set-CurrentTodoCategory -Category "Home"

    Sets the current TODO category to "Home".

#>
function Set-CurrentTodoCategory {
    param(
        [Parameter(
            Mandatory,
            Position = 0
        )]
        [string]$Category
    )

    $Json = @{
        currentCategory = $Category
    } | ConvertTo-Json

    Set-Content "$PSScriptRoot\..\Utils\current_category.json" -Value $Json

}