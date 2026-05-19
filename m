Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586DC3D88EC
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226717; cv=none; b=kH1xF+WnhV64V0SO8PRy+nv7HRlDBEzD4yUhkSkDIlSRZP8KzRC+G+4OMQmeS8jbgM2j0RGeQ0fzkssqAuNwWVdjvwL57WfSBU2bCqXZaJHumHi3p4BigYnTjLmjgOgmDC/4KaW+hqITmsEWaGygDvS/Sy/Kh0RHCh3mKwpuKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226717; c=relaxed/simple;
	bh=/CXP3tu+heMyjZYByaNx+AuU1bZ0D96MHXbs56IndS4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSKG9sVw9AoGRR+eflBW1UcGS03hb1CVRZeTeY0bpQ5LTmRn0VU/7jE/oAQ/7gQf3zHK5inqMF4KXIfjp2A5TJKC/UfKIyIzKg9vekPeTtLrPQl+mhz7qNyLrMU61swip9vsJj3ZfUCVeRvch4IdOzoeByojlOoN7arcSfstkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YPeaoWID; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YPeaoWID"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CB76060288
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226714;
	bh=iDGAk3swDfjwCq+BInVI+2xibsEcrK4DEC0EGL+abdo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YPeaoWIDKPEvneEZIQ3ddUIqgj6khdR/oHPLue2BXKilHvQ69HVf0LPc7S15qNjcR
	 73sas4MkuePry8Jbo/sx2u9dO2guV1vLVa+FibqbHOAI6E8C4H4N0Xg0qWaOsAm/EZ
	 5a77SYk4+N6az+x47qKq6S9qu2fHYNtjyYZpM9hkrt1bF7lyJlPTqIh/cvaOcb/324
	 8BOtqal0PR9KvvIAASEJXMlKbq7sNsL2eE6H6ee1vS1nqKQzby96cyoU2TstBL1TmS
	 OwQ0AZMxO/YeJTwPVbCZyY+Snqoj/OAudE2p0FSX2iSi2g/fPlGYUjQaB1p0E/gbUp
	 8p9v9RZ/KwiIA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 5/7] netfilter: conntrack: add nf_ct_iterate_destroy_net()
Date: Tue, 19 May 2026 23:38:24 +0200
Message-ID: <20260519213826.1181661-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
References: <20260519213826.1181661-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This calls nf_queue_nf_hook_drop(), bump generation id to invalidate
ct extension and finally nf_ct_iterate_cleanup().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  4 ++
 net/netfilter/nf_conntrack_core.c    | 71 ++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e6..4803e43677b9 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -245,6 +245,10 @@ void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 /* also set unconfirmed conntracks as dying. Only use in module exit path. */
 void nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data),
 			   void *data);
+/* same as previous function, but for one specific netns. */
+void nf_ct_iterate_destroy_net(struct net *net,
+			       int (*iter)(struct nf_conn *i, void *data),
+			       void *data);
 
 struct nf_conntrack_zone;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1c04ef9dd17c..59656b7de654 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2388,6 +2388,54 @@ void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 
+static void
+nf_ct_iterate_destroy_finish(int (*iter)(struct nf_conn *i, void *data),
+			     struct nf_ct_iter_data *iter_data)
+{
+	/* a skb w. unconfirmed conntrack could have been reinjected just
+	 * before we called nf_queue_nf_hook_drop().
+	 *
+	 * This makes sure its inserted into conntrack table.
+	 */
+	synchronize_net();
+
+	nf_ct_ext_bump_genid();
+	nf_ct_iterate_cleanup(iter, iter_data);
+
+	/* Another cpu might be in a rcu read section with
+	 * rcu protected pointer cleared in iter callback
+	 * or hidden via nf_ct_ext_bump_genid() above.
+	 *
+	 * Wait until those are done.
+	 */
+	synchronize_rcu();
+}
+
+/**
+ * nf_ct_iterate_destroy_net - destroy unconfirmed conntracks and iterate table in netns
+ * @iter: callback to invoke for each conntrack
+ * @data: data to pass to @iter
+ *
+ * Like nf_ct_iterate_cleanup, but first marks conntracks on the
+ * unconfirmed list as dying (so they will not be inserted into
+ * main table).
+ *
+ * Can only be called for netns.
+ */
+void
+nf_ct_iterate_destroy_net(struct net *net,
+			  int (*iter)(struct nf_conn *i, void *data), void *data)
+{
+	struct nf_ct_iter_data iter_data = {
+		.net	= net,
+		.data	= data,
+	};
+
+	nf_queue_nf_hook_drop(net);
+
+	nf_ct_iterate_destroy_finish(iter, &iter_data);
+}
+
 /**
  * nf_ct_iterate_destroy - destroy unconfirmed conntracks and iterate table
  * @iter: callback to invoke for each conntrack
@@ -2402,7 +2450,9 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup_net);
 void
 nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 {
-	struct nf_ct_iter_data iter_data = {};
+	struct nf_ct_iter_data iter_data = {
+		.data	= data,
+	};
 	struct net *net;
 
 	down_read(&net_rwsem);
@@ -2422,24 +2472,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	 */
 	net_ns_barrier();
 
-	/* a skb w. unconfirmed conntrack could have been reinjected just
-	 * before we called nf_queue_nf_hook_drop().
-	 *
-	 * This makes sure its inserted into conntrack table.
-	 */
-	synchronize_net();
-
-	nf_ct_ext_bump_genid();
-	iter_data.data = data;
-	nf_ct_iterate_cleanup(iter, &iter_data);
-
-	/* Another cpu might be in a rcu read section with
-	 * rcu protected pointer cleared in iter callback
-	 * or hidden via nf_ct_ext_bump_genid() above.
-	 *
-	 * Wait until those are done.
-	 */
-	synchronize_rcu();
+	nf_ct_iterate_destroy_finish(iter, &iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
 
-- 
2.47.3

