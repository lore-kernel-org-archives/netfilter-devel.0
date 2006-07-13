From: Amin Azez <azez@ufomechanic.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 15:11:59 +0100
Message-ID: <44B654AF.2080401@ufomechanic.net>
References: <44AA3446.6050609@trash.net>
	<44AA3496.5050909@trash.net>	<44AEFE20.3020307@shorewall.net>
	<44AF200F.9000204@trash.net>	<44B493BC.5010302@snapgear.com>
	<Pine.LNX.4.64.0607130937580.15827@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.64.0607130937580.15827@x2>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Patrick McHardy wrote, On 13/07/06 08:46:

>> Would it be possible to call the bridging code from the iptables
>> forward/output hooks, store the result somewhere, and then when the
>> packet is passed to the bridge device, just use the stored result?
>> So fix the problem by calling bridging early, instead of deferring
>> iptables?  I'm not sure if this could handle packets that need to
>> be sent out multiple ports.
> 
> No, it couldn't. Its questionable behaviour to do this anyway, think
> about something you REJECT without looking at the output port - you
> will reject once for each output port. The entire idea of using
> iptables from the bridge code seems flawed to me. Conntrack might
> also get very confused under certain cicurstances.
> 
>> And possibly related, could this be done for arp lookups too, so
>> that output mac matching is possible?
> 
> Theoretically yes, but I'm trying to get rid of a problem here,
> not introduce new ones :)

The difficulty I am now trying to solve is that of SNAT-ing bridged
traffic depending on the output port.

Bridging is really layer2 routing and so it makes a lot of sense to
handle it like this.

I'm currently looking at adding a bridge look-ahead target (similar to
Philips suggestion to see where a packet was likely to be bridged so I
can use that. It probably wants combining with physdev so that physdev
can use whichever strategy is suited whether the packet is routed or to
be bridged.

Sam
