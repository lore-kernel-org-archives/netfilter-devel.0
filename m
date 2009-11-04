From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/6] netfilter: get rid of the grossness in netfilter.h
Date: Wed, 4 Nov 2009 13:28:11 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911041325490.24537@obet.zrqbmnf.qr>
References: <1257271483-26772-1-git-send-email-jengelh@medozas.de>  <1257271483-26772-4-git-send-email-jengelh@medozas.de> <412e6f7f0911032359w74eef716r9cc9db97ada0f046@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60705 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbZKDM2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:28:08 -0500
In-Reply-To: <412e6f7f0911032359w74eef716r9cc9db97ada0f046@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-11-04 08:59, Changli Gao wrote:

>On Wed, Nov 4, 2009 at 2:04 AM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>>
>> -#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond) =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
>> -({int __ret; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
>> -if ((cond) || (__ret =3D nf_hook_thresh(pf, hook, (skb), indev, out=
dev, okfn, INT_MIN)) =3D=3D 1)\
>> - =C2=A0 =C2=A0 =C2=A0 __ret =3D (okfn)(skb); =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 \
>> -__ret;})
>This code isn't the same as the linus tree's.

It sure is:

        git diff mdz/next~6..mdz/next include/linux/netfilter.h

=3D> no output, hence the same.

>And has a risk about uninitialized variable __ret.
>
>#define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)        =
         \
>({int __ret;                                                          =
         \
>if ((__ret=3Dnf_hook_thresh(pf, hook, (skb), indev, outdev, okfn,
>INT_MIN, cond)) =3D=3D 1)\
>        __ret =3D (okfn)(skb);                                        =
           \
>__ret;})

No uninitialized variable either there.

>The fact is: no matter the cond value, okfn(skb) should always be
>called, and hf_hook_thresh() should be called only when cond is true.

Yes, thank you for noticing. I will have that fixed up:

Subject: augment a3dc8cdef7c00d0340a0e6bc80211ce81b665f3b
---
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d02dc03..6854000 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -209,7 +209,7 @@ __ret;})
=20
 #define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond)		      =
 \
 ({int __ret;								       \
-if ((cond) || (__ret =3D nf_hook_thresh(pf, hook, (skb), indev, outdev=
, okfn, INT_MIN)) =3D=3D 1)\
+if (!(cond) || (__ret =3D nf_hook_thresh(pf, hook, (skb), indev, outde=
v, okfn, INT_MIN)) =3D=3D 1)\
 	__ret =3D (okfn)(skb);						       \
 __ret;})
=20
--=20
# Created with git-export-patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
