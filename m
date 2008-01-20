From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Sun, 20 Jan 2008 17:55:40 +0100
Message-ID: <47937D0C.90107@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr> <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr> <479345F0.8000009@trash.net> <Pine.LNX.4.64.0801201410320.14598@fbirervta.pbzchgretzou.qr> <47934957.6000109@trash.net> <Pine.LNX.4.64.0801201746350.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62002 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbYATQzn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:55:43 -0500
In-Reply-To: <Pine.LNX.4.64.0801201746350.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 20 2008 14:15, Patrick McHardy wrote:
>>>> I also don't think the protocol
>>>> check is very useful in this case since all conntrack entries contain
>>>> port numbers or something similar.
>>> Is IPv4-in-IPv4 or IPv6-in-IPv4 conntracked like UDP is?
>> Sure, by proto_generic, which uses 0 for the port numbers.
> 
> See, that's another case why we have to explicitly list the protocols.
> Just consider a stupid invocation of iptables:
> 
> 	-m conntrack --ctorigport 0
> 
> I'd rather not let that match IPv4-in-IPv4 or so.

I prefer that to listing all the protocols explicitly. I guess
you would not object if it was named "--ctorigprotokey", but 
--ctorigport is clearer for most protocols.

>>> The protocol check is important though, because IPPROTO_GRE is
>>> _not_ included, since, it's not something that has a port.
>> It has the keys, which are also just a numerical value. Don't
>> think of it as ports but as "layer 4 protocol keys".
>>
> But do these keys actually get modified in NAT?

If the protocol is known to NAT and it clashes then yes.

