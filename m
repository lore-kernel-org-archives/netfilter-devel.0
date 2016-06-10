From: Thomas Woerner <twoerner@redhat.com>
Subject: [PATCH] ip6tables: Warn about use of DROP in nat table
Date: Fri, 10 Jun 2016 14:57:58 +0200
Message-ID: <1465563478-7602-1-git-send-email-twoerner@redhat.com>
Cc: Thomas Woerner <twoerner@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbcFJM6C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 08:58:02 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 7C088C05B1FE
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2016 12:58:01 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Clone of 1eada72b with 9bb76094 and e0390bee on top.

Signed-off-by: Thomas Woerner <twoerner@redhat.com>
---
:100644 100644 2731209... c48ddf9... M	iptables/ip6tables.c
 iptables/ip6tables.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 2731209..c48ddf9 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1720,6 +1720,13 @@ int do_command6(int argc, char *argv[], char **table,
 		cs.invert = FALSE;
 	}
 
+	if (strcmp(*table, "nat") == 0 &&
+	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
+	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
+		xtables_error(PARAMETER_PROBLEM,
+			"\nThe \"nat\" table is not intended for filtering, "
+		        "the use of DROP is therefore inhibited.\n\n");
+
 	for (matchp = cs.matches; matchp; matchp = matchp->next)
 		xtables_option_mfcall(matchp->match);
 	if (cs.target != NULL)
-- 
2.5.5

