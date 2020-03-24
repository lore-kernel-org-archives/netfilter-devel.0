Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F272CC2BAEE
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 17:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D745F206F6
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 17:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgCXRuR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:50:17 -0400
Received: from correo.us.es ([193.147.175.20]:39042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgCXRuR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 13:50:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 75D2EE1518
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 18:49:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 669F9DA8E6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 18:49:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 660DCDA736; Tue, 24 Mar 2020 18:49:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E60FDA3C2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 18:49:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 18:49:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7C1B742EF42D
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 18:49:37 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/3] netfilter: flowtable: add counter support
Date:   Tue, 24 Mar 2020 18:50:09 +0100
Message-Id: <20200324175009.3118-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324175009.3118-1-pablo@netfilter.org>
References: <20200324175009.3118-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new flag to turn on flowtable counters which are stored in the
conntrack entry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h    | 1 +
 include/uapi/linux/netfilter/nf_tables.h | 5 ++++-
 net/netfilter/nf_flow_table_ip.c         | 7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4beb7f13bc50..4a2ec6fd9ad2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -63,6 +63,7 @@ struct nf_flowtable_type {
 
 enum nf_flowtable_flags {
 	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
+	NF_FLOWTABLE_COUNTER		= 0x2,	/* NFT_FLOWTABLE_COUNTER */
 };
 
 struct nf_flowtable {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 717ee3aa05d7..30f2a87270dc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1557,10 +1557,13 @@ enum nft_object_attributes {
  * enum nft_flowtable_flags - nf_tables flowtable flags
  *
  * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
+ * @NFT_FLOWTABLE_COUNTER: enable flow counters
  */
 enum nft_flowtable_flags {
 	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
-	NFT_FLOWTABLE_MASK		= NFT_FLOWTABLE_HW_OFFLOAD
+	NFT_FLOWTABLE_COUNTER		= 0x2,
+	NFT_FLOWTABLE_MASK		= (NFT_FLOWTABLE_HW_OFFLOAD |
+					   NFT_FLOWTABLE_COUNTER)
 };
 
 /**
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721080f8..553cc0d5695a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -12,6 +12,7 @@
 #include <net/ip6_route.h>
 #include <net/neighbour.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -286,6 +287,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	ip_decrease_ttl(iph);
 	skb->tstamp = 0;
 
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
@@ -516,6 +520,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6h->hop_limit--;
 	skb->tstamp = 0;
 
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
-- 
2.11.0

