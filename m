Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D21521325A
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 20:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515845; cv=none; b=I2yEG6eRQZ87Huhm5bLx0EoJrjrXESywfuIwQiJNROkBCkIYTlcX3V2C/n7pEghPlMqIilX0thAc6Vqvsernudzg7wAGiZOd+hu5JwHqVaPAgnbpJq7tjVFYB5Qv/J89rlWrrvRJtQsEhMXymMf8yvHEMwoqtaokBkoAlcqv5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515845; c=relaxed/simple;
	bh=xdyDe1dyPqzbFpyj3sxWDbT0IchMYy+NJ7QrqtZi2h4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gXjiDgpPdKGwn/9B7YoDYQ0wUvOi9TElzXrDy9F/rbSf7271ftV8z3VN/tScnu3U0LXm1C2X4ddt5dvhYNhzQQWdO7+8gzgWHNoo4ky4GdtoTZVFfcecB08pCT4yZF0ZaA8n8vvis17pg3FZruhaHA7dHkLwwwry/SG+a4/cbGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tn1g9-00088K-Ax; Tue, 25 Feb 2025 21:37:21 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] payload: remove double-store
Date: Tue, 25 Feb 2025 21:33:30 +0100
Message-ID: <20250225203334.28465-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This assignment was duplicated.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index f8b192b5f2fa..eadc92efc0d7 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -353,7 +353,6 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 		expr->payload.tmpl = &proto_th.templates[thf];
 		expr->payload.desc = &proto_th;
 		expr->dtype = &inet_service_type;
-		expr->payload.desc = &proto_th;
 		break;
 	default:
 		break;
-- 
2.45.3

