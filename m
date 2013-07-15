From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4] netfilter: nf_tables: add insert operation
Date: Tue, 16 Jul 2013 01:57:14 +0200
Message-ID: <20130715235714.GA6221@localhost>
References: <20130707215644.GA31231@localhost>
 <1373324177-4991-1-git-send-email-eric@regit.org>
 <1373324177-4991-2-git-send-email-eric@regit.org>
 <20130715104859.GA14071@localhost>
 <1373909274.17537.26.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3GOX5Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:57:25 -0400
Content-Disposition: inline
In-Reply-To: <1373909274.17537.26.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Mon, Jul 15, 2013 at 07:27:54PM +0200, Eric Leblond wrote:
> Hi,
>=20
> Le lundi 15 juillet 2013 =E0 12:48 +0200, Pablo Neira Ayuso a =E9crit=
 :
> > Hi Eric,
> >=20
> > On Tue, Jul 09, 2013 at 12:56:17AM +0200, Eric Leblond wrote:
> > > This patch adds a new rule attribute NFTA_RULE_POSITION which is
> > > used to store the position of a rule relatively to the others.
> > > By providing a create command and specifying a position, the rule=
 is
> > > inserted after the rule with the handle equal to the provided
> > > position.
> > > Regarding notification, the position attribute is added to specif=
y
> > > the handle of the previous rule in append mode and the handle of
> > > the next rule in the other case.
> > >=20
> > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > ---
> > >  include/uapi/linux/netfilter/nf_tables.h |  1 +
> > >  net/netfilter/nf_tables_api.c            | 46 ++++++++++++++++++=
+++++++++++---
> > >  2 files changed, 43 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/u=
api/linux/netfilter/nf_tables.h
> > > index d40a7f9..d9bf8ea 100644
> > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > @@ -143,6 +143,7 @@ enum nft_rule_attributes {
> > >  	NFTA_RULE_EXPRESSIONS,
> > >  	NFTA_RULE_FLAGS,
> > >  	NFTA_RULE_COMPAT,
> > > +	NFTA_RULE_POSITION,
> > >  	__NFTA_RULE_MAX
> > >  };
> > >  #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tab=
les_api.c
> > > index b00aca8..012eb1f 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -1267,6 +1267,7 @@ static const struct nla_policy nft_rule_pol=
icy[NFTA_RULE_MAX + 1] =3D {
> > >  	[NFTA_RULE_EXPRESSIONS]	=3D { .type =3D NLA_NESTED },
> > >  	[NFTA_RULE_FLAGS]	=3D { .type =3D NLA_U32 },
> > >  	[NFTA_RULE_COMPAT]	=3D { .type =3D NLA_NESTED },
> > > +	[NFTA_RULE_POSITION]	=3D { .type =3D NLA_U64 },
> > >  };
> > > =20
> > >  static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 por=
tid, u32 seq,
> > > @@ -1279,6 +1280,7 @@ static int nf_tables_fill_rule_info(struct =
sk_buff *skb, u32 portid, u32 seq,
> > >  	struct nfgenmsg *nfmsg;
> > >  	const struct nft_expr *expr, *next;
> > >  	struct nlattr *list;
> > > +	const struct nft_rule *prule;
> > > =20
> > >  	event |=3D NFNL_SUBSYS_NFTABLES << 8;
> > >  	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenm=
sg),
> > > @@ -1298,6 +1300,26 @@ static int nf_tables_fill_rule_info(struct=
 sk_buff *skb, u32 portid, u32 seq,
> > >  	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->handl=
e)))
> > >  		goto nla_put_failure;
> > > =20
> > > +	if (flags & NLM_F_APPEND) {
> > > +		if ((event !=3D NFT_MSG_DELRULE) &&
> > > +		    (rule->list.prev !=3D &chain->rules)) {
> > > +			prule =3D list_entry(rule->list.prev,
> > > +					   struct nft_rule, list);
> > > +			if (nla_put_be64(skb, NFTA_RULE_POSITION,
> > > +					 cpu_to_be64(prule->handle)))
> > > +				goto nla_put_failure;
> > > +		}
> >=20
> > This looks good but I think we can simplify this to always use .pre=
v.
> >=20
> > 1) Append: we use .prev. If it's the first rule in the list, skip
> >    position attribute.
> >=20
> > 2) Insert: never dump position attribute as it is always the first
> >    rule in the list.
> >=20
> > 3) At position X: use .prev. If it's the first rule in the list, sk=
ip.
> >=20
> > That should allows us to remove the else branch below and it should
> > simplify the semantics of NFTA_RULE_POSITION as well.
>=20
> This code is not pretty and I understand your point but we have two t=
ype
> of operations:
>       * Insert before
>       * Append after
> In both cases, the presence of the NFTA_RULE_POSITION attribute is
> triggering the switch to this mode. And I think this is a convenient =
way
> to update the API.

I see. Then we need to save the append flag to report events correctly
in the commit path for the "insert after" case, according to this
approach (that's should be easy to resolve though with a follow up
patch).

> Furthermore, inside nf_tables_fill_rule_info() we don't have any
> information to decide that we are in "position X".

But we know the handle of our .prev node for that new rule we added,
that can be used to report back our relative location to it, ie.
always return the previous node.

This however results in reporting back a different handle via the
event notification in the "insert after" case (instead of the original
handle passed via the rule_position attribute).

> Only solution to switch to the method you describe would be to
> introduce a new operation and it seems that was is wanted (it was
> said in initial discussion).

Sure, I just wanted to discuss the nf_tables_fill_rule_info path, not
questioning the entire patch.

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
