Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA75FC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 07:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F3020657
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 07:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbfHBHWi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 03:22:38 -0400
Received: from vxsys-smtpclusterma-02.srv.cat ([46.16.60.192]:56021 "EHLO
        vxsys-smtpclusterma-02.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729406AbfHBHWi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 03:22:38 -0400
Received: from bubu.das-nano.com (242.red-83-48-67.staticip.rima-tde.net [83.48.67.242])
        by vxsys-smtpclusterma-02.srv.cat (Postfix) with ESMTPA id 4086424219
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 09:12:42 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v3] netfilter: nft_meta: support for time matching
Date:   Fri,  2 Aug 2019 09:12:33 +0200
Message-Id: <20190802071233.5580-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces meta matches in the kernel for time (a UNIX timestamp),
day (a day of week, represented as an integer between 0-6), and
hour (an hour in the current day, or: number of seconds since midnight).

All values are taken as unsigned 64-bit integers.

The 'time' keyword is internally converted to nanoseconds by nft in
userspace, and hence the timestamp is taken in nanoseconds as well.

This patch also introduces a new function, nft_reg_store64, to store
64-bit values in the register for comparison.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/net/netfilter/nf_tables.h        |  6 ++++
 include/uapi/linux/netfilter/nf_tables.h |  8 +++--
 net/netfilter/nft_meta.c                 | 39 ++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9b624566b82d..f635b9c2e221 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,6 +2,7 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
+#include <asm/unaligned.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -119,6 +120,11 @@ static inline void nft_reg_store8(u32 *dreg, u8 val)
 	*(u8 *)dreg = val;
 }
 
+static inline void nft_reg_store64(u64 *dreg, u64 val)
+{
+	put_unaligned(val, dreg);
+}
+
 static inline u16 nft_reg_load16(u32 *sreg)
 {
 	return *(u16 *)sreg;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 82abaa183fc3..6d9dd120b466 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
  * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
+ * @NFT_META_TIME: a UNIX timestamp
+ * @NFT_META_TIME_DAY: day of week
+ * @NFT_META_TIME_HOUR: hour of day
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -829,8 +832,9 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
-	NFT_META_BRI_IIFPVID,
-	NFT_META_BRI_IIFVPROTO,
+	NFT_META_TIME,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f1b1d948c07b..57ac1f9aab56 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -28,6 +28,27 @@
 
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
+static u8 nft_meta_weekday(u64 secs)
+{
+	u8 wday;
+	unsigned int dse;
+
+	secs -= 60 * sys_tz.tz_minuteswest;
+	dse = secs / 86400;
+	wday = (4 + dse) % 7;
+
+	return ++wday % 7;
+}
+
+static u32 nft_meta_hour(u64 secs)
+{
+	struct tm tm;
+
+	time64_to_tm(secs, 0, &tm);
+
+	return tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -226,6 +247,15 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
+	case NFT_META_TIME:
+		nft_reg_store64((u64 *)dest, ktime_get_real_ns());
+		break;
+	case NFT_META_TIME_DAY:
+		nft_reg_store8(dest, nft_meta_weekday(get_seconds()));
+		break;
+	case NFT_META_TIME_HOUR:
+		*dest = nft_meta_hour(get_seconds());
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -338,6 +368,15 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 #endif
+	case NFT_META_TIME:
+		len = sizeof(u64);
+		break;
+	case NFT_META_TIME_DAY:
+		len = sizeof(u8);
+		break;
+	case NFT_META_TIME_HOUR:
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

