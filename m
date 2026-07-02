Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191053C0A04;
	Thu,  2 Jul 2026 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989462; cv=none; b=lTTzG/FWLUFpCvYdmoIGcXNlyGrUzZtZfMXtIRowxI8zB2rS5jDr20mWPX2I4m6BpTRbOTLJCX2buUiAJfgn4vn11zZTlwV/+1hl7ynUAgAtQKccxG2T+BQG8keaEf0p+y+liPn/aC7W6jLmc284bbesq/LSyRaKrFRSr4VJpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989462; c=relaxed/simple;
	bh=CDs2WiizyhC7fea+Ua2oM6fnOg+EaDQ6hBs+/Tps8pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty7xlU5+JibDMEoRyELVRijY32dftJYx/gI6DlLvRGu6EOJh4vdC41Iu44dl3RgaN4pdF1nkZx2M+LoVlJbUKKwJD5udmnkXk3INMnqYPiltpeR9fEFv+Rw4EcZ6HrfXS/yzhoE1StKMjmfkB0l79f5DaBjR9d+h3LD+FO6xXD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9017060687; Thu, 02 Jul 2026 12:50:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 11/12] netfilter: ebtables: bound num_counters like nentries in do_replace()
Date: Thu,  2 Jul 2026 12:50:02 +0200
Message-ID: <20260702105003.13550-12-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.54.0

