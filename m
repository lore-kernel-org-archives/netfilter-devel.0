From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH/RFC 3/5] bridge-netfilter: simplify IP DNAT and fix IP
 DNAT on encapsulated packets
Date: Tue, 13 Apr 2010 11:44:36 +0200
Message-ID: <4BC43D04.2040808@trash.net>
References: <4BB207A8.6000608@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45735 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0DMJoi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:44:38 -0400
In-Reply-To: <4BB207A8.6000608@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> --- linux-2.6.33/net/bridge/br_device.c	2010-02-24 19:52:17.000000000 +0100
> +++ linux-2.6.33-uml/net/bridge/br_device.c	2010-03-30 14:15:19.000000000 +0200
> @@ -15,7 +15,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/ethtool.h>
> -
> +#include <linux/netfilter_bridge.h>
>  #include <asm/uaccess.h>
>  #include "br_private.h"
>  
> @@ -26,12 +26,19 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
>  	const unsigned char *dest = skb->data;
>  	struct net_bridge_fdb_entry *dst;
>  
> -	dev->stats.tx_packets++;
> -	dev->stats.tx_bytes += skb->len;
> -
>  	skb_reset_mac_header(skb);
>  	skb_pull(skb, ETH_HLEN);
>  
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
> +		br_nf_pre_routing_finish_bridge_slow(skb);
> +		return NETDEV_TX_OK;
> +	}
> +#endif
> +
> +	dev->stats.tx_packets++;
> +	dev->stats.tx_bytes += skb->len;

This changes how packets are counted by moving the statistics
update after the skb_pull() call.
