From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3] conntrack: do not exit when update returns an error
Date: Thu,  5 Sep 2013 11:27:50 +0200
Message-ID: <1378373270-6914-3-git-send-email-fw@strlen.de>
References: <1378373270-6914-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59813 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763411Ab3IEJ2C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:02 -0400
In-Reply-To: <1378373270-6914-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we fail to update an entry, just try to continue with the next one
instead of exiting.

Can happen f.e. when using "conntrack -U --add-label bla", but the
conntrack entry in the kernel does not have the label extension set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 404ecc9..1e45ca8 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1492,12 +1492,10 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	}
 
 	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
-	if (res < 0) {
-		nfct_destroy(tmp);
-		exit_error(OTHER_PROBLEM,
-			   "Operation failed: %s",
+	if (res < 0)
+		fprintf(stderr,
+			   "Operation failed: %s\n",
 			   err2str(errno, CT_UPDATE));
-	}
 	nfct_callback_register(ith, NFCT_T_ALL, print_cb, NULL);
 
 	res = nfct_query(ith, NFCT_Q_GET, tmp);
-- 
1.7.8.6

