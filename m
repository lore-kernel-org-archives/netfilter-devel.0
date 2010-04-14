From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/4] netfilter: xtables: inclusion of xt_TEE
Date: Wed, 14 Apr 2010 07:52:59 +0200
Message-ID: <1271224379.16881.610.camel@edumazet-laptop>
References: <1271200907-5262-1-git-send-email-jengelh@medozas.de>
	 <1271200907-5262-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46150 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0DNFxI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:53:08 -0400
Received: by bwz19 with SMTP id 19so10279bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 22:53:07 -0700 (PDT)
In-Reply-To: <1271200907-5262-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 14 avril 2010 =C3=A0 01:21 +0200, Jan Engelhardt a =C3=A9cr=
it :
> xt_TEE can be used to clone and reroute a packet. This can for
> example be used to copy traffic at a router for logging purposes
> to another dedicated machine.
>=20
> References: http://www.gossamer-threads.com/lists/iptables/devel/6878=
1
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---

Lovely :)


> +
> +static const union nf_inet_addr tee_zero_address;
> +
> +static struct net *pick_net(struct sk_buff *skb)
> +{

#ifdef CONFIG_NET_NS

> +	const struct net_device *dev;
> +	const struct dst_entry *dst;
> +
> +	if (skb->dev !=3D NULL)
> +		return dev_net(skb->dev);
> +	dst =3D skb_dst(skb);
> +	if (dst !=3D NULL && dst->dev !=3D NULL)
> +		return dev_net(dst->dev);

#endif /* CONFIG_NET_NS */

> +	return &init_net;
> +}
> +
> +
> +static unsigned int
> +tee_tg4(struct sk_buff *skb, const struct xt_target_param *par)
> +{
> +	const struct xt_tee_tginfo *info =3D par->targinfo;
> +	struct iphdr *iph;
> +
> +	/*
> +	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE=
 for
> +	 * the original skb, which should continue on its way as if nothing=
 has
> +	 * happened. The copy should be independently delivered to the TEE
> +	 * --gateway.
> +	 */
> +	skb =3D skb_copy(skb, GFP_ATOMIC);
> +	if (skb =3D=3D NULL)
> +		return XT_CONTINUE;
> +
> +#ifdef WITH_CONNTRACK
> +	/* Avoid counting cloned packets towards the original connection. *=
/
> +	nf_conntrack_put(skb->nfct);
> +	skb->nfct     =3D &nf_conntrack_untracked.ct_general;
> +	skb->nfctinfo =3D IP_CT_NEW;
> +	nf_conntrack_get(skb->nfct);

This atomic increment on a global variable worries me... Would it be
possible to avoid it (and the associated decrement and test if null)

I would like to use this TEE facility but with xxx kpps for instance ;)

> +#endif


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
