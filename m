Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F50745023
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294319; cv=none; b=r/P+erCn4WTDlGug4FXPczhDF3o9siMn6xbq7VrKFknXIJ5S4U3Jo1zquTRuYUJgUpd37O96adlqAR8dD+Y4PrJ53fAhAyWkHIkCOy+DesxNQCOqDDhuBtMKXiKbcVfnMIkAxPiY38T0Qnv6vjXS9tBRtOR8Z/7LEVdO3B6RxkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294319; c=relaxed/simple;
	bh=ae7s13PoqD2Tvl9i4tAPuqCZ/r1qMWIA3d1EXfFzRPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0XrPbPhkmrS3AfclN5nFcjOEquTDojTofPcOp/VGyAKxsctxsaWAieb0ZdtU2XTuJ+wk+4jcnpiyfR3zp5b8zYjMw01XuCTiQXOutwc/Vv2QRzvAGnPDQpr1Szr+ndr/6KK2vo09GApYHMicAbwIqHKheEWFQyNJHFxGne7mBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t68ak-0002qm-Sd; Wed, 30 Oct 2024 14:18:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: [PATCH nf-next v2] netfilter: conntrack: collect start time as early as possible
Date: Wed, 30 Oct 2024 14:12:29 +0100
Message-ID: <20241030131232.15524-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sample start time at allocation time, not when the conntrack entry is
inserted into the hashtable.

In most cases this makes very little difference, but there are cases where
there is significant delay beteen allocation and confirmation, e.g. when
packets get queued to userspace to when there are many (iptables) rules
that need to be evaluated.

Sampling as early as possible exposes this extra delay to userspace.
Before this, conntrack start time is the time when we insert into the
table, at that time all of prerouting/input (or forward/postrouting)
processing has already happened.

v2: if skb has a suitable timestamp set, use that.  This makes flow start
time to be either initial receive time of skb or the conntrack allocation.

Reported-by: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Fixes: a992ca2a0498 ("netfilter: nf_conntrack_tstamp: add flow-based timestamp extension")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_timestamp.h | 12 ++++++------
 net/netfilter/nf_conntrack_core.c              | 18 +++---------------
 net/netfilter/nf_conntrack_netlink.c           |  6 +-----
 3 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 57138d974a9f..5b6273058384 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -23,18 +23,18 @@ struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
 #endif
 }
 
-static inline
-struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
+static inline void nf_ct_tstamp_ext_add(struct nf_conn *ct, u64 tstamp_ns, gfp_t gfp)
 {
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	struct net *net = nf_ct_net(ct);
+	struct nf_conn_tstamp *tstamp;
 
 	if (!net->ct.sysctl_tstamp)
-		return NULL;
+		return;
 
-	return nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
-#else
-	return NULL;
+	tstamp = nf_ct_ext_add(ct, NF_CT_EXT_TSTAMP, gfp);
+	if (tstamp)
+		tstamp->start = tstamp_ns ? tstamp_ns : ktime_get_real_ns();
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9db3e2b0b1c3..33bc99356453 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -976,18 +976,6 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	}
 }
 
-static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
-{
-	struct nf_conn_tstamp *tstamp;
-
-	refcount_inc(&ct->ct_general.use);
-
-	/* set conntrack timestamp, if enabled. */
-	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp)
-		tstamp->start = ktime_get_real_ns();
-}
-
 /**
  * nf_ct_match_reverse - check if ct1 and ct2 refer to identical flow
  * @ct1: conntrack in hash table to check against
@@ -1111,7 +1099,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 	 */
 	loser_ct->status |= IPS_FIXED_TIMEOUT | IPS_NAT_CLASH;
 
-	__nf_conntrack_insert_prepare(loser_ct);
+	refcount_inc(&loser_ct->ct_general.use);
 
 	/* fake add for ORIGINAL dir: we want lookups to only find the entry
 	 * already in the table.  This also hides the clashing entry from
@@ -1295,7 +1283,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	   weird delay cases. */
 	ct->timeout += nfct_time_stamp;
 
-	__nf_conntrack_insert_prepare(ct);
+	refcount_inc(&ct->ct_general.use);
 
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
@@ -1782,7 +1770,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 				      GFP_ATOMIC);
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
-	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
+	nf_ct_tstamp_ext_add(ct, ktime_to_ns(skb_tstamp(skb)), GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1239433830..1761cd3a84e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2239,7 +2239,6 @@ ctnetlink_create_conntrack(struct net *net,
 	struct nf_conn *ct;
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
-	struct nf_conn_tstamp *tstamp;
 	u64 timeout;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
@@ -2303,7 +2302,7 @@ ctnetlink_create_conntrack(struct net *net,
 		goto err2;
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
-	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
+	nf_ct_tstamp_ext_add(ct, 0, GFP_ATOMIC);
 	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
 	nfct_seqadj_ext_add(ct);
@@ -2365,9 +2364,6 @@ ctnetlink_create_conntrack(struct net *net,
 		__set_bit(IPS_EXPECTED_BIT, &ct->status);
 		ct->master = master_ct;
 	}
-	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp)
-		tstamp->start = ktime_get_real_ns();
 
 	err = nf_conntrack_hash_check_insert(ct);
 	if (err < 0)
-- 
2.45.2

