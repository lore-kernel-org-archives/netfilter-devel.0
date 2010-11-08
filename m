From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 08 Nov 2010 07:51:30 +0100
Message-ID: <1289199090.2478.326.camel@edumazet-laptop>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>
	 <4CD79A79.3030103@trash.net> <4CD79B12.9060502@trash.net>
	 <AANLkTimdoYvCZhm-EqbVk2gBH-WR+yVXpnZyjqFbT-RF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44748 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0KHGvg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:51:36 -0500
Received: by wyb36 with SMTP id 36so3143434wyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Nov 2010 22:51:34 -0800 (PST)
In-Reply-To: <AANLkTimdoYvCZhm-EqbVk2gBH-WR+yVXpnZyjqFbT-RF@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 08 novembre 2010 =C3=A0 14:44 +0800, Changli Gao a =C3=A9crit =
:
> On Mon, Nov 8, 2010 at 2:39 PM, Patrick McHardy <kaber@trash.net> wro=
te:
> > [resend with netfilter-devel address fixed]
> >
> > On 08.11.2010 07:36, Patrick McHardy wrote:
> >> On 08.11.2010 07:32, Changli Gao wrote:
> >>> When conntrack is enabled, we can cache dst_entry into the
> >>> corresponding conntrack to eliminate the subsequence
> >>> ip_route_input_noref() calls for the same connection. The current
> >>> implementation is a standalone module. If this idea is welcomed, =
I'll
> >>> try to push it up. Thanks.
> >>>
> >>> Here it is: https://github.com/xiaosuo/xiaosuo/tree/master/nf_rtc=
ache/
> >>
> >> Please send the patch as attachment so it can be discussed.
> >
> >
>=20
> Here is a trivial patch to add RTCACHE NF extention.
>=20
>=20
> diff --git a/include/net/netfilter/nf_conntrack_extend.h
> b/include/net/netfilter/nf_conntrack_extend.h
> index 0772d29..a5077ef 100644
> --- a/include/net/netfilter/nf_conntrack_extend.h
> +++ b/include/net/netfilter/nf_conntrack_extend.h
> @@ -11,6 +11,7 @@ enum nf_ct_ext_id {
>  	NF_CT_EXT_ACCT,
>  	NF_CT_EXT_ECACHE,
>  	NF_CT_EXT_ZONE,
> +	NF_CT_EXT_RTCACHE,
>  	NF_CT_EXT_NUM,
>  };
>=20
> @@ -19,6 +20,7 @@ enum nf_ct_ext_id {
>  #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
>  #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
>  #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
> +#define NF_CT_EXT_RTCACHE_TYPE struct nf_rtcache
>=20
>  /* Extensions: optional stuff which isn't permanently in struct. */
>  struct nf_ct_ext {
>=20
> And here is main code:
>=20
>=20
> #define DEBUG
> #define pr_fmt(fmt) "nf_rtcache: " fmt
> #include <linux/module.h>
> #include <linux/ip.h>
> #include <net/ip.h>
> #include <net/dst.h>
> #include <net/route.h>
> #include <net/netfilter/nf_conntrack_extend.h>
>=20
> MODULE_AUTHOR("Changli Gao <xiaosuo@gmail.com>");
> MODULE_LICENSE("GPL");
>=20
> struct nf_rtcache {
> 	struct dst_entry	*dst[IP_CT_DIR_MAX];
> };
>=20
> static void nf_rtcache_destroy(struct nf_conn *ct)
> {
> 	struct nf_rtcache *cache =3D nf_ct_ext_find(ct, NF_CT_EXT_RTCACHE);
> 	struct dst_entry *dst;
>=20
> 	/* rcu_read_lock is held by __nf_ct_ext_destroy() */
> 	dst =3D rcu_dereference(cache->dst[IP_CT_DIR_ORIGINAL]);
> 	if (dst)
> 		dst_release(dst);
> 	dst =3D rcu_dereference(cache->dst[IP_CT_DIR_REPLY]);
> 	if (dst)
> 		dst_release(dst);
> }
>=20
> static struct nf_ct_ext_type nf_rtcache_ext __read_mostly =3D {
> 	.len		=3D sizeof(struct nf_rtcache),
> 	.align		=3D __alignof__(struct nf_rtcache),
> 	.id		=3D NF_CT_EXT_RTCACHE,
> 	.destroy	=3D nf_rtcache_destroy,
> };
>=20
> static unsigned int nf_rtcache_hook(unsigned int hooknum, struct sk_b=
uff *skb,
> 				    const struct net_device *in,
> 				    const struct net_device *out,
> 				    int (*okfn)(struct sk_buff *))
> {
> 	struct nf_conn *ct;
> 	enum ip_conntrack_info ctinfo;
> 	struct nf_rtcache *cache;
> 	enum ip_conntrack_dir dir;
> 	struct dst_entry *dst;
> 	struct iphdr *iph;
> 	int err;
>=20
> 	dst =3D skb_dst(skb);
> 	if (dst)
> 		return NF_ACCEPT;
> 	/* rcu_read_lock is held by nf_hook_slow() */
> 	ct =3D nf_ct_get(skb, &ctinfo);
> 	if (!ct)
> 		return NF_ACCEPT;
> 	cache =3D nf_ct_ext_find(ct, NF_CT_EXT_RTCACHE);
> 	if (!cache) {
> 		cache =3D nf_ct_ext_add(ct, NF_CT_EXT_RTCACHE, GFP_ATOMIC);
> 		if (!cache)
> 			return NF_ACCEPT;
> 	}
> 	dir =3D CTINFO2DIR(ctinfo);
> 	dst =3D rcu_dereference(cache->dst[dir]);
> 	iph =3D ip_hdr(skb);
> 	if (dst && dst->obsolete <=3D 0) {
> 		struct rtable *rth;
>=20
> 		rth =3D (struct rtable *)dst;
> 		if ((((__force u32)rth->fl.fl4_dst ^ (__force u32)iph->daddr) |
> 		     ((__force u32)rth->fl.fl4_src ^ (__force u32)iph->saddr) |
> 		     (rth->fl.iif ^ skb->dev->ifindex) |
> 		     rth->fl.oif |
> 		     (rth->fl.fl4_tos ^ (iph->tos & IPTOS_RT_MASK))) =3D=3D 0 &&
> 		    rth->fl.mark =3D=3D skb->mark &&
> 		    net_eq(dev_net(rth->dst.dev), dev_net(skb->dev)) &&
> 		    rth->dst.ops->check(&rth->dst, 0)) {
> 			dst_use_noref(dst, jiffies);
> 			skb_dst_set_noref(skb, dst);
> 			pr_debug("hit: %p\n", cache);
>=20
> 			return NF_ACCEPT;
> 		}
> 	}
>=20
> 	err =3D ip_route_input_noref(skb, iph->daddr, iph->saddr, iph->tos,
> 				   skb->dev);
> 	if (unlikely(err)) {
> 		if (err =3D=3D -EHOSTUNREACH)
> 			IP_INC_STATS(dev_net(skb->dev),
> 				     IPSTATS_MIB_INADDRERRORS);
> 		else if (err =3D=3D -ENETUNREACH)
> 			IP_INC_STATS(dev_net(skb->dev),
> 				     IPSTATS_MIB_INNOROUTES);
> 		else if (err =3D=3D -EXDEV)
> 			NET_INC_STATS(dev_net(skb->dev),
> 				      LINUX_MIB_IPRPFILTER);
> 		return NF_DROP;
> 	}
>=20
> 	dst =3D skb_dst(skb);
> 	if (dst->flags & DST_NOCACHE)
> 		dst =3D NULL;
> 	else
> 		dst_hold(dst);
> 	dst =3D xchg(&cache->dst[dir], dst);
> 	if (dst)
> 		dst_release(dst);
> 	pr_debug("miss: %p\n", cache);
>=20
> 	return NF_ACCEPT;
> }
>=20
> static struct nf_hook_ops nf_rtcache_ops __read_mostly =3D {
> 	.hook		=3D nf_rtcache_hook,
> 	.owner		=3D THIS_MODULE,
> 	.pf		=3D PF_INET,
> 	.hooknum	=3D NF_INET_PRE_ROUTING,
> 	.priority	=3D NF_IP_PRI_LAST,
> };
>=20
> static __init int init(void)
> {
> 	int err;
>=20
> 	need_ipv4_conntrack();
>=20
> 	err =3D nf_ct_extend_register(&nf_rtcache_ext);
> 	if (err)
> 		return err;
>=20
> 	err =3D nf_register_hook(&nf_rtcache_ops);
> 	if (err) {
> 		nf_ct_extend_unregister(&nf_rtcache_ext);
> 		return err;
> 	}
>=20
> 	return 0;
> }
>=20
> static __exit void fini(void)
> {
> 	nf_unregister_hook(&nf_rtcache_ops);
> 	nf_ct_extend_unregister(&nf_rtcache_ext);
> }
>=20
> module_init(init);
> module_exit(fini);
>=20

Adding yet another level of cache seems wrong to me.

Either we fix the first level, or we dont use it at all.

If ip_route_input_noref() is slow, we can work on it to make it faster.

I know dst_use_noref() is the real problem an can be optimized if
needed.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
