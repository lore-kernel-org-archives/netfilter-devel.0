From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Mon, 26 Nov 2007 21:14:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
 <474A749B.8000303@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	=?UTF-8?Q?Sebastian_Cla=C3=9Fen?= <sebastian.classen@freenet.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43424 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXKZUOY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:14:24 -0500
In-Reply-To: <474A749B.8000303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 26 2007 08:24, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> Netfilter: Import xt_TEE
>> 
>> Originally from Sebastian Classen.
>> xt_TEE is the logical successor to ipt_ROUTE; routing based on
>> packet charactersitics is done using xt_MARK/iproute2/fwmark
>> nowadays, so what remains of ipt_ROUTE is the --tee option, which
>> xt_TEE implements.
>
> This still has the same problems I've been mentioning every time
> this or ROUTE has come up, which is missing IPsec support,
> duplication of the IP output path and lots of unnecessary cruft.
>
>> +struct xt_tee_target_info {
>> +	union {
>> +		/* Address of gateway */
>> +		u_int32_t gateway_v4;
>> +		u_int32_t gateway_v6[4];
>
> These should be __be32 or simply use in_addr/in6_addr. At some
> point it would be good to have a nf_inet_addr type (or something
> net/-wide) so we don't have to introduce more and more of these.
>
In include/net/netfilter/nf_conntrack_tuple.h there is
nf_conntrack_address, which would be perfectly suited for the task.
But I am not sure if I can use that, since it would have to be
exported to userspacce (would probably need to move the union to
include/linux/netfilter/ too). Thoughts?


>> +	/* Trying to route the packet using the standard routing table. */
>> +	err = ip_route_output_key(&rt, &fl);
>> +	if (err != 0) {
>> +		if (net_ratelimit())
>> +			pr_debug(KBUILD_MODNAME
>> +			         ": could not route packet (%d)", err);
>
> No need to log this IMO. Not being able to route a packet is a
> quite normal condition.
>
It is a pr_debug(), which is compiled out by default. But I'll
happily rip it.


>> +/*
>> + * Stolen from ip_finish_output2
>> + * PRE : skb->dev is set to the device we are leaving by
>> + *       skb->dst is not NULL
>> + * POST: the packet is sent with the link layer header pushed
>> + *       the packet is destroyed
>> + */
>> +static void tee_ip_direct_send(struct sk_buff *skb)
>> +{
>
> Why is this function needed? dst_output should do fine.
>
Could IPsec xfrmation perhaps recurse? Thinking of something like

	(iptables -F OUTPUT)
	iptables -A OUTPUT -j TEE --gw overthere

Now, if overthere leads to an xfrm tunnel, the kernel will create an ESP
packet, and also send it through OUTPUT, would not it? Then there be a
recursion if using ipsec-aware dst_output.
How valid is this thought?


>> +static void __exit tee_tg_exit(void)
>> +{
>> +	xt_unregister_target(&tee_tg_reg);
>> +	/* [SC]: shoud not we cleanup tee_track here? */
>
> No, but you need to wait until all references to it
> are gone.
>
What's the _put() function I need for it?



thanks,
Jan
