From: "Amos Jeffries" <squid3@treenet.co.nz>
Subject: Re: xt_RAWNAT target idea
Date: Tue, 15 Jan 2008 11:43:44 +1300 (NZDT)
Message-ID: <47394.130.217.76.77.1200350624.squirrel@webmail.treenet.co.nz>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
    <478AFB75.7040701@trash.net>
    <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
    <478B310A.3040300@trash.net>
    <Pine.LNX.4.64.0801141347190.10906@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Patrick McHardy" <kaber@trash.net>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from treenet.co.nz ([60.234.233.111]:41460 "EHLO treenet.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYANWyR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:54:17 -0500
In-Reply-To: <Pine.LNX.4.64.0801141347190.10906@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
> On Jan 14 2008 10:53, Patrick McHardy wrote:
>>>
>>> - tc is a real black-box to most users;
>>>   lack of documentation (despite lartc.org efforts)
>>
>> That should be fixed by writing documentation, not code :)
>
> I would rather try obsoleting it.
>
>>> At which point I would be asking: why is tc trying to do the same
>>> as netfilter mangling targets?
>>
>> Well, true, it would be nice to be able to do this within
>> netfilter without TC actions. But adding a new chain to the
>> raw table is a high price, every new netfilter hooks costs
>> quite a bit of performance. Why not simply do this in the
>> mangle table? That will also make rerouting in OUTPUT work
>> as a side effect.
>
> That may just work.
>
>> Another issue is IPv6 support. Everyone agrees that we don't
>> want to support IPv6 NAT. So this would have to be removed.
>
> There is a need for IPv6 (conntrackful) NAT actually, just like there is
> for DHCPv6. Hiding hosts (you want websites to know how many devices you
> have?) or when your ISP runs a pay-per-address model.

I'll second that with transparent service proxying.
We all agree its not nice and should be avoided, but there are real-world
situations that need it in some form.

Amos Jeffries
Squid Development Team


