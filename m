Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266E6A7
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Dec 2023 04:08:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rAUDw-0007yB-QY; Tue, 05 Dec 2023 13:08:24 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix double free on dtype release
Date: Tue,  5 Dec 2023 13:08:17 +0100
Message-ID: <20231205120820.20346-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We release ->dtype twice, will either segfault or assert
on dtype->refcount != 0 check in datatype_free().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                              | 2 +-
 .../bogons/nft-f/double-free-on-binop-dtype_assert          | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/double-free-on-binop-dtype_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 16ad6473db1a..58cc811aca9a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1171,7 +1171,7 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 	base = prefix->prefix;
 	assert(expr_is_constant(base));
 
-	prefix->dtype	  = base->dtype;
+	prefix->dtype	  = datatype_get(base->dtype);
 	prefix->byteorder = base->byteorder;
 	prefix->len	  = base->len;
 	prefix->flags	 |= EXPR_F_CONSTANT;
diff --git a/tests/shell/testcases/bogons/nft-f/double-free-on-binop-dtype_assert b/tests/shell/testcases/bogons/nft-f/double-free-on-binop-dtype_assert
new file mode 100644
index 000000000000..b7a9a1cc7e8b
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/double-free-on-binop-dtype_assert
@@ -0,0 +1,6 @@
+table inet t {
+	chain c {
+		udp length . @th,160,118 vmap { 47-63 . 0xe3731353631303331313037353532/3 : accept }
+		jump noexist # only here so this fails to load after patch.
+	}
+}
-- 
2.41.0

