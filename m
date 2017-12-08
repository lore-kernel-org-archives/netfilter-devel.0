From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next RFC,v2 1/6] netfilter: nf_conntrack: add
 IPS_OFFLOAD status bit
Date: Fri, 8 Dec 2017 07:47:02 +0100
Message-ID: <20171208064702.GA26061@breakpoint.cc>
References: <20171207124501.24325-1-pablo@netfilter.org>
 <20171207124501.24325-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, simon.horman@netronome.com,
        ronye@mellanox.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207124501.24325-2-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> index dc947e59d03a..6b463b88182d 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> @@ -100,6 +100,10 @@ enum ip_conntrack_status {
>  	IPS_HELPER_BIT = 13,
>  	IPS_HELPER = (1 << IPS_HELPER_BIT),
>  
> +	/* Conntrack has been offloaded to flow table. */
> +	IPS_OFFLOAD_BIT = 14,
> +	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
> +
>  	/* Be careful here, modifying these bits can make things messy,
>  	 * so don't let users modify them directly.
>  	 */

I think this new bit has to be added to the UNCHANGEABLE mask below.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 01130392b7c0..02e195accd47 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -901,6 +901,9 @@ static unsigned int early_drop_list(struct net *net,
>  	hlist_nulls_for_each_entry_rcu(h, n, head, hnnode) {
>  		tmp = nf_ct_tuplehash_to_ctrack(h);
>  
> +		if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
> +			continue;
> +

nit: I would move this below the ASSURED bit check, AFAIU most
(all?) offloaded conntracks are not in ASSURED state since they never
see two-way communication but in case we've mixed flows or no offloading
in place then the ASSURED check takes care of skipping earlydrop
already.

> +/* Set an arbitrary timeout large enough not to ever expire, this save
> + * us a check for the IPS_OFFLOAD_BIT from the packet path via
> + * nf_ct_is_expired().
> + */
> +static void nf_ct_offload_timeout(struct nf_conn *ct)
> +{
> +       ct->timeout = nfct_time_stamp + DAY;
> +}

Not sure if its worth adding a test to avoid unconditional write,
e.g. something like

> +static void nf_ct_offload_timeout(struct nf_conn *ct)
> +{
	if (nf_ct_expires(ct) < DAY/2))
> +       ct->timeout = nfct_time_stamp + DAY;

but perhaps not worth it, gc_worker is infrequent.
