From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Mon, 26 Nov 2007 08:30:48 +0100
Message-ID: <474A7628.6050605@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, azez@ufomechanic.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47841 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbXKZHbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:31:34 -0500
In-Reply-To: <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Netfilter: Import xt_gateway
> 
> 
> Originally from <azez@ufomechanic.net>,
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.html
> 
> This adds a gateway match to iptables that lets you match against the
> routed ipv4 gateway, it is very useful for SNAT if you want to avoid
> replicating your routing in your SNAT table.
> 
> e.g.
> 
> 	iptables -t nat -A POSTROUTING -m gateway --nexthop \
> 		172.16.1.1 -j SNAT --to-address 172.16.1.5
> 	iptables -t nat -A POSTROUTING -m gateway --nexthop \
> 		192.168.1.1 -j SNAT --to-address 192.168.1.25
> 
> to help you choose the right SNAT address.


I think MASQUERADE with properly set source addresses for
the routes should do the same since we already use the
gateway for the lookup.

What advantages does this offer over using realms?
