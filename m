Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F7BB6
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 13:05:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rAG8Q-0002rQ-Vl; Mon, 04 Dec 2023 22:05:46 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: reject attempt to update a set
Date: Mon,  4 Dec 2023 22:05:40 +0100
Message-ID: <20231204210542.16212-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will crash as set->data is NULL. Check that SET_REF is pointing to a map:

Error: candidates_ipv4 is not a map
tcp dport 10003 ip saddr . tcp dport @candidates_ipv4 add @candidates_ipv4 { ip saddr . 10 :0004 timeout 1s }
                                     ~~~~~~~~~~~~~~~~

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                        |  4 ++++
 tests/shell/testcases/bogons/nft-f/add_to_a_set_crash | 11 +++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/add_to_a_set_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index 131b0a0eaa66..f05cac416eb8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4344,6 +4344,10 @@ static int stmt_evaluate_map(struct eval_ctx *ctx, struct stmt *stmt)
 		return expr_error(ctx->msgs, stmt->map.set,
 				  "Expression does not refer to a set");
 
+	if (!set_is_map(stmt->map.set->set->flags))
+		return expr_error(ctx->msgs, stmt->map.set,
+				  "%s is not a map", stmt->map.set->set->handle.set.name);
+
 	if (stmt_evaluate_key(ctx, stmt,
 			      stmt->map.set->set->key->dtype,
 			      stmt->map.set->set->key->len,
diff --git a/tests/shell/testcases/bogons/nft-f/add_to_a_set_crash b/tests/shell/testcases/bogons/nft-f/add_to_a_set_crash
new file mode 100644
index 000000000000..80a01b4539fb
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/add_to_a_set_crash
@@ -0,0 +1,11 @@
+table t {
+        set candidates_ipv4 {
+                type ipv4_addr . inet_service
+                size 65535
+                flags dynamic,timeout
+        }
+
+        chain input {
+                tcp dport 10003 ip saddr . tcp dport @candidates_ipv4 add @candidates_ipv4 { ip saddr . 10 :0004 timeout 1s }
+        }
+}
-- 
2.41.0

