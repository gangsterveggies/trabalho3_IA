from __future__ import print_function
import nltk
from nltk import grammar, parse


def sentence_analysis(sent, out=True):
    if out:
        cp = parse.load_parser('pt_grammar.fcfg', trace=1)
    else:
        cp = parse.load_parser('pt_grammar.fcfg', trace=0)
    san = sent.strip(',.').lower()
    tokens = san.split()
    try:
        trees = cp.parse(tokens)
        for tree in trees:
            if out:
                print(tree)
        return True
    except:
        if out:
            print("Esta sentenca nao e valida ou a gramatica ainda nao esta completa...")
        return False


valid_sentences = [
    "A menina corre para a floresta",
    "A menina corre para a mae",
    "A vida corre",
    "O tempo corre",
    "O cacador correu com os lobos",
    "A noticia correu pela cidade",
    "As lagrimas corriam pelo rosto",
    "O rio corre para o mar",
    "A menina bateu a porta",
    "A porta bateu",
    "O vento bateu a porta",
    "A menina bateu na porta",
    "O martelo bateu na porta",
    "A menina bateu no tambor",
    "Os tambores bateram",
    "O sino bateu",
    "A vida correu",
    "A noticia correu para a floresta",
    "A vida correu com os lobos",
    "A menina bateu a mae"
    ]
invalid_sentences = [
    "A tempo corre",
    "O tempo correram",
    "A cacador corriam pela rosto",
    "A tambores correu pela floresta",
    "Os tambores bateu na porta",
    "O sino bateu na meninas"
    ]

def assert_sentence_analysis():
    for vsent in valid_sentences:
        print("Testing \"%s\" ..." % vsent) 
        if sentence_analysis(vsent, False) == False:
            print("Failed!")
            return False
    print("All valid sentences were tested!")
    for fsent in invalid_sentences:
        print("Testing \"%s\" ..." % fsent) 
        if sentence_analysis(fsent, False) == True:
            print("Failed!")
            return False
    print("All invalid sentences were tested!")
    return True
    
        
