workflow Use-SqlCommandSample 
{ 
    param( 
        [parameter(Mandatory=$True)] 
        [string] $SqlServer, 
         
        [parameter(Mandatory=$False)] 
        [int] $SqlServerPort = 1433, 
         
        [parameter(Mandatory=$True)] 
        [string] $Database, 
         
        [parameter(Mandatory=$True)] 
        [string] $Table, 
         
        [parameter(Mandatory=$True)] 
        [PSCredential] $SqlCredential 
    ) 
 
 # Get the username and password from the SQL Credential 
 $SqlUsername = $SqlCredential.UserName 
  $SqlPass = $SqlCredential.GetNetworkCredential().Password 
     
    inlinescript { 
        # Define the connection to the SQL Database 
        $Conn = New-Object System.Data.SqlClient.SqlConnection("Server=tcp:$using:SqlServer,$using:SqlServerPort;Database=$using:Database;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;") 
         
        # Open the SQL connection 
        $Conn.Open() 
 
        # Define the SQL command to run. In this case we are getting the number of rows in the table 
        $Cmd=new-object system.Data.SqlClient.SqlCommand("SELECT * from dbo.$using:Table", $Conn) 
        $Cmd.CommandTimeout=120 
 
        # Execute the SQL command 
        $Ds=New-Object system.Data.DataSet 
        $Da=New-Object system.Data.SqlClient.SqlDataAdapter($Cmd) 
        [void]$Da.fill($Ds) 
 
        # Output the count 
        $Ds.Tables.Column1 
 
        # Close the SQL connection 
        $Conn.Close() 
    } 
}