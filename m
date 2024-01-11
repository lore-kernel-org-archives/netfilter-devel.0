Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636C658206
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 21:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] evaluate: release mpz type in expr_evaluate_list() error path
Date: Thu, 11 Jan 2024 22:55:20 +0100
Message-Id: <20240111215520.1415-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240111215520.1415-1-pablo@netfilter.org>
References: <20240111215520.1415-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detected when running:

 # nft -f tests/shell/testcases/bogons/nft-f/no_integer_basetype_crash
 ==383222==ERROR: LeakSanitizer: detected memory leaks

 Direct leak of 8 byte(s) in 1 object(s) allocated from:
    #0 0x7fe7b54a9e8f in __interceptor_malloc ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:145
    #1 0x7fe7b538b9a9 in __gmp_default_allocate (/lib/x86_64-linux-gnu/libgmp.so.10+0xc9a9)

Fixes: 3671c4897003 ("evaluate: guard against NULL basetype")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I picked a recent Fixes: tag, this error path memleak is rather old.

 src/evaluate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ad68d47252e0..d29921cdef2a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1668,16 +1668,22 @@ static int expr_evaluate_list(struct eval_ctx *ctx, struct expr **expr)
 
 	mpz_init_set_ui(val, 0);
 	list_for_each_entry_safe(i, next, &list->expressions, list) {
-		if (list_member_evaluate(ctx, &i) < 0)
+		if (list_member_evaluate(ctx, &i) < 0) {
+			mpz_clear(val);
 			return -1;
-		if (i->etype != EXPR_VALUE)
+		}
+		if (i->etype != EXPR_VALUE) {
+			mpz_clear(val);
 			return expr_error(ctx->msgs, i,
 					  "List member must be a constant "
 					  "value");
-		if (datatype_basetype(i->dtype)->type != TYPE_BITMASK)
+		}
+		if (datatype_basetype(i->dtype)->type != TYPE_BITMASK) {
+			mpz_clear(val);
 			return expr_error(ctx->msgs, i,
 					  "Basetype of type %s is not bitmask",
 					  i->dtype->desc);
+		}
 		mpz_ior(val, val, i->value);
 	}
 
-- 
2.30.2

