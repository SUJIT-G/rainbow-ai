export interface Env {
  AI: any;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/api/generate" && request.method === "POST") {
      try {
        const { prompt } = await request.json() as any;
        const coloringPrompt = `Simple black and white line art, coloring book page for kids, white background, no shading, thick lines, ${prompt}`;

        const response = await env.AI.run("@cf/stabilityai/stable-diffusion-xl-base-1.0", {
          prompt: coloringPrompt,
        });

        return new Response(response, {
          headers: { "content-type": "image/png" },
        });
      } catch (e) {
        return new Response("Error: " + e, { status: 500 });
      }
    }
    return new Response("Rainbow AI API is Live!");
  },
};
