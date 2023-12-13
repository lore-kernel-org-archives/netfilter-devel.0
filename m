Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73417D0
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 09:07:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDShI-0001YB-4f; Wed, 13 Dec 2023 18:07:00 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] intervals: BUG on prefix expressions without value
Date: Wed, 13 Dec 2023 18:06:43 +0100
Message-ID: <20231213170650.13451-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231213170650.13451-1-fw@strlen.de>
References: <20231213170650.13451-1-fw@strlen.de>
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
index 85de0199c373..6849b221df2c 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -26,6 +26,9 @@ static void setelem_expr_to_range(struct expr *expr)
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

