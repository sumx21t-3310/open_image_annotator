
class BubbleViewConstraints {
  final int clickLimit;
  final double bubbleRadius;
  final double blurAmount;

  const BubbleViewConstraints({
    this.bubbleRadius = 5,
    this.clickLimit = 50,
    this.blurAmount = 10,
  });

  BubbleViewConstraints copyWith({
    int? clickLimit,
    double? bubbleRadius,
    double? blurAmount,
  }) {
    return BubbleViewConstraints(
      clickLimit: clickLimit ?? this.clickLimit,
      bubbleRadius: bubbleRadius ?? this.bubbleRadius,
      blurAmount: blurAmount ?? this.blurAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "click_limit": clickLimit,
      "bubble_radius": bubbleRadius,
      "blur_amount": blurAmount,
    };
  }

  factory BubbleViewConstraints.fromMap(Map<String, dynamic> map) {
    return BubbleViewConstraints(
      clickLimit: map['click_limit'] as int? ?? 30,
      bubbleRadius: map['bubble_radius'] as double? ?? 30.0,
      blurAmount: map['blur_amount'] as double? ?? 10.0,
    );
  }

  BubbleViewConstraints deepCopy() {
    return BubbleViewConstraints(
      clickLimit: clickLimit,
      bubbleRadius: bubbleRadius,
    );
  }
}