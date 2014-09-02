From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] netfilter: nf_tables: add devgroup support in meta expresion
Date: Tue,  2 Sep 2014 20:36:14 +0200
Message-ID: <1409682974-11414-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48755 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaIBSeC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:34:02 -0400
Received: by mail-wg0-f43.google.com with SMTP id a1so7325335wgh.14
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2014 11:34:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add devgroup support to let us match device group of a packets incoming
or outgoing interface.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |    4 ++++
 net/netfilter/nft_meta.c                 |   12 ++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 67218f3..7e5dbcd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -573,6 +573,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: Packet type
  * @NFT_META_CPU: Packet cpu
+ * @NFT_META_IIFGROUP: packet input interface group
+ * @NFT_META_OIFGROUP: packet output interface group
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -596,6 +598,8 @@ enum nft_meta_keys {
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
 	NFT_META_CPU,
+	NFT_META_IIFGROUP,
+	NFT_META_OIFGROUP,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 34a587e..0064dea 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -154,6 +154,16 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	case NFT_META_CPU:
 		dest->data[0] = smp_processor_id();
 		break;
+	case NFT_META_IIFGROUP:
+		if (in == NULL)
+			goto err;
+		dest->data[0] = in->group;
+		break;
+	case NFT_META_OIFGROUP:
+		if (out == NULL)
+			goto err;
+		dest->data[0] = out->group;
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -227,6 +237,8 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 #endif
 	case NFT_META_PKTTYPE:
 	case NFT_META_CPU:
+	case NFT_META_IIFGROUP:
+	case NFT_META_OIFGROUP:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.7.10.4

