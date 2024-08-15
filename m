Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491BA1AC898
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723724178; cv=none; b=A0XXA60Vkt2nnI1S+04yty5tSIoS/nVl0MRwwteawORmoMNCaVG1g20rG52hNe5vw5DTppnM5fATn+DK8n1HgR2MAb+VH2u3VQ4Z2B6UIyhm8Cenmue7rpT0+KeN2PS7g7ZpXrr/RvL56lWMWowgo/D1XgmmhW0Wmii0htAQAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723724178; c=relaxed/simple;
	bh=b8kGwWcrzUKypcz1XTN30qJP9QeI6gvzyr3rbb1VRVw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=d98g+ScwIDDsyexRHm32T6Ri35sF5RAG2/gdcIxYA0/RKhEh0J+a93YmvSN7Q0b+28gH1fp8kXLmGfiqPJkzEhV7X1Z3JYKpVtO0dk7kxCk/xIgSQIxnuNOlfuET26EP3/SUqt80JU6I/jPNSUJFYKUdUZT0eSydhYzwswW46iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: allow 0 burst in limit rate byte mode
Date: Thu, 15 Aug 2024 14:16:11 +0200
Message-Id: <20240815121611.1281572-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unbreak restoring elements in set with rate limit that fail with:

> /dev/stdin:3618:61-61: Error: limit burst must be > 0
>                  elements = { 1.2.3.4 limit rate over 1000 kbytes/second timeout 1s,

no need for burst != 0 for limit rate byte mode.

Add tests/shell too.

Fixes: 702eff5b5b74 ("src: allow burst 0 for byte ratelimit and use it as default")
Fixes: 285baccfea46 ("src: disallow burst 0 in ratelimits")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                              |  5 -----
 .../shell/testcases/sets/dumps/elem_limit_0.nft |  7 +++++++
 tests/shell/testcases/sets/elem_limit_0         | 17 +++++++++++++++++
 3 files changed, 24 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/sets/dumps/elem_limit_0.nft
 create mode 100755 tests/shell/testcases/sets/elem_limit_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 10105f153aa0..f3368dd3e922 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4609,11 +4609,6 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 			}
 			|       LIMIT   RATE    limit_mode      limit_rate_bytes  limit_burst_bytes	close_scope_limit
 			{
-				if ($5 == 0) {
-					erec_queue(error(&@6, "limit burst must be > 0"),
-						   state->msgs);
-					YYERROR;
-				}
 				$$ = limit_stmt_alloc(&@$);
 				$$->limit.rate  = $4.rate;
 				$$->limit.unit  = $4.unit;
diff --git a/tests/shell/testcases/sets/dumps/elem_limit_0.nft b/tests/shell/testcases/sets/dumps/elem_limit_0.nft
new file mode 100644
index 000000000000..ca5b2b54e579
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/elem_limit_0.nft
@@ -0,0 +1,7 @@
+table netdev filter {
+	set test123 {
+		typeof ip saddr
+		limit rate over 1 mbytes/second
+		elements = { 1.2.3.4 limit rate over 1 mbytes/second }
+	}
+}
diff --git a/tests/shell/testcases/sets/elem_limit_0 b/tests/shell/testcases/sets/elem_limit_0
new file mode 100755
index 000000000000..b57f9274bcd0
--- /dev/null
+++ b/tests/shell/testcases/sets/elem_limit_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+## requires EXPR
+
+set -e
+
+RULESET="table netdev filter {
+	set test123 {
+		typeof ip saddr
+		limit rate over 1024 kbytes/second
+		elements = { 1.2.3.4 limit rate over 1024 kbytes/second }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+
+(echo "flush ruleset netdev"; $NFT --stateless list ruleset netdev) | $NFT -f -
-- 
2.30.2

