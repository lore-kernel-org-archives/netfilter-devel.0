From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Bridge netfilter defered hooks
Date: Fri, 02 Jun 2006 19:00:10 +0200
Message-ID: <1149267610.3021.11.camel@localhost.localdomain>
References: <448051F3.1070509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <448051F3.1070509@trash.net>
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

Op vr, 02-06-2006 te 16:57 +0200, schreef Patrick McHardy:
> Bart, I would like to get another discussion going about what
> to do about the physdev match and the hook deferal done by
> bridge netfilter. The lastest addition to the list of things
> it breaks is qdisc classification on the bridge device using
> MARK or CLASSIFY.
> 
> The main question is if the feature that causes all this trouble
> (output port matching within iptables) really is useful at all.
> It is not needed for filtering based on the output port of a
> bridge, this can be done using ebtables and iptables+mark if
> necessary. The only thing I can see that can't be done using
> ebtables is NAT based on the output port. I somehow doubt that
> this is really worth all the trouble, google show about 20 hits
> for "-t nat" "-m physdev" "--physdev-out", half of which appear
> to be examples in some magazines. So my prefered solution would
> be to deprecate it and remove it in a couple of month.

Sounds reasonable. You of course missed the combination of any of the
iptables specific matches/targets with the physdev match.
I'm against removing --physdev-out completely, since it's perfectly
usable without causing problems (AFAIK) for filtering purely bridged
packets.
I don't object to disabling the functionality for packets that get
routed to a bridge device. Most of those situations can probably be
fixed by routing the packets to the bridge ports instead.

> For a short-term solution we should also think about whether
> the hook deferal really needs to be done by default or if the
> few users that appear to be using this can't just enable it
> manually.

I have no objections to this either. The physdev module can be modified
so that it sends a warning to the syslog if --physdev-out is used in
non-bridging mode (meaning the rule is probably erroneous).

cheers,
Bart
