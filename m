Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD7D4D58E
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 19:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft 2/4] evaluate: do not fetch next expression on runaway number of concatenation components
Date: Wed, 10 Jan 2024 20:42:15 +0100
Message-Id: <20240110194217.484064-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240110194217.484064-1-pablo@netfilter.org>
References: <20240110194217.484064-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If this is the last expression, then the runaway flag is set on and
evaluation bails in the next iteration, do not fetch next list element
which refers to the list head.

I found this by code inspection, I could not trigger any crash with this
one.

Fixes: ae1d54d1343f ("evaluate: do not crash on runaway number of concatenation components")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 6405d55647fa..8ef1b5e39bdc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1621,8 +1621,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 		if (key && expressions) {
 			if (list_is_last(&key->list, expressions))
 				runaway = true;
-
-			key = list_next_entry(key, list);
+			else
+				key = list_next_entry(key, list);
 		}
 
 		ctx->inner_desc = NULL;
-- 
2.30.2

