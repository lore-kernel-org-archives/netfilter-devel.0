Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551301FC3
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2024 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729939849; cv=none; b=PiRgosaHXoYjWJXQmwFyCXkTCQqvmfHSrASvALFMkbhLHbSCyFL9wLDe+SKokXCkhksarjp7qVOJtOZeTngBCgUNcJMsVgtGOXDVHdSY7VsnAeJ02dJifM8HSjyzwlVMlh0Gvuc3amAytljsl6T64YHEHLmq23DZRhg/qxjn5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729939849; c=relaxed/simple;
	bh=42oINqSXKKDK6gPKaRLEalcQI+eWUyBJxtNtxEYdhgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tep72imbRHIUrHnsjadZbbzPeQJOuM4IcecMbsEDKobOzoffULI6+qrdJ0bHM6HBc0HMJWNeeQoyr88MW9++FOjiuJN7BBoM7tv713Xo0LEA0OT8poTcioPEYsG803HTEhbPQ2xe6Fw+p5NYdwGliKzUXeKlGkg9xUYwv2O/mGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t4eNY-0008Gq-38; Sat, 26 Oct 2024 12:50:44 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: [PATCH nf-next] netfilter: conntrack: collect start time as early as possible
Date: Sat, 26 Oct 2024 12:50:13 +0200
Message-ID: <20241026105030.75254-1-fw@strlen.de>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sample start time at allocation time, not when the conntrack entry
is inserted into the hashtable.

In most cases this makes very little difference, but there are
cases where there is significant delay beteen allocation and
confirmation, e.g. when packets get queued to userspace.

Sampling as early as possible exposes this extra delay to userspace
via ctnetlink.

Reported-by: Nadia Pinaeva <n.m.pinaeva@gmail.com>
Fixes: a992ca2a0498 ("netfilter: nf_conntrack_tstamp: add flow-based timestamp extension")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_timestamp.h | 12 ++++++------
 net/netfilter/nf_conntrack_core.c              | 16 ++--------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 57138d974a9f..76515353829d 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -23,18 +23,18 @@ struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
 #endif
 }
 
-static inline
-struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
+static inline void nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
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
+		tstamp->start = ktime_get_real_ns();
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9db3e2b0b1c3..ed1870096519 100644
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
-- 
2.47.0

