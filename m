Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FDA38B131
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338155; cv=none; b=BrbejVjqHLzvU1lvmK/0C+h9dCXZwL8zotsSer2nN8ba57D4bv+akKfxJ+oZpN9RKftcwFYjK3HpYzHSab+4Gw4hSOHPcQVMywH4uIq0wqAwhcCnRIYoG0+XeMNzvbdG+L5ahf57NpeDxPQsBTvsF8GPIFKYN1dOXa8kOxkdF4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338155; c=relaxed/simple;
	bh=x8bZifU574GNn4vOFRNq5xmMcpNPVqtuE0ezyi19iJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bAsDSthZhcLHlqzuusWUpItRiWg267fIQpoJLaH0qVPxQ0s0hnz3AWYeiJp7xN2GG8AbZTK2I6PHKdqOlhD7QKVgF91Ktk1Vx9MMqVJKHEIRLPFz5Q8uGC0/SDnjtHSTv4u8osnykUQghMQPGeByAU1JJ4YVmcmtohuVeRyHyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0AD5F60345; Thu, 12 Mar 2026 18:55:46 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_conntrack_h323: remove unreliable debug code in decode_octstr
Date: Thu, 12 Mar 2026 18:55:39 +0100
Message-ID: <20260312175542.27060-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debug code (not enabled in any build) reads up to 6 octets of
the inpt buffer, but does so without bound checks.  Zap this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 62aa22a07876..50a4ef54e301 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -21,7 +21,6 @@
 
 #if H323_TRACE
 #define TAB_SIZE 4
-#define IFTHEN(cond, act) if(cond){act;}
 #ifdef __KERNEL__
 #define PRINT printk
 #else
@@ -29,7 +28,6 @@
 #endif
 #define FNAME(name) name,
 #else
-#define IFTHEN(cond, act)
 #define PRINT(fmt, args...)
 #define FNAME(name)
 #endif
@@ -443,11 +441,6 @@ static int decode_octstr(struct bitstr *bs, const struct field_t *f,
 			BYTE_ALIGN(bs);
 			if (base && (f->attr & DECODE)) {
 				/* The IP Address */
-				IFTHEN(f->lb == 4,
-				       PRINT(" = %d.%d.%d.%d:%d",
-					     bs->cur[0], bs->cur[1],
-					     bs->cur[2], bs->cur[3],
-					     bs->cur[4] * 256 + bs->cur[5]));
 				*((unsigned int *)(base + f->offset)) =
 				    bs->cur - bs->buf;
 			}
-- 
2.52.0

