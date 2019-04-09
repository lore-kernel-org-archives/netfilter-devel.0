Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D626EC282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFF2E206C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 08:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfDIIqD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:46:03 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51564 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbfDIIqD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 04:46:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hDmOH-0008RK-1Y; Tue, 09 Apr 2019 10:46:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/3] netfilter: nf_nat: merge ip/ip6 masquerade headers
Date:   Tue,  9 Apr 2019 10:44:06 +0200
Message-Id: <20190409084408.23730-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190409084408.23730-1-fw@strlen.de>
References: <20190409084408.23730-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Both are now implemented by nf_nat_masquerade.c, so no need to keep
different headers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/ipv6/nf_nat_masquerade.h       | 11 -----------
 include/net/netfilter/{ipv4 => }/nf_nat_masquerade.h | 12 +++++++++---
 net/ipv4/netfilter/ipt_MASQUERADE.c                  |  2 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c                 |  2 +-
 net/netfilter/nf_nat_masquerade.c                    |  3 +--
 net/netfilter/nft_masq.c                             |  3 +--
 6 files changed, 13 insertions(+), 20 deletions(-)
 delete mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade.h
 rename include/net/netfilter/{ipv4 => }/nf_nat_masquerade.h (50%)

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
diff --git a/include/net/netfilter/ipv4/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
similarity index 50%
rename from include/net/netfilter/ipv4/nf_nat_masquerade.h
rename to include/net/netfilter/nf_nat_masquerade.h
index 13d55206bb9f..cafe71822a53 100644
--- a/include/net/netfilter/ipv4/nf_nat_masquerade.h
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NF_NAT_MASQUERADE_IPV4_H_
-#define _NF_NAT_MASQUERADE_IPV4_H_
+#ifndef _NF_NAT_MASQUERADE_H_
+#define _NF_NAT_MASQUERADE_H_
 
 #include <net/netfilter/nf_nat.h>
 
@@ -12,4 +12,10 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 int nf_nat_masquerade_ipv4_register_notifier(void);
 void nf_nat_masquerade_ipv4_unregister_notifier(void);
 
-#endif /*_NF_NAT_MASQUERADE_IPV4_H_ */
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
2.21.0

