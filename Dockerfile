
# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

# Copy project file
COPY ["InsuranceAPI.csproj", "./"]

# Restore NuGet packages
RUN dotnet restore "InsuranceAPI.csproj"

# Copy source code
COPY . .

# Publish application
RUN dotnet publish "InsuranceAPI.csproj" \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

COPY --from=build /app/publish .

# Application listens on port 8080
ENV ASPNETCORE_URLS=http://+:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "InsuranceAPI.dll"]
