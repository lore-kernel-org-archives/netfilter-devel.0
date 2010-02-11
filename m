From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 01/10] netfilter: ebtables: abort if next_offset is too small
Date: Thu, 11 Feb 2010 15:12:31 +0100
Message-ID: <1265897559-10610-2-git-send-email-fw@strlen.de>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53714 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab0BKOMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:12:38 -0500
In-Reply-To: <1265897559-10610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

next_offset must be > 0, otherwise this loops forever.
The offset also contains the size of the ebt_entry structure
itself, so anything smaller is invalid.

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 net/bridge/netfilter/ebtables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 208f4e3..6d6ba1c 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -442,6 +442,8 @@ static int ebt_verify_pointers(struct ebt_replace *repl,
 				break;
 			if (left < e->next_offset)
 				break;
+			if (e->next_offset < sizeof(struct ebt_entry))
+				return -EINVAL;
 			offset += e->next_offset;
 		}
 	}
-- 
1.6.3.3

