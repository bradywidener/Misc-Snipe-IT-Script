#Snipe API Info
$SnipeToken = #Place your bearer token here
$SnipeAPIBase = "https://example.snipe-it.io/api/v1" #Replace with your snipe custom domain

#import CSV
$AssetTags = Import-CSV -Path "C:\Path\to\CSV" #Replace with the path to your CSV

#Loop for Checkin
ForEach($ID in $AssetTags){
    Write-Host "Checking in Asset with ID:"$ID.ID
    $Tag = $ID.ID
    #Querying Snipe for the SnipeID of the device by AssetID
    $headers=@{}
    $headers.Add("accept", "application/json")
    $headers.Add("Authorization", "$SnipeToken")
    $response = Invoke-WebRequest -Uri "$SnipeAPIBase/hardware/bytag/$Tag ?deleted=false" -Method GET -Headers $headers

    #Converting JSON to PSObject
    $PSResponse = $response.content | ConvertFrom-Json
    
    #Get the Snipe ID
    $SnipeID = $PSResponse.id

    #Attempting Checkin

    #IMPORTANT - For status_id in the web request, you have to find the ID number for your selected status in Snipe to match this.
    #For example, status ID 12 is the status ID of 'Deployable' on my site.
    #To find out the ID of the status you want to choose, go to 
    # Snipe then Settings > Status Labels > Choose your Label > then the ID is at the end of the URL

    $headers=@{}
    $headers.Add("accept", "application/json")
    $headers.Add("Authorization", "$SnipeToken")
    $response2 = Invoke-WebRequest -Uri "$SnipeAPIBase/hardware/$SnipeID/checkin" -Method POST -Headers $headers -ContentType 'application/json' -Body '{"status_id":12}'
    #adding small sleep to not overload API
    Start-Sleep -seconds .3
}

Write-Host ""
Write-Host "FINISHED CHECKING IN"