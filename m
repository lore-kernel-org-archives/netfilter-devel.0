Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926361632D9
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515867; cv=none; b=K3DhqpTi1RArWj6kYT9kCinF4ncufsW69BB+1L8vmBAyHXieNZ/UR5FnvL+FUn2vnGXInAaODjjCl4ES6RxnC+76DF9AR0qQnhwzS3cZ0q/EmazPiotB4n4bZJNVdQJtMXwnBRS6jT2f3RSOy55s6thptPx7uHVkd1e4VVbwaTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515867; c=relaxed/simple;
	bh=OnjqBvUgEgIFZv9HHvrE3q1QyEe7bCbc6Pm26M7udo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FNNOMI0RSNPnwhvrYufZyIL8IdTqiQEL1LIiv7Mv0BQPeG0YKPeb4NV0rcnMs5Jk88IQwVaQejGy4VIPUL/tFtnY0uFKEQwxXODroqoVrXHdxJPQAOuuULGvDCXFvjYGXWMM/0lMmajQ0p5Q7z5QRuQ6/LePmQxqip5IqOSQuaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tn1gU-00088i-DP; Tue, 25 Feb 2025 21:37:42 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] payload: return early if dependency is not a payload expression
Date: Tue, 25 Feb 2025 21:33:57 +0100
Message-ID: <20250225203400.28709-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 if (dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)

is legal only after checking that ->left points to an
EXPR_PAYLOAD expression. The dependency store can also contain
EXPR_META, in this case we access a bogus part of the union.

The payload_may_dependency_kill_icmp helper can't handle a META
dep either, so return early.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index eadc92efc0d7..866cd9bc2b05 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -893,7 +893,8 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;
 
-	if (dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
+	if (dep->left->etype != EXPR_PAYLOAD ||
+	    dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;
 
 	if (dep->left->payload.desc == &proto_icmp)
-- 
2.45.3

