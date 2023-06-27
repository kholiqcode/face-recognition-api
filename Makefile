.PHONY: run 
run:
	@echo "Running the application"
	@uvicorn main:app --reload