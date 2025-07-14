Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ECE24DCEF
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752500571; cv=none; b=C8fDTgXAB8fPa2blWTIQiHcjXAkJkAL9sbFO2cNDvfawseW85oSN0iMOaLzq+YwJl01eIGNmrcsn8QgcooP0LjdLjjt7co0Ux45Yjgsc5uVEfC9aW9+7cV41t+25G+fNTEtAgLfjZZDEVxByRFBmii7Ll1Lopg2lergu9UMJLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752500571; c=relaxed/simple;
	bh=sU9rEQ3IvFpPAcCMRUoNP5JgIJRAm7O61lT3VrDYj8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d3+FD541AR77EnesDVqeyO8OAiMRaJ9MEPvPwikxwSYZPMgWglEBJGpZ76Uu/wzFk4pFp+HQM5KlL68HV9zEsTdkRiCEAU6JEMMzvRgwhHW3f53SYJMT3Wo8czpzV6uP2osrFsNfsMD1R3fmcG7r6DYzyF9BEx2fAXwmK2XYx5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 41A11604E7; Mon, 14 Jul 2025 15:42:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: BASECHAIN flag no longer implies presence of priority expression
Date: Mon, 14 Jul 2025 15:42:28 +0200
Message-ID: <20250714134231.19015-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to
44ea19364637 ("src: BASECHAIN flag no longer implies presence of priority expression"):
feeding the same bogon file into nft -j we get a very similar crash.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/json.c                                    | 32 ++++++++++++-------
 .../bogons/nft-j-f/null_ingress_type_crash    |  6 ++++
 2 files changed, 26 insertions(+), 12 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/null_ingress_type_crash

diff --git a/src/json.c b/src/json.c
index 5d34b27eb915..977f55667fc2 100644
--- a/src/json.c
+++ b/src/json.c
@@ -294,8 +294,7 @@ static json_t *rule_print_json(struct output_ctx *octx,
 
 static json_t *chain_print_json(const struct chain *chain)
 {
-	json_t *root, *tmp, *devs = NULL;
-	int priority, policy, i;
+	json_t *root;
 
 	root = nft_json_pack("{s:s, s:s, s:s, s:I}",
 			 "family", family2str(chain->handle.family),
@@ -307,8 +306,12 @@ static json_t *chain_print_json(const struct chain *chain)
 		json_object_set_new(root, "comment", json_string(chain->comment));
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		mpz_export_data(&priority, chain->priority.expr->value,
-				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		json_t *tmp = NULL, *devs = NULL;
+		int priority = 0, policy, i;
+
+		if (chain->priority.expr)
+			mpz_export_data(&priority, chain->priority.expr->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
 
 		if (chain->policy) {
 			mpz_export_data(&policy, chain->policy->value,
@@ -317,12 +320,15 @@ static json_t *chain_print_json(const struct chain *chain)
 			policy = NF_ACCEPT;
 		}
 
-		tmp = nft_json_pack("{s:s, s:s, s:i, s:s}",
-				"type", chain->type.str,
-				"hook", hooknum2str(chain->handle.family,
-						    chain->hook.num),
-				"prio", priority,
-				"policy", chain_policy2str(policy));
+		if (chain->type.str)
+			tmp = nft_json_pack("{s:s, s:s, s:i, s:s}",
+					"type", chain->type.str,
+					"hook", hooknum2str(chain->handle.family,
+							    chain->hook.num),
+					"prio", priority,
+					"policy", chain_policy2str(policy));
+		else
+			tmp = NULL;
 
 		for (i = 0; i < chain->dev_array_len; i++) {
 			const char *dev = chain->dev_array[i];
@@ -336,8 +342,10 @@ static json_t *chain_print_json(const struct chain *chain)
 		if (devs)
 			json_object_set_new(root, "dev", devs);
 
-		json_object_update(root, tmp);
-		json_decref(tmp);
+		if (tmp) {
+			json_object_update(root, tmp);
+			json_decref(tmp);
+		}
 	}
 
 	return nft_json_pack("{s:o}", "chain", root);
diff --git a/tests/shell/testcases/bogons/nft-j-f/null_ingress_type_crash b/tests/shell/testcases/bogons/nft-j-f/null_ingress_type_crash
new file mode 100644
index 000000000000..2ed88af24c56
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/null_ingress_type_crash
@@ -0,0 +1,6 @@
+table netdev filter1 {
+	chain c {
+		devices = { lo }
+	}
+}
+list ruleset
-- 
2.49.0

