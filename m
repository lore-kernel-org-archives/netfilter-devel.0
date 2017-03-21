From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 1/1] netfilter: helper: Remove the rcu lock in
 nf_ct_helper_expectfn_find_by_name and nf_ct_helper_expectfn_find_by_symbol.
Date: Tue, 21 Mar 2017 15:30:10 +0100
Message-ID: <20170321143010.GA17014@salvia>
References: <1489480145-54411-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932173AbdCUOaW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:30:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B110170D47
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:30:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88D73FB470
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:30:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD2ABEBACE
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:30:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489480145-54411-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 04:29:05PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because these two functions return the nf_ct_helper_expectfn pointer
> which should be protected by rcu lock. So it should makes sure the
> caller should hold the rcu lock, not inside these functions.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_helper.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..bce3d1f 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -311,38 +311,36 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
>  
> +/* Caller should hold the rcu lock */
>  struct nf_ct_helper_expectfn *
>  nf_ct_helper_expectfn_find_by_name(const char *name)
>  {
>  	struct nf_ct_helper_expectfn *cur;
>  	bool found = false;
>  
> -	rcu_read_lock();
>  	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
>  		if (!strcmp(cur->name, name)) {
>  			found = true;
>  			break;
>  		}
>  	}
> -	rcu_read_unlock();
>  	return found ? cur : NULL;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);

You have to collapse this patch to:

http://patchwork.ozlabs.org/patch/740576/

Please... use shorter patch subject names, around 80 chars long. There
is no strict limit that I know, but this subject looks too long.

I think rcu read side is missing in every invocations to:

__nf_conntrack_helper_find()

in ctnetlink. So this patch would be larger, have a closer look and
fix this in one go, please.
