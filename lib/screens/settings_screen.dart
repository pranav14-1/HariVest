import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  void _handleSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // TODO: Remove user token from storage if needed
              // TODO: Navigate to SignIn screen (replace below with your routing)
              _showAlert(context, "Signed Out", "You have been signed out.");
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String screenName) {
    // TODO: Replace with your navigation logic
    _showAlert(context, "Navigation", "Would navigate to: $screenName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF29ca9f), Color(0xFFFBE2BA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.6],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(top: 20, bottom: 25),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0x99367263),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Color(0x4D000000),
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Account Section
                        _section(
                          "Account",
                          [
                            _settingItem(
                              icon: "👤",
                              iconColor: const Color(0xFFFBBF24),
                              label: "Edit Profile",
                              onTap: () => _navigateTo(context, "EditProfile"),
                            ),
                            _settingItem(
                              icon: "🔑",
                              iconColor: const Color(0xFFF59E0B),
                              label: "Change Password",
                              onTap: () => _navigateTo(context, "ChangePassword"),
                            ),
                          ],
                        ),
                        // General Section
                        _section(
                          "General",
                          [
                            _settingItem(
                              icon: "🔔",
                              iconColor: const Color(0xFF3B82F6),
                              label: "Notifications",
                              onTap: () => _showAlert(context, "Notifications", "Go to notification settings"),
                            ),
                            _settingItem(
                              icon: "🌐",
                              iconColor: const Color(0xFFEF4444),
                              label: "Language",
                              onTap: () => _showAlert(context, "Language", "Change app language"),
                            ),
                            _settingItem(
                              icon: "📏",
                              iconColor: const Color(0xFF8B5CF6),
                              label: "Units of Measurement",
                              onTap: () => _showAlert(context, "Units of Measurement", "Change measurement units"),
                            ),
                          ],
                        ),
                        // Legal & About Section
                        _section(
                          "Legal & About",
                          [
                            _settingItem(
                              icon: "📄",
                              iconColor: const Color(0xFF6B7280),
                              label: "Privacy Policy",
                              onTap: () => _showAlert(context, "Privacy Policy", "Show privacy policy"),
                            ),
                            _settingItem(
                              icon: "⚖️",
                              iconColor: const Color(0xFF6B7280),
                              label: "Terms of Service",
                              onTap: () => _showAlert(context, "Terms of Service", "Show terms of service"),
                            ),
                            _settingItem(
                              icon: "❓",
                              iconColor: const Color(0xFFFBBF24),
                              label: "Help & Support",
                              onTap: () => _showAlert(context, "Help & Support", "Get help and support"),
                            ),
                            _settingItem(
                              icon: "📱",
                              iconColor: const Color(0xFF9CA3AF),
                              label: "App Version",
                              trailing: const Text("v1.0.0", style: TextStyle(fontSize: 14, color: Color(0xFF888888))),
                              onTap: null,
                            ),
                          ],
                        ),
                        // Sign Out Button
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              elevation: 5,
                              shadowColor: const Color(0xFFDC2626),
                            ),
                            onPressed: () => _handleSignOut(context),
                            child: const Text(
                              "Sign Out",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: const Border(bottom: BorderSide(color: Color(0x1A000000))),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _settingItem({
    required String icon,
    required Color iconColor,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 20, color: iconColor), textAlign: TextAlign.center),
            const SizedBox(width: 15),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF333333))),
            ),
            trailing ??
                const Icon(Icons.chevron_right, color: Color(0xFF777777), size: 20),
          ],
        ),
      ),
    );
  }
}
