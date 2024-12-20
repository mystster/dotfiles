import { defineConfig } from "https://raw.githubusercontent.com/Ryooooooga/gh-rd/main/src/config/types.ts";
import { tgz } from "https://deno.land/x/compress@v0.4.5/mod.ts";

async function saveCommandOutput(
  cmd: [string, ...string[]],
  to: string,
) {
  const { stdout } = await new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stderr: "inherit",
  }).output();

  await Deno.writeFile(to, stdout);
}

async function saveRemoteFile(
  from: string,
  to: string,
) {
  const res = await fetch(new URL(from));
  if (res.body !== null) {
    await Deno.writeFile(to, res.body);
  }
}

async function extractRemoteFile(from:string, to: string, extractFilePath: string) {
  const res = await fetch(new URL(from));
  if (res.body != null) {
    let workdir;
    try {
      workdir = await Deno.makeTempDir();
      await Deno.writeFile(`${workdir}/result`, res.body);
      const extractPath = `${workdir}/extract`;
      await Deno.mkdir(extractPath);
      await tgz.uncompress(`${workdir}/result`, extractPath);
      try {
        await Deno.copyFile(`${extractPath}/${extractFilePath}`, to);
      } catch (_) {
        console.log(`file not found in ${extractFilePath}`);
      }
    // deno-lint-ignore no-explicit-any
    } catch (e: any) {
      console.log(`error: ${e?.message}`);
    } finally {
      if (workdir) {
        await Deno.remove(workdir);
      }
    }
  }
}

export default defineConfig({
  tools: [
    {
      // https://github.com/rossmacarthur/sheldon
      // Fast, configurable, shell plugin manager 
      name: "mystster/sheldon",
    },
    {
      // https://github.com/Ryooooooga/croque
      // Fast and customizable shell prompt 
      name: "Ryooooooga/croque",
      async onDownload({ packageDir, bin: { croque } }) {
        await saveCommandOutput(
          [croque, "init", "zsh"],
          `${packageDir}/croque.zsh`,
        );
      },
    },
    {
      // https://github.com/dandavison/delta
      // A syntax-highlighting pager for git, diff, and grep output 
      name: "dandavison/delta",
    },
    {
      // https://github.com/itchyny/mmv
      // rename multiple files with editor 
      name: "itchyny/mmv",
    },
    {
      // https://github.com/BurntSushi/ripgrep
      // ripgrep recursively searches directories for a regex pattern while respecting your gitignore 
      name: "BurntSushi/ripgrep",
    },
    {
      // https://github.com/x-motemen/ghq
      // Remote repository management made easy 
      name: "x-motemen/ghq",
    },
    {
      // https://github.com/jesseduffield/lazygit
      // simple terminal UI for git commands 
      name: "jesseduffield/lazygit",
    },
    {
      // https://github.com/cli/cli
      // GitHub’s official command line tool 
      name: "cli/cli",
      async onDownload({ packageDir, bin: { gh } }) {
        await saveCommandOutput(
          [gh, "completion", "--shell", "zsh"],
          `${packageDir}/_gh`,
        );
      },
    },
    {
      // https://github.com/eza-community/eza
      // A modern, maintained replacement for ls 
      name: "eza-community/eza",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://raw.githubusercontent.com/eza-community/eza/main/completions/zsh/_eza",
          `${packageDir}/_eza`,
        );
      },
    },
    {
      // https://github.com/rhysd/hgrep
      // Grep with human-friendly search results 
      name: "rhysd/hgrep",
      async onDownload({ packageDir, bin: { hgrep } }) {
        await saveCommandOutput(
          [hgrep, "--generate-completion-script", "zsh"],
          `${packageDir}/_hgrep`,
        );
      },
    },
    // {
    //   // https://github.com/dbrgn/tealdeer
    //   // A very fast implementation of tldr in Rust. community based man
    //   name: "dbrgn/tealdeer",
    //   rename: [
    //     { from: "tealdeer*", to: "tldr", chmod: 0o755 },
    //   ],
    //   async onDownload({ packageDir, bin: { tldr } }) {
    //     await Promise.all([
    //       // tldr --update
    //       new Deno.Command(tldr, {
    //         args: ["--update"],
    //       }).output(),

    //       saveRemoteFile(
    //         "https://github.com/dbrgn/tealdeer/releases/latest/download/completions_zsh",
    //         `${packageDir}/_tldr`,
    //       ),
    //     ]);
    //   },
    // },
    {
      // https://github.com/junegunn/fzf
      // A command-line fuzzy finder 
      name: "junegunn/fzf",
      async onDownload({ packageDir }) {
        await saveRemoteFile(
          "https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh",
          `${packageDir}/_fzf`,
        );
      },
    },
    {
      // https://github.com/sharkdp/bat
      // A cat(1) clone with wings. 
      name: "sharkdp/bat",
    },
    {
      // https://github.com/sharkdp/fd
      // A simple, fast and user-friendly alternative to 'find' 
      name: "sharkdp/fd",
    },
    {
      // https://github.com/sharkdp/hexyl
      // A command-line hex viewer 
      name: "sharkdp/hexyl",
    },
    {
      // https://github.com/dalance/procs
      // A modern replacement for ps written in Rust 
      name: "dalance/procs",
    },
    {
      // https://github.com/denisidoro/navi
      // An interactive cheatsheet tool for the command-line 
      name: "denisidoro/navi",
    },
    {
      // https://github.com/jdx/mise
      // dev tools, env vars, task runner 
      name: "jdx/mise",
      async onDownload({ packageDir, bin: { mise } }) {
        await saveCommandOutput(
          [mise, "activate", "zsh"],
          `${packageDir}/mise.zsh`,
        );
      },
    },
    {
      // https://github.com/zellij-org/zellij
      // A terminal workspace with batteries included 
      name: "zellij-org/zellij",
      async onDownload({ packageDir, bin: { zellij } }) {
        await saveCommandOutput(
          [zellij, "setup", "--generate-completion", "zsh"],
          `${packageDir}/_zellij`,
        );
      },
    },
    {
      // https://github.com/ajeetdsouza/zoxide
      // A smarter cd command. Supports all major shells. 
      name: "ajeetdsouza/zoxide",
      async onDownload({ packageDir, bin: { zoxide } }) {
          await saveCommandOutput(
            [zoxide, "init", "zsh"],
            `${packageDir}/zoxide.zsh`
          )
      },
    },
    {
      // https://github.com/yt-dlp/yt-dlp
      // A youtube-dl fork with additional features and fixes 
      name: "yt-dlp/yt-dlp",
      // rename: [{ from: "yt-dlp*", to: "yt-dlp", chmod: 744 }],
      executables: [{ glob: "yt-dlp*", as: "yt-dlp"}],
      async onDownload({ packageDir }) {
        await extractRemoteFile(
          "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.tar.gz",
          `${packageDir}/_yt-dlp`,
          "yt-dlp/completions/zsh/_yt-dlp"
        );
      }
    },
    {
      // https://github.com/yt-dlp/FFmpeg-Builds
      // FFmpeg Builds for yt-dlp
      name: "yt-dlp/FFmpeg-Builds",
    },
    {
      // https://github.com/twpayne/chezmoi
      // Manage your dotfiles across multiple diverse machines, securely. 
      name: "twpayne/chezmoi",
    },
    {
      // https://github.com/sxyazi/yazi
      // Blazing fast terminal file manager written in Rust, based on async I/O.
      name: "sxyazi/yazi"
    }
  ],
});
