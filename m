From: Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH] netfilter: conntrack: fix calculation of next bucket
 number in early_drop
Date: Thu, 25 Oct 2018 05:52:53 +0100
Message-ID: <a2fa755a-048b-459a-b526-2fe27cbb6574@arista.com>
References: <20181025034853.23573-1-vasilykh@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: stable@vger.kernel.org
To: Vasily Khoruzhick <vasilykh@arista.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025034853.23573-1-vasilykh@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 10/25/18 4:48 AM, Vasily Khoruzhick wrote:
> If there's no entry to drop in bucket that corresponds to the hash,
> early_drop() should look for it in other buckets. But since it increments
> hash instead of bucket number, it actually looks in the same bucket 8
> times: hsize is 16k by default (14 bits) and hash is 32-bit value, so
> reciprocal_scale(hash, hsize) returns the same value for hash..hash+7 in
> most cases.
> 
> Fix it by increasing bucket number instead of hash and rename _hash
> to bucket to avoid future confusion.
> 
> Fixes: 3e86638e9a0b ("netfilter: conntrack: consider ct netns in early_drop logic")
> Cc: <stable@vger.kernel.org> # v4.7+
> Signed-off-by: Vasily Khoruzhick <vasilykh@arista.com>

Nice work!

Reviewed-by: Dmitry Safonov <dima@arista.com>

> ---
>   net/netfilter/nf_conntrack_core.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index ca1168d67fac..a04af246b184 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1073,19 +1073,22 @@ static unsigned int early_drop_list(struct net *net,
>   	return drops;
>   }
>   
> -static noinline int early_drop(struct net *net, unsigned int _hash)
> +static noinline int early_drop(struct net *net, unsigned int hash)
>   {
>   	unsigned int i;
>   
>   	for (i = 0; i < NF_CT_EVICTION_RANGE; i++) {
>   		struct hlist_nulls_head *ct_hash;
> -		unsigned int hash, hsize, drops;
> +		unsigned int bucket, hsize, drops;
>   
>   		rcu_read_lock();
>   		nf_conntrack_get_ht(&ct_hash, &hsize);
> -		hash = reciprocal_scale(_hash++, hsize);
> +		if (!i)
> +			bucket = reciprocal_scale(hash, hsize);
> +		else
> +			bucket = (bucket + 1) % hsize;
>   
> -		drops = early_drop_list(net, &ct_hash[hash]);
> +		drops = early_drop_list(net, &ct_hash[bucket]);
>   		rcu_read_unlock();
>   
>   		if (drops) {
> 

-- 
           Dima
