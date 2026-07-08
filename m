Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1248E40802E;
	Wed,  8 Jul 2026 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519457; cv=none; b=Aw0U/Heb5oTVAdLTwNV1z7vRZiMI4CBghvo3xKTycEL7YhJXlCLjyYKMCvrL3hao2ZZGaaFJkqCiPh0daRzat5gyliNTffOpymkSH5vGNeY9kNwLUfDjDVuaNWJvevg9dRJYUU6ddHVw1etJLLz4pFO/JWk30CM7vrzyNoYlTdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519457; c=relaxed/simple;
	bh=zKM+8MR0lWNg6NlcLBl6k6iL0aLmsuEJL529SssXuu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dn0zWQXdwp/OnEVhkyG+PvbM+BFiEM0fg5FQkjmWjITPdZqMTfJrUynD0T3VX16drQmm+J9Arr5n50N/u07RfLe7U65epSIKZ9bQCO1tQCO0b/xtYdHcrcBQJ3eoA3oX1myxAOYojwvvVoY5HMyVIil++AY/iRZu5Cil0xWpOrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9FB5660D50; Wed, 08 Jul 2026 16:04:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 13/17] netfilter: handle unreadable frags
Date: Wed,  8 Jul 2026 16:03:05 +0200
Message-ID: <20260708140309.19633-14-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko reports:
 When an skb with unreadable fragments (such as from devmem TCP, where
 skb_frags_readable(skb) returns false) is processed by the u32 module,
 skb_copy_bits() will safely return a negative error code [..]

xt_u32: bail out with hotdrop in this case.
gather_frags: return -1, just as if we had no fragment header.
nfnetlink_queue: restrict to the linear part.
nfnetlink_log: restrict to the linear part.

v2:
 - skb_zerocopy helpers don't copy readable flag, i.e. nfnetlink_queue
 is broken too
 xt_u32 shouldn't return true if hotdrop was set.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Cc: stable@vger.kernel.org
Acked-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/netfilter/nfnetlink_log.c           | 26 ++++++++++++++++---------
 net/netfilter/nfnetlink_queue.c         | 16 +++++++++++----
 net/netfilter/xt_u32.c                  | 16 ++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3637b20d3fa4..599c49bf0a0a 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -419,7 +419,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 			return -1;
 		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
-			BUG();
+			return -1;
 		if (nexthdr == NEXTHDR_AUTH)
 			hdrlen = ipv6_authlen(&hdr);
 		else
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fa3657599861..5fee61b3813c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -676,7 +676,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
-			BUG();
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = inst->skb->tail - old_tail;
@@ -698,6 +698,21 @@ static const struct nf_loginfo default_loginfo = {
 	},
 };
 
+static unsigned int nfulnl_get_copy_len(const struct nf_loginfo *li,
+					const struct sk_buff *skb,
+					unsigned int copy_len)
+{
+	unsigned int len = skb->len;
+
+	if ((li->u.ulog.flags & NF_LOG_F_COPY_LEN) &&
+	    li->u.ulog.copy_len < copy_len)
+		copy_len = li->u.ulog.copy_len;
+	if (!skb_frags_readable(skb))
+		len = skb_headlen(skb);
+
+	return min(len, copy_len);
+}
+
 /* log handler for internal netfilter logging api */
 static void
 nfulnl_log_packet(struct net *net,
@@ -790,14 +805,7 @@ nfulnl_log_packet(struct net *net,
 		break;
 
 	case NFULNL_COPY_PACKET:
-		data_len = inst->copy_range;
-		if ((li->u.ulog.flags & NF_LOG_F_COPY_LEN) &&
-		    (li->u.ulog.copy_len < data_len))
-			data_len = li->u.ulog.copy_len;
-
-		if (data_len > skb->len)
-			data_len = skb->len;
-
+		data_len = nfulnl_get_copy_len(li, skb, inst->copy_range);
 		size += nla_total_size(data_len);
 		break;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 35d4c6c628ff..b8aaf39cb4d8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -690,6 +690,17 @@ static int nfqnl_put_master_ifindex(struct sk_buff *nlskb, int attr,
 }
 #endif
 
+static unsigned int nfqnl_get_data_len(const struct sk_buff *entskb,
+				       unsigned int copy_range)
+{
+	unsigned int data_len = entskb->len;
+
+	if (!skb_frags_readable(entskb))
+		data_len = skb_headlen(entskb);
+
+	return min(data_len, copy_range);
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -755,10 +766,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		    nf_queue_checksum_help(entskb))
 			return NULL;
 
-		data_len = READ_ONCE(queue->copy_range);
-		if (data_len > entskb->len)
-			data_len = entskb->len;
-
+		data_len = nfqnl_get_data_len(entskb, READ_ONCE(queue->copy_range));
 		hlen = skb_zerocopy_headlen(entskb);
 		hlen = min_t(unsigned int, hlen, data_len);
 		size += sizeof(struct nlattr) + hlen;
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index ec1a21e3b6e2..dabbaa742874 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -14,8 +14,8 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_u32.h>
 
-static bool u32_match_it(const struct xt_u32 *data,
-			 const struct sk_buff *skb)
+static int u32_match_it(const struct xt_u32 *data,
+			const struct sk_buff *skb)
 {
 	const struct xt_u32_test *ct;
 	unsigned int testind;
@@ -40,7 +40,8 @@ static bool u32_match_it(const struct xt_u32 *data,
 			return false;
 
 		if (skb_copy_bits(skb, pos, &n, sizeof(n)) < 0)
-			BUG();
+			return -1;
+
 		val   = ntohl(n);
 		nnums = ct->nnums;
 
@@ -68,7 +69,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 
 				if (skb_copy_bits(skb, at + pos, &n,
 						    sizeof(n)) < 0)
-					BUG();
+					return -1;
 				val = ntohl(n);
 				break;
 			}
@@ -90,9 +91,14 @@ static bool u32_match_it(const struct xt_u32 *data,
 static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_u32 *data = par->matchinfo;
-	bool ret;
+	int ret;
 
 	ret = u32_match_it(data, skb);
+	if (ret < 0) {
+		par->hotdrop = true;
+		return false;
+	}
+
 	return ret ^ data->invert;
 }
 
-- 
2.54.0

