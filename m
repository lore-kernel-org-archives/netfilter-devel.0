From: Phil Oester <kernel@linuxace.com>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 07:35:41 -0800
Message-ID: <20071116153541.GA25986@linuxace.com>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net> <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44000
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753583AbXKPPmX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:42:23 -0500
Content-Disposition: inline
In-Reply-To: <473D91E9.4010809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Nov 16, 2007 at 01:49:45PM +0100, Patrick McHardy wrote:
> What I have in mind is roughly:
> 
> IPv4/IPv6 conntrack
> NAT
> ip_tables/ip6_tables
> tables: filter, nat
> matches: tcpudp, state, limit, hashlimit, policy
> targets: LOG, NFLOG, TCPMSS, REJECT, MASQUERADE
> 
> That should be enough for a simple firewall script. I'm not sure
> whether we should also select helpers though. Maybe the common
> ones, like ftp, irc and sip?

I'd vote for at least FTP here...most users will use it at
some point (or if they don't, wonder why FTP is broken).

Phil
