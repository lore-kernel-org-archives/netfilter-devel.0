From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Mon, 26 Nov 2007 08:24:11 +0100
Message-ID: <474A749B.8000303@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbXKZHY7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:24:59 -0500
In-Reply-To: <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Netfilter: Import xt_TEE
> 
> 
> Originally from Sebastian Classen.
> xt_TEE is the logical successor to ipt_ROUTE; routing based on packet
> charactersitics is done using xt_MARK/iproute2/fwmark nowadays, so
> what remains of ipt_ROUTE is the --tee option, which xt_TEE implements.

This still has the same problems I've been mentioning
every time this or ROUTE has come up, which is missing
IPsec support, duplication of the IP output path and
lots of unnecessary cruft.

> Index: linux-2.6/include/linux/netfilter/xt_TEE.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/netfilter/xt_TEE.h
> @@ -0,0 +1,12 @@
> +#ifndef _XT_TEE_TARGET_H
> +#define _XT_TEE_TARGET_H
> +
> +struct xt_tee_target_info {
> +	union {
> +		/* Address of gateway */
> +		u_int32_t gateway_v4;
> +		u_int32_t gateway_v6[4];

These should be __be32 or simply use in_addr/in6_addr.
At some point it would be good to have a nf_inet_addr
type (or something net/-wide) so we don't have to
introduce more and more of these.

> +static bool tee_routing(struct sk_buff *skb,
> +                        const struct xt_tee_target_info *info)
> +{
> +	int err;
> +	struct rtable *rt;
> +	struct iphdr *iph = ip_hdr(skb);
> +	struct flowi fl = {
> +		.nl_u = {
> +			.ip4_u = {
> +				.daddr = iph->daddr,
> +				.tos   = RT_TOS(iph->tos),
> +				.scope = RT_SCOPE_UNIVERSE,

Needs to initialize fl.proto for IPsec.

> +			}
> +		}
> +	};
> +
> +	/* The destination address may be overloaded by the target */
> +	if (info->gateway_v4 != 0)
> +		fl.fl4_dst = info->gateway_v4;
> +
> +	/* Trying to route the packet using the standard routing table. */
> +	err = ip_route_output_key(&rt, &fl);
> +	if (err != 0) {
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME
> +			         ": could not route packet (%d)", err);

No need to log this IMO. Not being able to route a packet
is a quite normal condition.

> +		return false;
> +	}
> +
> +	/* Drop old route. */
> +	dst_release(skb->dst);
> +	skb->dst = NULL;
> +
> +	/*
> +	 * Success if no oif specified or if the oif correspond to the
> +	 * one desired.
> +	 * [SC]: always the case, because we have no oif.
> +	 */
> +	skb->dst      = &rt->u.dst;
> +	skb->dev      = skb->dst->dev;
> +	skb->protocol = htons(ETH_P_IP);
> +	return true;
> +}
> +
> +/*
> + * Stolen from ip_finish_output2
> + * PRE : skb->dev is set to the device we are leaving by
> + *       skb->dst is not NULL
> + * POST: the packet is sent with the link layer header pushed
> + *       the packet is destroyed
> + */
> +static void tee_ip_direct_send(struct sk_buff *skb)
> +{

Why is this function needed? dst_output should do fine.

> +}
> +
> +/*
> + * To detect and deter routed packet loopback when using the --tee option, we
> + * take a page out of the raw.patch book: on the copied skb, we set up a fake
> + * ->nfct entry, pointing to the local &route_tee_track. We skip routing
> + * packets when we see they already have that ->nfct.
> + */
> +static unsigned int
> +tee_tg(struct sk_buff *skb, const struct net_device *in,
> +       const struct net_device *out, unsigned int hooknum,
> +       const struct xt_target *target, const void *targinfo)
> +{
> +	const struct xt_tee_target_info *info = targinfo;
> +
> +#ifdef WITH_CONNTRACK
> +	if (skb->nfct == &tee_track.ct_general) {
> +		/*
> +		 * Loopback - a packet we already routed, is to be
> +		 * routed another time. Avoid that, now.
> +		 */
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME "loopback - DROP!\n");
> +		return NF_DROP;
> +	}
> +#endif
> +
> +	/*
> +	 * If we are in INPUT, the checksum must be recalculated since
> +	 * the length could have changed as a result of defragmentation.
> +	 */
> +	if (hooknum == NF_INET_LOCAL_IN) {
> +		struct iphdr *iph = ip_hdr(skb);
> +		iph->check = 0;
> +		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);

ip_send_check(). This is actually only needed without conntrack
since it already recalculates the checksum when defragmenting.

> +	}
> +
> +	/*
> +	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
> +	 * the original skb, which should continue on its way as if nothing has
> +	 * happened. The copy should be independantly delivered to the TEE --gw.
> +	 */
> +	skb = skb_copy(skb, GFP_ATOMIC);
> +	if (skb == NULL) {
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME "copy failed!\n");
> +		return XT_CONTINUE;
> +	}

You have to do this before modifying the packets data. And no
logging for failed memory allocations please.

> +
> +#ifdef WITH_CONNTRACK
> +	/*
> +	 * Tell conntrack to forget this packet since it may get confused
> +	 * when a packet is leaving with dst address == our address.
> +	 * Good idea? Dunno. Need advice.
> +	 *
> +	 * NEW: mark the skb with our &tee_track, so we avoid looping
> +	 * on any already routed packet.
> +	 */
> +	nf_conntrack_put(skb->nfct);
> +	skb->nfct     = &tee_track.ct_general;
> +	skb->nfctinfo = IP_CT_NEW;
> +	nf_conntrack_get(skb->nfct);
> +#endif
> +
> +	if (info->gateway_v4 != 0) {
> +		if (tee_routing(skb, info))
> +			tee_ip_direct_send(skb);
> +	} else {
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME ": no parameter!\n");
> +	}

Seems to leak new packet in all but the successful case.

> +
> +	return XT_CONTINUE;
> +}
> +
> +static struct xt_target tee_tg_reg __read_mostly = {
> +	.name       = "TEE",
> +	.family     = AF_INET,
> +	.table      = "mangle",
> +	.target     = tee_tg,
> +	.targetsize = sizeof(struct xt_tee_target_info),
> +	.me         = THIS_MODULE,
> +};
> +
> +static int __init tee_tg_init(void)
> +{
> +#ifdef WITH_CONNTRACK
> +	/*
> +	 * Set up fake conntrack (stolen from raw.patch):
> +	 * - to never be deleted, not in any hashes
> +	 */
> +	atomic_set(&tee_track.ct_general.use, 1);
> +
> +	/* - and look it like as a confirmed connection */
> +	set_bit(IPS_CONFIRMED_BIT, &tee_track.status);
> +
> +	/* Initialize fake conntrack so that NAT will skip it */
> +	tee_track.status |= IPS_NAT_DONE_MASK;
> +#endif
> +
> +	return xt_register_target(&tee_tg_reg);
> +}
> +
> +static void __exit tee_tg_exit(void)
> +{
> +	xt_unregister_target(&tee_tg_reg);
> +	/* [SC]: shoud not we cleanup tee_track here? */

No, but you need to wait until all references to it
are gone.

> +}
> +
> +module_init(tee_tg_init);
> +module_exit(tee_tg_exit);
> +MODULE_AUTHOR("Sebastian Classen <sebastian.classen@freenet.ag>, Jan Engelhardt <jengelh@computergmbh.de>");
> +MODULE_DESCRIPTION("netfilter \"TEE\" target module");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_TEE");
> 

