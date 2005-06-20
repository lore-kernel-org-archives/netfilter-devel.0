From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 01:22:45 +0200
Message-ID: <42B74FC5.3070404@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>	
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>	
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1119293193.3381.9.camel@localhost.localdomain>
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
> When the _routing_ decision sends the packet to br0 (a bridge device),
> it is unknown which bridge port(s) the packet will be sent out. This is
> only known after the packet enters the bridge code. Therefore, for
> iptables to know the bridge port out device, the hooks must be postponed
> until in the bridge code.

This seems to be a really bad idea, for a single match that violates
layering we need to deal with this inconsistency. It's not just the
conntrack reference, with IPsec the packet passed to the defered hooks
is totally different from when it was still inside IP, which for example
breaks the policy match.

> Trust me, people will complain if they can no longer use the physdev
> match for routed packets.

I'm sure they will, now that they got used to it. Why can't people
match on the bridge port inside ebtables and only match on the device
within iptables? Is there a case that can't be handled this way?

Regards
Patrick
