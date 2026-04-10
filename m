Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4239DBEB;
	Fri, 10 Apr 2026 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820260; cv=none; b=rwEFeEJqA3IodVQYteR5EK3WOfpU+Rd6c1Sgoq5lkhrMfGkdiF3cCNPK4EA1xbAnYWjVo1/3+nz9wIGocqZcgpZOcF/+YTnhepK7+NwGp8VRr0mmqAB9c7h0fC3DdNaVZYslu8UEsmaDLvs+d2jUP+SuN8fzIfYi/x5YD7ldb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820260; c=relaxed/simple;
	bh=pIrTkanCiDQpmujH5RjT+aLdBLhafdd2InFmW1v3e5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnsdw6owY57wyYzBNShFXx/5BkjGe70Ypz/SUeMdiqUb+HyvV92t1uVEJZVLP/qI+Il8qEQtxa10W11A9RG96svITTF6DKEQx5A51Bfa+ekxYS7LEnhmx31a9JnN/WMb81kkvy1fWNaoGXSS4Ho+9jUyNg+hTdu0Y9jYtGuhZjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E41CF6065F; Fri, 10 Apr 2026 13:24:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 05/11] netfilter: nfnetlink: prefer skb_mac_header helpers
Date: Fri, 10 Apr 2026 13:23:46 +0200
Message-ID: <20260410112352.23599-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds implicit DEBUG_WARN_ON_ONCE for debug configurations.
No other changes intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c   | 19 ++++++++++---------
 net/netfilter/nfnetlink_queue.c | 25 ++++++++++++-------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b2c24cb919d4..2439cbbd5b26 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -401,7 +401,7 @@ nfulnl_timer(struct timer_list *t)
 
 static u32 nfulnl_get_bridge_size(const struct sk_buff *skb)
 {
-	u32 size = 0;
+	u32 mac_len, size = 0;
 
 	if (!skb_mac_header_was_set(skb))
 		return 0;
@@ -412,14 +412,17 @@ static u32 nfulnl_get_bridge_size(const struct sk_buff *skb)
 		size += nla_total_size(sizeof(u16)); /* tag */
 	}
 
-	if (skb->network_header > skb->mac_header)
-		size += nla_total_size(skb->network_header - skb->mac_header);
+	mac_len = skb_mac_header_len(skb);
+	if (mac_len > 0)
+		size += nla_total_size(mac_len);
 
 	return size;
 }
 
 static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff *skb)
 {
+	u32 mac_len;
+
 	if (!skb_mac_header_was_set(skb))
 		return 0;
 
@@ -437,12 +440,10 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 		nla_nest_end(inst->skb, nest);
 	}
 
-	if (skb->mac_header < skb->network_header) {
-		int len = (int)(skb->network_header - skb->mac_header);
-
-		if (nla_put(inst->skb, NFULA_L2HDR, len, skb_mac_header(skb)))
-			goto nla_put_failure;
-	}
+	mac_len = skb_mac_header_len(skb);
+	if (mac_len > 0 &&
+	    nla_put(inst->skb, NFULA_L2HDR, mac_len, skb_mac_header(skb)))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c7ee6f6ff725..58304fd1f70f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -579,6 +579,7 @@ static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
 {
 	struct sk_buff *entskb = entry->skb;
 	u32 nlalen = 0;
+	u32 mac_len;
 
 	if (entry->state.pf != PF_BRIDGE || !skb_mac_header_was_set(entskb))
 		return 0;
@@ -587,9 +588,9 @@ static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
 		nlalen += nla_total_size(nla_total_size(sizeof(__be16)) +
 					 nla_total_size(sizeof(__be16)));
 
-	if (entskb->network_header > entskb->mac_header)
-		nlalen += nla_total_size((entskb->network_header -
-					  entskb->mac_header));
+	mac_len = skb_mac_header_len(entskb);
+	if (mac_len > 0)
+		nlalen += nla_total_size(mac_len);
 
 	return nlalen;
 }
@@ -597,6 +598,7 @@ static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
 static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 {
 	struct sk_buff *entskb = entry->skb;
+	u32 mac_len;
 
 	if (entry->state.pf != PF_BRIDGE || !skb_mac_header_was_set(entskb))
 		return 0;
@@ -615,12 +617,10 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 		nla_nest_end(skb, nest);
 	}
 
-	if (entskb->mac_header < entskb->network_header) {
-		int len = (int)(entskb->network_header - entskb->mac_header);
-
-		if (nla_put(skb, NFQA_L2HDR, len, skb_mac_header(entskb)))
-			goto nla_put_failure;
-	}
+	mac_len = skb_mac_header_len(entskb);
+	if (mac_len > 0 &&
+	    nla_put(skb, NFQA_L2HDR, mac_len, skb_mac_header(entskb)))
+		goto nla_put_failure;
 
 	return 0;
 
@@ -1004,13 +1004,13 @@ nf_queue_entry_dup(struct nf_queue_entry *e)
 static void nf_bridge_adjust_skb_data(struct sk_buff *skb)
 {
 	if (nf_bridge_info_get(skb))
-		__skb_push(skb, skb->network_header - skb->mac_header);
+		__skb_push(skb, skb_mac_header_len(skb));
 }
 
 static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
 {
 	if (nf_bridge_info_get(skb))
-		__skb_pull(skb, skb->network_header - skb->mac_header);
+		__skb_pull(skb, skb_mac_header_len(skb));
 }
 #else
 #define nf_bridge_adjust_skb_data(s) do {} while (0)
@@ -1469,8 +1469,7 @@ static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 	}
 
 	if (nfqa[NFQA_L2HDR]) {
-		int mac_header_len = entry->skb->network_header -
-			entry->skb->mac_header;
+		u32 mac_header_len = skb_mac_header_len(entry->skb);
 
 		if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
 			return -EINVAL;
-- 
2.52.0

