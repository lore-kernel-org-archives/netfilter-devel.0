From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH v2] bridge: netfilter: don't call iptables on vlan packets
 if sysctl is off
Date: Mon, 05 Mar 2012 18:02:20 +0100
Message-ID: <4F54F19C.2050507@pandora.be>
References: <1330946020-25748-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:45927 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2CERCY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:02:24 -0500
In-Reply-To: <1330946020-25748-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 5/03/2012 12:13, Florian Westphal schreef:
> When net.bridge.bridge-nf-filter-vlan-tagged is 0 (default), vlan packets
> arriving should not be sent to ip(6)tables by bridge netfilter.

> +#define IS_ARP(skb) \
> +	(!vlan_tx_tag_present(skb)&&  skb->protocol == htons(ETH_P_ARP))
> +

I could nitpick on the lack of a space before the && (it's also in other 
places in your patch). Is that intentional? I've never seen this coding 
style before and you don't seem to do it for ||.
Apart from that it's a very clean patch. I leave it up to you and Pablo 
to decide if this needs to be changed before applying the patch.


Thanks,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
