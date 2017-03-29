From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: helper: Remove useless rcu
 lock when get expectfn
Date: Wed, 29 Mar 2017 12:07:30 +0200
Message-ID: <20170329100730.GA4131@salvia>
References: <1490148902-96508-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755087AbdC2KHr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 06:07:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 03590BA1A7
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:07:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7E0FDA873
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:07:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2174EDA875
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:07:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490148902-96508-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 22, 2017 at 10:15:02AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because these two functions return the nf_ct_helper_expectfn pointer
> which should be protected by rcu lock. So it should makes sure the
> caller should hold the rcu lock, not inside these functions.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Shorter subject, per Pablo
>  v1: Initial version
> 
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

nf_ct_helper_expectfn_find_by_name() is called from ctnetlink, via
ctnetlink_create_expect() and rcu read side lock is not held there.
