From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4] netfilter: nf_tables: add insert operation
Date: Tue, 16 Jul 2013 12:00:50 +0200
Message-ID: <20130716100050.GA5517@localhost>
References: <20130707215644.GA31231@localhost>
 <1373324177-4991-1-git-send-email-eric@regit.org>
 <1373324177-4991-2-git-send-email-eric@regit.org>
 <20130715104859.GA14071@localhost>
 <1373909274.17537.26.camel@ice-age.regit.org>
 <20130715235714.GA6221@localhost>
 <1373960158.22759.7.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab3GPKAz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:00:55 -0400
Content-Disposition: inline
In-Reply-To: <1373960158.22759.7.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 16, 2013 at 09:35:58AM +0200, Eric Leblond wrote:
> Hello Pablo,
>=20
> Le mardi 16 juillet 2013 =E0 01:57 +0200, Pablo Neira Ayuso a =E9crit=
 :
> > Hi Eric,
> >=20
> > On Mon, Jul 15, 2013 at 07:27:54PM +0200, Eric Leblond wrote:
> > > Hi,
> > >=20
> > > Le lundi 15 juillet 2013 =E0 12:48 +0200, Pablo Neira Ayuso a =E9=
crit :
> > > > Hi Eric,
> > > >=20
> > > > On Tue, Jul 09, 2013 at 12:56:17AM +0200, Eric Leblond wrote:
> > > > > This patch adds a new rule attribute NFTA_RULE_POSITION which=
 is
> > > > > used to store the position of a rule relatively to the others=
=2E
> > > > > By providing a create command and specifying a position, the =
rule is
> > > > > inserted after the rule with the handle equal to the provided
> > > > > position.
> > > > > Regarding notification, the position attribute is added to sp=
ecify
> > > > > the handle of the previous rule in append mode and the handle=
 of
> > > > > the next rule in the other case.
> > > > >=20
> > > > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > > > ---
> > > > >  include/uapi/linux/netfilter/nf_tables.h |  1 +
> > > > >  net/netfilter/nf_tables_api.c            | 46 ++++++++++++++=
+++++++++++++++---
> > > > >  2 files changed, 43 insertions(+), 4 deletions(-)
> > > > >=20
> > > > > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/inclu=
de/uapi/linux/netfilter/nf_tables.h
> > > > > index d40a7f9..d9bf8ea 100644
> > > > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > > > @@ -143,6 +143,7 @@ enum nft_rule_attributes {
> > > > >  	NFTA_RULE_EXPRESSIONS,
> > > > >  	NFTA_RULE_FLAGS,
> > > > >  	NFTA_RULE_COMPAT,
> > > > > +	NFTA_RULE_POSITION,
> > > > >  	__NFTA_RULE_MAX
> > > > >  };
> > > > >  #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
> > > > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf=
_tables_api.c
> > > > > index b00aca8..012eb1f 100644
> > > > > --- a/net/netfilter/nf_tables_api.c
> > > > > +++ b/net/netfilter/nf_tables_api.c
> > > > > @@ -1267,6 +1267,7 @@ static const struct nla_policy nft_rule=
_policy[NFTA_RULE_MAX + 1] =3D {
> > > > >  	[NFTA_RULE_EXPRESSIONS]	=3D { .type =3D NLA_NESTED },
> > > > >  	[NFTA_RULE_FLAGS]	=3D { .type =3D NLA_U32 },
> > > > >  	[NFTA_RULE_COMPAT]	=3D { .type =3D NLA_NESTED },
> > > > > +	[NFTA_RULE_POSITION]	=3D { .type =3D NLA_U64 },
> > > > >  };
> > > > > =20
> > > > >  static int nf_tables_fill_rule_info(struct sk_buff *skb, u32=
 portid, u32 seq,
> > > > > @@ -1279,6 +1280,7 @@ static int nf_tables_fill_rule_info(str=
uct sk_buff *skb, u32 portid, u32 seq,
> > > > >  	struct nfgenmsg *nfmsg;
> > > > >  	const struct nft_expr *expr, *next;
> > > > >  	struct nlattr *list;
> > > > > +	const struct nft_rule *prule;
> > > > > =20
> > > > >  	event |=3D NFNL_SUBSYS_NFTABLES << 8;
> > > > >  	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nf=
genmsg),
> > > > > @@ -1298,6 +1300,26 @@ static int nf_tables_fill_rule_info(st=
ruct sk_buff *skb, u32 portid, u32 seq,
> > > > >  	if (nla_put_be64(skb, NFTA_RULE_HANDLE, cpu_to_be64(rule->h=
andle)))
> > > > >  		goto nla_put_failure;
> > > > > =20
> > > > > +	if (flags & NLM_F_APPEND) {
> > > > > +		if ((event !=3D NFT_MSG_DELRULE) &&
> > > > > +		    (rule->list.prev !=3D &chain->rules)) {
> > > > > +			prule =3D list_entry(rule->list.prev,
> > > > > +					   struct nft_rule, list);
> > > > > +			if (nla_put_be64(skb, NFTA_RULE_POSITION,
> > > > > +					 cpu_to_be64(prule->handle)))
> > > > > +				goto nla_put_failure;
> > > > > +		}
> > > >=20
> > > > This looks good but I think we can simplify this to always use =
=2Eprev.
> > > >=20
> > > > 1) Append: we use .prev. If it's the first rule in the list, sk=
ip
> > > >    position attribute.
> > > >=20
> > > > 2) Insert: never dump position attribute as it is always the fi=
rst
> > > >    rule in the list.
> > > >=20
> > > > 3) At position X: use .prev. If it's the first rule in the list=
, skip.
> > > >=20
> > > > That should allows us to remove the else branch below and it sh=
ould
> > > > simplify the semantics of NFTA_RULE_POSITION as well.
> > >=20
> > > This code is not pretty and I understand your point but we have t=
wo type
> > > of operations:
> > >       * Insert before
> > >       * Append after
> > > In both cases, the presence of the NFTA_RULE_POSITION attribute i=
s
> > > triggering the switch to this mode. And I think this is a conveni=
ent way
> > > to update the API.
> >=20
> > I see. Then we need to save the append flag to report events correc=
tly
> > in the commit path for the "insert after" case, according to this
> > approach (that's should be easy to resolve though with a follow up
> > patch).
>=20
>=20
> IMHO, it is already there. At start of nf_tables_fill_rule_info, we a=
re
> doing:
>=20
> 	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
> 			flags);
>=20
> So flags is used as flag inside nlh. And we can get the information
> during event by checking (nlh->nlmsg_flags & NLM_F_APPEND). I've done
> some tests with the attached patch and it seems to work well.

Please, see nf_tables_commit. In that path nf_tables_rule_notify does
not get those flags at this moment, so it's returning its position in
the insert fashion, ie. pointing to .next.

The problem with pointing to the .next node in the commit path is we
are sure that .prev points to an existing rule. However, .next may poin=
t
to stale rule. So I think we have to notify the position always
relative to the .prev pointer to get this working in the commit path.

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
