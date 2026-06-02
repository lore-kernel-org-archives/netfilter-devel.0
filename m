Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D4B23B62B
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 21:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434609; cv=none; b=tkvSs/Roh1nhdpn4n4yX1MefPXOkbi8bVuQIWeWWBTxOmRkYoSgqFOWQVD/mt7wwVPXtwGsPICEDg7AsqLhKu8rWu2zrlI7iA+/AeEi7u+hVWsHOuwrAAWbw6aDX4uea8r6iNJkJ4ZKwF3LABSDLkd9qg2YDCVYDJnfR/9LPoVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434609; c=relaxed/simple;
	bh=4IdCtbUEW5g+/I5RIRcohKEBzfAPfmleE+C3Wfs0CRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDbB+kV/w2br9/iziczTcwVgYkqcbC3a2ywXfnWBlRjwCrO7HhqFaYPZ7IE2ZimnOq6H6gaSbXcYL+K3hjTsIAk5LKoA+ZpglM0PREBPmqhF6PF1XhWxOQxUOeqiXqDrvskpnFQ1UJzNxLYaWL20eTHD1CWEddEJpyThBqmjjs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ANia7XRx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ANia7XRx"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4A1EA601A0;
	Tue,  2 Jun 2026 23:10:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780434603;
	bh=VwK11x22SqLJIm8pjumjdjKOV6r3u7x75foese0Wj0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANia7XRxMabHad9JBNthG0QJiCK0U2OAbgWJ9gQ3GcyucqPxo21FLFOSrBSpshn0F
	 pqTkOXIVFXEsXlGZ3ziVLasoE9SKq8kgdcclIdddrNhV7/HuH6Y5shxrm+Pq43E6nB
	 +expC7Zuez3ICU1vNDpMyd64Ag+iZRaUASJacZSV+3lzjel9t00ZSRooycdD/fv2d7
	 9GauWmAIpi1tfGob/M5krcHFuhVHJkuRV40Bxd63mlEzNlrYTUGiV1/qziFSASupTR
	 CbfH7BQ1dktME4l4ts/8Q6qgaVEO7XyAVdnM0BHko5qwraWKN7AC9RnA0oi12ciosi
	 xr1Uv//2OIWmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 6/6] netfilter: nat: clean up nf_nat_bysource in module exit path
Date: Tue,  2 Jun 2026 23:09:52 +0200
Message-ID: <20260602210952.736311-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602210952.736311-1-pablo@netfilter.org>
References: <20260602210952.736311-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_iterate_destroy() removes all conntracks with NAT when the module
is going away.

However, unconfirmed conntracks are skipped and the .nat_bysource field
becomes stale. Walk the nf_nat_bysource hash to remove the conntrack
when the nf_nat module is going away and set the dying bit so this never
gets confirmed.

Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series, address possible rare corner case with nat
    module and unconfirmed conntrack entries found by AI reviewer.

 net/netfilter/nf_nat_core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 74ec224ce0d6..d3df176e8bf9 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1309,6 +1309,27 @@ static const struct nf_nat_hook nat_hook = {
 	.remove_nat_bysrc	= nf_nat_cleanup_conntrack,
 };
 
+/* Unconfirmed conntrack are also found in the bysource hash. */
+static void nf_nat_bysource_flush(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < nf_nat_htable_size; i++) {
+		spinlock_t *lock = &nf_nat_locks[i % CONNTRACK_LOCKS];
+		struct nf_conn *ct;
+		struct hlist_node *next;
+
+		spin_lock_bh(lock);
+		hlist_for_each_entry_safe(ct, next,
+					  &nf_nat_bysource[i], nat_bysource) {
+			hlist_del_rcu(&ct->nat_bysource);
+			set_bit(IPS_DYING_BIT, &ct->status);
+		}
+		spin_unlock_bh(lock);
+		cond_resched();
+	}
+}
+
 static int __init nf_nat_init(void)
 {
 	int ret, i;
@@ -1358,6 +1379,8 @@ static void __exit nf_nat_cleanup(void)
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
 	synchronize_net();
+
+	nf_nat_bysource_flush();
 	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
 }
-- 
2.47.3

