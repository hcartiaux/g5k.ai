# My collection of OAR launcher scripts for Grid'5000

These launcher scripts should be treated as examples and as a starting point.
Tweak them to fit your needs.

* [llama.cpp](https://github.com/hcartiaux/g5k.ai/tree/main/llama.cpp) - This launcher script spawns llama.cpp with gpt-oss:120b in user space.
  This allows to request a single GPU instead of a complete node to run a simple inference engine.

* [ollama](https://github.com/hcartiaux/g5k.ai/tree/main/ollama) - This launcher script spawns mistral:7b and OpenWebUI on a complete node using Docker.

* [vllm](https://github.com/hcartiaux/g5k.ai/tree/main/vllm) - This launcher script spawns several vllm instances behind a LiteLLM proxy using Docker on a complete node.

---

I host a few `gguf` files in my home directory, placed in `~/public/llama.cpp/`
and accessible internally at `http://public.luxembourg.grid5000.fr/~hcartiaux/llama.cpp/`
You can use them for your tests instead of downloading from the Internet.

```bash
curl -s http://public.luxembourg.grid5000.fr/~hcartiaux/llama.cpp/ | grep -oP '(?<=href=")[^"]+\.gguf(?=")'
unsloth_Qwen3.8-27B-UD-Q4_K_M-mmproj-BF16.gguf
unsloth_Qwen3.8-27B-UD-Q4_K_M.gguf
unsloth_Qwen3.8-Flash-Next-Q8_0-merged-mmproj-BF16.gguf
unsloth_Qwen3.8-Flash-Next-Q8_0-merged.gguf
unsloth_gpt-oss-20b-GGUF_gpt-oss-20b-Q4_K_M.gguf
unsloth_gpt-oss-120b-GGUF_gpt-oss-120b-F16.gguf
```
