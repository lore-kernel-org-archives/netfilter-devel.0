From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH conntrack-tools] conntrack: add zone direction support
Date: Tue, 25 Aug 2015 15:33:51 +0200
Message-ID: <9d0d25c2351442d8564063a51a7dc13fd1439e23.1440509200.git.daniel@iogearbox.net>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:34250 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbbHYNdy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2015 09:33:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for zone directions.

Since all options have the orig/reply as a prefix, I named it --orig-zone
and --reply-zone to stay consistent with the rest of the cmdline options.

As for the option chars, there was no unallocated reasonable combination,
thus only long options are officially exposed in the help, similarly as in
other cases.

Test suite results, after patch: OK: 79 BAD: 0

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 conntrack.8                      | 10 +++++-
 include/conntrack.h              |  2 +-
 src/conntrack.c                  | 67 ++++++++++++++++++++++++++--------------
 tests/conntrack/testsuite/04zone | 18 ++++++++++-
 4 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index abc26c5..a981a76 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -1,4 +1,4 @@
-.TH CONNTRACK 8 "Sep 25, 2014" "" ""
+.TH CONNTRACK 8 "Aug 24, 2015" "" ""
 
 .\" Man page written by Harald Welte <laforge@netfilter.org (Jun 2005)
 .\" Maintained by Pablo Neira Ayuso <pablo@netfilter.org (May 2007)
@@ -176,6 +176,14 @@ Filter any NAT connections.
 .BI "-w, --zone "
 Filter by conntrack zone. See iptables CT target for more information.
 .TP
+.BI "--orig-zone "
+Filter by conntrack zone in original direction.
+See iptables CT target for more information.
+.TP
+.BI "--reply-zone "
+Filter by conntrack zone in reply direction.
+See iptables CT target for more information.
+.TP
 .BI "--tuple-src " IP_ADDRESS
 Specify the tuple source address of an expectation.
 .TP
diff --git a/include/conntrack.h b/include/conntrack.h
index c2a0c8f..6659a64 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -10,7 +10,7 @@
 #include <netinet/in.h>
 
 #define NUMBER_OF_CMD   19
-#define NUMBER_OF_OPT   27
+#define NUMBER_OF_OPT   29
 
 struct ctproto_handler {
 	struct list_head 	head;
diff --git a/src/conntrack.c b/src/conntrack.c
index 00b09b6..3ae4527 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -262,17 +262,24 @@ enum ct_options {
 	CT_OPT_LABEL		= (1 << CT_OPT_LABEL_BIT),
 
 	CT_OPT_ADD_LABEL_BIT	= 25,
-	CT_OPT_ADD_LABEL		= (1 << CT_OPT_ADD_LABEL_BIT),
+	CT_OPT_ADD_LABEL	= (1 << CT_OPT_ADD_LABEL_BIT),
 
 	CT_OPT_DEL_LABEL_BIT	= 26,
-	CT_OPT_DEL_LABEL		= (1 << CT_OPT_DEL_LABEL_BIT),
+	CT_OPT_DEL_LABEL	= (1 << CT_OPT_DEL_LABEL_BIT),
+
+	CT_OPT_ORIG_ZONE_BIT	= 27,
+	CT_OPT_ORIG_ZONE	= (1 << CT_OPT_ORIG_ZONE_BIT),
+
+	CT_OPT_REPL_ZONE_BIT	= 28,
+	CT_OPT_REPL_ZONE	= (1 << CT_OPT_REPL_ZONE_BIT),
 };
 /* If you add a new option, you have to update NUMBER_OF_OPT in conntrack.h */
 
 /* Update this mask to allow to filter based on new options. */
 #define CT_COMPARISON (CT_OPT_PROTO | CT_OPT_ORIG | CT_OPT_REPL | \
 		       CT_OPT_MARK | CT_OPT_SECMARK |  CT_OPT_STATUS | \
-		       CT_OPT_ID | CT_OPT_ZONE | CT_OPT_LABEL)
+		       CT_OPT_ID | CT_OPT_ZONE | CT_OPT_LABEL | \
+		       CT_OPT_ORIG_ZONE | CT_OPT_REPL_ZONE)
 
 static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_ORIG_SRC_BIT] 	= "src",
