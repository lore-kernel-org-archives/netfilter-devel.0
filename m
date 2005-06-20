From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 10:05:42 +1000
Message-ID: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
References: <42B56D9B.9070401@trash.net>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	netfilter-devel@manty.net, ebtables-devel@lists.sourceforge.net,
	rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net (Patrick McHardy)
In-Reply-To: <42B56D9B.9070401@trash.net>
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

Patrick McHardy <kaber@trash.net> wrote:
>
> The bridge-netfilter code defers calling of some NF_IP_* hooks to the
> bridge layer, when the conntrack reference is already gone, so the entry

Why does it defer them at all? Shouldn't the fact that the device is
bridged be transparent to the IP layer?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
