# CLI dictionary
{
  writeShellApplication,
  fetchFromGitHub,
  lynx,
  gawk,
}:
writeShellApplication {
  name = "dict";

  runtimeInputs = [
    lynx
    gawk
  ];

  text =
    let
      dictionaries = fetchFromGitHub {
        owner = "Vuizur";
        repo = "Wiktionary-Dictionaries";
        rev = "be0cfb8d614470bc8b9d9006ddff8b921cd5c2e3";
        hash = "sha256-gTxAV/f7vWg9zOOGE5B8IOb59i/TU89htTm0t9HhUnA=";
      };
    in
    ''
      case $1 in
        fr)
          dict="${dictionaries}/French-English Wiktionary dictionary.tsv"
          ;;
        de)
          dict="${dictionaries}/German-English Wiktionary dictionary.tsv"
          ;;
        en)
          dict="${dictionaries}/English-English Wiktionary dictionary.tsv"
          ;;
        it)
          dict="${dictionaries}/Italian-English Wiktionary dictionary.tsv"
          ;;
        *)
          echo "Unknown language $1";
          exit 1;
        ;;
      esac
      awk 'BEGIN {FS=OFS="\t"} $1~/.*\|'"$2"'\|.*/ || $1~/^'"$2"'\|.*/ || $1~/.*\|'"$2"'$/ || $1~/^'"$2"'$/ {print "<h1>" gensub(/\|.*$/, ":</h1></br>", 1) " " $2}' "$dict" | lynx --dump -stdin
    '';
}
