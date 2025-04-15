class UnboardingContent{
  String image ;
  String title; 
  String descreaption;
  UnboardingContent(this.image , this.descreaption, this.title);

}

List<UnboardingContent> contentsForPages = [
  UnboardingContent(
    "images/screen1.png", 
    "Enjoy the most delicious dishes from the best restaurants near you, and choose your favorite meal easily.",
    "Delicious Meals at Your Fingertips!"
  ),
 UnboardingContent(
    "images/screen2.png", 
    "Pay securely with multiple payment options, including credit cards, e-wallets, and cash on delivery.",
    "Secure & Easy Payments!"
  ),
  UnboardingContent(
    "images/screen3.png", 
    "Fast and secure delivery service, ensuring your food arrives fresh and hot at your doorstep.",
    "Fast & Secure Delivery!"
  ),
];