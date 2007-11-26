From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Mon, 26 Nov 2007 16:34:02 +0000
Message-ID: <474AF57A.3090100@ufomechanic.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net> <474AE7DA.9050302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:45428 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbXKZQeL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:34:11 -0500
In-Reply-To: <474AE7DA.9050302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy wrote, On 26/11/07 15:35:
> Amin Azez wrote:
>> * Patrick McHardy wrote, On 26/11/07 07:30:
>>
>>> What advantages does this offer over using realms?
> >
>>> From my point of view, the advantage is that you don't have to use
>>> realms.
>>
>> Also, the match isn't REALLY strongly related to routing, which nexthop
>> suggests, it's really a dest-mac match but where the mac address is
>> resolved by IP each time from the neighbour table; so it's also useful
>> against layer 3 bridges as well, where the bridge hardware is out of
>> your control (may change) but it has the same IP address; e.g. some
>> hotspots. Realms can't do that AFAIK;
>
>
> Not sure I understand - if it has an IP, its not a bridge but a
> router. If its visible to routing in any way, realms can be used.
layer 3 bridges work by mac spoofing, so it's not routing or layer 2
bridging.
And so realms can't be used.

And the whole point of (ugh) layer 3 bridges is to join network segments
without the need to scatter routing changes everywhere.

The fact that xt_gatway can cope with this where realms can't is a nice
plus on top of the fact that you don't have to define a realm for each
gateway just to be able to match it's mac address.

Another advantage is that it can be used by linux users who haven't
manually defined any routing but still make use of
/etc/sysconfig/iptables to save and restore firewall rules.
(It's a matter of opinion whether or not it is desirable to give this
facility to users who haven't gone to the labour of defining a routing
table. Maybe we don't like those sort of people).

For myself, I have xml-based routing tables (yeah I posted my code to
lartc but no-one cared) but I still prefer xt_gateway over using realms
to indicate mere snat-ability, and to save realms for something more
realm-like. Lack of return routing seems incidental to the connotations
of realm in my mind, so use of realm seems like an abuse.

Sam
