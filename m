From: David Miller <davem@davemloft.net>
Subject: [PATCH] netfilter: Fix several warnings in compat_mtw_from_user().
Date: Thu, 19 May 2011 18:14:39 -0400 (EDT)
Message-ID: <20110519.181439.385337593682366302.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:59300 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934947Ab1ESWOm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2011 18:14:42 -0400
Received: from localhost (nat-pool-rdu.redhat.com [66.187.233.202])
	(authenticated bits=0)
	by shards.monkeyblade.net (8.14.4/8.14.4) with ESMTP id p4JMEecu026354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 19 May 2011 15:14:41 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Kill set but not used 'entry_offset'.

Add a default case to the switch statement so the compiler
can see that we always initialize off and size_kern before
using them.

Signed-off-by: David S. Miller <davem@davemloft.net>

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
