From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 16:47:24 +0100
Message-ID: <473DBB8C.9020709@trash.net>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net> <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46871 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXKPPra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:47:30 -0500
In-Reply-To: <20071116153541.GA25986@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> On Fri, Nov 16, 2007 at 01:49:45PM +0100, Patrick McHardy wrote:
>> What I have in mind is roughly:
>>
>> IPv4/IPv6 conntrack
>> NAT
>> ip_tables/ip6_tables
>> tables: filter, nat
>> matches: tcpudp, state, limit, hashlimit, policy
>> targets: LOG, NFLOG, TCPMSS, REJECT, MASQUERADE
>>
>> That should be enough for a simple firewall script. I'm not sure
>> whether we should also select helpers though. Maybe the common
>> ones, like ftp, irc and sip?
> 
> I'd vote for at least FTP here...most users will use it at
> some point (or if they don't, wonder why FTP is broken).


I agree. It would be useful if some users of a distribution that
includes a firewall script could check which modules it requires.

