int getPriorityFromCategory(String category) {
  switch (category) {
    case "Security Issues":
      return 1;
    case "Authentication Issues":
      return 2;
    case "Technical Issues":
      return 3;
    case "Hardware Issues":
      return 4;
    case "Connection Issues":
      return 5;
    default:
      return 6;
  }
}
