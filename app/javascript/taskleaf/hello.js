import React from 'react';
import ReactDom from 'react-dom';

document.addEventListener('DOMContentLoaded', () => {
  ReactDom.render(
    React.createElement('div', null, 'React練習!'),
    document.body.appendChild(document.createElement('div')),
  );
});
