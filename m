Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033B37485
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Jun 2025 12:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748866965; cv=none; b=LbDWtxs1NkmGi/y5MWxyPfb1H4po8Vp4PjRtMuJ5uYexmimA1JTyfXakoXrNlkFDM2jEOl19ntwKk9ocWxreo9WlAxiRbdtuzD5RtRmA7Aj2TI6AGq2muxU/ljd26sMQM+7H5eEXH+5jFUaIvpOmhIUV4wlUDeULhFCZ0QgzuS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748866965; c=relaxed/simple;
	bh=TIsmb4RnIR4HfrenrzWs3EUiG+FKa4VNQzfbN+LW4+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R/aDChXSX+zYU7CrzDVQaeyAoBfuvA6y2SMLW9wzwE2DEq6CasYollpyIHaE6qTZcWFVd/lQf7QLKqtjh3XpUavWC4T/TNXCWsEdqB7OPcOj75NAxfuAftFZdAKj3KHTsE9t+97H5ujodFuRak5C6GE5Rv/UXk1yOwssC+yqOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1FA1F60532; Mon,  2 Jun 2025 14:22:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: prevent null deref if chain->policy is not set
Date: Mon,  2 Jun 2025 14:22:33 +0200
Message-ID: <20250602122235.10923-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The two commits mentioned below resolved null dererence crashes when
resolved a null dereference crash when the policy resp. priority keyword
was missing in the chain / flowtable specification.

Same issue exists in the json output path, so apply similar fix
there and extend the existing test cases.

Fixes: 5b37479b42b3 ("nftables: don't crash in 'list ruleset' if policy is not set")
Fixes: b40bebbcee36 ("rule: do not crash if to-be-printed flowtable lacks priority")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c                                    | 19 ++++++++++++++-----
 .../nft-j-f/flowtable-no-priority-crash       |  6 ++++++
 .../shell/testcases/nft-f/0021list_ruleset_0  |  7 ++++++-
 3 files changed, 26 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/flowtable-no-priority-crash

diff --git a/src/json.c b/src/json.c
index 53e81446fd35..a46aed279167 100644
--- a/src/json.c
+++ b/src/json.c
@@ -309,8 +309,14 @@ static json_t *chain_print_json(const struct chain *chain)
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		mpz_export_data(&priority, chain->priority.expr->value,
 				BYTEORDER_HOST_ENDIAN, sizeof(int));
-		mpz_export_data(&policy, chain->policy->value,
-				BYTEORDER_HOST_ENDIAN, sizeof(int));
+
+		if (chain->policy) {
+			mpz_export_data(&policy, chain->policy->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
+		} else {
+			policy = NF_ACCEPT;
+		}
+
 		tmp = nft_json_pack("{s:s, s:s, s:i, s:s}",
 				"type", chain->type.str,
 				"hook", hooknum2str(chain->handle.family,
@@ -485,10 +491,13 @@ static json_t *obj_print_json(const struct obj *obj)
 static json_t *flowtable_print_json(const struct flowtable *ftable)
 {
 	json_t *root, *devs = NULL;
-	int i, priority;
+	int i, priority = 0;
+
+	if (ftable->priority.expr) {
+		mpz_export_data(&priority, ftable->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+	}
 
-	mpz_export_data(&priority, ftable->priority.expr->value,
-			BYTEORDER_HOST_ENDIAN, sizeof(int));
 	root = nft_json_pack("{s:s, s:s, s:s, s:I, s:s, s:i}",
 			"family", family2str(ftable->handle.family),
 			"name", ftable->handle.flowtable.name,
diff --git a/tests/shell/testcases/bogons/nft-j-f/flowtable-no-priority-crash b/tests/shell/testcases/bogons/nft-j-f/flowtable-no-priority-crash
new file mode 100644
index 000000000000..f348da9011a3
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/flowtable-no-priority-crash
@@ -0,0 +1,6 @@
+table ip filter {
+	flowtable ft1 {
+		devices = { lo }
+	}
+}
+list ruleset
diff --git a/tests/shell/testcases/nft-f/0021list_ruleset_0 b/tests/shell/testcases/nft-f/0021list_ruleset_0
index 37729b4f86d9..f3c3749be907 100755
--- a/tests/shell/testcases/nft-f/0021list_ruleset_0
+++ b/tests/shell/testcases/nft-f/0021list_ruleset_0
@@ -12,4 +12,9 @@ RULESET="table filter {
 list  ruleset
 "
 
-exec $NFT -f - <<< "$RULESET"
+$NFT -f - <<< "$RULESET"
+
+if [ "$NFT_TEST_HAVE_json" != n ]; then
+	$NFT flush ruleset
+	$NFT -j -f - <<< "$RULESET"
+fi
-- 
2.49.0

