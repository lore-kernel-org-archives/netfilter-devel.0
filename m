Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79904CE01
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNxR1-0000Pj-Pb; Thu, 11 Jan 2024 16:57:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: error out when expression has no datatype
Date: Thu, 11 Jan 2024 16:57:28 +0100
Message-ID: <20240111155731.10962-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 add rule ip6 f i rt2 addr . ip6 daddr  { dead:: . dead:: }

... will cause a segmentation fault, we assume expr->dtype is always
set.

rt2 support is incomplete, the template is uninitialised.

This could be fixed up, but rt2 (a subset of the deperecated type 0),
like all other routing headers, lacks correct dependency tracking.

Currently such routing headers are always assumed to be segment routing
headers, we would need to add dependency on 'Routing Type' field in the
routing header, similar to icmp type/code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index fd137e7b1001..fc43643c061f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1629,6 +1629,11 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 					  "cannot use %s in concatenation",
 					  expr_name(i));
 
+		if (!i->dtype)
+			return expr_error(ctx->msgs, i,
+					  "cannot use %s in concatenation, lacks datatype",
+					 expr_name(i));
+
 		flags &= i->flags;
 
 		if (!key && i->dtype->type == TYPE_INTEGER) {
-- 
2.41.0

