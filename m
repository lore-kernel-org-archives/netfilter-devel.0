From: Alexander Petrenas <zeracles@zeracles.net.ru>
Subject: RE: Kernel 4.1.0 broke the TARPIT & DELUGE targets in
 xtables-addons-2.6
Date: Tue, 23 Jun 2015 13:44:50 +0300
Message-ID: <6ba05a9b-e2ef-4c32-ab22-5e9e8440c91a@zeracles.net.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: 'Florian Westphal' <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zeracles.net.ru ([178.252.70.14]:54322 "EHLO zeracles.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbbFWKuC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2015 06:50:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks a lot, that works like a charm!

Here are diff patches for your convenience. They probably should be sub=
mitted to xtables-addons ASAP, so people's firewalls can continue filte=
ring & tarpitting instead of accepting...


#diff -u xt_TARPIT.orig.c xt_TARPIT.c

--- xt_TARPIT.orig.c    2015-06-23 13:31:04.406533833 +0300
+++ xt_TARPIT.c 2015-06-23 13:24:03.103202214 +0300
@@ -250,7 +250,7 @@

 #ifdef CONFIG_BRIDGE_NETFILTER
        if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
-           nskb->nf_bridge->mask & BRNF_BRIDGED))
+           nskb->nf_bridge->physoutdev))
 #else
        if (hook !=3D NF_INET_FORWARD)
 #endif
@@ -279,7 +279,7 @@

        nf_ct_attach(nskb, oldskb);

-       NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, nskb, NULL,
+       NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, NULL, nskb, NULL,
                skb_dst(nskb)->dev, dst_output);
        return;

@@ -394,7 +394,7 @@

        nf_ct_attach(nskb, oldskb);

-       NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, nskb, NULL,
+       NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, NULL, nskb, NULL,
                skb_dst(nskb)->dev, dst_output);
        return;





# diff -u xt_DELUDE.orig.c xt_DELUDE.c
--- xt_DELUDE.orig.c    2015-06-23 13:30:57.166533864 +0300
+++ xt_DELUDE.c 2015-06-23 13:28:11.046534539 +0300
@@ -107,7 +107,7 @@
        addr_type =3D RTN_UNSPEC;
 #ifdef CONFIG_BRIDGE_NETFILTER
        if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
-           nskb->nf_bridge->mask & BRNF_BRIDGED))
+           nskb->nf_bridge->physoutdev))
 #else
        if (hook !=3D NF_INET_FORWARD)
 #endif





Yours, Alexander Petrenas.


> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Florian Westphal
> Sent: Tuesday, June 23, 2015 12:40 PM
> To: Alexander Petrenas
> Cc: netfilter-devel@vger.kernel.org
>
> > Netfilter changes in the recent 4.1.0 kernel update included remova=
l of
> the BRNF_BRIDGED flag:
> >
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D40
> 451fd013878b005ccae767dfebc07dfecf85d9
> >
> > Unfortunately, getting rid of BRNF_BRIDGED flag broke the xtables-a=
ddons-
> 2.6 package, which now fails to build TARPIT & DELUGE targets with th=
e
> following errors:
> >
> > xtables-addons-2.6/extensions/xt_TARPIT.c:253:30: error: =E2=80=98B=
RNF_BRIDGED=E2=80=99
> undeclared (first use in this function)
> >       nskb->nf_bridge->mask & BRNF_BRIDGED))
> >                               ^
> >
> > xtables-addons-2.6/extensions/xt_TARPIT.c:282:2: error: too few arg=
uments
> to function =E2=80=98NF_HOOK=E2=80=99
> >   NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, nskb, NULL,
> >   ^
>=20
> NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, NULL, nskb, NULL,
>=20
> > xtables-addons-2.6/extensions/xt_TARPIT.c:397:2: error: too few arg=
uments
> to function =E2=80=98NF_HOOK=E2=80=99
> >   NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, nskb, NULL,
>=20
> NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, NULL, nskb, NULL,
>=20
> >
> > #ifdef CONFIG_BRIDGE_NETFILTER
> > 	if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
> > 	    nskb->nf_bridge->mask & BRNF_BRIDGED))
> > #else
>=20
> if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
>     nskb->nf_bridge->physoutdev))


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
