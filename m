From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Sun, 20 Jan 2008 17:48:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201746350.14598@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
 <477E487D.8000901@trash.net> <478C573D.2060401@trash.net>
 <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr>
 <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
 <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr>
 <479345F0.8000009@trash.net> <Pine.LNX.4.64.0801201410320.14598@fbirervta.pbzchgretzou.qr>
 <47934957.6000109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60970 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYATQsg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:48:36 -0500
In-Reply-To: <47934957.6000109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 20 2008 14:15, Patrick McHardy wrote:
>> 
>> > I also don't think the protocol
>> > check is very useful in this case since all conntrack entries contain
>> > port numbers or something similar.
>> 
>> Is IPv4-in-IPv4 or IPv6-in-IPv4 conntracked like UDP is?
>
> Sure, by proto_generic, which uses 0 for the port numbers.

See, that's another case why we have to explicitly list the protocols.
Just consider a stupid invocation of iptables:

	-m conntrack --ctorigport 0

I'd rather not let that match IPv4-in-IPv4 or so.

>> The protocol check is important though, because IPPROTO_GRE is
>> _not_ included, since, it's not something that has a port.
>
> It has the keys, which are also just a numerical value. Don't
> think of it as ports but as "layer 4 protocol keys".
>
But do these keys actually get modified in NAT?
