Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294BB33E355
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 03:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781060632; cv=none; b=HsYk8menzUvdsmYilTubW+7HoF1WJPOrsN6/WsDjDNfsya/bSz7xDrKylopkzoAMJaaCFiZ6V3s67ZeZm4bVW4V/oDpxiyR/1YrkwrntM+0FofOpuadxoHI+Wf6jBfgoUB09NjPW26CKZRxjhbtgN6RBOflhs1GINb8b7EkMt1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781060632; c=relaxed/simple;
	bh=qun9oyIAT5mnYgmIsjaXMtP7fFOG7+gKuLxPA8dFE7k=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qd0/0aYbjt13qqNuqdDv+nL93MXJwz1/XGuGy/upCvw8WZYQnvrvNCB2YHK48RDxT8RHngUEVyRXnPDGjxiHC9vLuYsYBuCrE+/ZmrNsSqeHey1QLNc3OwGaiSEs2QEMQ0B5JRs3dgIuJDgz/v6sTO515NVt3pqC1ZsqNeIlum8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PA5jWgFQ; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PA5jWgFQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781060627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6fAxcYZ1eHDCo73nCq7jZg+k/I4R3YvBZLgENzx+rhg=;
	b=PA5jWgFQmWuX7k4dUR1eTJg959bP7Ft7Nq+xJ7ddabcLL7LYZAMKbPDGNLeRdb9Z2w0WIA
	CaBUq6bbVAZUcgpJuLv3LctabutV0mWh/xpMSN3zm95zq5nV3cpWeAnCpDzyIy3CAyzFnH
	psZLIso6b+nBJhFSchb1wiTYsm0fHdo=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Wed, 10 Jun 2026 11:02:59 +0800
Message-ID: <20260610030259.194456-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

do_replace_finish() allocates the counter buffer before it is validated:

   counterstmp = vmalloc_array(repl->num_counters, sizeof(*counterstmp));

do_replace() only checks num_counters against INT_MAX / sizeof(struct
ebt_counter), so vmalloc_array() can be asked for up to 134217726 * 16 =
2147483616 bytes (~2 GiB).

num_counters must in fact equal nentries: do_replace_finish() later
rejects the request when repl->num_counters != t->private->nentries.
get_counters() folds the per-CPU counters back into one entry per rule,
so what userspace gets is bounded by nentries, never by nentries *
nr_cpus. Apply the same upper bound used for nentries (MAX_EBT_ENTRIES)
to the incoming num_counters so the over-sized allocation can no longer
be requested.

The allocation is still kept outside the ebt_mutex, since vmalloc() may
sleep and trigger reclaim; only the bound is tightened.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 net/bridge/netfilter/ebtables.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f20c039e44c8..042d31278713 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -39,6 +39,8 @@
 #define COUNTER_OFFSET(n) (SMP_ALIGN(n * sizeof(struct ebt_counter)))
 #define COUNTER_BASE(c, n, cpu) ((struct ebt_counter *)(((char *)c) + \
 				 COUNTER_OFFSET(n) * cpu))
+#define MAX_EBT_ENTRIES (((INT_MAX - sizeof(struct ebt_table_info)) / \
+			 NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
 
 struct ebt_pernet {
 	struct list_head tables;
@@ -1124,10 +1126,9 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -EINVAL;
 
 	/* overflow check */
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	tmp.name[sizeof(tmp.name) - 1] = 0;
@@ -2265,10 +2266,9 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
 	if (tmp.entries_size == 0)
 		return -EINVAL;
 
-	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
-			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+	if (tmp.nentries >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
-	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+	if (tmp.num_counters >= MAX_EBT_ENTRIES)
 		return -ENOMEM;
 
 	memcpy(repl, &tmp, offsetof(struct ebt_replace, hook_entry));
-- 
2.43.0

