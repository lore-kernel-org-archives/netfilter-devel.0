From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: tcp match silently drops packets
Date: Tue, 18 Oct 2005 07:27:32 +1000
Message-ID: <20051017212732.GA7010@gondor.apana.org.au>
References: <E1ERGOc-0008Hg-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.61.0510172114290.23546@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0510172114290.23546@filer.marasystems.com>
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

On Mon, Oct 17, 2005 at 09:30:21PM +0200, Henrik Nordstrom wrote:
> 
> >The latter is possible because the minimum fragment payload length is
> >8 bytes.
> 
> Yes, but not if the minimum allowed MTU of the available transports (not 
> including ATM) is accounted for. If you account for the minimum allowed 
> MTU on these transports then the smallest possible fragment is a bit 
> larger and these very small fragments is only seen if explicitly created 
> by "hacker" or similar trying to avoid packet filters (and quite 
> succesfully so in many simpler implementations).

This is not true if tunnels are involved.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
