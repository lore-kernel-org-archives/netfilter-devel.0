From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 12:25:30 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051221560.21891@fbirervta.pbzchgretzou.qr>
References: <48E8C90D.10202@trash.net> <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr> <48E8D3C4.60306@trash.net> <20081005.090202.143862823.davem@davemloft.net> <48E8E736.8060800@trash.net> <alpine.LNX.1.10.0810051212060.21891@fbirervta.pbzchgretzou.qr>
 <48E8E984.8090807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38581 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbYJEQZb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:25:31 -0400
In-Reply-To: <48E8E984.8090807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 12:21, Patrick McHardy wrote:
>
> Thats true. Not using any prefixes requires keeping the
> upper letter naming convention for targets though (which
> I don't really mind).

Anybody else's voice on this?
I'd like to go for $(always lowercase extension name)_{mt,tg}.c if 
noone objects.
Or, when obvious extensions get combined maybe (like xt_mark and xt_MARK),
just mark.c and the issue is all gone.

Now while we are at it.. should future xtables targets (their actual
name as is used with iptables -j) continue to be uppercase?


>
>> I think this is sufficient:
>> 
>> obj-$(config_foo) += nfct_ftp.o
>> nfct_ftp-objs := ftp.c
>> 
>> That way, Mr Developer can use ft<TAB> to get ftp.c, but the
>> final module that we will be using with modprobe/rmmod still
>> has the prefix (and we should really have one!)
>
> A lot of people are unloading modules in their firewall scripts
> and that will break.
>
Well whether it's nfct_ or nf_conntrack_ is up to you; the point was
that ftp.c exist for the joy of the developer.
