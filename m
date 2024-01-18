Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAAC2C6A3;
	Thu, 18 Jan 2024 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594665; cv=none; b=cyUN0nOMYUF+ShexPbPvIdo9EDfnh9xe8Aku9USh3P85W+avkug8rNZvRrAoHIpqVE+5IHFIAxaXacATQOZd1gzIocjayj4tbewEC99J3b/L6//FIWCCvBlHEzoxHc/JMBsnef45fgdLDxghueoHD3Nqlq2I4MOnTh0FDn9bUNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594665; c=relaxed/simple;
	bh=Yeywi/BF+jVrBpU8KHRO80VHtM1cc6uWlS/9uaeIhDs=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=mIz0r2WIY/J7zlxsP3AUwEbJOM5RmnHWBl+TJqD7IkVos50mAB6me4Ze8tDhiHmE9qYWAXuBaqBopEwuSKQcuKaOyfJ33MktPIzjIJznMLUDXZT4jwIkyE73KCo1NNS39ef31mNS5iaYEtO8OndMzjIbvNzg/VHV6joarhYWX4I=
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
Subject: [PATCH net 06/13] netfilter: nf_queue: remove excess nf_bridge variable
Date: Thu, 18 Jan 2024 17:17:19 +0100
Message-Id: <20240118161726.14838-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240118161726.14838-1-pablo@netfilter.org>
References: <20240118161726.14838-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

We don't really need nf_bridge variable here. And nf_bridge_info_exists
is better replacement for nf_bridge_info_get in case we are only
checking for existence.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 63d1516816b1..3dfcb3ac5cb4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -82,10 +82,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
-	struct nf_bridge_info *nf_bridge;
 
-	nf_bridge = nf_bridge_info_get(skb);
-	if (nf_bridge) {
+	if (nf_bridge_info_exists(skb)) {
 		entry->physin = nf_bridge_get_physindev(skb);
 		entry->physout = nf_bridge_get_physoutdev(skb);
 	} else {
-- 
2.30.2

