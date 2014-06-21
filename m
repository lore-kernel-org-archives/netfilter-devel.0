From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH v2] netfilter: Add SKPID and SKSID meta keys
Date: Sat, 21 Jun 2014 22:40:05 +0800
Message-ID: <1403361605-7696-1-git-send-email-yshuiv7@gmail.com>
References: <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Cc: Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35060 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFUOkV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:40:21 -0400
Received: by mail-pd0-f172.google.com with SMTP id w10so3999146pde.3
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2014 07:40:21 -0700 (PDT)
In-Reply-To: <1401977956-15500-3-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add SKPID and SKSID meta keys so we can implement PID and SID matching
rules in userspace nft tool.

v2: Fix compiler warnings.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_meta.c                 | 27 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7d6433f..d41880f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -565,6 +565,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_SKPID: origination socket owner PID
+ * @NFT_META_SKSID: origination socket owner SID
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -586,6 +588,8 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_SKPID,
+	NFT_META_SKSID,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 852b178..cb0b067 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,7 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/pid.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
@@ -27,7 +28,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	const struct net_device *in = pkt->in, *out = pkt->out;
+	struct pid *sid;
 	struct nft_data *dest = &data[priv->dreg];
+	struct task_struct *task;
 
 	switch (priv->key) {
 	case NFT_META_LEN:
@@ -109,6 +112,28 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 				 skb->sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
+	case NFT_META_SKPID:
+		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
+			goto err;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		dest->data[0] = pid_nr(skb->sk->sk_peer_pid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+		break;
+	case NFT_META_SKSID:
+		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
+			goto err;
+
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		task = get_pid_task(skb->sk->sk_peer_pid, PIDTYPE_PID);
+		sid = task_session(task);
+		if (!sid) {
+			read_unlock_bh(&skb->sk->sk_callback_lock);
+			goto err;
+		}
+		dest->data[0] = pid_nr(sid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID: {
 		const struct dst_entry *dst = skb_dst(skb);
@@ -189,6 +214,8 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 	case NFT_META_OIFTYPE:
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
+	case NFT_META_SKPID:
+	case NFT_META_SKSID:
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID:
 #endif
-- 
2.0.0

