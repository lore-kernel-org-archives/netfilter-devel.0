From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: fix mangle tables back
Date: Thu, 11 Feb 2010 17:25:36 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111724250.11348@obet.zrqbmnf.qr>
References: <20100211161235.GA4099@x200>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37932 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab0BKQZh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:25:37 -0500
In-Reply-To: <20100211161235.GA4099@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 17:12, Alexey Dobriyan wrote:

>Calling POST_ROUTING hook with NULL input device is not going to work.
>
>--- a/net/ipv4/netfilter/iptable_mangle.c
>+++ b/net/ipv4/netfilter/iptable_mangle.c
>@@ -85,7 +85,7 @@ iptable_mangle_hook(unsigned int hook,
> 		     const struct net_device *out,
> 		     int (*okfn)(struct sk_buff *))
> {
>-	if (hook == NF_INET_LOCAL_OUT)
>+	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
> 		return ipt_local_hook(hook, skb, in, out, okfn);
> 
> 	/* PREROUTING/INPUT/FORWARD: */

postrouting did not call ipt_local_hook before, so why now?


>--- a/net/ipv6/netfilter/ip6table_mangle.c
>+++ b/net/ipv6/netfilter/ip6table_mangle.c
>@@ -79,7 +79,7 @@ ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
> 		     const struct net_device *in, const struct net_device *out,
> 		     int (*okfn)(struct sk_buff *))
> {
>-	if (hook == NF_INET_LOCAL_OUT)
>+	if (hook == NF_INET_LOCAL_OUT || hook == NF_INET_POST_ROUTING)
> 		return ip6t_local_out_hook(hook, skb, out, okfn);
> 
> 	/* INPUT/FORWARD */
>

