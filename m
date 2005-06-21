From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 07:19:42 +0000
Message-ID: <1119338382.3390.24.camel@localhost.localdomain>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
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
In-Reply-To: <42B74FC5.3070404@trash.net>
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

Op di, 21-06-2005 te 01:22 +0200, schreef Patrick McHardy:
> This seems to be a really bad idea, for a single match that violates
> layering we need to deal with this inconsistency. It's not just the
> conntrack reference, with IPsec the packet passed to the defered hooks
> is totally different from when it was still inside IP, which for example
> breaks the policy match.

I agree it is annoying.

> > Trust me, people will complain if they can no longer use the physdev
> > match for routed packets.
> 
> I'm sure they will, now that they got used to it. Why can't people
> match on the bridge port inside ebtables and only match on the device
> within iptables? Is there a case that can't be handled this way?

ebtables doesn't have all the targets/matches that iptables has.
Perhaps a rule structure using marking can always be used so that the
ACCEPT/DROP can be deferred until inside ebtables, I don't know if that
will always be possible though.

Deferring the hooks makes the bridge-nf code alot more complicated, so I
would be glad to get rid of it if it is the right thing to do. But
backwards compatibility can't be maintained and I'd be surprised if
every ruleset that now works will still be possible using an
iptables/ebtables scheme.
It has worked fine in the past and I see no reason why to stop making it
work now because of some recently found and unrelated referencing
problem.
Of course, if the netfilter people decide it should be removed, then so
be it.

cheers,
Bart
