From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sun, 18 Nov 2007 03:19:44 +0100
Message-ID: <473FA140.7080708@trash.net>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net> <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net> <473E27E9.4080306@treenet.co.nz> <473F120F.80508@trash.net> <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Phil Oester <kernel@linuxace.com>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56042 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbXKRCUR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 21:20:17 -0500
In-Reply-To: <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 17 2007 17:08, Patrick McHardy wrote:
>> Amos Jeffries wrote:
>>> Patrick McHardy wrote:
>>>>
>>>> I agree. It would be useful if some users of a distribution that
>>>> includes a firewall script could check which modules it requires.
>>>>
>>> All right.
>>> Here is the fairly common shorewall 3.4's default dependencies as taken from
>>> /usr/share/shorewall/modules .
>>> These are not likely to change per-system without a clueful administrator.
>> This looks like basically everything. What I'm looking for is a list of
> 
> The problem is: you never know when they gonna change it!
> 
> 
>> modules required for the firewall scripts included in SuSE, RH, ...
> 
> SUSE:
> 
> DNAT LOG MARK MASQUERADE REDIRECT REJECT TCPMSS esp
> icmp icmpv6 limit pkttype policy
> state tcp udp

Thanks. Any RH/Fedora users?

> But - surprise, surprise - it allows to load a file of custom rules,
> so that basically means {ipt,ip6t,xt}_*, aka allmodconfig, like I said!
> :)

Well, the point of the avanced option is to handle *advanced*
cases, so we don't need to cover manual adjustments (including
things like shorewall which are usually installed manually). The
default cases for people not having touched their *firewall*
configuration is enough. I wasn't able to find the SuSE-script,
but from a screenshot I could see that they do optionally handle
IPsec. So what I'm saying is that we should include f.i. the policy
match, and all other modules needed without manually attending
to the firewall, but nothing more.

IOW, its for people like Linus, presumably not touching their
default configuration, but unwilling to go through the 50+
options to decide themselves.

For people who want to compile-test them all (like me), we
still can have a CONFIG_NETFILTER_ALL option hidden under
CONFIG_NETFILTER_ADVANCED for simplicity, but that is a
different topic.
