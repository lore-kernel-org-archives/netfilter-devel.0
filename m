From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Thu, 11 Oct 2007 09:21:35 +0200
Message-ID: <470DCEFF.6030709@trash.net>
References: <470CA4DF.6000803@oktetlabs.ru> <470DA22F.70807@trash.net> <470DC711.4020701@oktetlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Konstantin Ushakov <kostik@oktetlabs.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50573 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXJKHVp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:21:45 -0400
In-Reply-To: <470DC711.4020701@oktetlabs.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Konstantin Ushakov wrote:
> Patrick McHardy wrote:
>>> Questions:
>>>  - is it a bug or it's a deliberate decision to have such behaviour?
>>>  - is there any known add-hock solution for the problem?
>>
>> Its a consequence of how routing by fwmark works. Its not perfect,
>> but I don't see a better solution since the initial routing takes
>> place before we even have a packet.
>>
>> Just add a route to the dummy device or something like that, that
>> should make sure you don't get ENETUNREACH.
> 
> I'm afraid that dummy route does not solve the problem. I mean
>   - we should not pass out the packets, so where should the route lead?
> To loopback?


As I said, to the dummy device.

>   - another thing is that on 'send' (for, say, some external address,
> port 239)
>     with dummy route we hang, but if in fact the packet can't be routed,
>     we should get ENETUNREACH.
> [...]
> Idea that we had is the following:
> 
> we mark all packets that have passed netfilter (mangle table) with a
> specific mark (see configuration below).
> We add 2 rules:
>  - unreachable, for packets that have passed mange table but should not
> be routed
>  - rule that lookup table #100 for all packets, in table #100 we have
> route like
>    ip route add default via 127.0.0.2 table 100
> 
> Local traffic that goes to tcp port 80 is routed correctly. Forwarded
> traffic is not routed,
> ENETUNREACH is received on the lan side. BUT for local traffic that
> should not be forwarded,
> we don't receive UNREACH, 'send' just hangs.
> 
> Example:
> 
> on host on LAN side of the router:
> bash$ nc 192.168.1.5 81
> (UNKNOWN) [192.168.1.5] 80 (www) : No route to host
> 
> BUT if we issue that same command on the router itself, it handgs.


Ah, I see the problem. The route returns unreachable, which
iptable_mangle translates to NF_DROP. The problem is that
netfilter itself can't return ENETUNREACH and there is no
valid output function attached to the dst_entry that would
send an icmp unreachable. I think the only thing you could
do is manually call icmp_send(ICMP_DEST_UNREACH) in
ip_route_me_harder for this case.


