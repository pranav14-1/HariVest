import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Fetches a concise treatment recommendation for a given plant disease
/// using the Gemini generative AI API.
/// 
/// Returns a short, practical string (or an error message if the API fails).
Future<String> generateTreatmentWithGemini(String? disease) async {
  if (disease == null || disease.trim().isEmpty) {
    return 'No disease detected. Please analyze a plant first.';
  }

  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    return 'Gemini API key not found. Please check your configuration.';
  }

  final GenerativeModel geminiModel = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final String prompt =
      "You are an expert Indian agricultural advisor. "
      "In 2-3 sentences, give a concise, practical treatment for the following plant disease: \"$disease\". "
      "Be clear and actionable. If the disease is unknown, say so.";

  try {
    final response = await geminiModel.generateContent([
      Content.text(prompt),
    ]);
    final answer = response.text?.trim();
    if (answer == null || answer.isEmpty) {
      return "Sorry, I couldn't find a treatment for this disease.";
    }
    return answer;
  } catch (e) {
    return "Error fetching treatment: ${e.toString()}";
  }
}
