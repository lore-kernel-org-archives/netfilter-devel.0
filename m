From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 10/11] netfilter: l3proto: refactor l3proto
 support for netns
Date: Wed, 23 Jan 2013 14:16:48 +0100
Message-ID: <20130123131648.GJ13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1358842234-15005-10-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54112 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3AWNQz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:16:55 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-10-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:10:33PM +0800, Gao feng wrote:
> move the code that register/unregister l3proto
> to the module_init/exit context.

I have applied this with minor cosmetical changes:

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  include/net/netfilter/nf_conntrack_l3proto.h   | 19 +++++++++----
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 22 ++++++++++-----
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 26 ++++++++++++------
>  net/netfilter/nf_conntrack_proto.c             | 37 +++++++++-----------------
>  4 files changed, 61 insertions(+), 43 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
> index 6f7c13f..b22605a 100644
> --- a/include/net/netfilter/nf_conntrack_l3proto.h
> +++ b/include/net/netfilter/nf_conntrack_l3proto.h
> @@ -76,11 +76,20 @@ struct nf_conntrack_l3proto {
>  
>  extern struct nf_conntrack_l3proto __rcu *nf_ct_l3protos[AF_MAX];
>  
> -/* Protocol registration. */
> -extern int nf_conntrack_l3proto_register(struct net *net,
> -					 struct nf_conntrack_l3proto *proto);
> -extern void nf_conntrack_l3proto_unregister(struct net *net,
> -					    struct nf_conntrack_l3proto *proto);
> +/* Protocol pernet registration. */
> +extern int
> +nf_conntrack_l3proto_pernet_register(struct net *net,
> +				struct nf_conntrack_l3proto *proto);

I have renamed these functions from
nf_conntrack_l3proto_pernet_register to nf_ct_l3proto_pernet_register,
to avoid too long function names.

Similar changes to other registration/unregistration functions.

> +extern void
> +nf_conntrack_l3proto_pernet_unregister(struct net *net,
> +				struct nf_conntrack_l3proto *proto);
> +
> +/* Protocol global registration. */
> +extern int
> +nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto);
> +extern void
> +nf_conntrack_l3proto_unregister(struct nf_conntrack_l3proto *proto);
> +
>  extern struct nf_conntrack_l3proto *nf_ct_l3proto_find_get(u_int16_t l3proto);
>  extern void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p);
>  
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index fcdd0c2..04799da 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -438,10 +438,10 @@ static int ipv4_net_init(struct net *net)
>  		pr_err("nf_conntrack_l4proto_icmp4 :protocol register failed\n");
>  		goto out_icmp;
>  	}
> -	ret = nf_conntrack_l3proto_register(net,
> -					    &nf_conntrack_l3proto_ipv4);
> +	ret = nf_conntrack_l3proto_pernet_register(net,
> +						&nf_conntrack_l3proto_ipv4);

With the new shorter function naming, we save the extra line break in
all these registrations.
