Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B121994
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2023 04:37:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rBa6r-0007Ex-LL; Fri, 08 Dec 2023 13:37:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: fix memleak in meta set error handling
Date: Fri,  8 Dec 2023 13:37:27 +0100
Message-ID: <20231208123730.7081-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We must release the expression here, found via afl++ and
-fsanitize-address build.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                           | 1 +
 .../shell/testcases/bogons/nft-f/memleak_on_meta_set_errpath | 5 +++++
 2 files changed, 6 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/memleak_on_meta_set_errpath

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3e0f08b22c44..91c4d263dc73 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5338,6 +5338,7 @@ meta_stmt		:	META	meta_key	SET	stmt_expr	close_scope_meta
 				free_const($2);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
+					expr_free($4);
 					YYERROR;
 				}
 
diff --git a/tests/shell/testcases/bogons/nft-f/memleak_on_meta_set_errpath b/tests/shell/testcases/bogons/nft-f/memleak_on_meta_set_errpath
new file mode 100644
index 000000000000..917e8bf83f6a
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/memleak_on_meta_set_errpath
@@ -0,0 +1,5 @@
+table filter {
+ chain y {
+  meta seccark set ct secmark
+ }
+}
-- 
2.41.0

