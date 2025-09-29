# `llama.cpp`` launcher script for Grid'5000

This is a generic launcher script for `llama.cpp` for Luxembourg compute nodes with AMD GPUs.
Feel free to modify it and create pull requests.

**/!\ Note that it does not implement any security features or authentication.
Handle with care!**

Note that this launcher script will download `Gpt-Oss-120b` from the Luxembourg storage server (`srv-data2.luxembourg`).

1. Connect to the Luxembourg Grid'5000 site

   ```bash
   (local) $ ssh luxembourg.g5k
   ```

2. Clone this repository in your home directory, and cd into it.

   ```bash
   (fluxembourg) $ git clone https://github.com/hcartiaux/g5k.ai
   (fluxembourg) $ cd g5k.ai/llama.cpp
   ```

3. Submit the job on `larochette` (4x MI210)

   ```
   (fluxembourg) $ oarsub -S ./launch-larochette.sh
   OAR_JOB_ID=265401
   ```

   To submit the job on vianden, adapt the `#OAR` headers accordingly.

4. Look at the output and wait for the first model to be downloaded and `llama.cpp`` to be started.
   ```
   (fluxembourg) $ multitail -i OAR.<OAR_JOB_iD>.*
   {# Copyright 2025-present Unsloth. Apache 2.0 License. Unsloth chat template fixes. Edited from ggml-org & OpenAI #}, example_format: '<|start|>system<|mess
   age|>You are ChatGPT, a large language model trained by OpenAI.
   Knowledge cutoff: 2024-06
   Current date: 2025-09-29

   Reasoning: medium

   # Valid channels: analysis, commentary, final. Channel must be included for every message.<|end|><|start|>developer<|message|># Instructions

   You are a helpful assistant<|end|><|start|>user<|message|>Hello<|end|><|start|>assistant<|channel|>final<|message|>Hi there<|end|><|start|>user<|message|>Ho
   w are you?<|end|><|start|>assistant'
   main: server is listening on http://0.0.0.0:11434 - starting the main loop
   srv  update_slots: all slots are idle
   ```

5. Determine which compute node is used, and open a tunnel from your machine to use the Open-AI compatible API.

   ```bash
   (fluxembourg) $ oarstat -Jfj <OAR_JOB_ID> | jq -r '.[] | .assigned_network_address[0]'
   larochette-3.luxembourg.grid5000.fr
   ```

   ```bash
   (local) $ ssh -N -L11434:larochette-3.luxembourg.grid5000.fr:11434 luxembourg.g5k
   ```

6. Tips

   * `llama.cpp` is built inside `/tmp/llama.cpp/build/bin/`.

   * Download new models from HuggingFace using the parameter `-hf`
   ```bash
   cd /tmp/llama.cpp/build/bin
   ./llama-server -hf unsloth/gpt-oss-20b-GGUF --host 0.0.0.0 --port 11434 --ctx-size 131072 --jinja
   ```

   * Select your GPU devices with the environment variable `CUDA_VISIBLE_DEVICES`
   ```bash
   export CUDA_VISIBLE_DEVICES=0   # Use the 1st GPU only
   export CUDA_VISIBLE_DEVICES=0,1 # Use the 1st and 2nd GPU
   export CUDA_VISIBLE_DEVICES=2,3 # Use the 3rd and 4th GPU
   ```
