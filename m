From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 10:50:08 +1000
Message-ID: <20050620005008.GA7760@gondor.apana.org.au>
References: <42B56D9B.9070401@trash.net>
	<E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	<20050619.171813.104659699.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@manty.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, kaber@trash.net,
	ebtables-devel@lists.sourceforge.net, rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050619.171813.104659699.davem@davemloft.net>
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

On Sun, Jun 19, 2005 at 05:18:13PM -0700, David S. Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Mon, 20 Jun 2005 10:05:42 +1000
>
> > Why does it defer them at all? Shouldn't the fact that the device is
> > bridged be transparent to the IP layer?
> 
> The bridge netfilter layer uses netif_rx(skb) at the deepest level in
> order to avoid too deep stack usage.

Sorry, but I don't see the connection between this and deferring
NF_IP_* hooks on the transmit path.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
