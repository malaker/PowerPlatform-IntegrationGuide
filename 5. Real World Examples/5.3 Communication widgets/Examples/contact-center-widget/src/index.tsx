import React from 'react';
import ReactDOM from 'react-dom/client';
import './styles.css';

import { ContactCenterWidget } from './ContactCenterWidget';

// Initialize function for CIF v2
export function initialize(containerId: string) {
  const container = document.getElementById(containerId);
  if (container) {
    const root = ReactDOM.createRoot(container);
    root.render(<ContactCenterWidget />);
  }
}

const init = () => {
  const container = document.getElementById('contact-center-widget');
  if (container) {
    initialize('contact-center-widget');
  }
}

if (!document.getElementById('contact-center-widget')) {
  // Auto-initialize if element exists
  if (typeof window !== 'undefined') {
    debugger;
    console.log("DUPA123");
    window.addEventListener('DOMContentLoaded', () => {
      init();
    });
  }
}else{
  console.log("DUPA1234");
  debugger;
  init();
}

