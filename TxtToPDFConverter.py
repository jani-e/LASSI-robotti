# -*- coding: cp1252 -*-

from fpdf import FPDF

def convert_txt_to_pdf(input_file, output_file):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Helvetica", size = 10)
    text_file = open(input_file, "r")
    for row in text_file:
        pdf.cell(190, 10, txt = row, ln = 1, align = 'C')
    pdf.output(output_file)