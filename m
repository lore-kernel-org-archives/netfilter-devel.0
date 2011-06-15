From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] conntrack: -U: skip sending conntrack update message if conntrack is unchanged
Date: Wed, 15 Jun 2011 14:13:40 +0200
Message-ID: <1308140020-13487-3-git-send-email-fw@strlen.de>
References: <1308140020-13487-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36351 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1FOML5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:11:57 -0400
In-Reply-To: <1308140020-13487-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This speeds up operation when a lot of conntracks exist, but only
a few of them have to be altered.

This change is user-visible because the exit message
("%d flow entries have been updated") will now print the number of entries
that have been altered instead of the total number of conntracks seen.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index fb133f1..3e1cb11 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1258,6 +1258,12 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	nfct_copy(tmp, obj, NFCT_CP_META);
 	copy_mark(tmp, ct, &tmpl.mark);
 
+	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
+	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
+		nfct_destroy(tmp);
+		return NFCT_CB_CONTINUE;
+	}
+
 	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
 	if (res < 0) {
 		nfct_destroy(tmp);
-- 
1.7.3.4

