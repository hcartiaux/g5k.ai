# `llama.cpp` launcher script for Grid'5000

This is a generic launcher script for `llama.cpp` for Luxembourg compute nodes with AMD GPUs.
Feel free to modify it and create pull requests.

**/!\ Note that it does not implement any security features or authentication.
Handle with care!**

Note that this launcher script will download `Qwen 3.8 27B Q4` from the Luxembourg storage server (`srv-data2.luxembourg`).

1. Connect to the Luxembourg Grid'5000 site

   ```bash
   (local) $ ssh luxembourg.g5k
   ```

2. Clone this repository in your home directory, and cd into it.

   ```bash
   (fluxembourg) $ git clone https://github.com/hcartiaux/g5k.ai
   (fluxembourg) $ cd g5k.ai/llama.cpp
   ```

3. Submit the job on `larochette`, this will request only 1x MI210 GPU.

   ```
   (fluxembourg) $ oarsub -S ./launch-llama_cpp.sh
   OAR_JOB_ID=265401
   ```

   To submit the job on vianden, adapt the `#OAR` headers accordingly.

  ```
  #OAR -t exotic
  #OAR -p vianden
  ```

4. Look at the output and wait for the first model to be downloaded and `llama.cpp`` to be started (<10 minutes).
   ```
   (fluxembourg) $ multitail -i OAR.<OAR_JOB_iD>.*
    0.00.001.789 I srv  llama_server: initializing ...
    0.00.043.948 I cmn  common_param: common_params_print_info: verbosity = 3 (adjust with the `-lv N` CLI arg)
    0.00.044.289 W srv  llama_server: security: no API key is set and CORS allows all origins (see https://github.com/ggml-org/llama.cpp/pull/25655)
    0.00.057.118 I srv    load_model: loading model '/tmp/unsloth_Qwen3.8-27B-UD-Q4_K_M.gguf'
    0.03.530.030 I cmn          init: llama threadpool init, n_threads = 8
    0.03.637.883 I common_speculative_init_result: creating MTP draft context against the target model '/tmp/unsloth_Qwen3.8-27B-UD-Q4_K_M.gguf'
    0.03.797.526 I srv    load_model: initializing, n_slots = 4, n_ctx_slot = 131072, kv_unified = 'true'
    0.03.983.371 W srv          init: chat template supports preserving reasoning, it is enabled by default (may use more tokens, disable via --no-reasoning-preserve)
    0.03.983.413 I srv  llama_server: model loaded
    0.03.983.417 I srv  llama_server: listening on http://0.0.0.0:11434
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
