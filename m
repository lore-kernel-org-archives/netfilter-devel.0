Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59660304BA9;
	Tue,  2 Sep 2025 13:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820162; cv=none; b=YmiHK2fHAGaS/ZslfJI6tlWKYrif9mNuKcUa0ZLv0jPhOGJTXaMo8zsRkApeQqz9vs14wM65g2zmoCe2nxTn0oKR6uR9/Xz8A6IOJDiDFhBsj6n8HHzt+JGtd+S0s80fhirN0PwcNzCGthuEZ9MyHYr1phcJclueAp/nJVC4yv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820162; c=relaxed/simple;
	bh=0et1aHMOWnBJzLATWZZg7R4aNnNXoFaC85mkJbFfzH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy1nn7DTYILl7gSCfG9aViYwbHLQryo2bTCRp95F+cYDBVwJmErURiOJ2dSniX3wc13mle8ZOfN1/+F5fp0QUvFqcKfdVRgttuHedKkfsskJvvoKXPjAAxv84ML20zZs4kBnhfEhP0euZ67ljpHXM4/W19Y3281klIYMslD4nfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 506A160298; Tue,  2 Sep 2025 15:35:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 1/7] netfilter: ebtables: Use vmalloc_array() to improve code
Date: Tue,  2 Sep 2025 15:35:43 +0200
Message-ID: <20250902133549.15945-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250902133549.15945-1-fw@strlen.de>
References: <20250902133549.15945-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qianfeng Rong <rongqianfeng@vivo.com>

Remove array_size() calls and replace vmalloc() with vmalloc_array() to
simplify the code.  vmalloc_array() is also optimized better, uses fewer
instructions, and handles overflow more concisely[1].

[1]: https://lore.kernel.org/lkml/abc66ec5-85a4-47e1-9759-2f60ab111971@vivo.com/
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3e67d4aff419..5697e3949a36 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -920,8 +920,8 @@ static int translate_table(struct net *net, const char *name,
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc(array_size(nr_cpu_ids,
-					   sizeof(*(newinfo->chainstack))));
+			vmalloc_array(nr_cpu_ids,
+				      sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
@@ -938,7 +938,7 @@ static int translate_table(struct net *net, const char *name,
 			}
 		}
 
-		cl_s = vmalloc(array_size(udc_cnt, sizeof(*cl_s)));
+		cl_s = vmalloc_array(udc_cnt, sizeof(*cl_s));
 		if (!cl_s)
 			return -ENOMEM;
 		i = 0; /* the i'th udc */
@@ -1018,8 +1018,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	 * the check on the size is done later, when we have the lock
 	 */
 	if (repl->num_counters) {
-		unsigned long size = repl->num_counters * sizeof(*counterstmp);
-		counterstmp = vmalloc(size);
+		counterstmp = vmalloc_array(repl->num_counters,
+					    sizeof(*counterstmp));
 		if (!counterstmp)
 			return -ENOMEM;
 	}
@@ -1386,7 +1386,7 @@ static int do_update_counters(struct net *net, const char *name,
 	if (num_counters == 0)
 		return -EINVAL;
 
-	tmp = vmalloc(array_size(num_counters, sizeof(*tmp)));
+	tmp = vmalloc_array(num_counters, sizeof(*tmp));
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1526,7 +1526,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (num_counters != nentries)
 		return -EINVAL;
 
-	counterstmp = vmalloc(array_size(nentries, sizeof(*counterstmp)));
+	counterstmp = vmalloc_array(nentries, sizeof(*counterstmp));
 	if (!counterstmp)
 		return -ENOMEM;
 
-- 
2.49.1

