From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 15:28:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801141347190.10906@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
 <478AFB75.7040701@trash.net> <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
 <478B310A.3040300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYANO2a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:28:30 -0500
In-Reply-To: <478B310A.3040300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 14 2008 10:53, Patrick McHardy wrote:
>> 
>> - tc is a real black-box to most users;
>>   lack of documentation (despite lartc.org efforts)
>
> That should be fixed by writing documentation, not code :)

I would rather try obsoleting it.

>> At which point I would be asking: why is tc trying to do the same
>> as netfilter mangling targets?
>
> Well, true, it would be nice to be able to do this within
> netfilter without TC actions. But adding a new chain to the
> raw table is a high price, every new netfilter hooks costs
> quite a bit of performance. Why not simply do this in the
> mangle table? That will also make rerouting in OUTPUT work
> as a side effect.

That may just work.

> Another issue is IPv6 support. Everyone agrees that we don't
> want to support IPv6 NAT. So this would have to be removed.

There is a need for IPv6 (conntrackful) NAT actually, just like there is 
for DHCPv6. Hiding hosts (you want websites to know how many devices you 
have?) or when your ISP runs a pay-per-address model.
