From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/7] netfilter: ebtables: abort if next_offset is too small
Date: Fri,  5 Feb 2010 02:43:09 +0100
Message-ID: <1265334195-28120-2-git-send-email-fw@strlen.de>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59373 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756708Ab0BEBoK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:10 -0500
In-Reply-To: <1265334195-28120-1-git-send-email-fw@strlen.de>
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
index 12beb58..1939041 100644
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
1.6.4.4

