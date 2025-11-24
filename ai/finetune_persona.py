import os
import json
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def prepare_training_data(persona_data, dialogues):
    training_data = []
    
    system_prompt = f"""You are {persona_data['name']}.
Personality: {persona_data['personality']}
Tone: {persona_data['tone']}
Worldview: {persona_data['worldview']}
Stay true to these characteristics in all your responses."""
    
    for dialogue in dialogues:
        training_data.append({
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": dialogue['user_message']},
                {"role": "assistant", "content": dialogue['ai_response']}
            ]
        })
    
    return training_data

def create_training_file(training_data, filename="training_data.jsonl"):
    with open(filename, 'w') as f:
        for item in training_data:
            f.write(json.dumps(item) + '\n')
    return filename

def upload_training_file(filename):
    with open(filename, 'rb') as f:
        response = client.files.create(
            file=f,
            purpose='fine-tune'
        )
    return response.id

def create_fine_tune_job(training_file_id, model="gpt-4o-mini-2024-07-18"):
    response = client.fine_tuning.jobs.create(
        training_file=training_file_id,
        model=model,
        suffix="persona"
    )
    return response.id

def check_fine_tune_status(job_id):
    response = client.fine_tuning.jobs.retrieve(job_id)
    return response.status, response.fine_tuned_model

def main():
    persona_data = {
        'name': 'Example Persona',
        'personality': 'Friendly and helpful',
        'tone': 'Casual and warm',
        'worldview': 'Optimistic and curious'
    }
    
    dialogues = [
        {
            'user_message': 'Hello!',
            'ai_response': 'Hey there! How can I help you today?'
        },
    ]
    
    training_data = prepare_training_data(persona_data, dialogues)
    
    filename = create_training_file(training_data)
    print(f"Training file created: {filename}")
    
    file_id = upload_training_file(filename)
    print(f"File uploaded: {file_id}")
    
    job_id = create_fine_tune_job(file_id)
    print(f"Fine-tuning job created: {job_id}")
    
    status, model_id = check_fine_tune_status(job_id)
    print(f"Job status: {status}")
    if model_id:
        print(f"Fine-tuned model: {model_id}")

if __name__ == "__main__":
    main()
