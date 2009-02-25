From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Wed, 25 Feb 2009 11:26:18 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net>
 <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr> <49A51B26.3050906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42833 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZBYK0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:26:21 -0500
In-Reply-To: <49A51B26.3050906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-25 11:19, Patrick McHardy wrote:
>
>Thanks. About dst_output and reentrancy - using IPSKB_REROUTED to
>skip the netfilter hooks should work I guess.

IPv6 is missing IPSKB_REROUTED entirely.

>> +static bool
>> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
>> +{
>> +	int err;
>> +	struct rtable *rt;
>> +	struct flowi fl;
>> +
>> +	memset(&fl, 0, sizeof(fl));
>> +	fl.nl_u.ip4_u.daddr = info->gw.ip;
>> +	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
>
>An index is probably useful when you want to mirror packets
>somewhere outside of regular routing.

ifindex?

>> +static void __exit tee_tg_exit(void)
>> +{
>> +	xt_unregister_targets(tee_tg_reg, ARRAY_SIZE(tee_tg_reg));
>> +	/* [SC]: shoud not we cleanup tee_track here? */
>> +}
>>   
>
>This is not safe without waiting for the tee ct references. Using
>the untracked conntrack would be nicer anyways, but would need a
>different loop detection mechanism.
>
Patches please :)
