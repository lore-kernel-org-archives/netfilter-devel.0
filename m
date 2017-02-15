From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nf-next] netfilter: ct: add helper assignment support
Date: Wed, 15 Feb 2017 18:05:58 +0100
Message-ID: <20170215170558.GA22564@salvia>
References: <20170215162536.982-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751912AbdBORGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 12:06:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A09411DA08D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 18:06:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 936E3DA841
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 18:06:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DA2DDA817
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Feb 2017 18:06:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170215162536.982-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 15, 2017 at 05:25:36PM +0100, Florian Westphal wrote:
> This RFC adds native support to assign conntrack helpers.
> Not even compile tested.
> 
> It adds NFT_OBJECT_CT_HELPER to assign helpers to connections
> by using the stateful objects infra that is in place for quota and counter.
> 
> This would also need NFT_OBJECT_CT_TIMEOUT to support
> custom timeouts in nftables.
> 
> Does this look sane to you from a design p.o.v.?
> If yes, I would start looking into userspace side of things.

Yes.

I would add a NFT_OBJ_F_STATEFUL flag that we can set for counter and
quota. This flag would disable atomic-dump-and-reset which make no
sense for this object type.

> ---
>  include/uapi/linux/netfilter/nf_tables.h |  12 ++-
>  net/netfilter/nft_ct.c                   | 130 ++++++++++++++++++++++++++++++-
>  2 files changed, 139 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 05215d30fe5c..121e79cacc49 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1246,10 +1246,20 @@ enum nft_fib_flags {
>  	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
>  };
>  
> +enum nft_ct_helper_attributes {
> +	NFTA_CT_HELPER_UNSPEC,
> +	NFTA_CT_HELPER_NAME,
> +	NFTA_CT_HELPER_L3PROTO,
> 
> Note from myself, i dislike L3PROTO, it would be nicer to be able
> to handle this via the table family but I did not yet find a way
> to detect this from the obj->init() function.

We can pass nft_ctx to obj->init().

> Its needed for nf_conntrack_helper_try_module_get().
> 
> This also begs the question of how one would handle
> NFPROTO_INET, in that case we'd want both v4 and v6, but that
> would require stashing two struct nf_conntrack_helper in
> priv area.

Still, someone may want to only enable helper for IPv4 in the inet
chain, right? It's a bit of corner case but this attribute provides
slight more flexibility.

Probably, we should handle NFPROTO_INET as a real family at some
point, so user doesn't have to specify twice the same configuration to
attach helpers from inet chains. We may be able to save that double
pointer if we register the helper for NFPROTO_INET, but I would need
to have a closer look at that cthelper code to see the implications of
this.

On a different front, but related, I've been considering to handle the
NFPROTO_INET family from the netfilter/core, so we can get rid of the
existing specific code in nf_tables to handle this pseudofamily.
Actually, just handle it as a real family. I have a patchset here in a
branch I made to do this, I would need to revisit it.

> Any ideas/suggestions?
> 
> +	NFTA_CT_HELPER_L4PROTO,

Fine by now. We can place here more attributes, such as expectation
timeouts and specific per-helper setting (eg. ftp loose).  Just a
matter of adding more attributes later on, no problem.

> +	__NFTA_CT_HELPER_MAX,
> +};
> +#define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
> +
>  #define NFT_OBJECT_UNSPEC	0
>  #define NFT_OBJECT_COUNTER	1
>  #define NFT_OBJECT_QUOTA	2
> -#define __NFT_OBJECT_MAX	3
> +#define NFT_OBJECT_CT_HELPER	3
> +#define __NFT_OBJECT_MAX	4
>  #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
>  
>  /**
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index c6b8022c0e47..2a5bd9955122 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -32,6 +32,12 @@ struct nft_ct {
>  	};
>  };
>  
> +struct nft_ct_helper_obj  {
> +	struct nf_conntrack_helper *helper;
> +	u16 l3proto;
> +	u8 l4proto;
> +};
> +
>  #ifdef CONFIG_NF_CONNTRACK_ZONES
>  static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
>  static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
> @@ -729,28 +735,147 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
>  	.owner		= THIS_MODULE,
>  };
>  
> +static int nft_ct_helper_obj_init(const struct nlattr * const tb[],
> +				  struct nft_object *obj)
> +{
> +	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
> +	struct nf_conntrack_helper *helper;
> +	char name[NF_CT_HELPER_NAME_LEN];
> +	int family;
> +	u8 proto;
> +
> +	if (!tb[NFTA_CT_HELPER_NAME] || !tb[NFTA_CT_HELPER_L4PROTO] ||
> +	    !tb[NFTA_CT_HELPER_L3PROTO])
> +		return -EINVAL;
> +
> +	family = ntohs(nla_get_be16(tb[NFTA_CT_HELPER_L3PROTO]));
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		break;
> +	default:
> +		return -EAFNOSUPPORT;
> +	}
> +
> +	proto = nla_get_u8(tb[NFTA_CT_HELPER_L4PROTO]);
> +	if (!proto)
> +		return -ENOENT;
> +
> +
> +	if (nla_strlcpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name)) >= sizeof(name))
> +		return -EINVAL;

nla_policy already ensures we don't go over helper name size.

> +	helper = nf_conntrack_helper_try_module_get(name, family, proto);
> +	if (!helper)
> +		return -ENOENT;
> +
> +	priv->helper = helper;
> +	priv->l4proto = proto;
> +	priv->l3proto = family;
> +
> +	return 0;
> +}
