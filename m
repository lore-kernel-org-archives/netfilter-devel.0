Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDA226CFE
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367682; cv=none; b=KSvU7uctUfjECRSNQNPDnRY5HX3kvQQd8rk1wMt6ZySjgJxJqhwFUpvop6jfCNuj0GuxiihwWK7tNFDXY/EJd2wXKT3lEGAd+QaGUDLtEXvgTq27Ziou7A9nugFBnucqnUaJk5Pxp6L5hJ5RqAaftdH2SmyVP8VgdygVZb5Hewk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367682; c=relaxed/simple;
	bh=jBSUI1geImPy0a+gkrXu2rw1VjFhSpnsmXMOR5qTnuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfjaVF2uc0Zfj1A5l28zchYKNImVs1aZkC0egncm4CFwCOvN/IAOVcBBVwxQlUPJIjDfOSjKg/vxUsty3QtgBztnJ/hUokydDAFD9EbQRwcLauPAr+wznPQVz6XeJP5wk3gb9rwENbmDw/tr5sugGMcF4/cu6FhBKc+DiqQFGGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4189160242; Mon, 13 Oct 2025 17:01:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: disable 0 value for conntrack_max setting
Date: Mon, 13 Oct 2025 17:01:01 +0200
Message-ID: <20251013150107.4300-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Undocumented historical behavior inherited from ip_conntrack (ipv4 only
ancestor) days.

If set to 0, no limit is applied.

conntrack table can grow to huge value, only limited by size of conntrack
table and the kernel-internal upper limit on the hash chain lengths.

This feature makes no sense; users can just set
conntrack_max=2147483647 (INT_MAX) if tehy want.

Disallow a 0 value.  This will make it slightly easier to allow
per-netns constraints for this value in a future patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c       | 2 +-
 net/netfilter/nf_conntrack_standalone.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f88295976..0b95f226f211 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1668,7 +1668,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
 
-	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+	if (unlikely(ct_count > nf_conntrack_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 708b79380f04..207b240b14e5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -648,7 +648,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
@@ -929,7 +929,7 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
+		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
 };
-- 
2.51.0

