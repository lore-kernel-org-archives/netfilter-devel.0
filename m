From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Fix MASQUERADE
Date: Wed, 8 Sep 2004 07:30:36 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040907213036.GA1587@gondor.apana.org.au>
References: <1094566809.25641.9.camel@bach>
	<20040907080944.3f80976c.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>, netfilter-devel@lists.netfilter.org,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20040907080944.3f80976c.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 07, 2004 at 08:09:44AM -0700, David S. Miller wrote:
>
> Didn't Herbert Xu et al. come to the conclusion that this isn't
> the way to fix this and that using inet_select_addr() had
> some problems especially in policy routing situations?

No that was Julian Anastasov IIRC.

I agree with Rusty and Harald that MASQUERADE should be as simple as
possible.  So if you need complex routing to determine the correct
source address, then you should use SNAT.

Now I haven't actually seen Rusty's patch but if it just uses
inet_select_addr then it's definitely the way to go.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
