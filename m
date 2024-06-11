Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823C814290
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 08:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094905; cv=none; b=I/L42sUSxmUEZLOIi72YZrIAo/sGMdJ0Hdblsw2L58Ws86YZOP+SI9j9RN6JFg7j+NhuguoC1/LnvON+5x0VFQ6siJoHyGgiyBx3L9ksSxGIB+u5GNnukx8wUwD2UmTj5sFATx4lggeb3EZanq0RgyFkbBrBU2174R8zz+CYqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094905; c=relaxed/simple;
	bh=PUYWfRufBTaIHuew75hL6R9tpb2jZedHDaQ0f4NcHfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZyV1Fr6IUDuwpMBr+gmYcKHgpRuOxyczicsh5IcyejTdtOYpjOaf4VONVnDC0VhO36BLIyZFo19jTbxP09OtfRWxo/PUr6bLRI9O/aNWL6/oujaE3ifOhkrMMU5ecPGB115POhb5sAUb0h8ljOjXpWPED2rbfHOWkJ0u9v7rXyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: aojea@google.com,
	fw@strlen.de
Subject: [PATCH nf-next,v4 1/2] netfilter: nfnetlink_queue: unbreak SCTP traffic
Date: Tue, 11 Jun 2024 10:34:56 +0200
Message-Id: <20240611083457.3006-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Ojea <aojea@google.com>

when packet is enqueued with nfqueue and GSO is enabled, checksum
calculation has to take into account the protocol, as SCTP uses a
32 bits CRC checksum.

Enter skb_gso_segment() path in case of SCTP GSO packets because
skb_zerocopy() does not support for GSO_BY_FRAGS.

Signed-off-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - missing EXPORT_SYMBOL
    - enter skb_gso_segment() with SCTP GSO packets.

 net/core/dev.c                  |  1 +
 net/netfilter/nfnetlink_queue.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4d4de9008f6f..e36e383a1a0f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3384,6 +3384,7 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(skb_crc32c_csum_help);
 
 __be16 skb_network_protocol(struct sk_buff *skb, int *depth)
 {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f1c31757e496..fe550cebae1e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -540,6 +540,14 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	return -1;
 }
 
+static int nf_queue_checksum_help(struct sk_buff *entskb)
+{
+	if (skb_csum_is_sctp(entskb))
+		return skb_crc32c_csum_help(entskb);
+
+	return skb_checksum_help(entskb);
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -602,7 +610,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	case NFQNL_COPY_PACKET:
 		if (!(queue->flags & NFQA_CFG_F_GSO) &&
 		    entskb->ip_summed == CHECKSUM_PARTIAL &&
-		    skb_checksum_help(entskb))
+		    nf_queue_checksum_help(entskb))
 			return NULL;
 
 		data_len = READ_ONCE(queue->copy_range);
@@ -983,7 +991,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		break;
 	}
 
-	if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb))
+	if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
 	nf_bridge_adjust_skb_data(skb);
-- 
2.30.2

