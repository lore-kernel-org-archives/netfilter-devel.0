Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5271D39F19F
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783154910; cv=none; b=UiKu3Ih4FZpuC8Z6zq1oBQ+ibl+6zs0YElIcjkmfO+GfoxMNBSaoMFwDB6/nSLiDSxfgK7cfbmQW91c/iTxFwlliAWw6qNe45a/lh0419xdiKEMZ4+lJOsc7gqFEohpwgYCzARRDsHXQ3GEw+wK02jj9SHvHKVRW71fxyl15Chc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783154910; c=relaxed/simple;
	bh=jp548NajrTFz7sNJd8h6h/Kpp7Au+N8GH7PpK9SlN4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQLiF9t8Z+KViJD1wxFKZpD80qeaRqH73bGFCuEIsCIQDo5FeDIUk+zGSYF09HXI9VZdOP6rJeoGdZtD7hH+Y13+exJZbIslNIZD3fDlc5879oqnsqwSMUrqA4Lo76OyHJx66cSH4+w8H1HmO/hThURBjxG3V0+WcPDFvkNrIXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E260B60491; Sat, 04 Jul 2026 10:48:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: ebtables: account compat ebt_table_info to kmemcg
Date: Sat,  4 Jul 2026 10:48:10 +0200
Message-ID: <20260704084811.27355-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260704084811.27355-1-fw@strlen.de>
References: <20260704084811.27355-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko says:
 does compat_do_replace() bypass memory cgroup accounting?

This code is on the chopping block, but lets fix this up
for -stable sake.

Fixes: e2c8d550a973 ("netfilter: ebtables: account ebt_table_info to kmemcg")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 66c407cffa16..7238e48d51a1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2299,7 +2299,7 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	}
 
 	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
-	newinfo = vmalloc(sizeof(*newinfo) + countersize);
+	newinfo = __vmalloc(sizeof(*newinfo) + countersize, GFP_KERNEL_ACCOUNT);
 	if (!newinfo)
 		return -ENOMEM;
 
@@ -2308,7 +2308,7 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 
 	memset(&state, 0, sizeof(state));
 
-	newinfo->entries = vmalloc(tmp.entries_size);
+	newinfo->entries = __vmalloc(tmp.entries_size, GFP_KERNEL_ACCOUNT);
 	if (!newinfo->entries) {
 		ret = -ENOMEM;
 		goto free_newinfo;
-- 
2.55.0

