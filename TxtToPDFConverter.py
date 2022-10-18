from fpdf import FPDF

def convert_txt_to_pdf(input_file, output_file):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size = 10)
    f = open(input_file, "r")
    for x in f:
        pdf.cell(190, 10, txt = x, ln = 1, align = 'C')
    pdf.output(output_file)
