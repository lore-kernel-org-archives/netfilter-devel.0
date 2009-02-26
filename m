From: Patrick McHardy <kaber@trash.net>
Subject: Re: TEE patch [was: ROUTE patch]
Date: Thu, 26 Feb 2009 11:03:46 +0100
Message-ID: <49A66902.2060505@trash.net>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com> <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr> <49A3F922.4050508@trash.net> <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr> <49A4133E.4070703@trash.net> <alpine.LSU.2.00.0902251053270.20946@fbirervta.pbzchgretzou.qr> <49A51B26.3050906@trash.net> <alpine.LSU.2.00.0902251120250.20946@fbirervta.pbzchgretzou.qr> <49A51D95.9080009@trash.net> <alpine.LSU.2.00.0902251543370.4191@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Abhishek Singh <abhishek@abhishekonline.info>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZBZKD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:03:56 -0500
In-Reply-To: <alpine.LSU.2.00.0902251543370.4191@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-02-25 11:29, Patrick McHardy wrote:
>>>> An index is probably useful when you want to mirror packets
>>>> somewhere outside of regular routing.
>>> ifindex?
>> Yes.
> 
> Hm. I previously had removed  fl.nl_u.ip4_u.tos = RT_TOS(iph->tos)
> since I reasoned:
> 
> 	The cloned packet would theoretically go through the OUTPUT
> 	chain (if we did not skip Xtables to guard against
> 	reentracy), even if the original packet went through FORWARD
> 	instead. As such, it is not a true clone, and does not need
> 	to be treated as such.

Not sure what a true clone is ...

> Adding ifindex to the routing key also makes me wonder whether the
> mark should be used too, noting however, that it may lead to a trap
> (order of MARK vs TEE in a ruleset) - or some kinky feature:
> 
> 	-t mangle -A PREROUTING -j TEE --gw 192.168.1.15
> 	-t mangle -A PREROUTING -j MARK --set-mark 1
> 	-t mangle -A PREROUTING -j TEE --gw 192.168.1.15
> 
> I pretty much have no opinion on this.

I think it would make sense to simply allow setting all routing
keys.