@@ -302,6 +309,8 @@ static const char *optflags[NUMBER_OF_OPT] = {
 	[CT_OPT_LABEL_BIT]	= "label",
 	[CT_OPT_ADD_LABEL_BIT]	= "label-add",
 	[CT_OPT_DEL_LABEL_BIT]	= "label-del",
+	[CT_OPT_ORIG_ZONE_BIT]	= "orig-zone",
+	[CT_OPT_REPL_ZONE_BIT]	= "reply-zone",
 };
 
 static struct option original_opts[] = {
@@ -345,12 +354,14 @@ static struct option original_opts[] = {
 	{"label", 1, 0, 'l'},
 	{"label-add", 1, 0, '<'},
 	{"label-del", 2, 0, '>'},
+	{"orig-zone", 1, 0, '('},
+	{"reply-zone", 1, 0, ')'},
 	{0, 0, 0, 0}
 };
 
 static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
-				"g::c:b:C::Sj::w:l:<:>::";
+				"g::c:b:C::Sj::w:l:<:>::(:):";
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -365,26 +376,26 @@ static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > */
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2,0,0},
-/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,2,0,0},
-/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2,0,0},
-/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0},
-/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0},
-/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) */
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2},
+/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
+/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
+/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
+/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2,0,0,2,2},
+/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
+/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0},
+/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const int cmd2type[][2] = {
@@ -419,6 +430,8 @@ static const int opt2type[] = {
 	['l']	= CT_OPT_LABEL,
 	['<']	= CT_OPT_ADD_LABEL,
 	['>']	= CT_OPT_DEL_LABEL,
+	['(']	= CT_OPT_ORIG_ZONE,
+	[')']	= CT_OPT_REPL_ZONE,
 };
 
 static const int opt2family_attr[][2] = {
@@ -448,6 +461,8 @@ static const int opt2attr[] = {
 	['l']	= ATTR_CONNLABELS,
 	['<']	= ATTR_CONNLABELS,
 	['>']	= ATTR_CONNLABELS,
+	['(']	= ATTR_ORIG_ZONE,
+	[')']	= ATTR_REPL_ZONE,
 };
 
 static char exit_msg[NUMBER_OF_CMD][64] = {
@@ -511,6 +526,8 @@ static const char usage_parameters[] =
 	"  -t, --timeout timeout\t\tSet timeout\n"
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
 	"  -w, --zone value\t\tSet conntrack zone\n"
+	"  --orig-zone value\t\tSet zone for original direction\n"
+	"  --reply-zone value\t\tSet zone for reply direction\n"
 	"  -b, --buffer-size\t\tNetlink socket buffer size\n"
 	;
 
@@ -2117,6 +2134,8 @@ int main(int argc, char *argv[])
 			break;
 		}
 		case 'w':
+		case '(':
+		case ')':
 			options |= opt2type[c];
 			nfct_set_attr_u16(tmpl.ct,
 					  opt2attr[c],
diff --git a/tests/conntrack/testsuite/04zone b/tests/conntrack/testsuite/04zone
index 4ff3d34..dc8b691 100644
--- a/tests/conntrack/testsuite/04zone
+++ b/tests/conntrack/testsuite/04zone
@@ -1,4 +1,4 @@
-# create dummy
+# 1) zone, create dummy
 -I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --zone 1; OK
 # display dummy
 -L --zone 1; OK
@@ -6,3 +6,19 @@
 -L --zone 0; OK
 # delete dummy
 -D --zone 1; OK
+# 2) orig-zone, create dummy
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --orig-zone 2; OK
+# display dummy
+-L --orig-zone 2; OK
+# display dummy
+-L --orig-zone 0; OK
+# delete dummy
+-D --orig-zone 2; OK
+# 3) reply-zone, create dummy
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 --reply-zone 3; OK
+# display dummy
+-L --reply-zone 3; OK
+# display dummy
+-L --reply-zone 0; OK
+# delete dummy
+-D --reply-zone 3; OK
-- 
1.9.3

