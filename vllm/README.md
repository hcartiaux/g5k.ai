# VLLM and LiteLLM launcher script for Grid'5000

This is a generic launcher script for VLLM and LiteLLM for Luxembourg compute
nodes with AMD MI210 GPUs. Feel free to modify it, propose improvement.

The objective is to exploit the 4x AMD MI210 GPUs of a `larochette` compute node
by spawning a pool of VLLM workers behing a LiteLLM router:

* 1st worker uses GPUs 0 & 1 for `gpt-oss-120b`
* 2nd worker uses GPU 2 for `gpt-oss-20b`
* 3rd worker uses GPU 3 for `gpt-oss-20b`

LiteLLM exposes one unique API end-point on port `4000` and routes the queries
to the least busy worker with the requested model.

**/!\ Note that the security measures implemented here are quite basic.
LiteLLM is not configured with HTTPS. Handle with care!**

1. Connect to the Luxembourg Grid'5000 site

   ```
   (local) $ ssh luxembourg.g5k
   ```

2. Clone this repository in your home directory, and cd into it.

   ```
   (fluxembourg) $ git clone https://github.com/hcartiaux/g5k.ai
   (fluxembourg) $ cd g5k.ai/vllm
   ```

3. Generate a secure token

   ```
   (fluxembourg) $ echo LITELLM_MASTER_KEY=sk-$(openssl rand -hex 32) > .env
   (fluxembourg) $ cat .env
   sk-your-random-secret
   ```

4. Submit the job, either on `larochette` (4x MI210)

   ```
   (fluxembourg) $ oarsub -S ./launch-larochette.sh
   OAR_JOB_ID=276648
   ```

5. Look at the output and wait for VLLM and LiteLLM containers to be started.
   It may be quite long on first try due to the download time.

   ```
   (fluxembourg) $ multitail -i OAR.<OAR_JOB_iD>.*

   litellm-1      |
   litellm-1      |    ██╗     ██╗████████╗███████╗██╗     ██╗     ███╗   ███╗
   litellm-1      |    ██║     ██║╚══██╔══╝██╔════╝██║     ██║     ████╗ ████║
   litellm-1      |    ██║     ██║   ██║   █████╗  ██║     ██║     ██╔████╔██║
   litellm-1      |    ██║     ██║   ██║   ██╔══╝  ██║     ██║     ██║╚██╔╝██║
   litellm-1      |    ███████╗██║   ██║   ███████╗███████╗███████╗██║ ╚═╝ ██║
   litellm-1      |    ╚══════╝╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝
   litellm-1      |
   litellm-1      | INFO:     Application startup complete.
   litellm-1      | INFO:     Uvicorn running on http://0.0.0.0:4000 (Press CTRL+C to quit)
   ...
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]        █     █     █▄   ▄█
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]  ▄▄ ▄█ █     █     █ ▀▄▀ █  version 0.17.0
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]   █▄█▀ █     █     █     █  model   openai/gpt-oss-20b
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]    ▀▀  ▀▀▀▀▀ ▀▀▀▀▀ ▀     ▀
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-20b-b-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:238] non-default args: {'model_tag': 'openai/gpt-oss-20b', 'model': 'openai/gpt-oss-20b', 'gpu_memory_utilization': 0.8}
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]        █     █     █▄   ▄█
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]  ▄▄ ▄█ █     █     █ ▀▄▀ █  version 0.17.0
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]   █▄█▀ █     █     █     █  model   openai/gpt-oss-20b
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]    ▀▀  ▀▀▀▀▀ ▀▀▀▀▀ ▀     ▀
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-20b-c-1   | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:238] non-default args: {'model_tag': 'openai/gpt-oss-20b', 'model': 'openai/gpt-oss-20b', 'gpu_memory_utilization': 0.8}
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]        █     █     █▄   ▄█
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]  ▄▄ ▄█ █     █     █ ▀▄▀ █  version 0.17.0
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]   █▄█▀ █     █     █     █  model   openai/gpt-oss-120b
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]    ▀▀  ▀▀▀▀▀ ▀▀▀▀▀ ▀     ▀
   vllm-120b-a-1  | (APIServer pid=1) INFO 03-10 15:49:42 [utils.py:302]
   vllm-20b-c-1   | (APIServer pid=1) INFO:     Application startup complete.
   vllm-20b-b-1   | (APIServer pid=1) INFO:     Application startup complete.
   vllm-120b-a-1  | (APIServer pid=1) INFO:     Application startup complete.
   ...
   ```

6. Determine which compute node is used, and open a tunnel from your machine.

   ```
   (fluxembourg) $ oarstat -Jfj <OAR_JOB_ID> | jq -r '.[] | .assigned_network_address[0]'
   larochette-6.luxembourg.grid5000.fr
   ```

   ```
   (local) $ ssh -N -L4000:larochette-6:4000 luxembourg.g5k
   ```

7. The LiteLLM end point is now usable

   ```
   (local) $ curl http://localhost:4000/v1/chat/completions               \
                  -H "Content-Type: application/json"                     \
                  -H "Authorization: Bearer sk-your-random-secret"        \
                  -d '{
    "model": "gpt-oss-120b",
    "messages": [{"role": "user", "content": "What is the capital of Luxembourg"}]
   }'
   {"id":"chatcmpl-909394945dbf0807","created":1773158004,"model":"gpt-oss-120b","object":"chat.completion","choices":[{"finish_reason":"stop","index":0,"message":{"content":"The capital of Luxembourg is **Luxembourg City**.","role":"assistant","reasoning_content":"The user asks: \"What is the capital of Luxembourg\". Simple factual answer: Luxembourg City. Provide answer.","provider_specific_fields":{"refusal":null,"reasoning":"The user asks: \"What is the capital of Luxembourg\". Simple factual answer: Luxembourg City. Provide answer.","reasoning_content":"The user asks: \"What is the capital of Luxembourg\". Simple factual answer: Luxembourg City. Provide answer."}},"provider_specific_fields":{"token_ids":null,"stop_reason":null}}],"usage":{"completion_tokens":44,"prompt_tokens":73,"total_tokens":117}}
   ```
