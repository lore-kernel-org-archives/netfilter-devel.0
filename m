From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] netfilter: nft_meta: add cgroup support
Date: Mon,  3 Nov 2014 18:10:50 +0100
Message-ID: <1415034651-27242-2-git-send-email-anarey@gmail.com>
References: <1415034651-27242-1-git-send-email-anarey@gmail.com>
Cc: dborkman@redhat.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35607 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKCRKo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:10:44 -0500
Received: by mail-wg0-f50.google.com with SMTP id z12so11479351wgg.23
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 09:10:42 -0800 (PST)
In-Reply-To: <1415034651-27242-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to filter traffic by process control group (cgroup).

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |    2 ++
 net/netfilter/nft_meta.c                 |    7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c26df67..8ee8429 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -579,6 +579,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_CPU: cpu id through smp_processor_id()
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
+ * @NFT_META_CGROUP: packet cgroup
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -604,6 +605,7 @@ enum nft_meta_keys {
 	NFT_META_CPU,
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
+	NFT_META_CGROUP,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 1e7c076..e99911e 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -165,6 +165,12 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		dest->data[0] = out->group;
 		break;
+	case NFT_META_CGROUP:
+		if (skb->sk == NULL)
+			break;
+
+		dest->data[0] = skb->sk->sk_classid;
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -240,6 +246,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_CPU:
 	case NFT_META_IIFGROUP:
 	case NFT_META_OIFGROUP:
+	case NFT_META_CGROUP:
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
1.7.10.4

