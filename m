Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A818C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jan 2022 11:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353723AbiASLJm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 06:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353333AbiASLJm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 06:09:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059DAC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2022 03:09:42 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nA8qR-0004z4-Tm; Wed, 19 Jan 2022 12:09:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: add --reliable option
Date:   Wed, 19 Jan 2022 12:09:35 +0100
Message-Id: <20220119110935.28543-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To be used with connection tracking events: kernel will retry
delivery of DESTROY event until userspace can receive the message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/conntrack.h |  2 +-
 src/conntrack.c     | 58 +++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/include/conntrack.h b/include/conntrack.h
index 1c1720e998ad..3083ad503b24 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -12,7 +12,7 @@
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 #define NUMBER_OF_CMD   19
-#define NUMBER_OF_OPT   29
+#define NUMBER_OF_OPT   30
 
 struct nf_conntrack;
 
diff --git a/src/conntrack.c b/src/conntrack.c
index fe5574d205a6..55f59bcd581b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -114,6 +114,7 @@ struct ct_cmd {
 	int		options;
 	int		family;
 	int		protonum;
+	bool		reliable_events;
 	size_t		socketbuffersize;
 	struct ct_tmpl	tmpl;
 };
@@ -389,6 +390,7 @@ static struct option original_opts[] = {
 	{"label-del", 2, 0, '>'},
 	{"orig-zone", 1, 0, '('},
 	{"reply-zone", 1, 0, ')'},
+	{"reliable", 0, 0, 'R'},
 	{0, 0, 0, 0}
 };
 
@@ -409,26 +411,26 @@ static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) */
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2},
-/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
-/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
-/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0},
-/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) R*/
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2,0},
+/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2,0},
+/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0,0},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2,0},
+/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0,0},
+/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2,0},
+/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2},
+/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0,0},
+/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0},
+/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const int cmd2type[][2] = {
@@ -2933,6 +2935,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
 	int protonum = 0, family = AF_UNSPEC;
+	bool reliable_events = false;
 	size_t socketbuffersize = 0;
 	unsigned int command = 0;
 	unsigned int options = 0;
@@ -3175,6 +3178,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			socketbuffersize = atol(optarg);
 			options |= CT_OPT_BUFFERSIZE;
 			break;
+		case 'R':
+			reliable_events = true;
+			break;
 		case ':':
 			exit_error(PARAMETER_PROBLEM,
 				   "option `%s' requires an "
@@ -3248,6 +3254,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	ct_cmd->protonum = protonum;
 	ct_cmd->event_mask = event_mask;
 	ct_cmd->socketbuffersize = socketbuffersize;
+	ct_cmd->reliable_events = reliable_events;
 }
 
 static int do_command_ct(const char *progname, struct ct_cmd *cmd)
@@ -3516,6 +3523,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					socketbuffersize);
 		}
 
+		if (cmd->reliable_events) {
+			int on = 1;
+
+			mnl_socket_setsockopt(sock->mnl,
+					     NETLINK_BROADCAST_SEND_ERROR,
+					     &on, sizeof(int));
+			mnl_socket_setsockopt(sock->mnl,
+					     NETLINK_NO_ENOBUFS,
+					     &on, sizeof(int));
+		}
+
 		nfct_filter_init(cmd);
 
 		signal(SIGINT, event_sighandler);
-- 
2.34.1

