From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.12: connection tracking broken?
Date: Thu, 23 Jun 2005 13:53:35 +1000
Message-ID: <20050623035335.GA1276@gondor.apana.org.au>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>
	<1119293193.3381.9.camel@localhost.localdomain>
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
	<42B82F35.3040909@trash.net>
	<20050622214920.GA13519@gondor.apana.org.au>
	<Pine.LNX.4.62.0506230502070.12228@kaber.coreworks.de>
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
In-Reply-To: <Pine.LNX.4.62.0506230502070.12228@kaber.coreworks.de>
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

On Thu, Jun 23, 2005 at 05:26:30AM +0200, Patrick McHardy wrote:
>
> >3) After a set period (say a year or so) we remove ipt_physdev altogether.
> 
> How about we schedule it for removal in a year, keep the workaround
> until then and then remove the hook defering?

That's fine by me.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
