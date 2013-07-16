From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCHv4] netfilter: nf_tables: add insert operation
Date: Tue, 16 Jul 2013 09:35:58 +0200
Message-ID: <1373960158.22759.7.camel@ice-age.regit.org>
References: <20130707215644.GA31231@localhost>
	 <1373324177-4991-1-git-send-email-eric@regit.org>
	 <1373324177-4991-2-git-send-email-eric@regit.org>
	 <20130715104859.GA14071@localhost>
	 <1373909274.17537.26.camel@ice-age.regit.org>
	 <20130715235714.GA6221@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-reyEyVO8fT/EI79uHeZv"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44383 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3GPHgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:36:09 -0400
In-Reply-To: <20130715235714.GA6221@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-reyEyVO8fT/EI79uHeZv
Content-Type: multipart/mixed; boundary="=-toj94mjF5EZ5EOwMK9cf"


--=-toj94mjF5EZ5EOwMK9cf
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Pablo,

Le mardi 16 juillet 2013 =E0 01:57 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Eric,
>=20
> On Mon, Jul 15, 2013 at 07:27:54PM +0200, Eric Leblond wrote:
> > Hi,
> >=20
> > Le lundi 15 juillet 2013 =E0 12:48 +0200, Pablo Neira Ayuso a =E9crit :
> > > Hi Eric,
> > >=20
> > > On Tue, Jul 09, 2013 at 12:56:17AM +0200, Eric Leblond wrote:
> > > > This patch adds a new rule attribute NFTA_RULE_POSITION which is
> > > > used to store the position of a rule relatively to the others.
> > > > By providing a create command and specifying a position, the rule i=
s
> > > > inserted after the rule with the handle equal to the provided
> > > > position.
> > > > Regarding notification, the position attribute is added to specify
> > > > the handle of the previous rule in append mode and the handle of
> > > > the next rule in the other case.
> > > >=20
> > > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > > ---
> > > >  include/uapi/linux/netfilter/nf_tables.h |  1 +
> > > >  net/netfilter/nf_tables_api.c            | 46 ++++++++++++++++++++=
+++++++++---
> > > >  2 files changed, 43 insertions(+), 4 deletions(-)
> > > >=20
> > > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uap=
i/linux/netfilter/nf_tables.h
> > > > index d40a7f9..d9bf8ea 100644
> > > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > > @@ -143,6 +143,7 @@ enum nft_rule_attributes {
> > > >  	NFTA_RULE_EXPRESSIONS,
> > > >  	NFTA_RULE_FLAGS,
> > > >  	NFTA_RULE_COMPAT,
> > > > +	NFTA_RULE_POSITION,
> > > >  	__NFTA_RULE_MAX
> > > >  };
> > > >  #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
> > > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_table=
s_api.c
> > > > index b00aca8..012eb1f 100644
> > > > --- a/net/netfilter/nf_tables_api.c
> > > > +++ b/net/netfilter/nf_tables_api.c
> > > > @@ -1267,6 +1267,7 @@ static const struct nla_policy nft_rule_polic=
y[NFTA_RULE_MAX + 1] =3D {
> > > >  	[NFTA_RULE_EXPRESSIONS]	=3D { .type =3D NLA_NESTED },
> > > >  	[NFTA_RULE_FLAGS]	=3D { .type =3D NLA_U32 },
> > > >  	[NFTA_RULE_COMPAT]	=3D { .type =3D NLA_NESTED },
> > > > +	[NFTA_RULE_POSITION]	=3D { .type =3D NLA_U64 },
> > > >  };
> > > > =20
> > > >  static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 porti=
d, u32 seq,
> > > > @@ -1279,6 +1280,7 @@ static int nf_tables_fill_rule_info(struct sk=
_buff *skb, u32 portid, u32 seq,
> > > >  	struct nfgenmsg *nfmsg;
> > > >  	const struct nft_expr *expr, *next;
> > > >  	struct nlattr *list;
> > > > +	const struct nft_rule *prule;
> > > > =20
> > > >  	event |=3D NFNL_SUBSYS_NFTABLES << 8;
> > > >  	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg=
),
> > > > @@ -1298,6 +1300,26 @@ static int nf_tables_fill_rule_info(struct s=
k_buff *skb, u32 portid, u32 seq,
> > > >  	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)=
))
> > > >  		goto nla_put_failure;
> > > > =20
> > > > +	if (flags & NLM_F_APPEND) {
> > > > +		if ((event !=3D NFT_MSG_DELRULE) &&
> > > > +		    (rule->list.prev !=3D &chain->rules)) {
> > > > +			prule =3D list_entry(rule->list.prev,
> > > > +					   struct nft_rule, list);
> > > > +			if (nla_put_be64(skb, NFTA_RULE_POSITION,
> > > > +					 cpu_to_be64(prule->handle)))
> > > > +				goto nla_put_failure;
> > > > +		}
> > >=20
> > > This looks good but I think we can simplify this to always use .prev.
> > >=20
> > > 1) Append: we use .prev. If it's the first rule in the list, skip
> > >    position attribute.
> > >=20
> > > 2) Insert: never dump position attribute as it is always the first
> > >    rule in the list.
> > >=20
> > > 3) At position X: use .prev. If it's the first rule in the list, skip=
.
> > >=20
> > > That should allows us to remove the else branch below and it should
> > > simplify the semantics of NFTA_RULE_POSITION as well.
> >=20
> > This code is not pretty and I understand your point but we have two typ=
e
> > of operations:
> >       * Insert before
> >       * Append after
> > In both cases, the presence of the NFTA_RULE_POSITION attribute is
> > triggering the switch to this mode. And I think this is a convenient wa=
y
> > to update the API.
>=20
> I see. Then we need to save the append flag to report events correctly
> in the commit path for the "insert after" case, according to this
> approach (that's should be easy to resolve though with a follow up
> patch).


