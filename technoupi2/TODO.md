# TODO: Integrate Backend with Frontend

## Step 1: Create API Service Classes
- [ ] Create `lib/services/api_service.dart` for HTTP requests
- [ ] Create `lib/services/auth_service.dart` for authentication
- [ ] Add proper error handling and response parsing

## Step 2: Update Models
- [ ] Update `lib/models/user.dart` to match backend User model
- [ ] Update `lib/models/transaction.dart` to match backend Transaction model
- [ ] Add fromJson/toJson methods for API integration

## Step 3: Update AuthProvider
- [ ] Modify `lib/providers/auth_provider.dart` to use real API calls
- [ ] Implement JWT token storage and management
- [ ] Update login/logout logic

## Step 4: Update Screens
- [ ] Update `login_screen.dart` to use real authentication
- [ ] Update `home_screen.dart` to fetch real user data and transactions
- [ ] Update `payment_screen.dart` to make real payments
- [ ] Update `history_screen.dart` to show real transaction history

## Step 5: Add Configuration
- [ ] Create `lib/config/api_config.dart` for API endpoints
- [ ] Add environment variables for backend URL

## Step 6: Testing and Error Handling
- [ ] Test all API integrations
- [ ] Add proper loading states and error messages
- [ ] Verify blockchain transactions work end-to-end
