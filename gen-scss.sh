#!/bin/bash

# Check if internet is working
wget -q --spider http://google.com

# If internet is up, then clone repository from git
if [ $? -eq 0 ]; then
	git clone https://github.com/inkmyweb/css.git
else
# If internet is down, then create blank local copies 
	declare -a file_array
	file_array=("universal.scss" "global.scss" "header.scss" "footer.scss" "content.scss" "navigation.scss" "front.scss" "main.scss")

	mkdir css
	cd css

	counter=0
	while [ $counter -lt ${#file_array[@]} ]
	do
		touch ${file_array[counter]}
		let counter=counter+1
	done

	counter=0
	import_var="@import "
	while [ $counter -lt ${#file_array[@]} ]
	do
		echo "$import_var\"${file_array[counter]}\";">>main.scss
		let counter=counter+1
	done
fi

# Append script to enqueue main.css in functions.php
echo -e "\n/**\n * Function to enqueue main.css\n */">>functions.php
echo -e "add_action( 'wp_enqueue_scripts', 'organized_css_scripts' );">>functions.php
echo -e "function organized_css_scripts() {\n\twp_enqueue_style( 'main-css', get_template_directory_uri() . '/css/main.css' );\n}">>functions.php