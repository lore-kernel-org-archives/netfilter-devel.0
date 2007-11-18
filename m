From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sun, 18 Nov 2007 10:35:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711181031420.32356@fbirervta.pbzchgretzou.qr>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net>
 <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr>
 <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net>
 <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net>
 <473E27E9.4080306@treenet.co.nz> <473F120F.80508@trash.net>
 <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
 <473FA140.7080708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Phil Oester <kernel@linuxace.com>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXKRJfS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:35:18 -0500
In-Reply-To: <473FA140.7080708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 18 2007 03:19, Patrick McHardy wrote:
>> 
>> SUSE:
>> 
>> DNAT LOG MARK MASQUERADE REDIRECT REJECT TCPMSS esp
>> icmp icmpv6 limit pkttype policy
>> state tcp udp
>
> Thanks. Any RH/Fedora users?
>
>> But - surprise, surprise - it allows to load a file of custom rules,
>> so that basically means {ipt,ip6t,xt}_*, aka allmodconfig, like I said!
>> :)
>
> Well, the point of the avanced option is to handle *advanced*
> cases, so we don't need to cover manual adjustments (including
> things like shorewall which are usually installed manually).

Well even in "manual installations", I prefer to compile one kernel for all
hosts of the same arch I am ever going to work with, because it takes its time,
and time is precious when the number of hosts grows towards +Infinity.

> The
> default cases for people not having touched their *firewall*
> configuration is enough. I wasn't able to find the SuSE-script,

Unpack
http://download.opensuse.org/distribution/SL-OSS-factory/inst-source/suse/src/SuSEfirewall2-3.6_SVNr183-15.src.rpm
look into sbin/SuSEfirewall2.

> but from a screenshot I could see that they do optionally handle
> IPsec. So what I'm saying is that we should include f.i. the policy
> match,

...which I listed above...

> and all other modules needed without manually attending
> to the firewall, but nothing more.
>
> IOW, its for people like Linus, presumably not touching their
> default configuration, but unwilling to go through the 50+
> options to decide themselves.
>
> For people who want to compile-test them all (like me), we
> still can have a CONFIG_NETFILTER_ALL option hidden under
> CONFIG_NETFILTER_ADVANCED for simplicity, but that is a
> different topic.
>
For compile-testing, allmodconfig is sufficient IMO.
