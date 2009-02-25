From: Patrick McHardy <kaber@trash.net>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Wed, 25 Feb 2009 11:19:18 +0100
Message-ID: <49A51B26.3050906@trash.net>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net> <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58048 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZBYKT1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:19:27 -0500
In-Reply-To: <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-02-24 16:33, Patrick McHardy wrote:
>>> It cannot use dst_output because that would cause reentrancy into iptablse.
>>> Want a patch, though?
>>>       
>> I would like to have a look at the current patch, yes. Don't
>> bother fixing anything though, I mainly want to have a look
>> at the routing part.
>>     
> netfilter: xtables: import xt_TEE target
>   

Thanks. About dst_output and reentrancy - using IPSKB_REROUTED to
skip the netfilter hooks should work I guess.

A few suggestions:

> +#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
> +#	define WITH_CONNTRACK 1
> +#	include <net/netfilter/nf_conntrack.h>
> +static struct nf_conn tee_track;
> +#endif
> +
> +#include <linux/netfilter/xt_TEE.h>
> +
> +static const union nf_inet_addr tee_zero_address;
>   

ipv6_addr_any()?

> +static bool
> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
> +{
> +	int err;
> +	struct rtable *rt;
> +	struct flowi fl;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	fl.nl_u.ip4_u.daddr = info->gw.ip;
> +	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
>   

An index is probably useful when you want to mirror packets
somewhere outside of regular routing.
> +
> +	/* Trying to route the packet using the standard routing table. */
> +	err = ip_route_output_key(&init_net, &rt, &fl);
> +	if (err != 0) {
> +		if (net_ratelimit())
> +			pr_debug(KBUILD_MODNAME
> +			         ": could not route packet (%d)", err);
> +		return false;
> +	}
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
> +	return xt_register_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
> +}
> +
> +static void __exit tee_tg_exit(void)
> +{
> +	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
> +	/* [SC]: shoud not we cleanup tee_track here? */
> +}
>   

This is not safe without waiting for the tee ct references. Using the
untracked
conntrack would be nicer anyways, but would need a different loop detection
mechanism.

