import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-calculator',
  standalone: true,
  imports: [CommonModule, FormsModule],  // ✅ Import necessary modules
  templateUrl: './calculator.component.html',
  styleUrls: ['./calculator.component.css']
})
export class CalculatorComponent {
  display: string = "";
  buttons: string[] = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
    'C'
  ];

  onButtonClick(value: string) {
  if (value === '=') {
    try {
      this.display = new Function('return ' + this.display)();  // ✅ Safe alternative to eval()
    } catch {
      this.display = "Error";
    }
  } else if (value === 'C') {
    this.display = "";  // ✅ Clear the display
  } else {
    this.display += value;
  }
}

}
