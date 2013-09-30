From: Eric Leblond <eric@regit.org>
Subject: [libmnl PATCH] debug: don't colorize output on non tty
Date: Mon, 30 Sep 2013 23:38:26 +0200
Message-ID: <1380577106-13006-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:34098 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3I3Vis (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:38:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When output is not a tty (pipe or redirect to a file), the color
display is causing the output to be unreadable:
  02 00 00 00  |        |  extra header  |
 |ESC[1;31m00008ESC[0m|ESC[1;32m--ESC[0m|ESC[1;34m00001ESC[0m|   |len |flags| type|
This patch tests if the output is a terminal and only add color in
this case. It also displays space instead of char 0 if a letter is
not existing.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/nlmsg.c | 69 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index fdb7af8..07f19ba 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -281,28 +281,45 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 			fprintf(fd, "|  extra header  |\n");
 		/* this seems like an attribute header. */
 		} else if (rem == 0 && (attr->nla_type & NLA_TYPE_MASK) != 0) {
-			fprintf(fd, "|%c[%d;%dm"
-				    "%.5u"
-				    "%c[%dm"
-				    "|"
-				    "%c[%d;%dm"
-				    "%c%c"
-				    "%c[%dm"
-				    "|"
-				    "%c[%d;%dm"
-				    "%.5u"
-				    "%c[%dm|\t",
-				27, 1, 31,
-				attr->nla_len,
-				27, 0,
-				27, 1, 32,
-				attr->nla_type & NLA_F_NESTED ? 'N' : '-',
-				attr->nla_type &
-					NLA_F_NET_BYTEORDER ? 'B' : '-',
-				27, 0,
-				27, 1, 34,
-				attr->nla_type & NLA_TYPE_MASK,
-				27, 0);
+			if (isatty(fileno(fd))) {
+				fprintf(fd, "|%c[%d;%dm"
+					    "%.5u"
+					    "%c[%dm"
+					    "|"
+					    "%c[%d;%dm"
+					    "%c%c"
+					    "%c[%dm"
+					    "|"
+					    "%c[%d;%dm"
+					    "%.5u"
+					    "%c[%dm|\t",
+					27, 1, 31,
+					attr->nla_len,
+					27, 0,
+					27, 1, 32,
+					attr->nla_type &
+						NLA_F_NESTED ? 'N' : '-',
+					attr->nla_type &
+						NLA_F_NET_BYTEORDER ? 'B' : '-',
+					27, 0,
+					27, 1, 34,
+					attr->nla_type & NLA_TYPE_MASK,
+					27, 0);
+			} else {
+				fprintf(fd, "|"
+					    "%.5u"
+					    "|"
+					    "%c%c"
+					    "|"
+					    "%.5u"
+					    "|\t",
+					attr->nla_len,
+					attr->nla_type &
+						NLA_F_NESTED ? 'N' : '-',
+					attr->nla_type &
+						NLA_F_NET_BYTEORDER ? 'B' : '-',
+					attr->nla_type & NLA_TYPE_MASK);
+			}
 			fprintf(fd, "|len |flags| type|\n");
 
 			if (!(attr->nla_type & NLA_F_NESTED)) {
@@ -317,10 +334,10 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 				0xff & b[i+2],	0xff & b[i+3]);
 			fprintf(fd, "|      data      |");
 			fprintf(fd, "\t %c %c %c %c\n",
-				isalnum(b[i]) ? b[i] : 0,
-				isalnum(b[i+1]) ? b[i+1] : 0,
-				isalnum(b[i+2]) ? b[i+2] : 0,
-				isalnum(b[i+3]) ? b[i+3] : 0);
+				isalnum(b[i]) ? b[i] : 32,
+				isalnum(b[i+1]) ? b[i+1] : 32,
+				isalnum(b[i+2]) ? b[i+2] : 32,
+				isalnum(b[i+3]) ? b[i+3] : 32);
 		}
 	}
 	fprintf(fd, "----------------\t------------------\n");
-- 
1.8.4.rc3

