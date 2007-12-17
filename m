From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 53/64]: nfnetlink_log: include GID in netlink message
Date: Tue, 18 Dec 2007 00:47:25 +0100 (MET)
Message-ID: <20071217234725.23601.60947.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39047 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbXLQXr0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:26 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: include GID in netlink message

Similar to Maciej Soltysiak's ipt_LOG patch, include GID in addition
to UID in netlink message.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fcf0f585c5a36051119f250330feac0a672a73c2
tree 95af7eeb3d3132b085b639c4a697bb724ae13941
parent 46b6c5e9e3b9e78d9a2a0d73429d269d7f82c26a
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:45 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 include/linux/netfilter/nfnetlink_log.h |    1 +
 net/netfilter/nfnetlink_log.c           |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index 5966afa..a857213 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -47,6 +47,7 @@ enum nfulnl_attr_type {
 	NFULA_UID,			/* user id of socket */
 	NFULA_SEQ,			/* instance-local sequence number */
 	NFULA_SEQ_GLOBAL,		/* global sequence number */
+	NFULA_GID,			/* group id of socket */
 
 	__NFULA_MAX
 };
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 950b1f0..5013cb9 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -467,9 +467,11 @@ __build_packet_message(struct nfulnl_instance *inst,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
 			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
+			__be32 gid = htons(skb->sk->sk_socket->file->f_gid);
 			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			NLA_PUT_BE32(inst->skb, NFULA_UID, uid);
+			NLA_PUT_BE32(inst->skb, NFULA_GID, gid);
 		} else
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
@@ -564,6 +566,7 @@ nfulnl_log_packet(unsigned int pf,
 #endif
 		+ nla_total_size(sizeof(u_int32_t))	/* mark */
 		+ nla_total_size(sizeof(u_int32_t))	/* uid */
+		+ nla_total_size(sizeof(u_int32_t))	/* gid */
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
