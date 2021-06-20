abstract class EnvConfig {
  static const baseUrl = String.fromEnvironment('baseUrl', defaultValue: 'http://localhost:55440');
}
