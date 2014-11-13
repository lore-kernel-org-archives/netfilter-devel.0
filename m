From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix various sparse warnings
Date: Thu, 13 Nov 2014 12:16:37 +0100
Message-ID: <20141113111637.GA3565@salvia>
References: <1415869456-7553-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52291 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932364AbaKMLOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:14:45 -0500
Content-Disposition: inline
In-Reply-To: <1415869456-7553-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 13, 2014 at 10:04:16AM +0100, Florian Westphal wrote:
> net/bridge/br_netfilter.c:870:6: symbol 'br_netfilter_enable' was not declared. Should it be static?
>   no; add include
> net/ipv4/netfilter/nft_reject_ipv4.c:22:6: symbol 'nft_reject_ipv4_eval' was not declared. Should it be static?
>   yes
> net/ipv6/netfilter/nf_reject_ipv6.c:16:6: symbol 'nf_send_reset6' was not declared. Should it be static?
>   no; add include
> net/ipv6/netfilter/nft_reject_ipv6.c:22:6: symbol 'nft_reject_ipv6_eval' was not declared. Should it be static?
>   yes
> net/netfilter/core.c:33:32: symbol 'nf_ipv6_ops' was not declared. Should it be static?
>   no; add include
> net/netfilter/xt_DSCP.c:40:57: cast truncates bits from constant value (ffffff03 becomes 3)
> net/netfilter/xt_DSCP.c:57:59: cast truncates bits from constant value (ffffff03 becomes 3)
>   add __force, 3 is what we want.
> net/ipv4/netfilter/nf_log_arp.c:77:6: symbol 'nf_log_arp_packet' was not declared. Should it be static?
>   yes
> net/ipv4/netfilter/nf_reject_ipv4.c:17:6: symbol 'nf_send_reset' was not declared. Should it be static?
>   no; add include

Applied nf-next, thanks Florian.
