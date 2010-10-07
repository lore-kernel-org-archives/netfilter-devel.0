From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 09:13:40 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010070905240.28056@obet.zrqbmnf.qr>
References: <201010061842.20142.sven-ola@gmx.de> <alpine.LNX.2.01.1010061910060.28431@obet.zrqbmnf.qr> <201010062120.36885.sven-ola@gmx.de> <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven-Ola Tuecke <sven-ola@gmx.de>, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36882 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0JGHNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:13:41 -0400
In-Reply-To: <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-10-07 02:13, Amos Jeffries wrote:
>> 
>>> - NAT, even if NAT66, still interferes with ETE connectivity. Think
>>> FTP-SSL connections. That may not be your problem, but it's the Working
>>> Group's and the Draft's.
>> 
>> Yes - there are protocols that rely on addresses such as SIP, active FTP
>> etc. 
>> I don't plan to add NAT helpers for them, thats pointless somehow. 
>
>FWIW: FTP EPSV/EPRT extensions remove the need for layer-7 IPs and work
>with NAT44 and NAT66 nicely where the firewall supports them.

Yeah but if both sides are behind NAT, all bets are off with encrypted
connections.

>NAT66 is designed to work stateless AFAICT. As such the mapping likely
>does not need conntrack at all.

It does not /need/ it. But it interferes with it, given that conntrack runs
before mangle and thus sees received packet with their original contents
(2001:db8:1::<->2002:db8:1)), but locally originating packets with
(fefe:babe:1::<->2001:db8:1::).

>Is there perhapse some way to only configure the map once but have it
>apply to both src and dst depending on the packet direction?

No, for the following reason(s).

conntrack first has to figure out the direction of the flow too, by
looking at src/dst and comparing it with a table of known
connections. So if you wanted MAP66 to be a single rule too, you
would have to make MAP66 stateful at the very least.

Let alone there is, with the exception of the FORWARD chain, no place
that is entered by both receiving and sending side.

Even nf_nat's DNAT, which is normally only usable in PREROUTING, has
a secret hidden hook (NF_IP_PRI_NAT_SRC) on the "POST side" so that
reverse-direction mapping works.

>Why is /128 not allowed? that would be extremely useful for roaming
>devices internal firewalls and high-security setups with multi-homing.

To avoid user confusion, I suspect. When you declare

 -j MAP66 --from fefe:db8:1::12/128 --to 2001:db8:1::15/128,

you won't actually get 2001:db8:1::15, but something that fulfills
the checksum constraint. Like 2001:db8:1::f00d or so - which
would then be the point of user confusion.
