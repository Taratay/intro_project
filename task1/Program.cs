var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();
// UTC Startup time
var appStart = DateTime.UtcNow;
//
app.MapGet("/pong", () => appStart);

app.Run();