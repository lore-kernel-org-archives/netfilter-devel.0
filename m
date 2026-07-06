Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339B5414DE0
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jul 2026 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783353154; cv=none; b=YEdQnrkeraZSalwa509lhSS0Zs51qv5yDW5sAmwCWNfWJwsh0VvktrlZMfq5FKV4LjN9PAm6eujtMfHqJGe4emTdRYyYJRHdtHMY9fo1gUmVYbCqObZjGUvRBATEfBuZnaFOBJKur7PBSpF6BzOIYar/dnS5ogeEuzL5wNu09U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783353154; c=relaxed/simple;
	bh=UxYHw4BjuqCuh6SXmrJz7GYfb+XXldsSYc0gM5XFeVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F4HKCo7Rq4YRCtwERX+5lEh3H3T2+FnYTpBtDd0TGPeFDbLyklm4lOZ6DL8ANuqpYa4e7q58MNhBk3qU4HxiYOg/8q5w4u6CJ3BhK8/JV/ilEymId50qbU/RV3uVIXwuw+ivj1Us0BOPmSUV17XiSI4eWiLg9ExnzQ9vgj0XMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 179C16064E; Mon, 06 Jul 2026 17:52:26 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: handle unreadable frags
Date: Mon,  6 Jul 2026 17:52:17 +0200
Message-ID: <20260706155219.23757-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
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
 skb_copy_bits() will safely return a negative error code rather than
 successfully copying the bits.

For xt_u32: bail out with hotdrop in this case.
For gather_frags: return -1, just as if we had no fragment header.
For nfnetlink_log: restrict to the non-linear part.

nfnetlink_queue is ok, it uses skb_zerocopy() helper.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/netfilter/nfnetlink_log.c           | 26 ++++++++++++++++---------
 net/netfilter/xt_u32.c                  | 13 +++++++++----
 3 files changed, 27 insertions(+), 14 deletions(-)

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
index fa3657599861..6d1ed48c5e8f 100644
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
+	    (li->u.ulog.copy_len < copy_len))
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
 
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index ec1a21e3b6e2..1e81ece9b515 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -14,9 +14,10 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_u32.h>
 
-static bool u32_match_it(const struct xt_u32 *data,
+static bool u32_match_it(struct xt_action_param *par,
 			 const struct sk_buff *skb)
 {
+	const struct xt_u32 *data = par->matchinfo;
 	const struct xt_u32_test *ct;
 	unsigned int testind;
 	unsigned int nnums;
@@ -40,7 +41,8 @@ static bool u32_match_it(const struct xt_u32 *data,
 			return false;
 
 		if (skb_copy_bits(skb, pos, &n, sizeof(n)) < 0)
-			BUG();
+			goto err;
+
 		val   = ntohl(n);
 		nnums = ct->nnums;
 
@@ -68,7 +70,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 
 				if (skb_copy_bits(skb, at + pos, &n,
 						    sizeof(n)) < 0)
-					BUG();
+					goto err;
 				val = ntohl(n);
 				break;
 			}
@@ -85,6 +87,9 @@ static bool u32_match_it(const struct xt_u32 *data,
 	}
 
 	return true;
+err:
+	par->hotdrop = true;
+	return false;
 }
 
 static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -92,7 +97,7 @@ static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_u32 *data = par->matchinfo;
 	bool ret;
 
-	ret = u32_match_it(data, skb);
+	ret = u32_match_it(par, skb);
 	return ret ^ data->invert;
 }
 
-- 
2.54.0

