From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Wed, 25 Feb 2009 15:57:52 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902251543370.4191@fbirervta.pbzchgretzou.qr>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net>
 <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr> <49A51B26.3050906@trash.net> <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr> <49A51D95.9080009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34813 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZBYO5z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:57:55 -0500
In-Reply-To: <49A51D95.9080009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-25 11:29, Patrick McHardy wrote:
>>>> +static bool
>>>> +tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
>>>> +{
>>>> +	int err;
>>>> +	struct rtable *rt;
>>>> +	struct flowi fl;
>>>> +
>>>> +	memset(&fl, 0, sizeof(fl));
>>>> +	fl.nl_u.ip4_u.daddr = info->gw.ip;
>>>> +	fl.nl_u.ip4_u.scope = RT_SCOPE_UNIVERSE;
>>>>       
>>> An index is probably useful when you want to mirror packets
>>> somewhere outside of regular routing.
>>
>> ifindex?
>
>Yes.

Hm. I previously had removed  fl.nl_u.ip4_u.tos = RT_TOS(iph->tos)
since I reasoned:

	The cloned packet would theoretically go through the OUTPUT
	chain (if we did not skip Xtables to guard against
	reentracy), even if the original packet went through FORWARD
	instead. As such, it is not a true clone, and does not need
	to be treated as such.

Adding ifindex to the routing key also makes me wonder whether the
mark should be used too, noting however, that it may lead to a trap
(order of MARK vs TEE in a ruleset) - or some kinky feature:

	-t mangle -A PREROUTING -j TEE --gw 192.168.1.15
	-t mangle -A PREROUTING -j MARK --set-mark 1
	-t mangle -A PREROUTING -j TEE --gw 192.168.1.15

I pretty much have no opinion on this.
