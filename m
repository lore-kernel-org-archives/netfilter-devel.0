From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v3)
Date: Mon, 25 Jun 2007 15:53:22 +0200
Message-ID: <467FC8D2.5070102@trash.net>
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru> <46417137.5080501@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756924AbXFYNxg@vger.kernel.org>
In-Reply-To: <46417137.5080501@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Vasily Averin wrote:
> +static int early_drop(const struct nf_conntrack_tuple *orig)
> +{
> +	unsigned int i, hash, cnt;
> +	int ret = 0;
> +
> +	hash = hash_conntrack(orig);
> +	cnt = NF_CT_PER_BUCKET;
> +
> +	for (i = 0;
> +		!ret && cnt && i < nf_conntrack_htable_size;
> +			++i, hash = ++hash % nf_conntrack_htable_size)
> +		ret = __early_drop(&nf_conntrack_hash[hash], &cnt);

Formatting is a bit ugly, looks much nicer as:

        for (i = 0; i < nf_conntrack_htable_size; i++) {

                ret = __early_drop(&nf_conntrack_hash[hash], &cnt);
                if (ret || !cnt)
                        break;
                hash = ++hash % nf_conntrack_htable_size;
        }

> @@ -1226,7 +1243,7 @@ int __init nf_conntrack_init(void)
>  		if (nf_conntrack_htable_size < 16)
>  			nf_conntrack_htable_size = 16;
>  	}
> -	nf_conntrack_max = 8 * nf_conntrack_htable_size;
> +	nf_conntrack_max = NF_CT_PER_BUCKET * nf_conntrack_htable_size;


I don't like the NF_CT_PER_BUCKET constant. First of all, each
conntrack is hashed twice, so its really only 1/2 of the average
conntracks per bucket. Secondly, its only a default and many
people use nf_conntrack_max = nf_conntrack_htable_size / 2, so
using this constant for early_drop seems wrong.

Perhaps make it 2 * nf_conntrack_max / nf_conntrack_htable_size
or even add a nf_conntrack_eviction_range sysctl.
