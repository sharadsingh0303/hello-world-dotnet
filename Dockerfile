# Step 1: Use .NET Core 2.1 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build-env
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:80
# Step 2: Copy the solution file and restore dependencies
COPY dotnet-hello-world.sln ./
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore

# Step 3: Copy the application source code and build
COPY . ./
RUN mkdir -p /out
RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /out

# Step 4: Use ASP.NET Core 2.1 runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build-env /out .

# Step 5: Expose necessary ports
EXPOSE 80

# Step 6: Set the entry point
ENTRYPOINT ["dotnet", "hello-world-api.dll"]

