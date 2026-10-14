# My collection of OAR launcher scripts for Grid'5000

These launcher scripts should be treated as examples and as a starting point.
Tweak them to fit your needs.

* [llama.cpp](https://github.com/hcartiaux/g5k.ai/tree/main/llama.cpp) - This launcher script spawns llama.cpp with gpt-oss:120b in user space.
  This allows to request a single GPU instead of a complete node to run a simple inference engine.

* [ollama](https://github.com/hcartiaux/g5k.ai/tree/main/ollama) - This launcher script spawns mistral:7b and OpenWebUI on a complete node using Docker.

* [vllm](https://github.com/hcartiaux/g5k.ai/tree/main/vllm) - This launcher script spawns several vllm instances behind a LiteLLM proxy using Docker on a complete node.
