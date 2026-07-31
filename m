Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838573CF698
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491608; cv=none; b=FJOJDdMEilQbv1tSzMFhSjie6AGLRTyZY9r/KS6LUv4b7f4lnV4RkVnUJi9P8eMVhtIqeLHsQ0Fw5XJG7cZ/5x9gtTIai3Yt/0EzfnQOtJPwXTdiqDMtSbj5aYDU9dyYGnxZAIR/Yf9+y3Wwns04uLlSQQfh2FJZc6njWvQksJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491608; c=relaxed/simple;
	bh=CrAMnh/7PE31+G6eSHUGKQxsjK5OaA9ieUg/6YwYsDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N8kFZQKeqY098loX/um90O+xQvguVp9FEzzO7s3ApTMkwn1OFl4EXjLE/9PTrQqhSYYkpuQUHzGmn3muw5P+RtnkogLBSjNcTDVJBD6BxG4pApdyMcIKCiqXa+U4swJNptvQQ2VOdv/ijY/5ng/jPlEfjcFps5Kwl93pN2lVbTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QNQ0Chjl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QNQ0Chjl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87D26601C0;
	Fri, 31 Jul 2026 11:53:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785491592;
	bh=XL4Xed6JCg/DY5jmxoX8i4/5t77bdWqH2oCIYsLoMpQ=;
	h=From:To:Cc:Subject:Date:From;
	b=QNQ0ChjlWNPDLRjfc5QgkK78s1PeuGkkJue3Sv3PjBo7WSDmaVXBwLwKaDFpRJ71J
	 62KlUUBM3bFLY3SRxFC/HCiH+phj5ygs82FBJrWQDIwV7aIP5PHmi3eJUS9pOOZXQg
	 6GgmHXME+bTw0GpFuosuHQ87OkZ2WHsjAwkExfxQWZzYknSjgwu7JtfXRQXU1f+5N5
	 hq6Xe0JMSuThGKIRw4Q+WF8jX3Olag/iGNhHDe2p23dCcTwixcMpeZMbotozS1+kpM
	 DYb8POx1Da/mxl0YqUlv5sdQAqDWFUI5s3Kk2l2k9nOIfVgW7n58Q6fte+F4KAeH9b
	 T8PV2+HsDgeWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next] netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
Date: Fri, 31 Jul 2026 11:53:09 +0200
Message-ID: <20260731095309.682239-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trigger a warning if nf_ct_set() overlaps an existing ct object leading
to refcount leak. Add this warning to skb_set_nfct() whose only user is
nf_ct_set() instead.

Update existing nf_ct_set() callsites to use nf_reset_ct() first to
clean up stale pointer to conntrack object which migh trigger false
positive warnings.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/skbuff.h      | 1 +
 include/net/ip_vs.h         | 2 +-
 net/openvswitch/conntrack.c | 2 +-
 net/sched/act_ct.c          | 6 +++---
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 22eda1d54a0e..95184183180f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -5004,6 +5004,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	DEBUG_NET_WARN_ON_ONCE(skb->_nfct & NFCT_PTRMASK);
 	skb->slow_gro |= !!nfct;
 	skb->_nfct = nfct;
 #endif
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e6ca930a3507..c8091482bc7b 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -2130,7 +2130,7 @@ static inline void ip_vs_notrack(struct sk_buff *skb)
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 
 	if (ct) {
-		nf_conntrack_put(&ct->ct_general);
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	}
 #endif
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 95697d4e16e6..08043f5bb781 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -603,7 +603,7 @@ static bool skb_nfct_cached(struct net *net,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_delete(ct, 0, 0);
 
-		nf_ct_put(ct);
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, 0);
 		return false;
 	}
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index be535a261fa0..7395125f3cd8 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -782,7 +782,7 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	return true;
 
 drop_ct:
-	nf_ct_put(ct);
+	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 
 	return false;
@@ -996,7 +996,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		qdisc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
-			nf_ct_put(ct);
+			nf_reset_ct(skb);
 			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		}
 
@@ -1034,7 +1034,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			nf_conntrack_put(skb_nfct(skb));
+			nf_reset_ct(skb);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
-- 
2.47.3

