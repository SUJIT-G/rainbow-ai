export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === "/api/generate" && request.method === "POST") {
      const { prompt } = await request.json();
      const aiPrompt = `Simple black and white line art coloring page for kids, white background, no shading, ${prompt}`;
      const response = await env.AI.run('@cf/stabilityai/stable-diffusion-xl-base-1.0', {
        prompt: aiPrompt,
        num_inference_steps: 20
      });
      return new Response(response, { headers: { "content-type": "image/png" } });
    }
    return new Response("Rainbow AI API Active");
  },
};
