From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] netfilter: nf_tables: Add cpu attribute support to meta expresion.
Date: Thu,  7 Aug 2014 09:00:56 +0200
Message-ID: <1407394858-26841-2-git-send-email-anarey@gmail.com>
References: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Cc: eric.dumazet@gmail.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37983 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGG67 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:58:59 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so3751582wes.19
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2014 23:58:58 -0700 (PDT)
In-Reply-To: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add cpu support to meta expresion.

This allows you to match packets with cpu number.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |    2 ++
 net/netfilter/nft_meta.c                 |    5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 72ad208..67218f3 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -572,6 +572,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: Packet type
+ * @NFT_META_CPU: Packet cpu
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -594,6 +595,7 @@ enum nft_meta_keys {
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index dbf7fe1..34a587e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -17,6 +17,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/smp.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
@@ -150,6 +151,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		}
 		break;
+	case NFT_META_CPU:
+		dest->data[0] = smp_processor_id();
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -222,6 +226,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_SECMARK:
 #endif
 	case NFT_META_PKTTYPE:
+	case NFT_META_CPU:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.7.10.4

