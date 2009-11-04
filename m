From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Wed, 4 Nov 2009 15:59:44 +0800
Message-ID: <412e6f7f0911032359w74eef716r9cc9db97ada0f046@mail.gmail.com>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
	 <1257271483-26772-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:33786 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZKDH7j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:59:39 -0500
Received: by pzk26 with SMTP id 26so4535390pzk.4
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2009 23:59:44 -0800 (PST)
In-Reply-To: <1257271483-26772-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 4, 2009 at 2:04 AM, Jan Engelhardt <jengelh@medozas.de> wro=
te:
>
> -#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond) =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> -({int __ret; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> -if ((cond) || (__ret =3D nf_hook_thresh(pf, hook, (skb), indev, outd=
ev, okfn, INT_MIN)) =3D=3D 1)\
> - =C2=A0 =C2=A0 =C2=A0 __ret =3D (okfn)(skb); =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 \
> -__ret;})
This code isn't the same as the linus tree's. And has a risk about
uninitialized variable __ret.

#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)         =
        \
({int __ret;                                                           =
        \
if ((__ret=3Dnf_hook_thresh(pf, hook, (skb), indev, outdev, okfn,
INT_MIN, cond)) =3D=3D 1)\
        __ret =3D (okfn)(skb);                                         =
          \
__ret;})

/**
 *      nf_hook_thresh - call a netfilter hook
 *
 *      Returns 1 if the hook has allowed the packet to pass.  The func=
tion
 *      okfn must be invoked by the caller in this case.  Any other ret=
urn
 *      value indicates the packet has been consumed by the hook.
 */
static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
                                 struct sk_buff *skb,
                                 struct net_device *indev,
                                 struct net_device *outdev,
                                 int (*okfn)(struct sk_buff *), int thr=
esh,
                                 int cond)
{
        if (!cond)
                return 1;
#ifndef CONFIG_NETFILTER_DEBUG
        if (list_empty(&nf_hooks[pf][hook]))
                return 1;
#endif
        return nf_hook_slow(pf, hook, skb, indev, outdev, okfn, thresh)=
;
}


> +static inline int
> +NF_HOOK_COND(uint8_t pf, unsigned int hook, struct sk_buff *skb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct net_device *in, str=
uct net_device *out,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int (*okfn)(struct sk_buff=
 *), bool cond)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int ret =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 if (cond ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (ret =3D nf_hook_thresh(pf, hook=
, skb, in, out, okfn, INT_MIN) =3D=3D 1))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D okfn(skb);
> + =C2=A0 =C2=A0 =C2=A0 return ret;
> +}

The fact is: no matter the cond value, okfn(skb) should always be
called, and hf_hook_thresh() should be called only when cond is true.
So the code will be.

if (cond) {
   if (ret =3D nf_hook_thresh(pf, hook, skb, in, out, okfn, INT_MIN)) =3D=
=3D 1)
       ret =3D okfn(skb);
} else {
    ret =3D okfn(skb);
}

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
