Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE8C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 09:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiDHJzY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 05:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiDHJzV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 05:55:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9388227B00F
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 02:53:16 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2B5A46438D;
        Fri,  8 Apr 2022 11:49:26 +0200 (CEST)
Date:   Fri, 8 Apr 2022 11:53:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 09/16] netfilter: nfnetlink_cttimeout: use rcu
 protection in cttimeout_get_timeout
Message-ID: <YlAF/ZdhRsVWCWpg@salvia>
References: <20220323132214.6700-1-fw@strlen.de>
 <20220323132214.6700-10-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220323132214.6700-10-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 23, 2022 at 02:22:07PM +0100, Florian Westphal wrote:
> I'd like to be able to switch lifetime management of ctnl_timeout
> to free-on-zero-refcount.
> 
> This isn't possible at the moment because removal of the structures
> from the pernet list requires the nfnl mutex and release may happen from
> softirq.
> 
> Current solution is to prevent this by disallowing policy object removal
> if the refcount is > 1 (i.e., policy is still referenced from the ruleset).
> 
> Switch traversal to rcu-read-lock as a first step to reduce reliance on
> nfnl mutex protection: removal from softirq would require a extra list
> spinlock.

Needs .type = NFNL_CB_RCU?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nfnetlink_cttimeout.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index eea486f32971..aef2547bb579 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -253,6 +253,7 @@ static int cttimeout_get_timeout(struct sk_buff *skb,
>  				 const struct nlattr * const cda[])
>  {
>  	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(info->net);
> +	struct sk_buff *skb2;
>  	int ret = -ENOENT;
>  	char *name;
>  	struct ctnl_timeout *cur;
> @@ -268,31 +269,31 @@ static int cttimeout_get_timeout(struct sk_buff *skb,
>  		return -EINVAL;
>  	name = nla_data(cda[CTA_TIMEOUT_NAME]);
>  
> -	list_for_each_entry(cur, &pernet->nfct_timeout_list, head) {
> -		struct sk_buff *skb2;
> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!skb2)
> +		return -ENOMEM;
> +
> +	rcu_read_lock();
>  
> +	list_for_each_entry_rcu(cur, &pernet->nfct_timeout_list, head) {
>  		if (strncmp(cur->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
>  			continue;
>  
> -		skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> -		if (skb2 == NULL) {
> -			ret = -ENOMEM;
> -			break;
> -		}
> -
>  		ret = ctnl_timeout_fill_info(skb2, NETLINK_CB(skb).portid,
>  					     info->nlh->nlmsg_seq,
>  					     NFNL_MSG_TYPE(info->nlh->nlmsg_type),
>  					     IPCTNL_MSG_TIMEOUT_NEW, cur);
> -		if (ret <= 0) {
> -			kfree_skb(skb2);
> +		if (ret <= 0)
>  			break;
> -		}
>  
> -		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
> -		break;
> +		rcu_read_unlock();
> +
> +		return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
>  	}
>  
> +	rcu_read_unlock();
> +	kfree_skb(skb2);
> +
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 
