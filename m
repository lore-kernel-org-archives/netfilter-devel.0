Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5723C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F3120838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfCBSfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:18 -0500
Received: from mail.us.es ([193.147.175.20]:35784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfCBSfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DD7F1361AB
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86883DA867
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7AD94DA85E; Sat,  2 Mar 2019 19:35:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6595DDA872;
        Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 141874265A4C;
        Sat,  2 Mar 2019 19:35:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/29] netfilter: nat: remove nf_nat_l4proto.h
Date:   Sat,  2 Mar 2019 19:34:35 +0100
Message-Id: <20190302183457.3079-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

after ipv4/6 nat tracker merge, there are no external callers, so
make last function static and remove the header.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l4proto.h | 16 ----------------
 net/netfilter/nf_nat_helper.c          |  1 -
 net/netfilter/nf_nat_proto.c           | 15 ++++++---------
 3 files changed, 6 insertions(+), 26 deletions(-)
 delete mode 100644 include/net/netfilter/nf_nat_l4proto.h

diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
deleted file mode 100644
index 95a4655bd1ad..000000000000
--- a/include/net/netfilter/nf_nat_l4proto.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Header for use in defining a given protocol. */
-#ifndef _NF_NAT_L4PROTO_H
-#define _NF_NAT_L4PROTO_H
-#include <net/netfilter/nf_nat.h>
-#include <linux/netfilter/nfnetlink_conntrack.h>
-
-struct nf_nat_l3proto;
-
-/* Translate a packet to the target according to manip type.  Return on success. */
-bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
-			      const struct nf_nat_l3proto *l3proto,
-			      unsigned int iphdroff, unsigned int hdroff,
-			      const struct nf_conntrack_tuple *tuple,
-			      enum nf_nat_manip_type maniptype);
-#endif /*_NF_NAT_L4PROTO_H*/
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 38793b95d9bc..12dea976d959 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -23,7 +23,6 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
 
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 9c4db18741ef..ecb988ed4d69 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -22,7 +22,6 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l3proto.h>
-#include <net/netfilter/nf_nat_l4proto.h>
 
 #include <linux/ipv6.h>
 #include <linux/netfilter_ipv6.h>
@@ -34,6 +33,7 @@
 
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nfnetlink_conntrack.h>
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -320,7 +320,7 @@ gre_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 
-bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
+static bool l4proto_manip_pkt(struct sk_buff *skb,
 			      const struct nf_nat_l3proto *l3proto,
 			      unsigned int iphdroff, unsigned int hdroff,
 			      const struct nf_conntrack_tuple *tuple,
@@ -356,7 +356,6 @@ bool nf_nat_l4proto_manip_pkt(struct sk_buff *skb,
 	/* If we don't know protocol -- no error, pass it unmodified. */
 	return true;
 }
-EXPORT_SYMBOL_GPL(nf_nat_l4proto_manip_pkt);
 
 static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
@@ -372,8 +371,8 @@ static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 	iph = (void *)skb->data + iphdroff;
 	hdroff = iphdroff + iph->ihl * 4;
 
-	if (!nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
-				      hdroff, target, maniptype))
+	if (!l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv4, iphdroff,
+			       hdroff, target, maniptype))
 		return false;
 	iph = (void *)skb->data + iphdroff;
 
@@ -409,8 +408,8 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 		goto manip_addr;
 
 	if ((frag_off & htons(~0x7)) == 0 &&
-	    !nf_nat_l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
-				      target, maniptype))
+	    !l4proto_manip_pkt(skb, &nf_nat_l3proto_ipv6, iphdroff, hdroff,
+			       target, maniptype))
 		return false;
 
 	/* must reload, offset might have changed */
@@ -758,8 +757,6 @@ void nf_nat_l3proto_exit(void)
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
-
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
 	.manip_pkt		= nf_nat_ipv6_manip_pkt,
-- 
2.11.0


