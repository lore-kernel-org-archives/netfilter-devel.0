From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v6 nf] netfilter: seqadj: Drop the packet directly when
 fail to add seqadj extension to avoid dereference NULL pointer later
Date: Fri, 9 Sep 2016 15:53:42 +0200
Message-ID: <20160909135342.GA25330@salvia>
References: <1473254789-25065-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        coreteam@netfilter.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750710AbcIINxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 09:53:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C4E62273DF
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:53:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C99851150C7
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:53:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E55C9114D7A
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:53:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473254789-25065-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Sep 07, 2016 at 09:26:29PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When memory is exhausted, nfct_seqadj_ext_add may fail to add the seqadj
> extension. But the function nf_ct_seqadj_init doesn't check if get valid
> seqadj pointer by the nfct_seqadj.
> 
> Now drop the packet directly when fail to add seqadj extension to avoid
> dereference NULL pointer in nf_ct_seqadj_init.

Now this patch also handles synproxy extension, so I'd suggest the
title and description are adapted to match to what the patch does, I
suggest this:

        netfilter: synproxy: Check oom when adding synproxy and seqadj ct extensions

        When memory is exhausted, nfct_seqadj_ext_add may fail to add the
        synproxy and seqadj extensions. The function nf_ct_seqadj_init doesn't
        check if get valid seqadj pointer by the nfct_seqadj.

        Now drop the packet directly when fail to add seqadj extension to
        avoid dereference NULL pointer in nf_ct_seqadj_init from
        init_conntrack().

More comments below.

> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v6: Add one helper function to add synproxy
>  v5: Return NF_ACCEPT instead of NF_DROP when nfct_seqadj_ext_add failed in nf_nat_setup_info
>  v4: Drop the packet directly when fail to add seqadj extension;
>  v3: Remove the warning log when seqadj is null;
>  v2: Remove the unnessary seqadj check in nf_ct_seq_adjust
>  v1: Initial patch
> 
>  include/net/netfilter/nf_conntrack_synproxy.h | 13 +++++++++++++
>  net/netfilter/nf_conntrack_core.c             |  7 ++++---
>  net/netfilter/nf_nat_core.c                   |  3 ++-
>  3 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
> index 6793614..e8cf825 100644
> --- a/include/net/netfilter/nf_conntrack_synproxy.h
> +++ b/include/net/netfilter/nf_conntrack_synproxy.h
> @@ -27,6 +27,19 @@ static inline struct nf_conn_synproxy *nfct_synproxy_ext_add(struct nf_conn *ct)
>  #endif
>  }
>  
> +static inline bool nf_ct_add_synproxy(struct nf_conn *ct, const struct nf_conn *tmpl)
> +{
> +	if (tmpl && nfct_synproxy(tmpl)) {
> +		if (!nfct_seqadj_ext_add(ct))
> +			return false;
> +
> +		if (!nfct_synproxy_ext_add(ct))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  struct synproxy_stats {
>  	unsigned int			syn_received;
>  	unsigned int			cookie_invalid;
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index dd2c43a..67353d0 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1035,9 +1035,10 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  	if (IS_ERR(ct))
>  		return (struct nf_conntrack_tuple_hash *)ct;
>  
> -	if (tmpl && nfct_synproxy(tmpl)) {
> -		nfct_seqadj_ext_add(ct);
> -		nfct_synproxy_ext_add(ct);
> +	if (!nf_ct_add_synproxy(ct, tmpl)) {
> +		nf_conntrack_free(ct);
> +		pr_debug("Can't add synproxy\n");

Not your fault, we have more pr_debug() in nf_conntrack. I don't think
this is very useful, actually I don't remember when was last time I
enabled these pr_debug() in nf_conntrack.

This pr_debug() is a bit like crack, once you get hooked into this,
you have to think a bit if you can get rid of it.

So while we're deciding if we want to get rid of it or not, better not
introduce more pr_debug() into this code.

> +		return NULL;
>  	}
>  
>  	timeout_ext = tmpl ? nf_ct_timeout_find(tmpl) : NULL;
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index de31818..f8b916a 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -441,7 +441,8 @@ nf_nat_setup_info(struct nf_conn *ct,
>  			ct->status |= IPS_DST_NAT;
>  
>  		if (nfct_help(ct))
> -			nfct_seqadj_ext_add(ct);
> +			if (!nfct_seqadj_ext_add(ct))
> +				return NF_ACCEPT;

Regarding this, I think Florian is right.

static inline struct nf_conn_seqadj *nfct_seqadj_ext_add(struct nf_conn *ct)
{
        return nf_ct_ext_add(ct, NF_CT_EXT_SEQADJ, GFP_ATOMIC);
}

Since this just leaves this NULL.

I got confused by nf_ct_nat_ext_add() which although looks the same,
it has different semantics.

So this NF_DROP you initially introduced is fine.
