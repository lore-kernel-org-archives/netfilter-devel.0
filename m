Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018843451D4
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626809; cv=none; b=dkgYNz2l1EGfvT0tO7l1IXT4ocBaJVt+8sxCGGHsTwusQLJuHr5ejcT9kI7+wV6dVhlx72rYx4VjZI6ytdopgvKyB+AYPvsO9BxPPPOcEmxXjBXLCqTEnWwSCOVQKv+KkBIK2r+G7iXyBBYMntl4DLgxu6tFNkaEXBOv2SeAcQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626809; c=relaxed/simple;
	bh=cYbtqbpgLHMGG9Lx4hDi7A+GPRWnbDeWtkG7fkqQAmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUI8SpkgbBjvRuZe5WYxgnZjWc2VW1NY4qn0uubINjJGh1998oIBNU/pfdbQ5rDswATvg6Z4ENA/n5bE4QOufFmg916yXbyFrSPqNXLZRfyXJIXPdfz4/MUR/8DkruBGiy26uveJ4IOX6czuba6/9J+8B8EfVI5UkQrdFePcy30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DF99260958; Thu, 16 Oct 2025 17:00:05 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] evaluate: tunnel: don't assume src is set
Date: Thu, 16 Oct 2025 16:59:33 +0200
Message-ID: <20251016145955.7785-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251016145955.7785-1-fw@strlen.de>
References: <20251016145955.7785-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon crashes, after fix:

empty_geneve_definition_crash:2:9-16: Error: Could not process rule: Invalid argument

Since this feature is undocumented (hint, hint) I don't know
if there are cases where ip daddr can be elided.

If not, a followup patch should reject empty dst upfront
so users get a more verbose error message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                           | 9 +++++----
 .../testcases/bogons/nft-f/empty_geneve_definition_crash | 4 ++++
 2 files changed, 9 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index 0c7d90f8f43b..ac482c83cce2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5865,11 +5865,12 @@ static int tunnel_evaluate(struct eval_ctx *ctx, struct obj *obj)
 				 obj->tunnel.dst->dtype->size);
 		if (expr_evaluate(ctx, &obj->tunnel.dst) < 0)
 			return -1;
-	}
 
-	if (obj->tunnel.src->dtype != obj->tunnel.dst->dtype)
-		return __stmt_binary_error(ctx, &obj->location, NULL,
-					  "specify either ip or ip6 for address");
+		if (obj->tunnel.src &&
+		    obj->tunnel.src->dtype != obj->tunnel.dst->dtype)
+			return __stmt_binary_error(ctx, &obj->location, NULL,
+						  "specify either ip or ip6 for address");
+	}
 
 	return 0;
 }
diff --git a/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash b/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
new file mode 100644
index 000000000000..d1bc76c56bd5
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/empty_geneve_definition_crash
@@ -0,0 +1,4 @@
+table netdev x {
+	tunnel geneve-t {
+	}
+}
-- 
2.51.0

