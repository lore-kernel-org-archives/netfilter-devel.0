From: pablo@netfilter.org
Subject: [PATCH 4/5] netfilter: Fix several warnings in compat_mtw_from_user().
Date: Fri, 27 May 2011 13:44:56 +0200
Message-ID: <1306496697-12196-5-git-send-email-pablo@netfilter.org>
References: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1E0LpU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 07:45:20 -0400
In-Reply-To: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: David Miller <davem@davemloft.net>

Kill set but not used 'entry_offset'.

Add a default case to the switch statement so the compiler
can see that we always initialize off and size_kern before
using them.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1a92b36..2b5ca1a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1883,14 +1883,13 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 	struct xt_target *wt;
 	void *dst = NULL;
 	int off, pad = 0;
-	unsigned int size_kern, entry_offset, match_size = mwt->match_size;
+	unsigned int size_kern, match_size = mwt->match_size;
 
 	strlcpy(name, mwt->u.name, sizeof(name));
 
 	if (state->buf_kern_start)
 		dst = state->buf_kern_start + state->buf_kern_offset;
 
-	entry_offset = (unsigned char *) mwt - base;
 	switch (compat_mwt) {
 	case EBT_COMPAT_MATCH:
 		match = try_then_request_module(xt_find_match(NFPROTO_BRIDGE,
@@ -1933,6 +1932,9 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 		size_kern = wt->targetsize;
 		module_put(wt->me);
 		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	state->buf_kern_offset += match_size + off;
-- 
1.7.2.5

