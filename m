From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: tcp match silently drops packets
Date: Tue, 18 Oct 2005 12:11:09 +1000
Message-ID: <E1ERgwX-0002vy-00@gondolin.me.apana.org.au>
References: <Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hno@marasystems.com (Henrik Nordstrom)
In-Reply-To: <Pine.LNX.4.61.0510171549520.21372@filer.marasystems.com>
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
> An IP fragment with offset 1 can overwrite parts of the TCP header, and if 

IP fragment offset is measured in units of 8 bytes so this can't happen.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
