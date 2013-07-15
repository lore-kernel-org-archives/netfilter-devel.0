From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCHv4] netfilter: nf_tables: add insert operation
Date: Mon, 15 Jul 2013 19:27:54 +0200
Message-ID: <1373909274.17537.26.camel@ice-age.regit.org>
References: <20130707215644.GA31231@localhost>
	 <1373324177-4991-1-git-send-email-eric@regit.org>
	 <1373324177-4991-2-git-send-email-eric@regit.org>
	 <20130715104859.GA14071@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iRNeWgBuJkzt33ozmvwm"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40214 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3GOR2H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:28:07 -0400
In-Reply-To: <20130715104859.GA14071@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-iRNeWgBuJkzt33ozmvwm
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 15 juillet 2013 =E0 12:48 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Eric,
>=20
> On Tue, Jul 09, 2013 at 12:56:17AM +0200, Eric Leblond wrote:
> > This patch adds a new rule attribute NFTA_RULE_POSITION which is
> > used to store the position of a rule relatively to the others.
> > By providing a create command and specifying a position, the rule is
> > inserted after the rule with the handle equal to the provided
> > position.
> > Regarding notification, the position attribute is added to specify
> > the handle of the previous rule in append mode and the handle of
> > the next rule in the other case.
> >=20
> > Signed-off-by: Eric Leblond <eric@regit.org>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |  1 +
> >  net/netfilter/nf_tables_api.c            | 46 ++++++++++++++++++++++++=
+++++---
> >  2 files changed, 43 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
> > index d40a7f9..d9bf8ea 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -143,6 +143,7 @@ enum nft_rule_attributes {
> >  	NFTA_RULE_EXPRESSIONS,
> >  	NFTA_RULE_FLAGS,
> >  	NFTA_RULE_COMPAT,
> > +	NFTA_RULE_POSITION,
> >  	__NFTA_RULE_MAX
> >  };
> >  #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
> > index b00aca8..012eb1f 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1267,6 +1267,7 @@ static const struct nla_policy nft_rule_policy[NF=
TA_RULE_MAX + 1] =3D {
> >  	[NFTA_RULE_EXPRESSIONS]	=3D { .type =3D NLA_NESTED },
> >  	[NFTA_RULE_FLAGS]	=3D { .type =3D NLA_U32 },
> >  	[NFTA_RULE_COMPAT]	=3D { .type =3D NLA_NESTED },
> > +	[NFTA_RULE_POSITION]	=3D { .type =3D NLA_U64 },
> >  };
> > =20
> >  static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u=
32 seq,
> > @@ -1279,6 +1280,7 @@ static int nf_tables_fill_rule_info(struct sk_buf=
f *skb, u32 portid, u32 seq,
> >  	struct nfgenmsg *nfmsg;
> >  	const struct nft_expr *expr, *next;
> >  	struct nlattr *list;
> > +	const struct nft_rule *prule;
> > =20
> >  	event |=3D NFNL_SUBSYS_NFTABLES << 8;
> >  	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
> > @@ -1298,6 +1300,26 @@ static int nf_tables_fill_rule_info(struct sk_bu=
ff *skb, u32 portid, u32 seq,
> >  	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handle)))
> >  		goto nla_put_failure;
> > =20
> > +	if (flags & NLM_F_APPEND) {
> > +		if ((event !=3D NFT_MSG_DELRULE) &&
> > +		    (rule->list.prev !=3D &chain->rules)) {
> > +			prule =3D list_entry(rule->list.prev,
> > +					   struct nft_rule, list);
> > +			if (nla_put_be64(skb, NFTA_RULE_POSITION,
> > +					 cpu_to_be64(prule->handle)))
> > +				goto nla_put_failure;
> > +		}
>=20
> This looks good but I think we can simplify this to always use .prev.
>=20
> 1) Append: we use .prev. If it's the first rule in the list, skip
>    position attribute.
>=20
> 2) Insert: never dump position attribute as it is always the first
>    rule in the list.
>=20
> 3) At position X: use .prev. If it's the first rule in the list, skip.
>=20
> That should allows us to remove the else branch below and it should
> simplify the semantics of NFTA_RULE_POSITION as well.

