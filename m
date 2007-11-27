From: Amin Azez <azez@ufomechanic.net>
Subject: Re: NF [PATCH 4/4] xt_gateway
Date: Tue, 27 Nov 2007 13:33:58 +0000
Message-ID: <474C1CC6.1050401@ufomechanic.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006570.9477@fbirervta.pbzchgretzou.qr> <474A7628.6050605@trash.net> <474A8F3B.8020209@ufomechanic.net> <474AE7DA.9050302@trash.net> <474AF57A.3090100@ufomechanic.net> <474B6284.6010104@trash.net> <474BE470.2050209@ufomechanic.net> <474C158D.9050004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:58013 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbXK0NeH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:34:07 -0500
In-Reply-To: <474C158D.9050004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy wrote, On 27/11/07 13:03:
> Amin Azez wrote:
>> * Patrick McHardy wrote, On 27/11/07 00:19:
>>> The version Jan posted doesn't match on mac but on IP address.
>> It should be refusing to match mac if the ip's do match in the --gateway
>> match, because if the IP matches then the host is being addressed
>> directly and not as a gateway.
>> That's why it also checks IP.
>>
>> +    if (memcmp(&info->gateway_v4, &neigh->primary_key, tbl->key_len)
>> != 0)
>> +        return false;
>>
>> It checks mac as the primary key of the neighbour table.
>
> The primary key is the IP address.
thats true :-) Shame!
I can't even remember code I wrote 5 months back!

So....


>
>>> So I still don't see the point. You have a route with a gateway
>>> address, which you can match on. The fact that some MAC spoofing
>>> is done seems irrelevant. 
>> Take the case of a numbered layer 2 bridge. The bridged packets are not
>> routed by the bridge, but you might still want to snat or dnat some
>> certain packets to a certain gateway. I know networks that do this.
>> (Maybe the nat helpers are better on the bridge than on the nat-ing
>> router or something). Hey - thats what brouters are for.
>>
>> If there is mac spoofing where you are not routing, then it helps to
>> identify the box doing the spoofing; and it is best to do so by IP
>> address which in such cases usually identifies the role.
>> For example, if you have a win2K box doing internet connection sharing
>> on an ISDN dialup to another office on the same subnet, the box doing
>> the sharing (which may change) will generally have the same IP address.
>> There is no route to that box, but the xt_gateway match still has a use
>> here to recognize traffic that will be going over the ISDN link and may
>> want to be marked for shaping.
>
>
> I don't even see how that would work, if the box is doing mac spoofing
> then you have an arp entry for every IP behind the ISDN link. So you
> have the choice of adding n "gateway" rules or n destination IP rules.
Based on how the code works, you are right.  As you say, there is no mac
match.
> If I'm still not getting you (which might be possible since my brain is
> not really up to 100% because of sickness), just make an example using
> the actual rules you'd use.
I am not now certain the the example cases I proposed will work as I
said, your present understanding is well grounded.

>
> A completely different issue is that the neighbour entry is created
> after a packet has traversed all netfilter hooks, so you might set up
> incorrect NAT mappings (in your example). How do you deal with that?

For my examples you are correct. For real routing the neighbor table
entry is actually the routing entry; so you deftly show that the module
as it stands only has well defined behaviour in the case where there is
a routing entry or a static arp entry.

And so unless Jan has a strong case, I think you are right that this
adds nothing extra that routing realms have, and possible causes some
surprises in some non-routing conditions.

Although I still prefer it in routing cases, I admit there is no strong
case that you should prefer it.

Thanks for persisting nicely with me!

Sam
