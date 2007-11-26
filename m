From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Mon, 26 Nov 2007 09:17:47 +0000
Message-ID: <474A8F3B.8020209@ufomechanic.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:40713 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbXKZJR4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:17:56 -0500
In-Reply-To: <474A7628.6050605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy wrote, On 26/11/07 07:30:
> Jan Engelhardt wrote:
>> Netfilter: Import xt_gateway
>>
>>
>> Originally from <azez@ufomechanic.net>,
>> http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/027954.html
>>
>>
>> This adds a gateway match to iptables that lets you match against the
>> routed ipv4 gateway, it is very useful for SNAT if you want to avoid
>> replicating your routing in your SNAT table.
>>
>> e.g.
>>
>>     iptables -t nat -A POSTROUTING -m gateway --nexthop \
>>         172.16.1.1 -j SNAT --to-address 172.16.1.5
>>     iptables -t nat -A POSTROUTING -m gateway --nexthop \
>>         192.168.1.1 -j SNAT --to-address 192.168.1.25
>>
>> to help you choose the right SNAT address.
>
> I think MASQUERADE with properly set source addresses for
> the routes should do the same since we already use the
> gateway for the lookup.
>
> What advantages does this offer over using realms?
>From my point of view, the advantage is that you don't have to use realms.

Also, the match isn't REALLY strongly related to routing, which nexthop
suggests, it's really a dest-mac match but where the mac address is
resolved by IP each time from the neighbour table; so it's also useful
against layer 3 bridges as well, where the bridge hardware is out of
your control (may change) but it has the same IP address; e.g. some
hotspots. Realms can't do that AFAIK;

Sam
