From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
	breaks amanda dumps
Date: Fri, 05 Nov 2004 07:45:53 +1100
Message-ID: <E1CPoUT-0000sk-00@gondolin.me.apana.org.au>
References: <418A7B0B.7040803@trash.net>
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net (Patrick McHardy)
In-Reply-To: <418A7B0B.7040803@trash.net>
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
> The data that is changed is only a copy, the actual packet is not touched.

Does it call skb_ip_make_writable anywhere? If not then it may be
shared/cloned and can't be written at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
