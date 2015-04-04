Sequel.migration do
 change do
	 create_table(:words) do
		 primary_key :id
		 String :word, null: false, unique: true
		 Integer :frequency
		 index [:word, :frequency]
	 end
 end
end
