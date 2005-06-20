From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 18:46:33 +0000
Message-ID: <1119293193.3381.9.camel@localhost.localdomain>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42B6B373.20507@trash.net>
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

Op ma, 20-06-2005 te 14:15 +0200, schreef Patrick McHardy:
> Bart De Schuymer wrote:
> > Op ma, 20-06-2005 te 04:45 +0200, schreef Patrick McHardy:
> > 
> >> Bart, can you explain why the hooks are defered please?
> > 
> > This is done so that iptables knows which bridge port the output device
> > is, using the iptables physdev match.
> 
> In which cases is this necessary? AFAICT the output device is determined
> in br_handle_frame_finish() for a normally bridged packet.

When the _routing_ decision sends the packet to br0 (a bridge device),
it is unknown which bridge port(s) the packet will be sent out. This is
only known after the packet enters the bridge code. Therefore, for
iptables to know the bridge port out device, the hooks must be postponed
until in the bridge code.

> > Can't you release the conntrack reference with a function registered on
> > the POSTROUTING hook with a prio higher than nat POSTROUTING (or
> > something like that)?
> 
> We would have to hold the reference while the packet is queued at the
> device for the bridge case, which we want to avoid.

Trust me, people will complain if they can no longer use the physdev
match for routed packets.
People using a bridging firewall will just have to live with the fact
that the reference is held until in the bridge code.

cheers,
Bart
