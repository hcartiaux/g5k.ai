# `llama.cpp` launcher script for Grid'5000

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
   (fluxembourg) $ oarsub -S ./launch-llama_cpp.sh
   OAR_JOB_ID=265401
   ```

   To submit the job on vianden, adapt the `#OAR` headers accordingly.

4. Look at the output and wait for the first model to be downloaded and `llama.cpp`` to be started (<10 minutes).
   ```
   (fluxembourg) $ multitail -i OAR.<OAR_JOB_iD>.*
    0.00.002.376 I srv  llama_server: initializing ...
    0.00.080.896 I cmn  common_param: common_params_print_info: verbosity = 3 (adjust with the `-lv N` CLI arg)
    0.00.096.195 I srv    load_model: loading model '/tmp/unsloth_gpt-oss-120b-GGUF_gpt-oss-120b-F16.gguf'
    0.01.268.292 W load: setting token '<|message|>' (200008) attribute to USER_DEFINED (16), old attributes: 8
    0.01.268.295 W load: setting token '<|start|>' (200006) attribute to USER_DEFINED (16), old attributes: 8
    0.01.268.296 W load: setting token '<|constrain|>' (200003) attribute to USER_DEFINED (16), old attributes: 8
    0.01.269.058 W load: setting token '<|channel|>' (200005) attribute to USER_DEFINED (16), old attributes: 8
    0.01.273.730 W load: special_eog_ids contains both '<|return|>' and '<|call|>', or '<|calls|>' and '<|flush|>' tokens, removing '<|end|>' token from EOG list
    6.55.337.849 I cmn          init: llama threadpool init, n_threads = 96
    6.55.578.156 I srv    load_model: initializing, n_slots = 4, n_ctx_slot = 131072, kv_unified = 'true'
    6.55.580.886 I srv  llama_server: model loaded
    6.55.580.891 I srv  llama_server: listening on http://0.0.0.0:11434
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
