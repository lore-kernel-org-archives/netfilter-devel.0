From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter defered hooks
Date: Fri, 02 Jun 2006 19:18:52 +0200
Message-ID: <448072FC.3060902@trash.net>
References: <448051F3.1070509@trash.net>
	<1149267610.3021.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1149267610.3021.11.camel@localhost.localdomain>
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

Bart De Schuymer wrote:
> Op vr, 02-06-2006 te 16:57 +0200, schreef Patrick McHardy:
> 
>>Bart, I would like to get another discussion going about what
>>to do about the physdev match and the hook deferal done by
>>bridge netfilter. The lastest addition to the list of things
>>it breaks is qdisc classification on the bridge device using
>>MARK or CLASSIFY.
>>
>>The main question is if the feature that causes all this trouble
>>(output port matching within iptables) really is useful at all.
>>It is not needed for filtering based on the output port of a
>>bridge, this can be done using ebtables and iptables+mark if
>>necessary. The only thing I can see that can't be done using
>>ebtables is NAT based on the output port. I somehow doubt that
>>this is really worth all the trouble, google show about 20 hits
>>for "-t nat" "-m physdev" "--physdev-out", half of which appear
>>to be examples in some magazines. So my prefered solution would
>>be to deprecate it and remove it in a couple of month.
> 
> 
> Sounds reasonable. You of course missed the combination of any of the
> iptables specific matches/targets with the physdev match.

Thats what I meant by "iptables+mark". You can combine iptables
specific matches by marking matching packets, then match on the
mark with ebtables (or the other way around for incoming packets).

> I'm against removing --physdev-out completely, since it's perfectly
> usable without causing problems (AFAIK) for filtering purely bridged
> packets.

I'm fine with that as long as it doesn't stand in the way of getting
rid of the defered hooks, but I think you're right and it won't.

> I don't object to disabling the functionality for packets that get
> routed to a bridge device. Most of those situations can probably be
> fixed by routing the packets to the bridge ports instead.
>
>>For a short-term solution we should also think about whether
>>the hook deferal really needs to be done by default or if the
>>few users that appear to be using this can't just enable it
>>manually.
> 
> 
> I have no objections to this either. The physdev module can be modified
> so that it sends a warning to the syslog if --physdev-out is used in
> non-bridging mode (meaning the rule is probably erroneous).

Great, I'll look into this. Thanks.
