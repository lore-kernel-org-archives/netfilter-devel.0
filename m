From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 14:21:00 +0200
Message-ID: <4C404EAC.7050509@trash.net>
References: <4C402DBD.3010007@quarantainenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Bas van Sisseren <bas@quarantainenet.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35861 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310Ab0GPMVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:21:03 -0400
In-Reply-To: <4C402DBD.3010007@quarantainenet.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 16.07.2010 12:00, schrieb Bas van Sisseren:
> Hello,
> 
> When redirecting, the destination address is replaced by the first
> ip-address on the receiving interface.
> 
> If the packet originally was sent to the second ip-address (or third,
> fourth, etc..), this patch doesn't change the destination ip.

So I guess you use statically configured address that are known
in advance. So why don't you simply set up your ruleset to only
redirect packets sent to the first address? That avoids iterating
through the entire address list for each new connection, which
can be quite large.

> 
> ============
> --- linux.orig/net/ipv4/netfilter/ipt_REDIRECT.c
> +++ linux/net/ipv4/netfilter/ipt_REDIRECT.c
> @@ -78,7 +78,21 @@
>         rcu_read_lock();
>         indev = __in_dev_get_rcu((*pskb)->dev);
>         if (indev && (ifa = indev->ifa_list))
> +       {
> +           struct in_ifaddr *ifa_cur; // interface ip-list cursor
> +
> +           // set current destination ip
> +           newdst = ((struct iphdr*)skb_network_header(*pskb))->daddr;
> +
> +           // iterate through interface ip list
> +           for (ifa_cur = ifa; ifa_cur; ifa_cur = ifa_cur->ifa_next)
> +               if (newdst == ifa_cur->ifa_local)
> +                   goto newdst_is_local;
> +
> +           // set new destination to first ip of this interface
>             newdst = ifa->ifa_local;
> +       }
> +   newdst_is_local:
>         rcu_read_unlock();
> 
>         if (!newdst)
> ============
> 
> Kind regards,
> 
> Bas van Sisseren
> 

