From: Florian Westphal <fw@strlen.de>
Subject: [PATCH][conntrack-tools] conntrack: flush stdout for each expectation event, too
Date: Fri, 18 May 2012 13:36:49 +0200
Message-ID: <1337341009-15287-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49177 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697Ab2ERLex (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 May 2012 07:34:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

else, piping "conntrack -E expect" output will be buffered/delayed,
which is not what users expect. Normal conntrack events are already
flushed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b065211..0920bc5 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1380,6 +1380,7 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 
 	nfexp_snprintf(buf,sizeof(buf), exp, type, op_type, op_flags);
 	printf("%s\n", buf);
+	fflush(stdout);
 	counter++;
 
 	return NFCT_CB_CONTINUE;
-- 
1.7.3.4