IMHO, it is already there. At start of nf_tables_fill_rule_info, we are
doing:

	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
			flags);

So flags is used as flag inside nlh. And we can get the information
during event by checking (nlh->nlmsg_flags & NLM_F_APPEND). I've done
some tests with the attached patch and it seems to work well.

So events get insert/append information as well as position. This should
be enough for event listeners to follow ruleset evolution.

> > Furthermore, inside nf_tables_fill_rule_info() we don't have any
> > information to decide that we are in "position X".
>=20
> But we know the handle of our .prev node for that new rule we added,
> that can be used to report back our relative location to it, ie.
> always return the previous node.
>=20
> This however results in reporting back a different handle via the
> event notification in the "insert after" case (instead of the original
> handle passed via the rule_position attribute).

Yes, getting insert/append information and position is better.

> > Only solution to switch to the method you describe would be to
> > introduce a new operation and it seems that was is wanted (it was
> > said in initial discussion).
>=20
> Sure, I just wanted to discuss the nf_tables_fill_rule_info path, not
> questioning the entire patch.

Cool :)

BR,
--
Eric

--=-toj94mjF5EZ5EOwMK9cf
Content-Disposition: attachment; filename="0001-after-before.patch"
Content-Type: text/x-patch; name="0001-after-before.patch"; charset="ISO-8859-15"
Content-Transfer-Encoding: base64

RnJvbSA4NmU2ZTA5ZWJiZTJiNzcwNTQ3MDM0YzJjYjZhMjIzOWY3OWYxY2U0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogRXJpYyBMZWJsb25kIDxlcmljQHJlZ2l0Lm9yZz4NCkRhdGU6
IFR1ZSwgMTYgSnVsIDIwMTMgMDk6MTI6MTkgKzAyMDANClN1YmplY3Q6IFtQQVRDSF0gYWZ0ZXIg
YmVmb3JlDQoNClNpZ25lZC1vZmYtYnk6IEVyaWMgTGVibG9uZCA8ZXJpY0ByZWdpdC5vcmc+DQot
LS0NCiBleGFtcGxlcy9uZnQtZXZlbnRzLmMgfCA0ICsrKysNCiAxIGZpbGUgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9leGFtcGxlcy9uZnQtZXZlbnRzLmMgYi9leGFt
cGxlcy9uZnQtZXZlbnRzLmMNCmluZGV4IDU1NTBjNzAuLjViYmRjZTQgMTAwNjQ0DQotLS0gYS9l
eGFtcGxlcy9uZnQtZXZlbnRzLmMNCisrKyBiL2V4YW1wbGVzL25mdC1ldmVudHMuYw0KQEAgLTYz
LDYgKzYzLDEwIEBAIHN0YXRpYyBpbnQgcnVsZV9jYihjb25zdCBzdHJ1Y3Qgbmxtc2doZHIgKm5s
aCwgaW50IHR5cGUpDQogCQlnb3RvIGVycl9mcmVlOw0KIAl9DQogDQorCWlmIChubGgtPm5sbXNn
X2ZsYWdzICYgTkxNX0ZfQVBQRU5EKQ0KKwkJcHJpbnRmKCJBRlRFUiAiKTsNCisJZWxzZQ0KKwkJ
cHJpbnRmKCJCRUZPUkUgIik7DQogCW5mdF9ydWxlX3NucHJpbnRmKGJ1Ziwgc2l6ZW9mKGJ1Ziks
IHQsIE5GVF9SVUxFX09fREVGQVVMVCwgMCk7DQogCXByaW50ZigiWyVzXVx0JXNcbiIsIHR5cGUg
PT0gTkZUX01TR19ORVdSVUxFID8gIk5FVyIgOiAiREVMIiwgYnVmKTsNCiANCi0tIA0KMS44LjMu
Mg0KDQo=


--=-toj94mjF5EZ5EOwMK9cf--

--=-reyEyVO8fT/EI79uHeZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBR5PfenxA7CdMWjzIRAspLAJ44CCiG6sKrlYpv7cWeXx5id10Q0ACgji6+
BictgTq7sB2MSpBx9FIgQ4I=
=Ub38
-----END PGP SIGNATURE-----

--=-reyEyVO8fT/EI79uHeZv--

