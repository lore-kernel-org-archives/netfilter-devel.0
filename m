From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 11/11] netfilter: l4proto: refactor l4proto
 support for netns
Date: Wed, 23 Jan 2013 14:19:55 +0100
Message-ID: <20130123131955.GK13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1358842234-15005-11-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3AWNT6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:19:58 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-11-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have applied this, again with minor comestical changes

On Tue, Jan 22, 2013 at 04:10:34PM +0800, Gao feng wrote:
[...]
> diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
> index c3be4ae..74195e6 100644
> --- a/include/net/netfilter/nf_conntrack_l4proto.h
> +++ b/include/net/netfilter/nf_conntrack_l4proto.h
> @@ -121,11 +121,19 @@ extern struct nf_conntrack_l4proto *
>  nf_ct_l4proto_find_get(u_int16_t l3proto, u_int8_t l4proto);
>  extern void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p);
>  
> -/* Protocol registration. */
> -extern int nf_conntrack_l4proto_register(struct net *net,
> -					 struct nf_conntrack_l4proto *proto);
> -extern void nf_conntrack_l4proto_unregister(struct net *net,
> -					    struct nf_conntrack_l4proto *proto);
> +/* Protocol pernet registration. */
> +extern int
> +nf_conntrack_l4proto_pernet_register(struct net *net,
> +				     struct nf_conntrack_l4proto *proto);
> +extern void
> +nf_conntrack_l4proto_pernet_unregister(struct net *net,
> +				       struct nf_conntrack_l4proto *proto);
> +
> +/* Protocol global registration. */
> +extern int
> +nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
> +extern void
> +nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);

Using the nf_ct_* prefix instead of nf_conntrack_*.

>  static inline void nf_ct_kfree_compat_sysctl_table(struct nf_proto_net *pn)
>  {
> diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> index 04799da..71e32c4 100644
> --- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
> @@ -420,39 +420,39 @@ static int ipv4_net_init(struct net *net)
>  {
>  	int ret = 0;
>  
> -	ret = nf_conntrack_l4proto_register(net,
> -					    &nf_conntrack_l4proto_tcp4);
> +	ret = nf_conntrack_l4proto_pernet_register(net,
> +						&nf_conntrack_l4proto_tcp4);
>  	if (ret < 0) {
> -		pr_err("nf_conntrack_l4proto_tcp4 :protocol register failed\n");
> +		pr_err("nf_conntrack_l4proto_tcp4 :sysctl register failed\n");
>  		goto out_tcp;
>  	}
> -	ret = nf_conntrack_l4proto_register(net,
> -					    &nf_conntrack_l4proto_udp4);

We save again all those line breaks. Many of them were unnecesarily
added in previous patchset, you only have to break if the line is
larger than 80 chars per column.

Thanks a lot for this patchset, Gao. The netns support for conntrack
looks much cleaner now.
