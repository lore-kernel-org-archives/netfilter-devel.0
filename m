From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools] conntrack: send mark filter to kernel iff set
Date: Fri, 23 Dec 2016 15:53:47 +0100
Message-ID: <1482504827-14047-1-git-send-email-pablo@netfilter.org>
Cc: joseph.j.conley@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbcLWOx6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:53:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28CC83066A2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:53:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 178201B3078
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:53:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF5641B3098
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:53:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not set a mark filter to ctnetlink if the user doesn't explicitly
specify this.

Fixes: aa925010951e ("conntrack: allow to filter by mark from kernel-space")
Reported-by: Joseph Conley <joseph.j.conley@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index ff030fe54e10..682afa68784e 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -79,6 +79,7 @@ static struct {
 
 	/* Allow to filter by mark from kernel-space. */
 	struct nfct_filter_dump_mark filter_mark_kernel;
+	bool filter_mark_kernel_set;
 
 	/* Allows filtering by ctlabels */
 	struct nfct_bitmask *label;
@@ -2374,6 +2375,7 @@ int main(int argc, char *argv[])
 			parse_u32_mask(optarg, &tmpl.mark);
 			tmpl.filter_mark_kernel.val = tmpl.mark.value;
 			tmpl.filter_mark_kernel.mask = tmpl.mark.mask;
+			tmpl.filter_mark_kernel_set = true;
 			break;
 		case 'l':
 		case '<':
@@ -2523,11 +2525,14 @@ int main(int argc, char *argv[])
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
 
-		nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_MARK,
-					  &tmpl.filter_mark_kernel);
-		nfct_filter_dump_set_attr_u8(filter_dump,
-					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+		if (tmpl.filter_mark_kernel_set) {
+			nfct_filter_dump_set_attr(filter_dump,
+						  NFCT_FILTER_DUMP_MARK,
+						  &tmpl.filter_mark_kernel);
+			nfct_filter_dump_set_attr_u8(filter_dump,
+						     NFCT_FILTER_DUMP_L3NUM,
+						     family);
+		}
 
 		if (options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
@@ -2626,11 +2631,14 @@ int main(int argc, char *argv[])
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
 
-		nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_MARK,
-					  &tmpl.filter_mark_kernel);
-		nfct_filter_dump_set_attr_u8(filter_dump,
-					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+		if (tmpl.filter_mark_kernel_set) {
+			nfct_filter_dump_set_attr(filter_dump,
+						  NFCT_FILTER_DUMP_MARK,
+						  &tmpl.filter_mark_kernel);
+			nfct_filter_dump_set_attr_u8(filter_dump,
+						     NFCT_FILTER_DUMP_L3NUM,
+						     family);
+		}
 
 		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
 
-- 
2.1.4

