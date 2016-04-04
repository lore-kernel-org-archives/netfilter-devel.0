From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack: Fix wrong --src, or --dst option shown.
Date: Mon,  4 Apr 2016 11:41:04 +0200
Message-ID: <1459762864-10326-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at03-1.mx.upcmail.net ([62.179.121.151]:29140 "EHLO
	vie01a-dmta-at03-1.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbcDDJlO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2016 05:41:14 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at03.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1an10S-0002ai-Ev
	for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2016 11:41:12 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 If running into PARAMETER_PROBLEM on usage of --mask-src, or --mask-dst
 without using the needed --orig-src, or --orig-dst option,
 the wrong options were offered in the error message.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 src/conntrack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 2367459..d40f23f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2091,14 +2091,14 @@ nfct_filter_init(const int family)
 	if (options & CT_OPT_MASK_SRC) {
 		if (!(options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't use --mask-src without --src");
+			           "Can't use --mask-src without --orig-src");
 		nfct_network_attr_prepare(family, DIR_SRC);
 	}
 
 	if (options & CT_OPT_MASK_DST) {
 		if (!(options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
-			           "Can't use --mask-dst without --dst");
+			           "Can't use --mask-dst without --orig-dst");
 		nfct_network_attr_prepare(family, DIR_DST);
 	}
 }
-- 
1.7.2.5

