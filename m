From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 05/17] netfilter: x_tables: assert minimum target size
Date: Fri,  1 Apr 2016 14:17:25 +0200
Message-ID: <1459513057-30652-6-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46466 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135AbcDAMRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:17:36 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The target size includes the size of the xt_entry_target struct.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 1f44bfa..ec1b718 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -568,6 +568,9 @@ int xt_check_entry_offsets(const void *base,
 		return -EINVAL;
 
 	t = (void *)(e + target_offset);
+	if (t->u.target_size < sizeof(*t))
+		return -EINVAL;
+
 	if (target_offset + t->u.target_size > next_offset)
 		return -EINVAL;
 
-- 
2.7.3

