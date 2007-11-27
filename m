From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Tue, 27 Nov 2007 01:12:17 +0100
Message-ID: <474B60E1.6060002@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr> <474A749B.8000303@trash.net> <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	=?ISO-8859-1?Q?Sebastian_Cla=DFen?= <sebastian.classen@freenet.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbXK0AMX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:12:23 -0500
In-Reply-To: <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 26 2007 08:24, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>> +struct xt_tee_target_info {
>>> +	union {
>>> +		/* Address of gateway */
>>> +		u_int32_t gateway_v4;
>>> +		u_int32_t gateway_v6[4];
>>>       
>> These should be __be32 or simply use in_addr/in6_addr. At some
>> point it would be good to have a nf_inet_addr type (or something
>> net/-wide) so we don't have to introduce more and more of these.
>>
>>     
> In include/net/netfilter/nf_conntrack_tuple.h there is
> nf_conntrack_address, which would be perfectly suited for the task.
> But I am not sure if I can use that, since it would have to be
> exported to userspacce (would probably need to move the union to
> include/linux/netfilter/ too). Thoughts?
>   

And the name doesn't really match. I'd prefer to type for all of
netfilter and then have conntrack use that one.

>
>   
>>> +	/* Trying to route the packet using the standard routing table. */
>>> +	err = ip_route_output_key(&rt, &fl);
>>> +	if (err != 0) {
>>> +		if (net_ratelimit())
>>> +			pr_debug(KBUILD_MODNAME
>>> +			         ": could not route packet (%d)", err);
>>>       
>> No need to log this IMO. Not being able to route a packet is a
>> quite normal condition.
>>
>>     
> It is a pr_debug(), which is compiled out by default. But I'll
> happily rip it.
>   

Right, I missed that. Still seems like something that should go after
debugging.

>>> +/*
>>> + * Stolen from ip_finish_output2
>>> + * PRE : skb->dev is set to the device we are leaving by
>>> + *       skb->dst is not NULL
>>> + * POST: the packet is sent with the link layer header pushed
>>> + *       the packet is destroyed
>>> + */
>>> +static void tee_ip_direct_send(struct sk_buff *skb)
>>> +{
>>>       
>> Why is this function needed? dst_output should do fine.
>>
>>     
> Could IPsec xfrmation perhaps recurse? Thinking of something like
>
> 	(iptables -F OUTPUT)
> 	iptables -A OUTPUT -j TEE --gw overthere
>
> Now, if overthere leads to an xfrm tunnel, the kernel will create an ESP
> packet, and also send it through OUTPUT, would not it? Then there be a
> recursion if using ipsec-aware dst_output.
> How valid is this thought?
>   

Packets only go through IPsec once unless the IPSKB_XFRM_TRANSFORMED
flag is cleared. You need to clear it once of course to handle already
encapsulated packets, your tee_ct should prevent further recursion,
right?

>
>   
>>> +static void __exit tee_tg_exit(void)
>>> +{
>>> +	xt_unregister_target(&tee_tg_reg);
>>> +	/* [SC]: shoud not we cleanup tee_track here? */
>>>       
>> No, but you need to wait until all references to it
>> are gone.
>>
>>     
> What's the _put() function I need for it?

None, something like for the untracked conntrack:

        /* wait until all references to nf_conntrack_untracked are 
dropped */
        while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
                schedule();


