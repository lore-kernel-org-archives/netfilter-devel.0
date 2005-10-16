From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 07:50:22 +1000
Message-ID: <E1ERGOc-0008Hg-00@gondolin.me.apana.org.au>
References: <Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hno@marasystems.com (Henrik Nordstrom)
In-Reply-To: <Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
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

Henrik Nordstrom <hno@marasystems.com> wrote:
> 
> The reason why this match hotdrops such packets is to deal with attacks 
> using fragmented packets in a reasonably secure manner without having to 
> rely on "UNCLEAN" or similar. A TCP packet so small that it does not even 
> include the TCP header is below the minimum MTU allowed and you should not 
> see any such fragments in normal traffic.

Not having any TCP header at all or not having the complete TCP header?

The latter is possible because the minimum fragment payload length is
8 bytes.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
