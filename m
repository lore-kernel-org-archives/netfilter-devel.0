From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 13:49:45 +0100
Message-ID: <473D91E9.4010809@trash.net>
References: <473D6C99.1010306@trash.net>	<20071116.021254.114985389.davem@davemloft.net>	<Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbXKPMtt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:49:49 -0500
In-Reply-To: <20071116.044413.227110480.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> From: Jan Engelhardt <jengelh@computergmbh.de>
> Date: Fri, 16 Nov 2007 13:19:43 +0100 (CET)
> 
>> Well, anyway, what modules did you have in mind NETFILTER_ADVANCED=n would turn
>> on?
> 
> Basic NAT and connection tracking, nothing else.


Thats not very useful without iptables and a couple of matches and
targets to make use of it :)

What I have in mind is roughly:

IPv4/IPv6 conntrack
NAT
ip_tables/ip6_tables
tables: filter, nat
matches: tcpudp, state, limit, hashlimit, policy
targets: LOG, NFLOG, TCPMSS, REJECT, MASQUERADE

That should be enough for a simple firewall script. I'm not sure
whether we should also select helpers though. Maybe the common
ones, like ftp, irc and sip?

