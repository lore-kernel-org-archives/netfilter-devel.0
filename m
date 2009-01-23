From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/2] IPv6 conntrack support for neighbour discovery
Date: Fri, 23 Jan 2009 19:42:12 +0900 (JST)
Message-ID: <200901231042.n0NAgD2O020049@toshiba.co.jp>
References: <1232701347.32071.13.camel@khasse.inl.fr>
	<alpine.DEB.2.00.0901231032320.13848@blackhole.kfki.hu>
	<alpine.DEB.2.00.0901231049000.13848@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: eric@inl.fr, yasuyuki.kozakai@toshiba.co.jp,
	Marek.Szuba@if.pw.edu.pl, kaber@trash.net,
	netfilter-devel@vger.kernel.org, vstinner@inl.fr,
	pablo@netfilter.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:63080 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZAWKmQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:42:16 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id n0NAgEIk001644
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 19:42:14 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id n0NAgEwA000934
	for netfilter-devel@vger.kernel.org; Fri, 23 Jan 2009 19:42:14 +0900 (JST)
Received: from mx.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id n0NAgDA4007731
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2009 19:42:13 +0900 (JST)
In-Reply-To: <alpine.DEB.2.00.0901231049000.13848@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Fri, 23 Jan 2009 10:50:59 +0100 (CET)

> On Fri, 23 Jan 2009, Jozsef Kadlecsik wrote:
> 
> > On Fri, 23 Jan 2009, Eric Leblond wrote:
> > 
> > > > How about just using NOTRACK target ?
> > > 
> > > This is a possible solution but you will then have to be a Netfilter
> > > Jedi to build a correct IPv6 filtering ruleset. I think even Padawan
> > > have no clue about the existence of the NOTRACK target.
> > > 
> > > Seriously speaking, the NOTRACK target is tagged "NETFILTER_ADVANCED"
> > > and IPv6 is becoming more and more frequent. I don't think we should use
> > > such a complicated solution for simply obtaining an IPv6 address. We
> > > will loose quit a bunch of users on this.
> > 
> > RFC4890, Recommendations for Filtering ICMPv6 Messages in Firewalls, deals 
> > with ICMPv6 filtering on firewalls in details and even contains a sample 
> > ip6tables script.
> > 
> > Wouldn't it make sense to add simply the RFC to the iptables source tree, 
> > and a sentence to the ip6tables manpage saying:
> > 
> > "Please read RFC 4890 and the sample script in it on how to filter ICMPv6
> > properly in an IPv6 environment."
> 
> Looking through the sample script again, it is incomplete as it does not 
> handle the ICMPv6 traffic targeted to/sent from the firewall itself. But 
> it'd be not hard to add the missing rules.

I looks not to show the recommended rules but just the usage of ip6tables.

-- Yasuyuki Kozakai
