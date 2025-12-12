# Tax File Management System

A comprehensive SwiftUI iOS app for tax file management with dual-role authentication (Admin/Customer), Core Data persistence, geocoding integration, and full CRUD operations. Built for final college iOS development assignment demonstrating enterprise-level app architecture.

## Features

**Authentication & Role-Based Access**
- Secure login for Admin (adnan7/test123) and Customers with username/password validation
- NavigationStack with dynamic routing to role-specific home screens
- Pre-seeded admin account with customer self-registration

**Admin Dashboard**
- Complete customer list with status badges (AWAITED, ONBOARDED, COMPLETED, DENIED, etc.)
- Color-coded rows, swipe-to-delete, and detailed customer profiles
- Real-time customer management with visual status indicators

**Customer Portal**
- Comprehensive profile editing across 15+ fields (personal, address, company info)
- Forward geocoding integration for address-to-coordinates conversion
- Form validation preventing empty submissions with loading states

**Core Data Architecture**
- Complex entity relationships: Customer → Address → Geo, Customer → Company
- Centralized `CoreDataHelper` for all CRUD operations and validation
- Persistent storage across app restarts with proper error handling

## Tech Stack
- SwiftUI NavigationStack with enum-based routing
- Core Data with custom entities and relationship mapping
- Forward geocoding via `GeocodingManager` for lat/lng conversion
- `@ObservedObject` and `@StateObject` for reactive data flow

## Screenshots
<img width="401" height="815" alt="image" src="https://github.com/user-attachments/assets/8d23c3b5-adc3-4d05-83c2-db141e59b329" />
<img width="388" height="817" alt="image" src="https://github.com/user-attachments/assets/c3a22bf7-7ff1-4430-a3cf-5532266f13b4" />
<img width="403" height="819" alt="image" src="https://github.com/user-attachments/assets/0e7a3c62-28d8-4793-932d-441a65e8ab6e" />
<img width="409" height="826" alt="image" src="https://github.com/user-attachments/assets/19be9b20-f499-4074-99f6-2f81908eac06" />
<img width="393" height="825" alt="image" src="https://github.com/user-attachments/assets/57c4d535-05fc-47a2-aba3-7d3f4341f344" />
<img width="395" height="812" alt="image" src="https://github.com/user-attachments/assets/b04ccf43-ede2-4921-93ef-0065c9832ce7" />
<img width="391" height="818" alt="image" src="https://github.com/user-attachments/assets/ad835c64-ba14-4c7a-ba6f-6216417a13bc" />
<img width="402" height="822" alt="image" src="https://github.com/user-attachments/assets/e2934a19-45d5-4d3f-b497-6bee2e30a111" />
<img width="404" height="825" alt="image" src="https://github.com/user-attachments/assets/259c6842-dfb6-44f8-a698-ed22c28fd6fb" />



## Development Approach
Architected as production-ready enterprise app with strict separation of concerns—`CoreDataHelper` centralizes all persistence logic, views focus purely on UI/state. Implemented robust validation across all forms, edge case handling for geocoding failures, and color-coded visual feedback. Modular design enables easy extension for additional roles/features.


Run directly in Xcode simulator—includes seeded admin account, all data persists locally with no external dependencies.
