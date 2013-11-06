From: Luis Fernando Cornachioni Estrozi <lestrozi@uolinc.com>
Subject: bugfix: fix regression bug in ebt_ip6 which resulted in ebtables
 IPv6 src/dst fields not being zeroed
Date: Wed, 6 Nov 2013 21:39:32 +0000
Message-ID: <527AB6D0.8090605@uolinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "pablo@netfilter.org" <pablo@netfilter.org>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a1-soldier1.uolinc.com ([200.147.2.64]:60623 "EHLO
	a1-soldier1.uolinc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3KFVtO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:49:14 -0500
Content-Language: en-US
Content-ID: <351702F5247F9B42B1D2B2F7DB772540@uolinc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fix regression bug in ebt_ip6 which resulted in ebtables IPv6 src/dst
fields not being zeroed

Signed-off-by: Lu=EDs Fernando Cornachioni Estrozi <lestrozi@uolinc.com=
>
---
this bug was introduced on commit
0898f99a267f89a7dc72cc687955f17613a711b8 on Mar 08, 2010; I'm just
returning 2 checks that existed before as suggested by Bart De Schuymer

--- linux-3.8.13/net/bridge/netfilter/ebt_ip6.c.orig    2013-07-03
12:07:25.892466692 -0300
+++ linux-3.8.13/net/bridge/netfilter/ebt_ip6.c    2013-07-03
12:29:47.272496246 -0300
@@ -48,10 +48,12 @@ ebt_ip6_mt(const struct sk_buff *skb, st
      if (info->bitmask & EBT_IP6_TCLASS &&
         FWINV(info->tclass !=3D ipv6_get_dsfield(ih6), EBT_IP6_TCLASS)=
)
          return false;
-    if (FWINV(ipv6_masked_addr_cmp(&ih6->saddr, &info->smsk,
-                       &info->saddr), EBT_IP6_SOURCE) ||
-        FWINV(ipv6_masked_addr_cmp(&ih6->daddr, &info->dmsk,
-                       &info->daddr), EBT_IP6_DEST))
+    if ((info->bitmask & EBT_IP6_SOURCE &&
+            FWINV(ipv6_masked_addr_cmp(&ih6->saddr, &info->smsk,
+                    &info->saddr), EBT_IP6_SOURCE)) ||
+            (info->bitmask & EBT_IP6_DEST &&
+            FWINV(ipv6_masked_addr_cmp(&ih6->daddr, &info->dmsk,
+                    &info->daddr), EBT_IP6_DEST)))
          return false;
      if (info->bitmask & EBT_IP6_PROTO) {
          uint8_t nexthdr =3D ih6->nexthdr;

________________________________

AVISO: A informa=E7=E3o contida neste e-mail, bem como em qualquer de s=
eus anexos, =E9 CONFIDENCIAL e destinada ao uso exclusivo do(s) destina=
t=E1rio(s) acima referido(s), podendo conter informa=E7=F5es sigilosas =
e/ou legalmente protegidas. Caso voc=EA n=E3o seja o destinat=E1rio des=
ta mensagem, informamos que qualquer divulga=E7=E3o, distribui=E7=E3o o=
u c=F3pia deste e-mail e/ou de qualquer de seus anexos =E9 absolutament=
e proibida. Solicitamos que o remetente seja comunicado imediatamente, =
respondendo esta mensagem, e que o original desta mensagem e de seus an=
exos, bem como toda e qualquer c=F3pia e/ou impress=E3o realizada a par=
tir destes, sejam permanentemente apagados e/ou destru=EDdos. Informa=E7=
=F5es adicionais sobre nossa empresa podem ser obtidas no site http://s=
obre.uol.com.br/.

NOTICE: The information contained in this e-mail and any attachments th=
ereto is CONFIDENTIAL and is intended only for use by the recipient nam=
ed herein and may contain legally privileged and/or secret information.
If you are not the e-mail=B4s intended recipient, you are hereby notifi=
ed that any dissemination, distribution or copy of this e-mail, and/or =
any attachments thereto, is strictly prohibited. Please immediately not=
ify the sender replying to the above mentioned e-mail address, and perm=
anently delete and/or destroy the original and any copy of this e-mail =
and/or its attachments, as well as any printout thereof. Additional inf=
ormation about our company may be obtained through the site http://www.=
uol.com.br/ir/.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
