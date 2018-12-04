use "files"
use "itertools"
use "collections"

primitive FileHelper
  fun get_lines(path: String, env: Env): Array[String] val ? =>
    let lines = recover trn Array[String] end

    let file_path = FilePath(env.root as AmbientAuth, path)?

    with file = OpenFile(file_path) as File do
      for line in FileLines(file) do
        lines.push(consume line)
      end
    end

    consume lines
