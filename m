From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Tue, 27 Nov 2007 09:33:36 +0000
Message-ID: <474BE470.2050209@ufomechanic.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net> <474AE7DA.9050302@trash.net> <474AF57A.3090100@ufomechanic.net> <474B6284.6010104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:55549 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbXK0Jdq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:33:46 -0500
In-Reply-To: <474B6284.6010104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy wrote, On 27/11/07 00:19:
>
> The version Jan posted doesn't match on mac but on IP address.
It should be refusing to match mac if the ip's do match in the --gateway
match, because if the IP matches then the host is being addressed
directly and not as a gateway.
That's why it also checks IP.

+	if (memcmp(&info->gateway_v4, &neigh->primary_key, tbl->key_len) != 0)
+		return false;

It checks mac as the primary key of the neighbour table.
> So I still don't see the point. You have a route with a gateway
> address, which you can match on. The fact that some MAC spoofing
> is done seems irrelevant. 
Take the case of a numbered layer 2 bridge. The bridged packets are not
routed by the bridge, but you might still want to snat or dnat some
certain packets to a certain gateway. I know networks that do this.
(Maybe the nat helpers are better on the bridge than on the nat-ing
router or something). Hey - thats what brouters are for.

If there is mac spoofing where you are not routing, then it helps to
identify the box doing the spoofing; and it is best to do so by IP
address which in such cases usually identifies the role.
For example, if you have a win2K box doing internet connection sharing
on an ISDN dialup to another office on the same subnet, the box doing
the sharing (which may change) will generally have the same IP address.
There is no route to that box, but the xt_gateway match still has a use
here to recognize traffic that will be going over the ISDN link and may
want to be marked for shaping.

This setup is not so contrived, I write software that goes into hardware
which is re-sold as a drop-in solution in all kinds of scenarios.
Drop-in solutions get paid for where network re-organisations will not
be considered. How nice to be able to traffic-shape and prioritize (at
last) traffic over that lowly legacy ISDN link and not have to
reconfigure when we swap the hardware.
> Since you have this route, you can also
> use realms. What am I missing here?
There may be no route, as in layer 3 bridge
The routing may not be done on a layer 2 bridge as above.
Realms are sometimes ugly.

Consider the design principles of coupling and cohesion.
In the cases where there is a route, setting a routing realm and
checking in iptables introduces a higher degree of coupling or
inter-dependance.
Also, a lower degree of cohesion; because realms do not necessarily of
themselves signify snat-ability there is low natural cohesion between
realms and snat-ability.
Awareness of both these points must be communicated a any future use of
realms must consider whether or not in each case any of the realms is
being referred to for snat.

Whether or not realms actually are or are not suitable depends on the
actual network. In a formally defined networks where realms are used,
realms may well be the best answer.
In an informally defined network where a router and it's role are
identified only by it's IP address

>
>>
>> For myself, I have xml-based routing tables (yeah I posted my code to
>> lartc but no-one cared) but I still prefer xt_gateway over using realms
>> to indicate mere snat-ability, and to save realms for something more
>> realm-like. Lack of return routing seems incidental to the connotations
>> of realm in my mind, so use of realm seems like an abuse
>
> Since we already have a crapload of stuff in the kernel, I prefer to
> only add things that extend the expressiveness of iptables to things
> not possible otherwise. Mere simplifications can be done in userspace
> IMO.
>

This mere simplification is, in user-space, (as explained above)  a
complication, and doubly so because there are no generally available
routing table manipulation tools to match iptables-save/iptables-restore.

However, I think then by your criteria above you will accept xt_gateway
because it extends the expressiveness of iptables to do things not
possible by realm (detection of gateways on a box that did not route)
and to do other things which are possible, but in (as you say) a simpler
way (albeit not in userspace), and by my judgement, a more expressive way.

I think I met your criteria.... :-)

Sam
