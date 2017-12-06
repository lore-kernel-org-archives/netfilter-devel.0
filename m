From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: reduce hook array sizes to what
 is needed
Date: Wed, 6 Dec 2017 19:14:27 +0100
Message-ID: <20171206181427.GA1765@salvia>
References: <20171202235848.22737-1-fw@strlen.de>
 <20171202235848.22737-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdLFSOb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 13:14:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12E231B8404
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 19:14:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00F91DA861
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 19:14:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171202235848.22737-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 03, 2017 at 12:58:48AM +0100, Florian Westphal wrote:
> Not all families share the same hook count.
> 
> Can't use the corresponding ARP, BRIDGE, DECNET defines because they are
> defined in uapi headers and including them causes build failures.
> 
> struct net before:
> /* size: 6592, cachelines: 103, members: 46 */
> after:
> /* size: 5952, cachelines: 93, members: 46 */
> 
> Also, no need to define hook points if the family isn't supported.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter.h     |  6 ++++++
>  include/net/netns/netfilter.h | 19 ++++++++++++++-----
>  net/netfilter/core.c          | 22 ++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 80aa9a0b3d10..30a0d12a1f6d 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -202,15 +202,21 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
>  	case NFPROTO_IPV6:
>  		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
>  		break;
> +#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)

There'a also nftables here that can use the NFPROTO_ARP family.

>  	case NFPROTO_ARP:
>  		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
>  		break;
> +#endif
> +#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)

Same here with ebtables?

>  	case NFPROTO_BRIDGE:
>  		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
>  		break;
> +#endif
