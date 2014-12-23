From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] bridge: detect NAT66 correctly and change MAC address
Date: Tue, 23 Dec 2014 15:03:43 +0100
Message-ID: <20141223140343.GA17171@salvia>
References: <1417813945-5050-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sven@open-mesh.com
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbaLWOBM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:01:12 -0500
Content-Disposition: inline
In-Reply-To: <1417813945-5050-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 05, 2014 at 10:12:25PM +0100, Bernhard Thaler wrote:
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index c190d22..73ea96a 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
[...]
> +static int br_nf_pre_routing_finish_ipv6(struct sk_buff *skb)
> +{
> +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> +	struct rtable *rt;
> +	struct net_device *dev = skb->dev;
> +
> +	if (nf_bridge->mask & BRNF_PKT_TYPE) {
> +		skb->pkt_type = PACKET_OTHERHOST;
> +		nf_bridge->mask ^= BRNF_PKT_TYPE;
> +	}
> +	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;

There is no fragmentation handling here. Actually, not your fault, the
original br_nf_pre_routing_finish_ipv6() doesn't consider this case.

I can take this patch, it doesn't do any worse than the existing code,
but probably you want to have a look at this.

Please, let me know. Thanks.
