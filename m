From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] add support for modifying secmark via ctnetlink
Date: Wed, 21 May 2008 13:15:04 +0200
Message-ID: <48340438.5020106@trash.net>
References: <483350D3.50103@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, James Morris <jmorris@namei.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37472 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbYEULPE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 07:15:04 -0400
In-Reply-To: <483350D3.50103@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> As for now we only support dumping. This patch adds support to change
> the secmark from ctnetlink.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
> ===================================================================
> --- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:10:31.000000000 +0200
> +++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:10:56.000000000 +0200
> @@ -1121,6 +1121,11 @@ ctnetlink_change_conntrack(struct nf_con
>  		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
>  #endif
>  
> +#if defined(CONFIG_NF_CONNTRACK_SECMARK)
> +	if (cda[CTA_SECMARK])
> +		ct->secmark = ntohl(nla_get_be32(cda[CTA_SECMARK]));
> +#endif
> +
>  #ifdef CONFIG_NF_NAT_NEEDED
>  	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
>  		err = ctnetlink_change_nat_seq_adj(ct, cda);

I'm wondering whether this isn't subverting the intent of
secmark since AFAIK SELinux doesn't have finegrained
controls for netlink messages. OTOH, it also doesn't have
finegrained control over iptables rulesets.

James, does this patch look OK to you?
