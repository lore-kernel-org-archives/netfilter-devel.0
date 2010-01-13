From: Dong Wei <dwei.zh@gmail.com>
Subject: Port back 2.6 kernel patch to 2.4 which fixed bridge module panic
	when received special fragments
Date: Wed, 13 Jan 2010 17:30:38 +0800
Message-ID: <3104bfb61001130130s4fbf1649oa9a12e7c855cc6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:41684 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0AMJai convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:30:38 -0500
Received: by qyk32 with SMTP id 32so2923634qyk.4
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2010 01:30:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, All

linux-2.6.32.3 fixed a kernel panic problem in bridge module when
received special fragments.

see: http://git.kernel.org/?p=3Dlinux/kernel/git/hpa/linux-2.6-allstabl=
e.git;a=3Dcommit;h=3D8fa9ff6849bb86c59cc2ea9faadf3cb2d5223497

There is a ebtables kernel patch ebtables-brnf-11-2_vs_2.4.31.diff.gz
which port back bridge netfilter. =A0After applied the kernel patch, th=
e
kernel panic problem will be introduced to the kernel. I made a kernel
patch on 2.4.37.7 which can fix this problem. I think this patch
should be merged to the ebtables-brnf-11-2_vs_2.4.31.diff.gz .


Signed-off-by Dong Wei<dwei.zh@gmail.com>


diff -ruNp linux-2.4.37.7/include/net/ip.h linux-2.4.37.7-new/include/n=
et/ip.h
--- linux-2.4.37.7/include/net/ip.h	2009-11-08 00:52:20.000000000 +0800
+++ linux-2.4.37.7-new/include/net/ip.h	2010-01-13 15:46:32.000000000 +=
0800
@@ -234,6 +234,7 @@ enum ip_defrag_users
 	IP_DEFRAG_CALL_RA_CHAIN,
 	IP_DEFRAG_CONNTRACK_IN,
 	IP_DEFRAG_CONNTRACK_OUT,
+	IP_DEFRAG_CONNTRACK_BRIDGE_IN,
 	IP_DEFRAG_NAT_OUT,
 	IP_DEFRAG_VS_OUT,
 	IP_DEFRAG_VS_FWD
diff -ruNp linux-2.4.37.7/net/ipv4/netfilter/ip_conntrack_core.c
linux-2.4.37.7-new/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.37.7/net/ipv4/netfilter/ip_conntrack_core.c	2009-11-08
00:52:20.000000000 +0800
+++ linux-2.4.37.7-new/net/ipv4/netfilter/ip_conntrack_core.c	2010-01-1=
3
16:09:40.000000000 +0800
@@ -38,6 +38,7 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)

+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
@@ -810,6 +811,20 @@ resolve_normal_ct(struct sk_buff *skb,
 	return h->ctrack;
 }

+static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
+					      struct sk_buff *skb)
+{
+#if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
+	if (skb->nf_bridge &&
+	    skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)
+		return IP_DEFRAG_CONNTRACK_BRIDGE_IN;
+#endif
+	if (hooknum =3D=3D NF_IP_PRE_ROUTING)
+		return IP_DEFRAG_CONNTRACK_IN;
+	else
+		return IP_DEFRAG_CONNTRACK_OUT;
+}
+
 /* Netfilter hook itself. */
 unsigned int ip_conntrack_in(unsigned int hooknum,
 			     struct sk_buff **pskb,
@@ -848,10 +863,8 @@ unsigned int ip_conntrack_in(unsigned in

 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb =3D ip_ct_gather_frags(*pskb,
-		                           hooknum =3D=3D NF_IP_PRE_ROUTING ?
-		                           IP_DEFRAG_CONNTRACK_IN :
-		                           IP_DEFRAG_CONNTRACK_OUT);
+		enum ip_defrag_users user =3D nf_ct_defrag_user(hooknum, *pskb);
+		*pskb =3D ip_ct_gather_frags(*pskb, user);
 		if (!*pskb)
 			return NF_STOLEN;
 	}
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
