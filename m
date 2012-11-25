From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: move ipv6_find_hdr to net/ipv6/netfilter.c
 and rename it
Date: Sun, 25 Nov 2012 12:34:20 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211251228320.26208@nerf07.vanv.qr>
References: <1353798438-6331-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41913 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab2KYLeY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2012 06:34:24 -0500
In-Reply-To: <1353798438-6331-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-11-25 00:07, pablo@netfilter.org wrote:

>From: Pablo Neira Ayuso <pablo@netfilter.org>
>
>IPVS uses ipv6_find_hdr, but this function is defined in ip6_tables.c,
>to avoid such a dependency, move the function definition to the
>generic IPv6 netfilter infrastructure.

Could we move this in a different way, such that the "ipv6_find_hdr"
function and functions from exthdrs_core.c end up in a separate
module (or even built-in code), such that modules like xt_socket.c
can drop their dependency on ipv6.ko?

>index 429089c..d25f2d9 100644
>--- a/net/ipv6/netfilter.c
>+++ b/net/ipv6/netfilter.c
>@@ -60,6 +60,109 @@ int ip6_route_me_harder(struct sk_buff *skb)
> EXPORT_SYMBOL(ip6_route_me_harder);
> 
>+int nf_ip6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
>+		    int target, unsigned short *fragoff, int *flags)
>+{
>[...]
>+}
>+EXPORT_SYMBOL(nf_ip6_find_hdr);
