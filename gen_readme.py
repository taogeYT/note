"""
note readme.md 中文档结构自动生成
"""
from pathlib import Path

def gen(root_name, f, n=0):
    root = Path(root_name)
    for file in root.iterdir():
        if file.is_dir():
            content = "{}* {}\n".format('  '*n, file.name)
            f.write(content)
            gen(file, f, n+1)
        elif file.is_file():
            content = "{}* [{}]({})\n".format('  '*n, file.stem, file.as_posix())
            f.write(content)
        else:
            raise Exception("无效文件")


def main():
    with open("readme.md", "w", encoding="utf-8") as f:
        f.write("# 笔记目录\n\n")
        gen("note", f)

if __name__ == "__main__":
    main()
