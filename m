From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: audit target to record accepted/dropped packets
Date: Fri, 14 Jan 2011 16:46:03 +0100
Message-ID: <4D306FBB.8020705@trash.net>
References: <20110114152024.GA9654@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37739 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab1ANPqC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:46:02 -0500
In-Reply-To: <20110114152024.GA9654@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01.2011 16:20, Thomas Graf wrote:
> +static unsigned int
> +audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
> +{
> +	const struct xt_AUDIT_info *info = par->targinfo;
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> +	if (ab == NULL)
> +		goto errout;
> +
> +	audit_log_format(ab, "action=%u hook=%u len=%u inif=%s outif=%s",
> +			 info->type, par->hooknum, skb->len,
> +			 par->in ? par->in->name : "?",
> +			 par->out ? par->out->name : "?");
> +
> +	if (skb->mark)
> +		audit_log_format(ab, " mark=%#x", skb->mark);
> +
> +	switch (skb->dev->type) {

This won't work in the AF_INET/LOCAL_OUT hook, skb->dev is set just
before the packet is handed to the POST_ROUTING hook. The ethernet
header is also only present on incoming packets.

> +	case ARPHRD_ETHER:
> +		audit_log_format(ab, " smac=%pM dmac=%pM macproto=0x%04x",
> +				 eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
> +				 ntohs(eth_hdr(skb)->h_proto));
> +
> +		if (par->family == NFPROTO_BRIDGE) {
> +			switch (eth_hdr(skb)->h_proto) {
> +			case __constant_htons(ETH_P_IP):
> +				audit_ip4(ab, skb);
> +				break;
> +
> +			case __constant_htons(ETH_P_IPV6):
> +				audit_ip6(ab, skb);
> +				break;
> +			}
> +		}
> +		break;
> +	}
> +
> +	switch (par->family) {
> +	case NFPROTO_IPV4:
> +		audit_ip4(ab, skb);
> +		break;
> +
> +	case NFPROTO_IPV6:
> +		audit_ip6(ab, skb);
> +		break;
> +	}
> +
> +	audit_log_end(ab);
> +
> +errout:
> +	return XT_CONTINUE;
> +}
> +
