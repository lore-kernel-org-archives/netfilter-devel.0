From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: xtables: introduce xt_length revision 2
Date: Sat, 24 Jul 2010 13:42:56 +0200
Message-ID: <1279971776.2451.66.camel@edumazet-laptop>
References: <1279961719-20479-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab0GXLnE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 07:43:04 -0400
Received: by wyf19 with SMTP id 19so997978wyf.19
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 04:43:01 -0700 (PDT)
In-Reply-To: <1279961719-20479-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le samedi 24 juillet 2010 =C3=A0 10:55 +0200, Jan Engelhardt a =C3=A9cr=
it :
> Introduce xt_length match revision 1. It adds support for layer-4,
> layer-5 and layer-7 length matching. It is much easier than writing u=
p
> the according xt_u32 magic.
>=20
> This can be used for packet scheduling; specific example are online
> games where all data is transferred over the same port, but the regul=
ar
> gameplay has a characteristically lower packet size than bulk downloa=
ds
> of game maps. (Tested with Unreal Tournament 99.)
>=20
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---

> +static bool
> +length2_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +	const struct xt_length_mtinfo2 *info =3D par->matchinfo;
> +	const struct iphdr *iph =3D ip_hdr(skb);
> +	unsigned int len =3D 0;
> +	bool hit =3D true;
> +
> +	if (info->flags & XT_LENGTH_LAYER3)
> +		len =3D ntohs(iph->tot_len);
> +	else if (info->flags & XT_LENGTH_LAYER4)
> +		len =3D ntohs(iph->tot_len) - par->thoff;
> +	else if (info->flags & XT_LENGTH_LAYER5)
> +		hit =3D xtlength_layer5(&len, skb, iph->protocol, par->thoff);
> +	else if (info->flags & XT_LENGTH_LAYER7)
> +		hit =3D xtlength_layer7(&len, skb, iph->protocol, par->thoff);
> +	if (!hit)
> +		return false;
> +
> +	return (len >=3D info->min && len <=3D info->max) ^
> +	       !!(info->flags & XT_LENGTH_INVERT);
> +}


This serie of tests is expensive and useless.

A switch() would be faster, if you dont use a bit mask, but continuous
values to get the layer.

(Use 3 bits to encode the layer, one bit for the invert)

Also, using a u16 is more expensive than a u32.

On x86, compiler is forced to use prefixes or conversions instructions
(movzwl), this makes code bigger. And much slower on some arches.

Trying to make xt_length rules shorter is a not a win, considering the
minimum size of an iptable rule (112 bytes) and 8 bytes alignement, and
bigger code size.

When v0 of xt_length was designed, the u16 choice for min/max was
already a bad choice, since a v1 is now needed.=20

BTW, you mention "revision 2" in your patch title, while it is revision
1



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
