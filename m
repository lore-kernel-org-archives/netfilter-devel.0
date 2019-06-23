Return-Path: <SRS0=Qe96=UW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F47C43613
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jun 2019 16:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3D7320652
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jun 2019 16:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFWQRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jun 2019 12:17:13 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.67]:33394 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfFWQRN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jun 2019 12:17:13 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2019 12:17:12 EDT
Received: from localhost.localdomain (static-187-140-230-77.ipcom.comunitel.net [77.230.140.187])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id AAB198118;
        Sun, 23 Jun 2019 18:08:05 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH] nft_meta: Introduce new conditions 'time', 'day' and 'hour'
Date:   Sun, 23 Jun 2019 18:07:58 +0200
Message-Id: <20190623160758.10925-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces meta matches in the kernel for time (a UNIX timestamp),
day (a day of week, represented as an integer between 0-6), and
hour (an hour in the current day, or: number of seconds since midnight).

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 +++++
 net/netfilter/nft_meta.c                 | 32 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c6c8ec5c7c00..92c78813bc7d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -795,6 +795,9 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_TIME: a UNIX timestamp
+ * @NFT_META_TIME_DAY: day of week
+ * @NFT_META_TIME_HOUR: hour of day
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -825,6 +828,9 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_TIME,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 987d2d6ce624..a684abd00597 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -50,6 +50,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	const struct net_device *in = nft_in(pkt), *out = nft_out(pkt);
 	struct sock *sk;
 	u32 *dest = &regs->data[priv->dreg];
+	s64 *d64;
 #ifdef CONFIG_NF_TABLES_BRIDGE
 	const struct net_bridge_port *p;
 #endif
@@ -254,6 +255,28 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
+	case NFT_META_TIME:
+		d64 = (s64 *) dest;
+		*d64 = get_seconds();
+		break;
+	case NFT_META_TIME_DAY:
+	case NFT_META_TIME_HOUR:
+	{
+		s64 secs;
+		struct tm tm;
+
+		d64 = (s64 *) dest;
+
+		/* get timestamp in seconds, and convert to tm structure */
+		secs = get_seconds();
+		time64_to_tm(secs, 0, &tm);
+
+		if (priv->key == NFT_META_TIME_HOUR)
+			*d64 = (s64) (tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec);
+		else
+			nft_reg_store8(dest, (u8) tm.tm_wday);
+	}
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -371,6 +394,15 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 #endif
+	case NFT_META_TIME:
+		len = sizeof(s64);
+		break;
+	case NFT_META_TIME_DAY:
+		len = sizeof(u8);
+		break;
+	case NFT_META_TIME_HOUR:
+		len = sizeof(s64);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1

