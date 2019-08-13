Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3325CC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16F102064A
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfHMSjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:39:55 -0400
Received: from vxsys-smtpclusterma-02.srv.cat ([46.16.61.68]:35931 "EHLO
        vxsys-smtpclusterma-02.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726427AbfHMSjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:39:55 -0400
Received: from localhost.localdomain (static-79-171-230-77.ipcom.comunitel.net [77.230.171.79])
        by vxsys-smtpclusterma-02.srv.cat (Postfix) with ESMTPA id 68960245F8
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:39:51 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 2/2] netfilter: nft_meta: support for time matching
Date:   Tue, 13 Aug 2019 20:38:20 +0200
Message-Id: <20190813183820.6659-2-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190813183820.6659-1-a@juaristi.eus>
References: <20190813183820.6659-1-a@juaristi.eus>
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
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nft_meta.c                 | 39 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 82abaa183fc3..67ae55e08518 100644
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
@@ -831,6 +834,9 @@ enum nft_meta_keys {
 	NFT_META_OIFKIND,
 	NFT_META_BRI_IIFPVID,
 	NFT_META_BRI_IIFVPROTO,
+	NFT_META_TIME,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f1b1d948c07b..3e665a1a744a 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -28,6 +28,27 @@
 
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
+static u8 nft_meta_weekday(unsigned long secs)
+{
+	u8 wday;
+	unsigned int dse;
+
+	secs -= 60 * sys_tz.tz_minuteswest;
+	dse = secs / 86400;
+	wday = (4 + dse) % 7;
+
+	return wday;
+}
+
+static u32 nft_meta_hour(unsigned long secs)
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
+		nft_reg_store64(dest, ktime_get_real_ns());
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

