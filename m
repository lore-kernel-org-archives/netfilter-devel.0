Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F594DBD62
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 11:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732404; cv=none; b=Y29IzP1GNC8U/cRY2B7d43IS3YSYuJL8UmnUt9faFvTIkkg08mn85i4mMiRRKlvNiZkZ6elFaDVXhAEu5iMCiuLleGhXkvMzA3L609qBPQljyP4SAuQecys2yFX0ZoSgYcr189vffUr+jkfpPW/u+/Uj9pdXAdwDV6DZDSOiE7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732404; c=relaxed/simple;
	bh=Lah7Y8Uuyz1z9TljDqatGO0ZK+lRwIabLQfKkLivJoY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Lp5X2kTUxu/r/8j5PkZr18wu3hx5hxEkBxoTFtmWRE0Sa1clLHEiWj2vV8y36xkWusGdlfcFOZdxrkojemv7LERw6L86vqiZMYpKk2zIhWw6w1vTWRBf6QOelbG3pFmTN2+VejGfmDW616qm05/sVhuexlG/1xpOSj46fj4HgIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lUsmZBEq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lUsmZBEq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789732400;
	bh=BGuTV1nfznEn3oUJT12F7lU8AJHxYsqCXZkZbOZtxR8=;
	h=From:To:Subject:Date:From;
	b=lUsmZBEqEA6zNEZhT4JOZncGl+VLZTgmxX7VtEA0r95NGBjKo1XLwJWFdY7T0juSh
	 y43zx+RpPV4SR1KNKVLNtqMLtYWUV+ybbXupbcu8ACWpMFLwMbk8EZVF5aWCr0+jnW
	 nNEmFtYLjQbwJ8YMuofZVGwKLM7rJ0PX3dws5EAVVwhLtbII8yfCDvFFZ4YT7HrT7Y
	 uTWaIEEwpFN+86SDl8rLVVvIXVueK4vbnlVX0y4zmc+K78mXbQQg5IGWYsp0qoy8Uj
	 ERf0gHL6xf9vpUS5eV0kBDINT/rXN4GcnrtV58WadB+/Hq5n/UPixxwUdI2mzY84bj
	 1E8yzCHLMay7g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E2D960058
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 13:53:20 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: generalize pending status bit
Date: Fri, 18 Sep 2026 13:53:17 +0200
Message-ID: <20260918115317.200054-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename NF_FLOW_HW_PENDING to NF_FLOW_PENDING and use it to inhibit the
flowtable GC worker until pending offload work has been completed.

Apparently, nf_flow_offload_stats() can schedule work to retrieve stats
while the flow is being removed by GC.

And this bit can also be used in a follow up patch to disable GC until
the flow has been fully added in both directions.

Fixes: 2c8897953f3b ("netfilter: flowtable: Add pending bit for offload work")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This patch supersedes the patch that adds the _CONFIRMED bit by reusing this existing bit.

 include/net/netfilter/nf_flow_table.h | 2 +-
 net/netfilter/nf_flow_table_core.c    | 7 ++++++-
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f2e2771f188f..f14fd70e8289 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -186,7 +186,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW,
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
-	NF_FLOW_HW_PENDING,
+	NF_FLOW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
 	NF_FLOW_HW_ESTABLISHED,
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 934c6151f558..36bbc7be2f74 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -575,7 +575,12 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
-	bool teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	bool teardown;
+
+	if (test_bit(NF_FLOW_PENDING, &flow->flags))
+		return;
+
+	teardown = test_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..2409cbd44a02 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1058,7 +1058,7 @@ static void flow_offload_work_handler(struct work_struct *work)
 			WARN_ON_ONCE(1);
 	}
 
-	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
+	clear_bit(NF_FLOW_PENDING, &offload->flow->flags);
 	kfree(offload);
 }
 
@@ -1084,12 +1084,12 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 {
 	struct flow_offload_work *offload;
 
-	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
+	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
 		return NULL;
 
 	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
 	if (!offload) {
-		clear_bit(NF_FLOW_HW_PENDING, &flow->flags);
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
 		return NULL;
 	}
 
-- 
2.47.3

