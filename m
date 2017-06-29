From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: move CTA_TIMEOUT case to outside
Date: Thu, 29 Jun 2017 18:51:12 +0200
Message-ID: <20170629165112.GA8551@salvia>
References: <1496983067-11214-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752136AbdF2QvV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 12:51:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A93DA7E93
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:51:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 485F3D2E4A
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:51:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4AD7D1CA7
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 18:51:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496983067-11214-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 09, 2017 at 12:37:47PM +0800, Haishuang Yan wrote:
> When cda[CTA_TIMEOUT] is zero, ctnetlink_new_conntrack will
> free allocated ct and return, so move it to outside to optimize
> this situation.
> 
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index a8be9b7..d1e6b1c 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1768,9 +1768,6 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
>  	if (IS_ERR(ct))
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (!cda[CTA_TIMEOUT])
> -		goto err1;

Actually, I think we would make ctnetlink a better place if we just
relax this. I mean, I would like to see how a patch to use the default
timeout based on the protocol state looks like.

ctnetlink is overly pendantic, in asking things that we can probably
infer, just in case the user doesn't specify this.

> -
>  	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
>  
>  	rcu_read_lock();
> @@ -1944,7 +1941,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
>  		if (nlh->nlmsg_flags & NLM_F_CREATE) {
>  			enum ip_conntrack_events events;
>  
> -			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
> +			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY] || !cda[CTA_TIMEOUT])
>  				return -EINVAL;
>  			if (otuple.dst.protonum != rtuple.dst.protonum)
>  				return -EINVAL;
> -- 
> 1.8.3.1
> 
> 
> 
