Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DE8FE
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2023 09:22:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rACeT-0001Pj-KZ; Mon, 04 Dec 2023 18:22:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: guard against NULL basetype
Date: Mon,  4 Dec 2023 18:22:24 +0100
Message-ID: <20231204172228.5255-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

i->dtype->basetype can be NULL.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                               | 2 +-
 tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index b6428018c398..b6670254b9fd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1610,7 +1610,7 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 			return expr_error(ctx->msgs, i,
 					  "List member must be a constant "
 					  "value");
-		if (i->dtype->basetype->type != TYPE_BITMASK)
+		if (datatype_basetype(i->dtype)->type != TYPE_BITMASK)
 			return expr_error(ctx->msgs, i,
 					  "Basetype of type %s is not bitmask",
 					  i->dtype->desc);
diff --git a/tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash b/tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash
new file mode 100644
index 000000000000..16d3e41fcce9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash
@@ -0,0 +1 @@
+cPoR et ip dscp << 2>0 ,xl rt  ipsec   c0tt in  tabl rt  ipsec   cl
-- 
2.41.0

