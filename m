Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68C71703
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Nov 2023 12:37:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1r8nmc-0008WV-44; Thu, 30 Nov 2023 21:37:14 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: reject sets with no key
Date: Thu, 30 Nov 2023 21:37:02 +0100
Message-ID: <20231130203706.28300-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft --check -f tests/shell/testcases/bogons/nft-f/set_without_key
Segmentation fault (core dumped)

Fixes: 56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                     | 3 +++
 tests/shell/testcases/bogons/nft-f/map_without_key | 5 +++++
 tests/shell/testcases/bogons/nft-f/set_without_key | 5 +++++
 3 files changed, 13 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/map_without_key
 create mode 100644 tests/shell/testcases/bogons/nft-f/set_without_key

diff --git a/src/evaluate.c b/src/evaluate.c
index 2ead03471102..048880e54daf 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4621,6 +4621,9 @@ static int elems_evaluate(struct eval_ctx *ctx, struct set *set)
 {
 	ctx->set = set;
 	if (set->init != NULL) {
+		if (set->key == NULL)
+			return set_error(ctx, set, "set definition does not specify key");
+
 		__expr_set_context(&ctx->ectx, set->key->dtype,
 				   set->key->byteorder, set->key->len, 0);
 		if (expr_evaluate(ctx, &set->init) < 0)
diff --git a/tests/shell/testcases/bogons/nft-f/map_without_key b/tests/shell/testcases/bogons/nft-f/map_without_key
new file mode 100644
index 000000000000..78f16b23f3a9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/map_without_key
@@ -0,0 +1,5 @@
+table t {
+	map m {
+		elements = { 0x00000023 : 0x00001337 }
+	}
+}
diff --git a/tests/shell/testcases/bogons/nft-f/set_without_key b/tests/shell/testcases/bogons/nft-f/set_without_key
new file mode 100644
index 000000000000..f194afbf98e5
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/set_without_key
@@ -0,0 +1,5 @@
+table ip t {
+	set s {
+		elements = { 0x00000023-0x00000142, 0x00001337 }
+	}
+}
-- 
2.41.0

