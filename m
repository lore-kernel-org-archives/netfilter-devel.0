From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 3/3] netfilter: ctnetlink: randomize 32-bit ID
Date: Tue, 28 Nov 2017 13:18:37 +0100
Message-ID: <20171128121837.GI23412@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128021309.11277-3-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753738AbdK1MTq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 07:19:46 -0500
Content-Disposition: inline
In-Reply-To: <20171128021309.11277-3-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Don't leak the kernel pointer to userspace by adding a random seed. If
> you want a unique conntrack ID, used the new CTA_ID64 attribute.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 7aecb8ae5ecc..9a3357eeecdc 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -60,6 +60,7 @@
>  MODULE_LICENSE("GPL");
>  
>  static char __initdata version[] = "0.93";
> +static u32 nf_ct_seed __read_mostly;
>  
>  static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
>  				const struct nf_conntrack_tuple *tuple,
> @@ -444,9 +445,19 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
>  	return -1;
>  }
>  
> +static u32 nf_ct_id32(const struct nf_conn *ct)
> +{
> +	u32 id = (u32)(unsigned long)ct;
> +
> +	if (!nf_ct_seed)
> +		nf_ct_seed = get_random_u32();
> +
> +	return id + nf_ct_seed;
> +}

If we have the 64bit id, why not use it instead of ct address?
