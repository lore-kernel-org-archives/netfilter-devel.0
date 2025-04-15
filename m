Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4A21ACEA6
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 13:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744725378; cv=none; b=jqpknsLuKe5E+Dji1PbtE9sSPesyLJ7HwFgvbneE+oj5uNrx3dpdXjtxe16aJEMcRUrX3TBjsqUgnDFsqkLqdKQ7M79R43QDBsPLugvkbxsiI/Fi2QE4bYWEphPAnEbSPq5SciY28Sc8gH9xSwvv+c2OIRLjzt3CBPdcARjTDSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744725378; c=relaxed/simple;
	bh=gmJWk8LPKkt7w/KhxMyxTZCAn/XbM/tztnNaNwCCIyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GWl92sZBlRou5cCFrs0nZG2UG2eXSrn2063PS2znGzdK3SodJBT2WQvScZGnAjhpqCApvDwOCIgTE9RShw1xKVi36L7oBbCGM1XOfnSTf+oUz9PbtweOeShbRqkKUzNCmKwZhiWdVakD3Qdoyffjs1xdTGf3nUrskK2GARsum+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u4glj-0007Fe-V6; Tue, 15 Apr 2025 15:56:07 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: fix erronous removal of offload bit
Date: Tue, 15 Apr 2025 15:53:48 +0200
Message-ID: <20250415135355.11427-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blamed commit exposes a possible issue with flow_offload_teardown():
We might remove the offload bit of a conntrack entry that has been
offloaded again.

1. conntrack entry c1 is offloaded via flow f1 (f1->ct == c1).
2. f1 times out and is pushed back to slowpath, c1 offload bit is
   removed.  Due to bug, f1 is not unlinked from rhashtable right away.
3. a new packet arrives for the flow and re-offload is triggered, i.e.
   f2->ct == c1.  This is because lookup in flowtable skip entries with
   teardown bit set.
4. Next flowtable gc cycle finds f1 again
5. flow_offload_teardown() is called again for f1 and c1 offload bit is
   removed again, even though we have f2 referencing the same entry.

This is harmless, but clearly not correct.
Fix the bug that exposes this: set 'teardown = true' to have the gc
callback unlink the flowtable entry from the table right away instead of
the unintentional defer to the next round.

Also prevent flow_offload_teardown() from fixing up the ct state more than
once: We could also be called from the data path or a notifier, not only
from the flowtable gc callback.

NF_FLOW_TEARDOWN can never be unset, so we can use it as synchronization
point: if we observe did not see a 0 -> 1 transition, then another CPU
is already doing the ct state fixups for us.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9d8361526f82..9441ac3d8c1a 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -383,8 +383,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow);
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+		flow_offload_fixup_ct(flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -558,10 +558,12 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_custom_gc(flow_table, flow))
+	    nf_flow_custom_gc(flow_table, flow)) {
 		flow_offload_teardown(flow);
-	else if (!teardown)
+		teardown = true;
+	} else if (!teardown) {
 		nf_flow_table_extend_ct_timeout(flow->ct);
+	}
 
 	if (teardown) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
-- 
2.49.0

