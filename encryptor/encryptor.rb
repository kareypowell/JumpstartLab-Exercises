class Encryptor
	
	def cipher(rotation)
    characters = (' '..'z').to_a
    rotated_characters = characters.rotate(rotation)
    Hash[characters.zip(rotated_characters)]
  end

  def encrypt_letter(letter, rotation)
  	cipher_for_rotation = cipher(rotation)
  	cipher_for_rotation[letter]
  end

  def decrypt_letter(letter, rotation)
  	cipher_for_rotation = cipher(-rotation)
  	cipher_for_rotation.collect { |k,v| v if k == letter }
  end

  def encrypt(string, rotation)
  	# 1. Cut the input string into letters
  	letters = string.split("")

	  # 2. Encrypt those letters one at a time, gathering the results
	  results = []
	  letters.collect { |letter| results << encrypt_letter(letter, rotation) }

	  # 3. Join the results back together in one string
	  results.join("")
  end

  def decrypt(string, rotation)
  	# 1. Cut the input string into letters
  	letters = string.split("")

  	# 2. Decrypt those letters one at a time, gathering the results
  	results = []
  	letters.collect { |letter| results << decrypt_letter(letter, rotation) }

  	# 3. Join the results back together in one string
  	results.join("")
  end

  def encrypt_file(filename, rotation)
	  # 1. Create the file handle to the input file
	  input = File.open(filename, "r")

		# 2. Read the text of the input file
		secret_message = input.read

		# 3. Encrypt the text
		encrypted_message = encrypt(secret_message, rotation)

		# 4. Create a name for the output file
		encrypted_filename = "#{filename}.encrypted"

		# 5. Create an output file handle
		out = File.open(encrypted_filename, "w")

		# 6. Write out the text
		out.write(encrypted_message)

		# 7. Close the file
		out.close
  end

  def decrypt_file(filename, rotation)
  	# 1. Create the file handle to the encrypted file
  	input = File.open(filename, "r")

		# 2. Read the encrypted text
		encrypted_message = input.read

		# 3. Decrypt the text by passing in the text and rotation
		decrypted_message = decrypt(encrypted_message, rotation)

		# 4. Create a name for the decrypted file
		output_filename = filename.gsub("encrypted", "decrypted")

		# 5. Create an output file handle
		out = File.open(output_filename, "w")

		# 6. Write out the text
		out.write(decrypted_message)

		# 7. Close the file
		out.close
  end

  def supported_characters
  	(' '..'z').to_a
  end

  def crack(message)
  	supported_characters.count.times.collect do |attempt|
  		decrypt(message, attempt)
  	end
  end

  # Go back and complete the futher exercise section
  # http://tutorials.jumpstartlab.com/projects/encryptor.html

end