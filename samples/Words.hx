// SIMPLE LIST COLLECTION.

module org.crsx.hacs.samples.Words {

// Simple word membership query.
main sort Query | ⟦ ⟨Word⟩ in ⟨List⟩ ⟧ ;
sort List | ⟦ ⟨Word⟩, ⟨List⟩ ⟧ | ⟦ ⟨Word⟩ ⟧ ;
token Word | [A-Za-z0-9]+ ;

// Helper 'list' data structure sort to collect words.
sort Words | MoreWords(Word, Words) | NoWords;

// Synthesize helper list that collects all the words in the list.
attribute ↑z(Words) ;
sort List | ↑z ;
⟦ ⟨Word#w⟩, ⟨List#ws ↑z(#zs)⟩ ⟧ ↑z(MoreWords(#w, #zs)) ;
⟦ ⟨Word#w⟩ ⟧ ↑z(MoreWords(#w, NoWords)) ;

// We'll provide the answer in clear text.
sort Answer
| ⟦Yes, the list contains ⟨Word⟩.⟧
| ⟦No, the list does not contain ⟨Word⟩.⟧
;

// Helper scheme to check if a word is in a (helper) list.
sort Answer | scheme CheckMember(Word, Words) ;

// If the word and the first member of the list are the same, then we succeed!
CheckMember(#w, MoreWords(#w, #zs)) → ⟦Yes, the list contains ⟨Word#w⟩.⟧ ;

// If the word was not the same, fall back to a default recursive case.
default CheckMember(#w, MoreWords(#z, #zs)) → CheckMember(#w, #zs) ;

// Once there is no more to search, then we failed...
CheckMember(#w, NoWords) → ⟦No, the list does not contain ⟨Word#w⟩.⟧ ;

// Main "program" takes a Query and gives an Answer.
sort Answer | scheme Check(Query) ;

// The main program needs the synthesized list before it can check membership.
Check( ⟦ ⟨Word#w⟩ in ⟨List#ws ↑z(#zs)⟩ ⟧ ) → CheckMember(#w, #zs) ;

/// TODO: MAKE THIS WORK (possibly use (_) instead of {:_}):
/// // Collect words in list.
/// attribute ↑z{Word} ;
/// sort List | ↑z ;
/// ⟦ ⟨Word#w⟩, ⟨List#ws ↑z{:#zs}⟩ ⟧ ↑z{:#zs} ↑z{#w} ;   OR  ↑z{:#zs, #w} ;
/// ⟦ ⟨Word#w⟩ ⟧ ↑z{#w} ;

}
