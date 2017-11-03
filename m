From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC,WIP 3/5] netfilter: nf_flow_offload: integration with
 conntrack
Date: Fri, 3 Nov 2017 20:49:35 +0100
Message-ID: <20171103194935.GH9424@breakpoint.cc>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-4-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103152636.9967-4-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch adds the IPS_OFFLOAD status bit, this new bit tells us that
> the conntrack entry is owned by the flow offload infrastructure. The
> timer of such conntrack entries is stopped - the conntrack garbage
> collector skips them - and they display no internal state in the case of
> TCP flows.
>
> Conntrack entries that have been offloaded to the flow table
> infrastructure cannot be deleted/flushed via ctnetlink. The flow table
> infrastructure is also responsible for releasing this conntrack entry.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Instead of nf_flow_release_ct(), I'd rather keep a pointer reference to
> the conntrack object from the flow_offload entry, so we can skip the
> conntrack look up.

I agree, this would make sense.

> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 8f3bd30511de..9af4bb0c2f46 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -272,7 +272,8 @@ static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
>  
>  static inline bool nf_ct_is_expired(const struct nf_conn *ct)
>  {
> -	return (__s32)(ct->timeout - nfct_time_stamp) <= 0;
> +	return (__s32)(ct->timeout - nfct_time_stamp) <= 0 &&
> +	       !test_bit(IPS_OFFLOAD_BIT, &ct->status);

An alternative would be to not touch nf_ct_is_expired() and instead ...
>  }
>  
> @@ -1011,12 +1014,14 @@ static void gc_worker(struct work_struct *work)
>  			tmp = nf_ct_tuplehash_to_ctrack(h);
>  
>  			scanned++;
> +			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
> +				continue;
 
... advance/refresh ct->timeout from gc worker, i.e.

 if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
     ct->timeout = nfct_time_stamp + (1 DAY);
     continue;
 }

Would prevent normal path to ever see offloaded entry
as 'timed out', without having to check for the flag in lookup path
(OTOH the check should not be an issue either because lookup path
 has to access ct->status anyway).
