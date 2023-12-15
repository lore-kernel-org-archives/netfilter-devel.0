Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C81719445
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 09:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rE4Li-0002n2-FP; Fri, 15 Dec 2023 10:19:14 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix stack overflow with huge priority string
Date: Fri, 15 Dec 2023 10:19:02 +0100
Message-ID: <20231215091907.23312-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alternative would be to refactor this and move this into the parsers
(bison, json) instead of this hidden re-parsing.

Fixes: 627c451b2351 ("src: allow variables in the chain priority specification")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                     | 2 +-
 tests/shell/testcases/bogons/nft-f/huge_chain_prio | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/huge_chain_prio

diff --git a/src/evaluate.c b/src/evaluate.c
index 731313e08c2a..a220a8ca1809 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4909,7 +4909,7 @@ static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
 			NFT_NAME_MAXLEN);
 	loc = prio->expr->location;
 
-	if (sscanf(prio_str, "%s %c %d", prio_fst, &op, &prio_snd) < 3) {
+	if (sscanf(prio_str, "%255s %c %d", prio_fst, &op, &prio_snd) < 3) {
 		priority = std_prio_lookup(prio_str, family, hook);
 		if (priority == NF_IP_PRI_LAST)
 			return false;
diff --git a/tests/shell/testcases/bogons/nft-f/huge_chain_prio b/tests/shell/testcases/bogons/nft-f/huge_chain_prio
new file mode 100644
index 000000000000..41f8061a1369
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/huge_chain_prio
@@ -0,0 +1,5 @@
+table t {
+        chain c {
+                type filter hook input priority srcnDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD#DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD; policy accept;
+        }
+}
-- 
2.41.0

