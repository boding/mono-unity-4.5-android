// gcs0695.cs: `C<X,Y>' cannot implement both `I<K<Y>>' and `I<X>' because they may unify for some type parameter substitutions
// Line: 10

interface I<X>
{ }

interface K<X>
{ }

class C<X,Y> : I<X>, I<K<Y>>
{ }
