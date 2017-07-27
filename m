From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v2 2/5] netfilter: nf_tables: Unlimit table name
 length
Date: Thu, 27 Jul 2017 11:32:33 +0200
Message-ID: <20170727093233.GA6224@salvia>
References: <20170724185651.24063-1-phil@nwl.cc>
 <20170724185651.24063-3-phil@nwl.cc>
 <20170725161002.GA3489@salvia>
 <20170725191628.GC2235@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750965AbdG0Jcp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 05:32:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0FB7C106E
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 11:32:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B0D8DA57E
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 11:32:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B395DA46C
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 11:32:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725191628.GC2235@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Tue, Jul 25, 2017 at 09:16:28PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Jul 25, 2017 at 06:10:02PM +0200, Pablo Neira Ayuso wrote:
> > I think you can rename patch title to "allow table names up to 256
> > chars". This is not unlimited anymore since v2.
> 
> OK.
> 
> > A couple more comments below.
> > 
> > On Mon, Jul 24, 2017 at 08:56:48PM +0200, Phil Sutter wrote:
> [...]
> > > --- a/include/uapi/linux/netfilter/nf_tables.h
> > > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > > @@ -1,7 +1,7 @@
> > >  #ifndef _LINUX_NF_TABLES_H
> > >  #define _LINUX_NF_TABLES_H
> > >  
> > > -#define NFT_TABLE_MAXNAMELEN	32
> > > +#define NFT_NAME_MAXLEN		256
> > 
> > I understand NFT_*_MAXNAMELEN per object is probably too much, but
> > given this is uapi, I think we have to keep it around, ie.
> > 
> > #define NFT_NAME_MAXLEN		256
> > #define NFT_TABLE_MAXNAMELEN    NFT_NAME_MAXLEN
> > 
> > And so on.
> 
> OK, I will change it. But using NFT_NAME_MAXLEN throughout kernel code
> is OK? Or should I revert the policy struct changes?
>
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 7843efa33c598..cf12f63606aaf 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -428,7 +428,7 @@ nf_tables_chain_type_lookup(const struct nft_af_info *afi,
> > >  
> > >  static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
> > >  	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
> > > -				    .len = NFT_TABLE_MAXNAMELEN - 1 },
> > > +				    .len = NFT_NAME_MAXLEN - 1 },
> > >  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
> > >  };
> 
> This one, e.g.: Keeping the old NFT_TABLE_MAXNAMELEN around makes that
> change needless in theory.

Probably good to keep using the old definitions, so we save one line
update in the patch. And we avoid people having the temptation to
remove this from uapi.

> [...]
> > > diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
> > > index e1b15e7a5793f..e95098c1faaf0 100644
> > > --- a/net/netfilter/nf_tables_trace.c
> > > +++ b/net/netfilter/nf_tables_trace.c
> > > @@ -175,7 +175,6 @@ void nft_trace_notify(struct nft_traceinfo *info)
> > >  		return;
> > >  
> > >  	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
> > > -		nla_total_size(NFT_TABLE_MAXNAMELEN) +
> > >  		nla_total_size(NFT_CHAIN_MAXNAMELEN) +
> > >  		nla_total_size_64bit(sizeof(__be64)) +	/* rule handle */
> > >  		nla_total_size(sizeof(__be32)) +	/* trace type */
> > > @@ -194,6 +193,9 @@ void nft_trace_notify(struct nft_traceinfo *info)
> > >  		nla_total_size(sizeof(u32)) +		/* nfproto */
> > >  		nla_total_size(sizeof(u32));		/* policy */
> > >  
> > > +	if (info->chain)
> > > +		size += nla_total_size(strlen(info->chain->table->name));
> > 
> > Do we need a branch here? I think info->chain is always set in traces,
> > right?
> 
> I wasn't sure, so I stuck to how nft_trace_notify() handles it later:
> 
> | if (info->chain) {
> |         if (nla_put_string(skb, NFTA_TRACE_CHAIN,
> |                            info->chain->name))
> |                 goto nla_put_failure;
> |         if (nla_put_string(skb, NFTA_TRACE_TABLE,
> |                            info->chain->table->name))
> |                 goto nla_put_failure;
> | }
> 
> This made me believe there is a case where info->chain is not set.
> Though looking at nft_do_chain() which is the only caller of
> nft_trace_packet(), it seems like there is indeed always a chain (it is
> dereferenced right at the top).
> 
> So probably nft_trace_notify() can unconditionally put NFTA_TRACE_CHAIN
> and NFTA_TRACE_TABLE attributes. Maybe Florian knows more?

info->chain is always set from __nft_trace_packet(), and all calls to
nft_trace_packet() pass a non-null the chain object. So my impression
is that you can send an unfront patch in this series to remove the
branch. Nonetheless, please make another review of what I'm telling
above to confirm this.

> Another questionable part (in the 'Unlimit chain name length' patch) is
> the existence check for info->verdict->chain: The relevant attribute is
> created only if info->type is either NFT_TRACETYPE_RETURN or
> NFT_TRACETYPE_RULE *and* info->verdict->code is either NFT_JUMP or
> NFT_GOTO. Hard to tell whether this can be assumed to always exist.

See struct nft_regs, it's a union, so info->verdict is a valid pointer
under very specific circunstances. I think patch 3/5 is not correct.

Thanks!
