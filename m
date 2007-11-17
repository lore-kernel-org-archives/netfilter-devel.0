From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sat, 17 Nov 2007 22:19:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net>
 <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr>
 <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net>
 <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net>
 <473E27E9.4080306@treenet.co.nz> <473F120F.80508@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Phil Oester <kernel@linuxace.com>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42305 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXKQVTr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 16:19:47 -0500
In-Reply-To: <473F120F.80508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 17 2007 17:08, Patrick McHardy wrote:
> Amos Jeffries wrote:
>> Patrick McHardy wrote:
>> >
>> >
>> > I agree. It would be useful if some users of a distribution that
>> > includes a firewall script could check which modules it requires.
>> >
>>
>> All right.
>> Here is the fairly common shorewall 3.4's default dependencies as taken from
>> /usr/share/shorewall/modules .
>> These are not likely to change per-system without a clueful administrator.
>
> This looks like basically everything. What I'm looking for is a list of

The problem is: you never know when they gonna change it!


> modules required for the firewall scripts included in SuSE, RH, ...

SUSE:

DNAT LOG MARK MASQUERADE REDIRECT REJECT TCPMSS esp
icmp icmpv6 limit pkttype policy
state tcp udp

But - surprise, surprise - it allows to load a file of custom rules,
so that basically means {ipt,ip6t,xt}_*, aka allmodconfig, like I said!
:)
