Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FC41684AE;
	Thu, 22 Aug 2024 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365190; cv=none; b=hvSqC+0dxcPIjh3V6MK2aS8IGlQWEYP3wT4BCYShpJzn/fUMqll9nLcIR3G4B2HkIa2JWN3qLNGJBrPYbWcmkYxOrA/ZTZ5wh8CrkmH6ZrOOcjdKZ2XOrErWFHFyW5tmpbmMUO1N1sh6pbar7h5oBK3q5Btbrk3BuNo3CTr2jH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365190; c=relaxed/simple;
	bh=OYm+71XqklzghjeRY2nBgPG0DoLOf1CgjK8RxhB+oSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=seyKH827V2m0x78gZ15PV2vlaTVHsu1R8NPLwTFZ0XEJZXOrlZM73WrVI31wEBTt1OtQYPcePZvHABF70o4rp+y7LxD7/QRS/cUJVMM6XFcj1DGPNNJ9UR77O5LglFO/QcCrzbQwnny/MZWgdd/IoExbUHg7ZyynZUXBoiHylgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 1/9] netfilter: nfnetlink_queue: unbreak SCTP traffic
Date: Fri, 23 Aug 2024 00:19:31 +0200
Message-Id: <20240822221939.157858-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
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

Joint work with Pablo.

Signed-off-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/dev.c                  |  1 +
 net/netfilter/nfnetlink_queue.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e7260889d4cb..8384282acadf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3386,6 +3386,7 @@ int skb_crc32c_csum_help(struct sk_buff *skb)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(skb_crc32c_csum_help);
 
 __be16 skb_network_protocol(struct sk_buff *skb, int *depth)
 {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e0716da256bf..d2773ce9b585 100644
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
@@ -1014,7 +1022,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		break;
 	}
 
-	if ((queue->flags & NFQA_CFG_F_GSO) || !skb_is_gso(skb))
+	if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
 	nf_bridge_adjust_skb_data(skb);
-- 
2.30.2

