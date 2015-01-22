From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCHv2 1/1] bridge: forward IPv6 fragmented packets when
 passing netfilter
Date: Fri, 23 Jan 2015 00:49:40 +0100
Message-ID: <20150122234940.GD16045@breakpoint.cc>
References: <20150120172805.GA11456@salvia>
 <1421969232-19103-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50416 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbbAVXto (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:49:44 -0500
Content-Disposition: inline
In-Reply-To: <1421969232-19103-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> +/* Equivalent to br_parse_ip_options for IPv6 */
> +
> +static int br_parse_ip6_options(struct sk_buff *skb)
> +{

Its not parsing options (yes, the ipv4 counterpart
is also	a misnomer, lets at least not repeat it?).

> +	const struct ipv6hdr *ip6h;
> +	struct net_device *dev = skb->dev;
> +	struct inet6_dev *idev = in6_dev_get(skb->dev);
> +	u32 len;
> +	u8 ip6h_len = sizeof(struct ipv6hdr);
> +
> +	if (!pskb_may_pull(skb, ip6h_len))
> +		goto inhdr_error;
> +
> +	ip6h = ipv6_hdr(skb);
> +
> +	/* Basic sanity checks
> +	 * check version
> +	 * check minimum header length (40 bytes)
> +	 * check total length
> +	 */
> +	if (ip6h->version != 6)
> +		goto inhdr_error;
> +
> +	if (!pskb_may_pull(skb, ip6h_len))
> +		goto inhdr_error;

This maypull call is not needed.

> +	len = ntohs(ip6h->payload_len) + ip6h_len;
> +
> +	if (skb->len < len) {
> +		IP6_INC_STATS_BH(dev_net(dev), idev,
> +				 IPSTATS_MIB_INTRUNCATEDPKTS);
> +		goto drop;
> +	} else if (len < ip6h_len) {

How can this evaluate to true?

I think this should be refactored with what we have in
br_nf_pre_routing_ipv6(); in fact br_nf_pre_routing_ipv6 says that there
is no ipv6 nat which isn't true anymore; I think we should at the very
least zero out skb->cb[] there as well.

Perhaps factor out some common br_ip6_validate() helper that does
whats in br_nf_pre_routing_ipv6.

> +		if (br_parse_ip6_options(skb))
> +			/* Drop invalid packet */
> +			return NF_DROP;

If we call br_parse_ip6_options() (or eqivalent) in PREROUTING, do we need to call
it again here?  It seems to me we validated skb already (Also true for ipv4 counterpart)?

The IP6CB reset is needed of course.

So, to summarize:

- Not sure we need br_parse_ip6_options; we only call it from
  br_nf_dev_queue_xmit(); as long as we validated things in prerouting
  earlier we should be fine.
- The existing validation calls in br_nf_pre_routing_ipv6() should at
  least also zero IP6CB.

I agree with the other changes (even though its ugly; don't have any better
solution either).

Cheers,
Florian
