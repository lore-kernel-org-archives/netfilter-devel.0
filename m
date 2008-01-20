From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Sun, 20 Jan 2008 14:15:03 +0100
Message-ID: <47934957.6000109@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr> <478F5D92.3040404@netfilter.org> <Pine.LNX.4.64.0801171557040.28116@fbirervta.pbzchgretzou.qr> <479345F0.8000009@trash.net> <Pine.LNX.4.64.0801201410320.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57654 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYATNQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:16:03 -0500
In-Reply-To: <Pine.LNX.4.64.0801201410320.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 20 2008 14:00, Patrick McHardy wrote:
>> Another nitpick: we support masks for the addresses, ranges of ports
>> would be nice to have here as well.
> 
> Well well why don't we just add address ranges too then :p
> Do we need it so badly?

We already have masks, which is probably good enough.

> 
>> I also don't think the protocol
>> check is very useful in this case since all conntrack entries contain
>> port numbers or something similar.
> 
> Is IPv4-in-IPv4 or IPv6-in-IPv4 conntracked like UDP is?

Sure, by proto_generic, which uses 0 for the port numbers.

> The protocol check is important though, because IPPROTO_GRE is
> _not_ included, since, it's not something that has a port.

It has the keys, which are also just a numerical value. Don't
think of it as ports but as "layer 4 protocol keys".
