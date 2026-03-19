FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /App

# https://learn.microsoft.com/en-us/dotnet/core/docker/build-container?tabs=linux&pivots=dotnet-10-0
# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -o out

FROM mcr.microsoft.com/dotnet/aspnet:10.0

ENV ASPNETCORE_URLS=http://+:8080

WORKDIR /App
COPY --from=build /App/out .
ENTRYPOINT ["dotnet", "Api.dll"]