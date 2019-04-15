Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3841AC282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE1F2183F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfDORBN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:01:13 -0400
Received: from mail.us.es ([193.147.175.20]:50438 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfDORAp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 60D431C4440
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A7FBDA714
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 48CF6DA70F; Mon, 15 Apr 2019 19:00:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2267EDA706;
        Mon, 15 Apr 2019 19:00:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E89424265A31;
        Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/22] netfilter: nf_nat: merge ip/ip6 masquerade headers
Date:   Mon, 15 Apr 2019 19:00:21 +0200
Message-Id: <20190415170028.3470-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Both are now implemented by nf_nat_masquerade.c, so no need to keep
different headers.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_nat_masquerade.h | 15 ---------------
 include/net/netfilter/ipv6/nf_nat_masquerade.h | 11 -----------
 include/net/netfilter/nf_nat_masquerade.h      | 21 +++++++++++++++++++++
 net/ipv4/netfilter/ipt_MASQUERADE.c            |  2 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c           |  2 +-
 net/netfilter/nf_nat_masquerade.c              |  3 +--
 net/netfilter/nft_masq.c                       |  3 +--
 7 files changed, 25 insertions(+), 32 deletions(-)
 delete mode 100644 include/net/netfilter/ipv4/nf_nat_masquerade.h
 delete mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade.h
 create mode 100644 include/net/netfilter/nf_nat_masquerade.h

diff --git a/include/net/netfilter/ipv4/nf_nat_masquerade.h b/include/net/netfilter/ipv4/nf_nat_masquerade.h
deleted file mode 100644
index 13d55206bb9f..000000000000
--- a/include/net/netfilter/ipv4/nf_nat_masquerade.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NF_NAT_MASQUERADE_IPV4_H_
-#define _NF_NAT_MASQUERADE_IPV4_H_
-
-#include <net/netfilter/nf_nat.h>
-
-unsigned int
-nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
-		       const struct nf_nat_range2 *range,
-		       const struct net_device *out);
-
-int nf_nat_masquerade_ipv4_register_notifier(void);
-void nf_nat_masquerade_ipv4_unregister_notifier(void);
-
-#endif /*_NF_NAT_MASQUERADE_IPV4_H_ */
diff --git a/include/net/netfilter/ipv6/nf_nat_masquerade.h b/include/net/netfilter/ipv6/nf_nat_masquerade.h
deleted file mode 100644
index 2917bf95c437..000000000000
--- a/include/net/netfilter/ipv6/nf_nat_masquerade.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NF_NAT_MASQUERADE_IPV6_H_
-#define _NF_NAT_MASQUERADE_IPV6_H_
-
-unsigned int
-nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
-		       const struct net_device *out);
-int nf_nat_masquerade_ipv6_register_notifier(void);
-void nf_nat_masquerade_ipv6_unregister_notifier(void);
-
-#endif /* _NF_NAT_MASQUERADE_IPV6_H_ */
diff --git a/include/net/netfilter/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
new file mode 100644
index 000000000000..cafe71822a53
--- /dev/null
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_NAT_MASQUERADE_H_
+#define _NF_NAT_MASQUERADE_H_
+
+#include <net/netfilter/nf_nat.h>
+
+unsigned int
+nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
+		       const struct nf_nat_range2 *range,
+		       const struct net_device *out);
+
+int nf_nat_masquerade_ipv4_register_notifier(void);
+void nf_nat_masquerade_ipv4_unregister_notifier(void);
+
+unsigned int
+nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
+		       const struct net_device *out);
+int nf_nat_masquerade_ipv6_register_notifier(void);
+void nf_nat_masquerade_ipv6_unregister_notifier(void);
+
+#endif /*_NF_NAT_MASQUERADE_H_ */
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index fd3f9e8a74da..0a2bffb6a0ad 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/ipv4/nf_nat_masquerade.h>
+#include <net/netfilter/nf_nat_masquerade.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
diff --git a/net/ipv6/netfilter/ip6t_MASQUERADE.c b/net/ipv6/netfilter/ip6t_MASQUERADE.c
index 29c7f1915a96..4a22343ed67a 100644
--- a/net/ipv6/netfilter/ip6t_MASQUERADE.c
+++ b/net/ipv6/netfilter/ip6t_MASQUERADE.c
@@ -19,7 +19,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/addrconf.h>
 #include <net/ipv6.h>
-#include <net/netfilter/ipv6/nf_nat_masquerade.h>
+#include <net/netfilter/nf_nat_masquerade.h>
 
 static unsigned int
 masquerade_tg6(struct sk_buff *skb, const struct xt_action_param *par)
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index d85c4d902e7b..10053e70f69d 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -7,8 +7,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 
-#include <net/netfilter/ipv4/nf_nat_masquerade.h>
-#include <net/netfilter/ipv6/nf_nat_masquerade.h>
+#include <net/netfilter/nf_nat_masquerade.h>
 
 static DEFINE_MUTEX(masq_mutex);
 static unsigned int masq_refcnt4 __read_mostly;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 35a1794acf4c..0783a3e99bd7 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -14,8 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_nat.h>
-#include <net/netfilter/ipv4/nf_nat_masquerade.h>
-#include <net/netfilter/ipv6/nf_nat_masquerade.h>
+#include <net/netfilter/nf_nat_masquerade.h>
 
 struct nft_masq {
 	u32			flags;
-- 
2.11.0

