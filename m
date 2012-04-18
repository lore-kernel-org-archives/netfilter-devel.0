From: Florian Westphal <fw@strlen.de>
Subject: [PATCH xt-addons] xt_psd: avoid crash due to curr->next corruption
Date: Wed, 18 Apr 2012 14:13:28 +0200
Message-ID: <1334751208-10387-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45942 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab2DRMLh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:11:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

curr->ports[] is of size SCAN_MAX_COUNT - 1, so under certain
conditions we wrote past end of array, corrupting ->next pointer
of the adjacent host entry.

Reported-and-tested-by: Serge Leschinsky <serge.leschinsky@gmail.com>
---
 extensions/xt_psd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 46b2831..acb5e8e 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -227,7 +227,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 				goto out_match;
 
 			/* Remember the new port */
-			if (curr->count < SCAN_MAX_COUNT) {
+			if (curr->count < ARRAY_SIZE(curr->ports)) {
 				curr->ports[curr->count].number = dest_port;
 				curr->ports[curr->count].proto = proto;
 				curr->ports[curr->count].and_flags = tcp_flags;
-- 
1.7.3.4

