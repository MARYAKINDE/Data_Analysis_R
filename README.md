# College Information Analysis 

## Overview

This project is a comprehensive R Shiny application designed to analyze and visualize college student data. The application aims to provide insights into various key performance metrics such as retention rates, attrition rates, admission rates, average salary post-graduation, and completion rates.

## Features

- **Retention Rate Analysis**: Understand how many students continue their studies year over year.
- **Attrition Rate Analysis**: Identify the number of students who leave before completing their studies.
- **Admission Rate Analysis**: Track the number of students admitted over time.
- **Average Salary Analysis**: Analyze the average salary of graduates post-completion.
- **Completion Rate Analysis**: Monitor the percentage of students who complete their programs.

## Installation

To run this project locally, you'll need to have R and R Shiny installed. Follow these steps:

1. **Clone the repository**:
    ```sh
    git clone https://github.com/MARYAKINDE/College_Information_Analysis.git
    cd College_Information_Analysis
    ```

2. **Install required packages**:
    Open R or RStudio and run:
    ```r
    install.packages(c("shiny", "ggplot2", "dplyr", "plotly"))
    ```

3. **Run the application**:
    In R or RStudio, set your working directory to the cloned repository and run:
    ```r
    library(shiny)
    runApp()
    ```

## Usage

Once the application is running, you can access it in your web browser. The application interface allows you to:

- View interactive plots and charts.
- Filter data by various criteria.
- Export reports and data summaries.

### Key Metrics

1. **Retention Rate**: The percentage of students who continue their studies from one year to the next.
2. **Attrition Rate**: The percentage of students who discontinue their studies before completion.
3. **Admission Rate**: The number of new students admitted to the college.
4. **Average Salary**: The average salary of graduates, providing insights into the economic impact of completing their studies.
5. **Completion Rate**: The percentage of students who successfully complete their programs.

## Data

The application uses a dataset containing the following columns:

- `student_id`: Unique identifier for each student
- `admission_year`: Year of admission
- `graduation_year`: Year of graduation (if applicable)
- `status`: Current status of the student (enrolled, graduated, dropped out)
- `salary`: Salary of the student after graduation
- `program`: Academic program the student is enrolled in

## Contributing

We welcome contributions to improve the application. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, please open an issue or contact us at `youremail@example.com`.
