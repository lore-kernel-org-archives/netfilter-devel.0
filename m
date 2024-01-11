Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859DF50264
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNydQ-0000rm-Pf; Thu, 11 Jan 2024 18:14:28 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] evaluate: tproxy: move range error checks after arg evaluation
Date: Thu, 11 Jan 2024 18:14:15 +0100
Message-ID: <20240111171419.15210-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240111171419.15210-1-fw@strlen.de>
References: <20240111171419.15210-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testing for range before evaluation will still crash us later during
netlink linearization, prefixes turn into ranges, symbolic expression
might hide a range/prefix.

So move this after the argument has been evaluated.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                   | 12 ++++++------
 tests/shell/testcases/bogons/nft-f/tproxy_ranges |  8 ++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/tproxy_ranges

diff --git a/src/evaluate.c b/src/evaluate.c
index d18d65428d51..ff42d97d32e0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4154,22 +4154,22 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 		return err;
 
 	if (stmt->tproxy.addr != NULL) {
-		if (stmt->tproxy.addr->etype == EXPR_RANGE)
-			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
-
 		err = stmt_evaluate_addr(ctx, stmt, &stmt->tproxy.family,
 					 &stmt->tproxy.addr);
-
 		if (err < 0)
 			return err;
+
+		if (stmt->tproxy.addr->etype == EXPR_RANGE)
+			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
 	}
 
 	if (stmt->tproxy.port != NULL) {
-		if (stmt->tproxy.port->etype == EXPR_RANGE)
-			return stmt_error(ctx, stmt, "Port ranges are not supported for tproxy.");
 		err = nat_evaluate_transport(ctx, stmt, &stmt->tproxy.port);
 		if (err < 0)
 			return err;
+
+		if (stmt->tproxy.port->etype == EXPR_RANGE)
+			return stmt_error(ctx, stmt, "Port ranges are not supported for tproxy.");
 	}
 
 	return 0;
diff --git a/tests/shell/testcases/bogons/nft-f/tproxy_ranges b/tests/shell/testcases/bogons/nft-f/tproxy_ranges
new file mode 100644
index 000000000000..1230860e3dfe
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tproxy_ranges
@@ -0,0 +1,8 @@
+define range = 42-80
+
+table t {
+	chain c {
+		tcp dport 42 tproxy to 192.168.0.1:$range
+		tcp dport 42 tproxy to 192.168.0.0/16
+	}
+}
-- 
2.41.0

