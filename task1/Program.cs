var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
// UTC Startup time
var appStart = DateTime.UtcNow;
// Simple pong endpoint to create app start time in UTC 
app.MapGet("/pong", () => appStart);

app.Run();