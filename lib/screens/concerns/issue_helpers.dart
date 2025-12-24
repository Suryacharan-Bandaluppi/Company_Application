int getPriorityFromCategory(String category) {
  switch (category) {
    case "Security Concern":
      return 1;
    case "Authentication Issues":
      return 2;
    case "Technical Issues":
      return 3;
    case "Hardware Issues":
      return 4;
    default:
      return 5;
  }
}
