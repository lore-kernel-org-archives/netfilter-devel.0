Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FDD3845DC
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790944914; cv=none; b=kww7PhMR1OVpgJ5Q1A/JwE7F5tmbuS/PG93L5zJdXfU0RcmbB+OCvOEJz1S7F+6w6cf9lzM+D3/xhFvJJfsY9URIrFe/PWGEPjkwr6Y+qEX9Dq4IZiJQS0piTs4eze2kdXOVMhy1vxKEYFdIfrigpv+h+fycKsvjedwXvAsFtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790944914; c=relaxed/simple;
	bh=kjisgeNED9CDW5vVy1K0pOBpTQBxrzLKvWy0Iqzym8E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ohQR/uanYlgXVdntnG4Eui0D7Fg8HWFZRGFuqFqSnTRUgl0r7OrH3jbvFE17dzASZHlR9+DrX0WnsjnayhNs/jKTMgOZXLR3iCfDU+MSYizI7ICJb2Lv5b1UrWENWcPIikQ/+X9sqxOHTWo0204zzqEUvMl5/rmq4MCT3gRYwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 19CB260D1B; Fri, 02 Oct 2026 14:41:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: collapse both dev log blocks
Date: Fri,  2 Oct 2026 14:41:32 +0200
Message-ID: <20261002124132.13387-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Looked like this:

 if (indev && skb->dev &&
   skb_mac_header_was_set(skb) &&
   skb_mac_header_len(skb) != 0) {
...
 }

 if (indev && skb_mac_header_was_set(skb)) {
...
 }

LLM (sashiko) claims there is a NULL deref in the second block, because
it dereferences skb->dev without checking skb->dev != NULL.

Don't know if `indev && !skb->dev` is even possible:
NF_HOOK() invocation normally passes skb->dev as the indev argument.

Instead of cargo-culting additional skb->dev check, lets just merge
both blocks into one. This gives 2nd block the tighter guards and
results in a small behavioral change:

When `skb_mac_header_was_set` is true but `skb_mac_header_len == 0`
HWADDR was not emitted, but HWTYPE/HWLEN was.  But given 2nd block also
emits NFULA_HWHEADER based off skb->dev->hard_header_len, that change
is probably desireable.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index dddbaf6860cc..3df2998b8cc0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -600,9 +600,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			if (nla_put(inst->skb, NFULA_HWADDR, sizeof(phw), &phw))
 				goto nla_put_failure;
 		}
-	}
 
-	if (indev && skb_mac_header_was_set(skb)) {
 		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
 		    nla_put_be16(inst->skb, NFULA_HWLEN,
 				 htons(skb->dev->hard_header_len)))
-- 
2.55.0