This code is not pretty and I understand your point but we have two type
of operations:
      * Insert before
      * Append after
In both cases, the presence of the NFTA_RULE_POSITION attribute is
triggering the switch to this mode. And I think this is a convenient way
to update the API.

Furthermore, inside nf_tables_fill_rule_info() we don't have any
information to decide that we are in "position X". Only solution to
switch to the method you describe would be to introduce a new operation
and it seems that was is wanted (it was said in initial discussion).

BR,

>=20
> > +	} else {
> > +		if ((event !=3D NFT_MSG_DELRULE) &&
> > +		    list_is_last(&rule->list, &chain->rules)) {
> > +			prule =3D list_entry(rule->list.next,
> > +					   struct nft_rule, list);
> > +			if (nla_put_be64(skb, NFTA_RULE_POSITION,
> > +					 cpu_to_be64(prule->handle)))
> > +				goto nla_put_failure;
> > +		}
> > +	}
> > +
> >  	list =3D nla_nest_start(skb, NFTA_RULE_EXPRESSIONS);
> >  	if (list =3D=3D NULL)
> >  		goto nla_put_failure;
> > @@ -1537,7 +1559,7 @@ static int nf_tables_newrule(struct sock *nlsk, s=
truct sk_buff *skb,
> >  	int err, rem;
> >  	bool create;
> >  	u32 flags =3D 0;
> > -	u64 handle;
> > +	u64 handle, pos_handle;
> > =20
> >  	create =3D nlh->nlmsg_flags & NLM_F_CREATE ? true : false;
> > =20
> > @@ -1571,6 +1593,15 @@ static int nf_tables_newrule(struct sock *nlsk, =
struct sk_buff *skb,
> >  		handle =3D nf_tables_alloc_handle(table);
> >  	}
> > =20
> > +	if (nla[NFTA_RULE_POSITION]) {
> > +		if (!(nlh->nlmsg_flags & NLM_F_CREATE))
> > +			return -EOPNOTSUPP;
> > +		pos_handle =3D be64_to_cpu(nla_get_be64(nla[NFTA_RULE_POSITION]));
> > +		old_rule =3D __nf_tables_rule_lookup(chain, pos_handle);
> > +		if (IS_ERR(old_rule))
> > +			return PTR_ERR(old_rule);
> > +	}
> > +
> >  	nft_ctx_init(&ctx, skb, nlh, afi, table, chain, nla);
> > =20
> >  	n =3D 0;
> > @@ -1625,9 +1656,16 @@ static int nf_tables_newrule(struct sock *nlsk, =
struct sk_buff *skb,
> >  			nf_tables_rule_destroy(old_rule);
> >  		}
> >  	} else if (nlh->nlmsg_flags & NLM_F_APPEND)
> > -		list_add_tail_rcu(&rule->list, &chain->rules);
> > -	else
> > -		list_add_rcu(&rule->list, &chain->rules);
> > +		if (old_rule)
> > +			list_add_rcu(&rule->list, &old_rule->list);
> > +		else
> > +			list_add_tail_rcu(&rule->list, &chain->rules);
> > +	else {
> > +		if (old_rule)
> > +			list_add_tail_rcu(&rule->list, &old_rule->list);
> > +		else
> > +			list_add_rcu(&rule->list, &chain->rules);
> > +	}
> > =20
> >  	if (flags & NFT_RULE_F_COMMIT)
> >  		list_add(&rule->dirty_list, &chain->dirty_rules);
> > --=20
> > 1.8.3.2
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-iRNeWgBuJkzt33ozmvwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBR5DEbnxA7CdMWjzIRAnqPAJ0b624U/vUypaaI6JtAa5qSfS9WVACeKrY2
+FlM0f944Fl9ifDfscmZgPI=
=EZcw
-----END PGP SIGNATURE-----

--=-iRNeWgBuJkzt33ozmvwm--

