Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DC17741
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2023 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFY3h-00031g-JP; Tue, 19 Dec 2023 12:14:45 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] intervals: BUG on prefix expressions without value
Date: Tue, 19 Dec 2023 12:14:37 +0100
Message-ID: <20231219111440.12564-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its possible to end up with prefix expressions that have
a symbolic expression, e.g.:

table t {
        set s {
                type inet_service
                flags interval
                elements = { 0-1024, 8080-8082, 10000-40000 }
                elements = { 172.16.0.0/16 }
        }

        set s {
                type inet_service
                flags interval
                elements = { 0-1024, 8080-8082, 10000-40000 }
        }
}

Without this change, nft will crash.  We end up in setelem_expr_to_range()
with prefix "/16" for the symbolic expression "172.16.0.0".

We than pass invalid mpz_t pointer into libgmp.

This isn't the right fix (see next patch), but instead of blindly assuming
that the attached expression has a gmp value die with at least some info.

Its possible there are more ways than one to feed such
"symbol-with-prefix" down into the interval code, so also add this
assertion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/intervals.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/intervals.c b/src/intervals.c
index e535fc34afda..5a88a8eb20bd 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -28,6 +28,9 @@ static void setelem_expr_to_range(struct expr *expr)
 	case EXPR_RANGE:
 		break;
 	case EXPR_PREFIX:
+		if (expr->key->prefix->etype != EXPR_VALUE)
+			BUG("Prefix for unexpected type %d", expr->key->prefix->etype);
+
 		mpz_init(rop);
 		mpz_bitmask(rop, expr->key->len - expr->key->prefix_len);
 		if (expr_basetype(expr)->type == TYPE_STRING)
-- 
2.41.0

