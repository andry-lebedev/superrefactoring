import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export const SuperrefactoringPlugin = async () => {
  const skillsDir = path.resolve(__dirname, '../../skills');
  const bootstrap = `<IMPORTANT>
You have the Superrefactoring skills library available.

Use refactor-research for maintainability-focused PR/local-diff investigation before code changes.
Use writing-refactor-plans when research exists and the user wants a scoped refactor plan.

These skills do not write output files or implement code unless the user explicitly asks through a separate execution workflow.
</IMPORTANT>`;

  return {
    config: async (config) => {
      config.skills = config.skills || {};
      config.skills.paths = config.skills.paths || [];
      if (!config.skills.paths.includes(skillsDir)) {
        config.skills.paths.push(skillsDir);
      }
    },

    'experimental.chat.messages.transform': async (_input, output) => {
      if (!output.messages.length) return;
      const firstUser = output.messages.find((message) => message.info.role === 'user');
      if (!firstUser || !firstUser.parts.length) return;
      if (firstUser.parts.some((part) => part.type === 'text' && part.text.includes('Superrefactoring'))) return;

      const ref = firstUser.parts[0];
      firstUser.parts.unshift({ ...ref, type: 'text', text: bootstrap });
    }
  };
};
