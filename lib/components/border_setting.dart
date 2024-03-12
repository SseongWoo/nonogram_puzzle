class BorderSettingClass {
  double borderTop;
  double borderBottom;
  double borderLeft;
  double borderRight;

  BorderSettingClass(
      this.borderTop, this.borderBottom, this.borderLeft, this.borderRight);
}

BorderSettingClass borderSetting(int row, int col, int hw) {
  double borderTop = 0.5,
      borderBottom = 0.5,
      borderLeft = 0.5,
      borderRight = 0.5;

  if (row % 5 == 0) {
    borderTop = 2.0;
  }
  if (col % 5 == 0) {
    borderLeft = 2.0;
  }
  if (row == hw - 1) {
    borderBottom = 2.0;
  }
  if (col == hw - 1) {
    borderRight = 2.0;
  }

  return BorderSettingClass(borderTop, borderBottom, borderLeft, borderRight);
}