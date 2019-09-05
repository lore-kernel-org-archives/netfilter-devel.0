Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302D5C43140
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09132082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbfIEQEM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:04:12 -0400
Received: from correo.us.es ([193.147.175.20]:53050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390790AbfIEQEK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E51871228D0
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D91E8DA4D0
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CED6EDA840; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A87D8CA0F3;
        Thu,  5 Sep 2019 18:04:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7A36B42EE38E;
        Thu,  5 Sep 2019 18:04:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/8] netfilter: nft_meta: support for time matching
Date:   Thu,  5 Sep 2019 18:03:54 +0200
Message-Id: <20190905160400.25399-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ander Juaristi <a@juaristi.eus>

This patch introduces meta matches in the kernel for time (a UNIX timestamp),
day (a day of week, represented as an integer between 0-6), and
hour (an hour in the current day, or: number of seconds since midnight).

All values are taken as unsigned 64-bit integers.

The 'time' keyword is internally converted to nanoseconds by nft in
userspace, and hence the timestamp is taken in nanoseconds as well.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 +++++
 net/netfilter/nft_meta.c                 | 46 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 82abaa183fc3..b83b62eb4b01 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
  * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
+ * @NFT_META_TIME_NS: time since epoch (in nanoseconds)
+ * @NFT_META_TIME_DAY: day of week (from 0 = Sunday to 6 = Saturday)
+ * @NFT_META_TIME_HOUR: hour of day (in seconds)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -831,6 +834,9 @@ enum nft_meta_keys {
 	NFT_META_OIFKIND,
 	NFT_META_BRI_IIFPVID,
 	NFT_META_BRI_IIFVPROTO,
+	NFT_META_TIME_NS,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f69afb9ff3cb..317e3a9e8c5b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -26,8 +26,36 @@
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
 
+#define NFT_META_SECS_PER_MINUTE	60
+#define NFT_META_SECS_PER_HOUR		3600
+#define NFT_META_SECS_PER_DAY		86400
+#define NFT_META_DAYS_PER_WEEK		7
+
 static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 
+static u8 nft_meta_weekday(unsigned long secs)
+{
+	unsigned int dse;
+	u8 wday;
+
+	secs -= NFT_META_SECS_PER_MINUTE * sys_tz.tz_minuteswest;
+	dse = secs / NFT_META_SECS_PER_DAY;
+	wday = (4 + dse) % NFT_META_DAYS_PER_WEEK;
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
+	return tm.tm_hour * NFT_META_SECS_PER_HOUR
+		+ tm.tm_min * NFT_META_SECS_PER_MINUTE
+		+ tm.tm_sec;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -218,6 +246,15 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
+	case NFT_META_TIME_NS:
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
@@ -330,6 +367,15 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = sizeof(u8);
 		break;
 #endif
+	case NFT_META_TIME_NS:
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
2.11.0

