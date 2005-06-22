From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.12: connection tracking broken?
Date: Thu, 23 Jun 2005 07:49:20 +1000
Message-ID: <20050622214920.GA13519@gondor.apana.org.au>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
	<42B82F35.3040909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@manty.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42B82F35.3040909@trash.net>
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

On Tue, Jun 21, 2005 at 05:16:05PM +0200, Patrick McHardy wrote:
> Bart De Schuymer wrote:
> > Deferring the hooks makes the bridge-nf code alot more complicated, so I
> > would be glad to get rid of it if it is the right thing to do. But
> > backwards compatibility can't be maintained and I'd be surprised if
> > every ruleset that now works will still be possible using an
> > iptables/ebtables scheme.
> 
> I unfortunately don't see a way to remove it, but we should keep
> thinking about it. Can you please check if the attached patch is
> correct? It should exclude all packets handled by bridge-netfilter
> from having their conntrack reference dropped. I didn't add nf_reset()'s
> to the bridging code because with tc actions the packets can end up
> anywhere else anyway, and this will hopefully get fixed right sometime.

I think this patch will be fine for 2.6.12.*.

Longer term though we should obsolete the ipt_physdev module.  The
rationale there is that this creates a precedence that we can't
possibly maintain in a consistent way.  For example, we don't have
a target that matches by hardware MAC address.  If you wanted to
do that, you'd hook into the arptables interface rather than deferring
iptables after the creation of the hardware header.

This can be done in two stages to minimise pain for people already
using it:

1) We rewrite ipt_physdev to do the lookups necessary to get the output
physical devices through the bridge layer.  Of course this may not be
the real output device due to changes in the environment.  So this should
be accompanied with a warning that users should switch to ebt.

2) We remove the iptables deferring since ipt_physdev will no longer need
it.

3) After a set period (say a year or so) we remove ipt_physdev altogether.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
