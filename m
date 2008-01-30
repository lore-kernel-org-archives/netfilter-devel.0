From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/69]: nfnetlink_log: fix typo
Date: Wed, 30 Jan 2008 21:17:01 +0100 (MET)
Message-ID: <20080130201659.29874.84730.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60650 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765984AbYA3URF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:05 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: fix typo

It should use htonl for the GID, not htons.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b64a07de84c00708be436ec05a75c093430e262d
tree 0bfbb96d69717d2146e0f9683d8b0a22a3216910
parent 55a3ad929c35527e0ac6ccdb5535779ed1523be5
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:21:52 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:13 +0100

 net/netfilter/nfnetlink_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 5013cb9..2348fcb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -467,7 +467,7 @@ __build_packet_message(struct nfulnl_instance *inst,
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
 			__be32 uid = htonl(skb->sk->sk_socket->file->f_uid);
-			__be32 gid = htons(skb->sk->sk_socket->file->f_gid);
+			__be32 gid = htonl(skb->sk->sk_socket->file->f_gid);
 			/* need to unlock here since NLA_PUT may goto */
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			NLA_PUT_BE32(inst->skb, NFULA_UID, uid);
