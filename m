From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v7 nf] netfilter: synproxy: Check oom when adding
 synproxy and seqadj ct extensions
Date: Mon, 12 Sep 2016 19:15:09 +0200
Message-ID: <20160912171509.GA28913@salvia>
References: <1473432621-20908-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55460 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934774AbcILRPR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:15:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E91093066CB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:15:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D710B1153E2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:15:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 000B9FF6F4
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:15:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473432621-20908-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 10:50:21PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When memory is exhausted, nfct_seqadj_ext_add may fail to add the
> synproxy and seqadj extensions. The function nf_ct_seqadj_init doesn't
> check if get valid seqadj pointer by the nfct_seqadj.
> 
> Now drop the packet directly when fail to add seqadj extension to
> avoid dereference NULL pointer in nf_ct_seqadj_init from
> init_conntrack().
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v7: Remove one debug log and revert to NF_DROP again;
>  v6: Add one helper function to add synproxy
>  v5: Return NF_ACCEPT instead of NF_DROP when nfct_seqadj_ext_add failed in nf_nat_setup_info
>  v4: Drop the packet directly when fail to add seqadj extension;
>  v3: Remove the warning log when seqadj is null;
>  v2: Remove the unnessary seqadj check in nf_ct_seq_adjust
>  v1: Initial patch
> 
>  include/net/netfilter/nf_conntrack_synproxy.h | 13 +++++++++++++
>  net/netfilter/nf_conntrack_core.c             |  6 +++---
>  net/netfilter/nf_nat_core.c                   |  3 ++-
>  3 files changed, 18 insertions(+), 4 deletions(-)
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
> index dd2c43a..64aabeb 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1035,9 +1035,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  	if (IS_ERR(ct))
>  		return (struct nf_conntrack_tuple_hash *)ct;
>  
> -	if (tmpl && nfct_synproxy(tmpl)) {
> -		nfct_seqadj_ext_add(ct);
> -		nfct_synproxy_ext_add(ct);
> +	if (!nf_ct_add_synproxy(ct, tmpl)) {
> +		nf_conntrack_free(ct);
> +		return NULL;

This has to be ERR_PTR(-ENOMEM);

So the packet is dropped.

NULL is used for invalid packets, invalid packets keep going and the
user can drop them via -m state --state INVALID.
