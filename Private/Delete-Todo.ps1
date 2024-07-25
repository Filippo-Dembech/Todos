function Delete-Todo {
    param(
        [string]$Id,
        [string]$From,
        [switch]$FromAll
    )

    $Todos = Get-Todo -All -Raw

    $Result = @()

    if ($FromAll) {
        for ($i = 0; $i -lt $Todos.length; $i++) {
            if ($i -eq $Id) { continue }
            $Result += $Todos[$i]
        }
    } else {
        $CategoryId = 0
        for ($i = 0; $i -lt $Todos.count; $i++) {
            if ($Todos[$i].Category -eq $Category) {
                if ($CategoryId -eq $Id) {
                    $CategoryId++
                    continue
                }
                $CategoryId++
            }
            $Result += $Todos[$i]
        }
    }
    return $Result
}