From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 18:32:20 +0200
Message-ID: <48E8EC14.5060209@trash.net>
References: <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr> <48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net> <48E8E736.8060800@trash.net> <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr> <48E8E984.8090807@trash.net> <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48834 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030AbYJEQc0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:32:26 -0400
In-Reply-To: <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 12:21, Patrick McHardy wrote:
>> Thats true. Not using any prefixes requires keeping the
>> upper letter naming convention for targets though (which
>> I don't really mind).
> 
> Anybody else's voice on this?
> I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
> noone objects.
> Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
> just mark.c and the issue is all gone.

Thats a good point, once we've go for the directory split,
combining matches and targets will not fit into the scheme
very well. And I think that would be a good change.

So I'm very undecided right now, I think I need to let this
settle in my brain first :)

> Now while we are at it.. should future xtables targets (their actual
> name as is used with iptables -j) continue to be uppercase?

I was afraid I would trigger this kind of suggestions. Lets do
one thing at a time, and I don't think we should change too many
of the visible conventions. We can do this in nftables.

>>> I think this is sufficient:
>>>
>>> obj-$(config_foo) += nfct_ftp.o
>>> nfct_ftp-objs := ftp.c
>>>
>>> That way, Mr Developer can use ft<TAB> to get ftp.c, but the
>>> final module that we will be using with modprobe/rmmod still
>>> has the prefix (and we should really have one!)
>> A lot of people are unloading modules in their firewall scripts
>> and that will break.
>>
> Well whether it's nfct_ or nf_conntrack_ is up to you; the point was
> that ftp.c exist for the joy of the developer.

Right, we don't have to change the module names at all, I didn't
think of that.

I think I'm going to get a bit more rest from the workshop before
trying to use my brain again :)

