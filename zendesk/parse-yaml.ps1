$intro = @"

          %%%%%%%%%%%%%%        
        %%%%           %%       
       %%  %%/          %%%     
     #%(     %%           %%  
    %%        %%/          %%   
   %%          /%%%%%%%%%%%%%   SNOWPLOW'S OPSDOCS 
    %%.       %%,          %%   ~~~~~~~~~~~~~~~~~~~
     (%%    .%%          ,%% 
       %%. %%*          %%(  
        %%%%           %%    
          %%%%%%%%%%%%%% 

"@

function convertTo-fileName ($docTitle) {
    #aim: convert "Document Title" into "Document-Title.md"
    $fileName = ("$docTitle" -replace "\s", "-") -replace ".+", "$&.md"
    return $fileName
}
function create-NewDoc($filename) {
    #aim: populate the newly created file with a template
    $templatePath = "C:\Users\Admin\Documents\workspace\SNOW\opsdocs\zendesk\template.md"
    $filePath = "C:\Users\Admin\Documents\workspace\SNOW\opsdocs\demo\$filename"
    $template = Get-Content $templatePath
    Set-Content $filePath -Value  $template
    Invoke-Item $filePath
}
function update-configFile($docTitle, $fileName) {
    #aim: create a new node in the config.yaml and populate it with doc title and file path
    $conf = "C:\Users\Admin\Documents\workspace\SNOW\opsdocs\zendesk\config.yaml"
    $existingDocs = gc $conf | ConvertFrom-Yaml -Ordered
    $newDoc = @([ordered]@{
            id      = $null; 
            title   = "$docTitle"; 
            file    = "../demo/$fileName"; 
            hash    = $null 
            webLink = $null
        })
    
    $articlesHelper = $existingDocs.sections.articles
    $articlesHelper += $newDoc
    
    $existingDocs.sections[0].remove('articles')
    $existingDocs.sections[0].add('articles', $articlesHelper)
    
    ConvertTo-Yaml $existingDocs -OutFile $conf -Force
    Invoke-Item $conf
}

function publish-toZendesk {
    $scriptFolder = "c:\Users\Admin\Documents\workspace\SNOW\opsdocs\zendesk\"
    $scriptFile = "publish.js"
    Start-Process node $scriptFile -WorkingDirectory $scriptFolder 
    Write-Host "new opsdocs pushed to zendesk"
}

Write-Host $intro
$userSelection = Read-Host "PLEASE SELECT: CREATE [1] OR PUBLISH [2]"
switch ($userSelection) {
    1 { 
        $docTitle = Read-Host "Title"
        $fileName = convertTo-fileName -docTitle $docTitle
        create-NewDoc -filename $fileName
        update-configFile -docTitle $docTitle -fileName $fileName
    }
    2 { 
        publish-toZendesk
    }
}