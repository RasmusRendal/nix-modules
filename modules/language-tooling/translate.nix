# Prompt for translategemma, which translates some string

{
  writeShellApplication,
  ollama,
}:
writeShellApplication {
  name = "translate";

  runtimeInputs = [
    ollama
  ];

  text = ''
    # Empty line to distinguish long inputs from long outputs
    echo ""

    case $1 in
      fr)
        lang="french"
        ;;
      de)
        lang="german"
        ;;
      it)
        lang="italian"
        ;;
      *)
        echo "Unknown language $1";
        exit 1;
      ;;
    esac

    # Let input be args, starting at 2
    read -r -a all_args <<< "''${@}"
    input="''${all_args[*]:1}"

    ollama run translategemma:4b "You are a professional $lang ($1) to English (EN) translator. Your goal is to translate $lang text in the most literal-word-to-word fashion, while still being understandable. Produce only the English translation, without any additional explanations or commentary. Please translate the following $lang text into English:\n\n$input";
  '';
}
