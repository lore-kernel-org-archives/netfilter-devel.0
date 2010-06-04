From: Ninad Adi <adi.ninad@gmail.com>
Subject: Netfilter Implementation Details.
Date: Fri, 4 Jun 2010 22:05:39 +0530
Message-ID: <AANLkTinQDDSWaxLDCuaRDTGLM_y8qPq4eCQT0smdjMzt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61105 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0FDQfl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:35:41 -0400
Received: by iwn37 with SMTP id 37so1190444iwn.19
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jun 2010 09:35:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am not a Netfilter GURU.
Let Me know if my code tracing for netfilter is on right Path.
Kernel Version 2.6.34.

# I have divided the netfilter activities happening in kernel in two pa=
rts

1) On one side the Custom firewall kernel module written by a user
registers the nf_hook_ops using
=A0=A0=A0 nf_register_hook=A0 by filling all the needed parameters for =
nf_hook_ops.

=46or PRE_ROUTING HOOK
2) On Other side NF_HOOK is called from ip_rcv which is NF_INET_PRE_ROU=
TING HOOK
=A0=A0=A0 which goes and checks if there is any instance of netfilter_o=
ps
structure is registered with the HOOK or not.

=A0=A0=A0 int ip_rcv(struct sk_buff *skb, struct net_device *dev, struc=
t
packet_type *pt,
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 s=
truct net_device *orig_dev)
=A0=A0=A0 NF_HOOK(PF_INET, NF_INET_PRE_ROUTING, skb, dev, NULL,ip_rcv_f=
inish)
=A0=A0=A0 =A0=A0 NF_HOOK_THRESH(pf, hook, skb, in, out, okfn, INT_MIN)
=A0=A0=A0 =A0=A0=A0 nf_hook_thresh(pf, hook, skb, in, out, okfn, thresh=
)
=A0=A0=A0 =A0=A0=A0 =A0=A0 nf_hook_slow(pf, hook, skb, indev, outdev, o=
kfn, thresh)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 nf_iterate(&nf_hooks[pf][hook], skb, hook=
, indev,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 outdev, &elem, okfn, hook_thresh)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 verdict =3D elem->hook(hook, sk=
b, indev, outdev, okfn);



MY QUESTIONS

QUES 1 --> What is this nf_hook_slow function why is it called so ?
QUES 2 --> How does the registration of custom hook process takes
place exactly and how does
=A0 =A0 =A0 =A0 =A0 =A0 =A0=A0 =A0=A0 packet know if there is any rule =
registered for it
or not in the kernel code ?

Thanks In Advance.

Ninad.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
