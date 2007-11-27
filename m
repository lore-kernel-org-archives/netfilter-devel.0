From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Tue, 27 Nov 2007 01:19:16 +0100
Message-ID: <474B6284.6010104@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net> <474AE7DA.9050302@trash.net> <474AF57A.3090100@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39408 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134AbXK0ATV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:19:21 -0500
In-Reply-To: <474AF57A.3090100@ufomechanic.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Amin Azez wrote:
> * Patrick McHardy wrote, On 26/11/07 15:35:
>> Amin Azez wrote:
>>>
>>> Also, the match isn't REALLY strongly related to routing, which nexthop
>>> suggests, it's really a dest-mac match but where the mac address is
>>> resolved by IP each time from the neighbour table; so it's also useful
>>> against layer 3 bridges as well, where the bridge hardware is out of
>>> your control (may change) but it has the same IP address; e.g. some
>>> hotspots. Realms can't do that AFAIK;
>>>       
>> Not sure I understand - if it has an IP, its not a bridge but a
>> router. If its visible to routing in any way, realms can be used.
>>     
> layer 3 bridges work by mac spoofing, so it's not routing or layer 2
> bridging.
> And so realms can't be used.
>
> And the whole point of (ugh) layer 3 bridges is to join network segments
> without the need to scatter routing changes everywhere.
>
> The fact that xt_gatway can cope with this where realms can't is a nice
> plus on top of the fact that you don't have to define a realm for each
> gateway just to be able to match it's mac address.
>   

The version Jan posted doesn't match on mac but on IP address.
So I still don't see the point. You have a route with a gateway
address, which you can match on. The fact that some MAC spoofing
is done seems irrelevant. Since you have this route, you can also
use realms. What am I missing here?

> Another advantage is that it can be used by linux users who haven't
> manually defined any routing but still make use of
> /etc/sysconfig/iptables to save and restore firewall rules.
> (It's a matter of opinion whether or not it is desirable to give this
> facility to users who haven't gone to the labour of defining a routing
> table. Maybe we don't like those sort of people).
>
> For myself, I have xml-based routing tables (yeah I posted my code to
> lartc but no-one cared) but I still prefer xt_gateway over using realms
> to indicate mere snat-ability, and to save realms for something more
> realm-like. Lack of return routing seems incidental to the connotations
> of realm in my mind, so use of realm seems like an abuse

Since we already have a crapload of stuff in the kernel, I prefer to
only add things that extend the expressiveness of iptables to things
not possible otherwise. Mere simplifications can be done in userspace
IMO.


