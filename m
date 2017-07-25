From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nf-next PATCH v2 2/5] netfilter: nf_tables: Unlimit table name
 length
Date: Tue, 25 Jul 2017 21:16:28 +0200
Message-ID: <20170725191628.GC2235@orbyte.nwl.cc>
References: <20170724185651.24063-1-phil@nwl.cc>
 <20170724185651.24063-3-phil@nwl.cc>
 <20170725161002.GA3489@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52077 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdGYTQ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 15:16:29 -0400
Content-Disposition: inline
In-Reply-To: <20170725161002.GA3489@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tue, Jul 25, 2017 at 06:10:02PM +0200, Pablo Neira Ayuso wrote:
> I think you can rename patch title to "allow table names up to 256
> chars". This is not unlimited anymore since v2.

OK.

> A couple more comments below.
> 
> On Mon, Jul 24, 2017 at 08:56:48PM +0200, Phil Sutter wrote:
[...]
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -1,7 +1,7 @@
> >  #ifndef _LINUX_NF_TABLES_H
> >  #define _LINUX_NF_TABLES_H
> >  
> > -#define NFT_TABLE_MAXNAMELEN	32
> > +#define NFT_NAME_MAXLEN		256
> 
> I understand NFT_*_MAXNAMELEN per object is probably too much, but
> given this is uapi, I think we have to keep it around, ie.
> 
> #define NFT_NAME_MAXLEN		256
> #define NFT_TABLE_MAXNAMELEN    NFT_NAME_MAXLEN
> 
> And so on.

OK, I will change it. But using NFT_NAME_MAXLEN throughout kernel code
is OK? Or should I revert the policy struct changes?

> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 7843efa33c598..cf12f63606aaf 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -428,7 +428,7 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
> >  
> >  static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
> >  	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
> > -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> > +				    .len = NFT_NAME_MAXLEN - 1 },
> >  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
> >  };

This one, e.g.: Keeping the old NFT_TABLE_MAXNAMELEN around makes that
change needless in theory.

[...]
> > diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
> > index e1b15e7a5793f..e95098c1faaf0 100644
> > --- a/net/netfilter/nf_tables_trace.c
> > +++ b/net/netfilter/nf_tables_trace.c
> > @@ -175,7 +175,6 @@ void nft_trace_notify(struct nft_traceinfo *info)
> >  		return;
> >  
> >  	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
> > -		nla_total_size(NFT_TABLE_MAXNAMELEN) +
> >  		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
> >  		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
> >  		nla_total_size(sizeof(__be32)) +	/* trace type */
> > @@ -194,6 +193,9 @@ void nft_trace_notify(struct nft_traceinfo *info)
> >  		nla_total_size(sizeof(u32)) +		/* nfproto */
> >  		nla_total_size(sizeof(u32));		/* policy */
> >  
> > +	if (info->chain)
> > +		size += nla_total_size(strlen(info->chain->table->name));
> 
> Do we need a branch here? I think info->chain is always set in traces,
> right?

I wasn't sure, so I stuck to how nft_trace_notify() handles it later:

| if (info->chain) {
|         if (nla_put_string(skb, NFTA_TRACE_CHAIN,
|                            info->chain->name))
|                 goto nla_put_failure;
|         if (nla_put_string(skb, NFTA_TRACE_TABLE,
|                            info->chain->table->name))
|                 goto nla_put_failure;
| }

This made me believe there is a case where info->chain is not set.
Though looking at nft_do_chain() which is the only caller of
nft_trace_packet(), it seems like there is indeed always a chain (it is
dereferenced right at the top).

So probably nft_trace_notify() can unconditionally put NFTA_TRACE_CHAIN
and NFTA_TRACE_TABLE attributes. Maybe Florian knows more?

Another questionable part (in the 'Unlimit chain name length' patch) is
the existence check for info->verdict->chain: The relevant attribute is
created only if info->type is either NFT_TRACETYPE_RETURN or
NFT_TRACETYPE_RULE *and* info->verdict->code is either NFT_JUMP or
NFT_GOTO. Hard to tell whether this can be assumed to always exist.

Thanks, Phil
