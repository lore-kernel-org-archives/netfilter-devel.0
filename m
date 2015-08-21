From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools] nfct: Update syntax to specify command before subsystem
Date: Fri, 21 Aug 2015 21:19:44 +0200
Message-ID: <1440184784-4392-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55834 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbbHUTNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 15:13:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch gets the nfct syntax in sync with nft so it looks like this:

	nfct <add|delete|...> object ...

instead of:

	nfct object <add|delete|...> ...

This patch retains backward compatibility so you can still use the old syntax.
The manpage and tests have been also updated to promote the adoption of this
syntax in the little existing users as we can only use this to configure the
cttimeout and cthelper infrastructures.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I'm updating this before the next release of the conntrack-tools bundle. This
tool is in early stage and it currently supports very little extensions, but I
think this could be enhanced later on to start up a replacement for the
existing `conntrack' utility.

@Arturo: This is overlapping with your patch for nfct.8 manpage, so I'll keep
that back, thanks anyway for you patch.

 include/nfct.h                |    4 +-
 nfct.8                        |   36 ++++++++-------
 src/nfct-extensions/helper.c  |   46 +++++++++----------
 src/nfct-extensions/timeout.c |   53 ++++++++++------------
 src/nfct.c                    |   97 +++++++++++++++++++++++++++++++++--------
 tests/nfct/test-live.sh       |   14 +++---
 tests/nfct/timeout/00tcp      |   16 +++----
 tests/nfct/timeout/01udp      |   16 +++----
 tests/nfct/timeout/02generic  |   16 +++----
 tests/nfct/timeout/03udplite  |   16 +++----
 tests/nfct/timeout/04icmp     |   16 +++----
 tests/nfct/timeout/05icmpv6   |   16 +++----
 tests/nfct/timeout/06sctp     |   16 +++----
 tests/nfct/timeout/07dccp     |   16 +++----
 tests/nfct/timeout/08gre      |   16 +++----
 15 files changed, 225 insertions(+), 169 deletions(-)

diff --git a/include/nfct.h b/include/nfct.h
index dc103c6..bfffdd6 100644
--- a/include/nfct.h
+++ b/include/nfct.h
@@ -9,6 +9,7 @@ enum {
 	NFCT_SUBSYS_HELPER,
 	NFCT_SUBSYS_VERSION,
 	NFCT_SUBSYS_HELP,
+	NFCT_SUBSYS_MAX
 };
 
 enum {
@@ -21,6 +22,7 @@ enum {
 	NFCT_CMD_DISABLE,
 	NFCT_CMD_DEFAULT_SET,
 	NFCT_CMD_DEFAULT_GET,
+	NFCT_CMD_MAX,
 };
 
 #define __init __attribute__((constructor))
@@ -30,7 +32,7 @@ void nfct_perror(const char *msg);
 struct nfct_extension {
 	struct list_head	head;
 	int			type;
-	int (*parse_params)(struct mnl_socket *nl, int argc, char *argv[]);
+	int (*parse_params)(struct mnl_socket *nl, int argc, char *argv[], int cmd);
 };
 
 void nfct_extension_register(struct nfct_extension *ext);
diff --git a/nfct.8 b/nfct.8
index 6f5190a..863fe12 100644
--- a/nfct.8
+++ b/nfct.8
@@ -3,12 +3,26 @@
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Feb 2012)
 
 .SH NAME
-nfct \- command line tool to interact with the connection tracking system
+nfct \- command line tool to configure with the connection tracking system
 .SH SYNOPSIS
-.BR "nfct subsystem command [parameters]"
+.BR "nfct command subsystem [parameters]"
 .SH DESCRIPTION
 .B nfct
-is the command line tool that allows you Netfilter's manipulate Connection Tracking System.
+is the command line tool that allows to configure the Connection Tracking
+System.
+.SH COMMANDS
+.TP
+.BI "list "
+List the existing objects.
+.TP
+.BI "add "
+Add new object.
+.TP
+.BI "delete "
+Delete an object.
+.TP
+.BI "get "
+Get an existing object.
 .SH SUBSYS
 By the time this manpage has been written, the supported subsystem are
 .B timeout
@@ -16,24 +30,14 @@ By the time this manpage has been written, the supported subsystem are
 .BI "timeout "
 The timeout subsystem allows you to define fine-grain timeout policies.
 .TP
+.BI "helper "
+The helper subsystem allows you to configure userspace helpers.
+.TP
 .BI "version "
 Displays the version information.
 .TP
 .BI "help "
 Displays the help message.
-.SH TIMEOUT SUBSYSTEM
-.TP
-.BI "list "
-List the existing timeout policies.
-.TP
-.BI "add "
-Add new timeout policy.
-.TP
-.BI "delete "
-Delete timeout policy.
-.TP
-.BI "get "
-Get existing timeout policy.
 .SH EXAMPLE
 .TP
 .B nfct timeout add test-tcp inet tcp established 100 close 10 close_wait 10
diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index bfb153f..dfc55e7 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -45,36 +45,31 @@ static int nfct_cmd_helper_flush(struct mnl_socket *nl, int argc, char *argv[]);
 static int nfct_cmd_helper_disable(struct mnl_socket *nl, int argc, char *argv[]);
 
 static int
-nfct_cmd_helper_parse_params(struct mnl_socket *nl, int argc, char *argv[])
+nfct_helper_parse_params(struct mnl_socket *nl, int argc, char *argv[], int cmd)
 {
-	int cmd = NFCT_CMD_NONE, ret = 0;
+	int ret;
 
 	if (argc < 3) {
-		fprintf(stderr, "nfct v%s: Missing command\n"
-				"%s helper list|add|delete|get|flush "
-				"[parameters...]\n", VERSION, argv[0]);
-		exit(EXIT_FAILURE);
+		nfct_cmd_helper_usage(argv);
+		return -1;
 	}
-	if (strncmp(argv[2], "list", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_LIST;
-	else if (strncmp(argv[2], "add", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_ADD;
-	else if (strncmp(argv[2], "delete", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_DELETE;
-	else if (strncmp(argv[2], "get", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_GET;
-	else if (strncmp(argv[2], "flush", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_FLUSH;
-	else if (strncmp(argv[2], "disable", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_DISABLE;
-	else {
+
+	switch (cmd) {
+	case NFCT_CMD_LIST:
+	case NFCT_CMD_ADD:
+	case NFCT_CMD_DELETE:
+	case NFCT_CMD_GET:
+	case NFCT_CMD_FLUSH:
+	case NFCT_CMD_DISABLE:
+		break;
+	default:
 		fprintf(stderr, "nfct v%s: Unknown command: %s\n",
 			VERSION, argv[2]);
 		nfct_cmd_helper_usage(argv);
 		exit(EXIT_FAILURE);
 	}
 
-	switch(cmd) {
+	switch (cmd) {
 	case NFCT_CMD_LIST:
 		ret = nfct_cmd_helper_list(nl, argc, argv);
 		break;
@@ -93,6 +88,9 @@ nfct_cmd_helper_parse_params(struct mnl_socket *nl, int argc, char *argv[])
 	case NFCT_CMD_DISABLE:
 		ret = nfct_cmd_helper_disable(nl, argc, argv);
 		break;
+	default:
+		nfct_cmd_helper_usage(argv);
+		return -1;
 	}
 
 	return ret;
@@ -160,8 +158,7 @@ static int nfct_cmd_helper_add(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 6) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct helper add name "
-			    "family protocol");
+			    "syntax: nfct add helper name family protocol");
 		return -1;
 	}
 
@@ -411,8 +408,7 @@ nfct_cmd_helper_disable(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 6) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct helper add name "
-			    "family protocol");
+			    "syntax: nfct add helper name family protocol");
 		return -1;
 	}
 
@@ -469,7 +465,7 @@ nfct_cmd_helper_disable(struct mnl_socket *nl, int argc, char *argv[])
 
 static struct nfct_extension helper = {
 	.type		= NFCT_SUBSYS_HELPER,
-	.parse_params	= nfct_cmd_helper_parse_params,
+	.parse_params	= nfct_helper_parse_params,
 };
 
 static void __init helper_init(void)
diff --git a/src/nfct-extensions/timeout.c b/src/nfct-extensions/timeout.c
index c9aa386..1cb04a1 100644
--- a/src/nfct-extensions/timeout.c
+++ b/src/nfct-extensions/timeout.c
@@ -32,7 +32,7 @@ static void
 nfct_cmd_timeout_usage(char *argv[])
 {
 	fprintf(stderr, "nfct v%s: Missing command\n"
-			"%s timeout <list|add|delete|get|flush|set> "
+			"%s <list|add|delete|get|flush|set> timeout "
 			"[<parameters>, ...]\n", VERSION, argv[0]);
 }
 
@@ -45,35 +45,30 @@ static int nfct_cmd_timeout_default_set(struct mnl_socket *nl, int argc, char *a
 static int nfct_cmd_timeout_default_get(struct mnl_socket *nl, int argc, char *argv[]);
 
 static int
-nfct_cmd_timeout_parse_params(struct mnl_socket *nl, int argc, char *argv[])
+nfct_timeout_parse_params(struct mnl_socket *nl, int argc, char *argv[], int cmd)
 {
-	int cmd = NFCT_CMD_NONE, ret;
+	int ret;
 
 	if (argc < 3) {
 		nfct_cmd_timeout_usage(argv);
 		return -1;
 	}
-	if (strncmp(argv[2], "list", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_LIST;
-	else if (strncmp(argv[2], "add", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_ADD;
-	else if (strncmp(argv[2], "delete", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_DELETE;
-	else if (strncmp(argv[2], "get", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_GET;
-	else if (strncmp(argv[2], "flush", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_FLUSH;
-	else if (strncmp(argv[2], "default-set", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_DEFAULT_SET;
-	else if (strncmp(argv[2], "default-get", strlen(argv[2])) == 0)
-		cmd = NFCT_CMD_DEFAULT_GET;
-	else {
-		fprintf(stderr, "nfct v%s: Unknown command: %s\n",
-			VERSION, argv[2]);
+
+	switch (cmd) {
+	case NFCT_CMD_LIST:
+	case NFCT_CMD_ADD:
+	case NFCT_CMD_DELETE:
+	case NFCT_CMD_GET:
+	case NFCT_CMD_FLUSH:
+	case NFCT_CMD_DEFAULT_SET:
+	case NFCT_CMD_DEFAULT_GET:
+		break;
+	default:
 		nfct_cmd_timeout_usage(argv);
 		return -1;
 	}
-	switch(cmd) {
+
+	switch (cmd) {
 	case NFCT_CMD_LIST:
 		ret = nfct_cmd_timeout_list(nl, argc, argv);
 		break;
@@ -95,6 +90,9 @@ nfct_cmd_timeout_parse_params(struct mnl_socket *nl, int argc, char *argv[])
 	case NFCT_CMD_DEFAULT_GET:
 		ret = nfct_cmd_timeout_default_get(nl, argc, argv);
 		break;
+	default:
+		nfct_cmd_timeout_usage(argv);
+		return -1;
 	}
 
 	return ret;
@@ -270,9 +268,7 @@ int nfct_cmd_timeout_add(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 6) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct timeout add name "
-			    "family protocol state1 "
-			    "timeout1 state2 timeout2...");
+			    "syntax: nfct add timeout name family protocol state1 timeout1 ...");
 		return -1;
 	}
 
@@ -415,9 +411,7 @@ nfct_cmd_timeout_default_set(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 6) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct timeout default-set "
-			    "family protocol state1 "
-			    "timeout1 state2 timeout2...");
+			    "syntax: nfct default-set timeout family protocol state1 timeout1...");
 		return -1;
 	}
 
@@ -454,8 +448,7 @@ nfct_cmd_timeout_default_get(struct mnl_socket *nl, int argc, char *argv[])
 
 	if (argc < 5) {
 		nfct_perror("missing parameters\n"
-			    "syntax: nfct timeout default-get "
-			    "family protocol");
+			    "syntax: nfct default-get timeout family protocol");
 		return -1;
 	}
 
@@ -497,7 +490,7 @@ nfct_cmd_timeout_default_get(struct mnl_socket *nl, int argc, char *argv[])
 
 static struct nfct_extension timeout = {
 	.type		= NFCT_SUBSYS_TIMEOUT,
-	.parse_params	= nfct_cmd_timeout_parse_params,
+	.parse_params	= nfct_timeout_parse_params,
 };
 
 static void __init timeout_init(void)
diff --git a/src/nfct.c b/src/nfct.c
index 533d75d..3331e5b 100644
--- a/src/nfct.c
+++ b/src/nfct.c
@@ -31,7 +31,7 @@ static int nfct_cmd_help(int argc, char *argv[]);
 
 static void usage(char *argv[])
 {
-	fprintf(stderr, "Usage: %s subsystem command [parameters]...\n",
+	fprintf(stderr, "Usage: %s command subsystem [parameters]...\n",
 		argv[0]);
 }
 
@@ -63,32 +63,93 @@ static struct nfct_extension *nfct_extension_lookup(int type)
 	return NULL;
 }
 
+static const char *nfct_cmd_array[NFCT_CMD_MAX] = {
+	[NFCT_CMD_LIST]		= "list",
+	[NFCT_CMD_ADD]		= "add",
+	[NFCT_CMD_DELETE]	= "delete",
+	[NFCT_CMD_GET]		= "get",
+	[NFCT_CMD_FLUSH]	= "flush",
+	[NFCT_CMD_DISABLE]	= "disable",
+	[NFCT_CMD_DEFAULT_SET]	= "default-set",
+	[NFCT_CMD_DEFAULT_GET]	= "default-get",
+};
+
+static int nfct_cmd_parse(const char *cmdstr)
+{
+	int i;
+
+	for (i = 1; i < NFCT_CMD_MAX; i++) {
+		if (strncmp(nfct_cmd_array[i], cmdstr, strlen(cmdstr)) == 0)
+			return i;
+	}
+	return -1;
+}
+
+static int nfct_cmd_error(char *argv[])
+{
+	fprintf(stderr, "nfct v%s: Unknown command: %s\n", VERSION, argv[1]);
+	usage(argv);
+
+	return EXIT_FAILURE;
+}
+
+static const char *nfct_subsys_array[NFCT_SUBSYS_MAX] = {
+	[NFCT_SUBSYS_TIMEOUT]	= "timeout",
+	[NFCT_SUBSYS_HELPER]	= "helper",
+	[NFCT_SUBSYS_VERSION]	= "version",
+	[NFCT_SUBSYS_HELP]	= "help",
+};
+
+static int nfct_subsys_parse(const char *cmdstr)
+{
+	int i;
+
+	for (i = 1; i < NFCT_SUBSYS_MAX; i++) {
+		if (strncmp(nfct_subsys_array[i], cmdstr, strlen(cmdstr)) == 0)
+			return i;
+	}
+	return -1;
+}
+
+static int nfct_subsys_error(char *argv[])
+{
+	fprintf(stderr, "nfct v%s: Unknown subsystem: %s\n", VERSION, argv[1]);
+	usage(argv);
+
+	return EXIT_FAILURE;
+}
+
 int main(int argc, char *argv[])
 {
-	int subsys = NFCT_SUBSYS_NONE, ret = 0;
+	int subsys, cmd, ret = 0;
 	struct nfct_extension *ext;
 	struct mnl_socket *nl;
 
-	if (argc < 2) {
+	if (argc < 3) {
 		usage(argv);
 		exit(EXIT_FAILURE);
 	}
-	if (strncmp(argv[1], "timeout", strlen(argv[1])) == 0) {
-		subsys = NFCT_SUBSYS_TIMEOUT;
-	} else if (strncmp(argv[1], "helper", strlen(argv[1])) == 0) {
-		subsys = NFCT_SUBSYS_HELPER;
-	} else if (strncmp(argv[1], "version", strlen(argv[1])) == 0)
-		subsys = NFCT_SUBSYS_VERSION;
-	else if (strncmp(argv[1], "help", strlen(argv[1])) == 0)
-		subsys = NFCT_SUBSYS_HELP;
-	else {
-		fprintf(stderr, "nfct v%s: Unknown subsystem: %s\n",
-			VERSION, argv[1]);
-		usage(argv);
-		exit(EXIT_FAILURE);
+
+	cmd = nfct_cmd_parse(argv[1]);
+	if (cmd < 0) {
+		/* Workaround not to break backward compatibility and to get
+		 * the syntax in sync with nft. Old nfct versions allow to
+		 * specify the subsystem before the command.
+		 */
+		subsys = nfct_subsys_parse(argv[1]);
+		if (subsys < 0)
+			return nfct_subsys_error(argv);
+
+		cmd = nfct_cmd_parse(argv[2]);
+		if (cmd < 0)
+			return nfct_cmd_error(argv);
+	} else {
+		subsys = nfct_subsys_parse(argv[2]);
+		if (subsys < 0)
+			return nfct_subsys_error(argv);
 	}
 
-	switch(subsys) {
+	switch (subsys) {
 	case NFCT_SUBSYS_VERSION:
 		ret = nfct_cmd_version(argc, argv);
 		break;
@@ -109,7 +170,7 @@ int main(int argc, char *argv[])
 			return -1;
 		}
 
-		ret = ext->parse_params(nl, argc, argv);
+		ret = ext->parse_params(nl, argc, argv, cmd);
 		mnl_socket_close(nl);
 		break;
 	}
diff --git a/tests/nfct/test-live.sh b/tests/nfct/test-live.sh
index c338e63..2257087 100644
--- a/tests/nfct/test-live.sh
+++ b/tests/nfct/test-live.sh
@@ -6,7 +6,7 @@
 WAIT_BETWEEN_TESTS=10
 
 # flush cttimeout table
-nfct timeout flush
+nfct flush timeout
 
 # flush the conntrack table
 conntrack -F
@@ -19,7 +19,7 @@ echo "---- test no. 1 ----"
 
 conntrack -E -p 13 &
 
-nfct timeout add test-generic inet generic timeout 100
+nfct add timeout test-generic inet generic timeout 100
 iptables -I OUTPUT -t raw -p all -j CT --timeout test-generic
 hping3 -c 1 -V -I eth0 -0 8.8.8.8 -H 13
 
@@ -30,7 +30,7 @@ echo "---- end test no. 1 ----"
 sleep $WAIT_BETWEEN_TESTS
 
 iptables -D OUTPUT -t raw -p all -j CT --timeout test-generic
-nfct timeout del test-generic
+nfct del timeout test-generic
 
 #
 # No.2: test TCP timeout policy
@@ -40,14 +40,14 @@ echo "---- test no. 2 ----"
 
 conntrack -E -p tcp &
 
-nfct timeout add test-tcp inet tcp syn_sent 100
+nfct add timeout test-tcp inet tcp syn_sent 100
 iptables -I OUTPUT -t raw -p tcp -j CT --timeout test-tcp
 hping3 -V -S -p 80 -s 5050 8.8.8.8 -c 1
 
 sleep $WAIT_BETWEEN_TESTS
 
 iptables -D OUTPUT -t raw -p tcp -j CT --timeout test-tcp
-nfct timeout del test-tcp
+nfct del timeout test-tcp
 
 killall -15 conntrack
 
@@ -61,12 +61,12 @@ echo "---- test no. 3 ----"
 
 conntrack -E -p icmp &
 
-nfct timeout add test-icmp inet icmp timeout 50
+nfct add timeout test-icmp inet icmp timeout 50
 iptables -I OUTPUT -t raw -p icmp -j CT --timeout test-icmp
 hping3 -1 8.8.8.8 -c 2
 
 iptables -D OUTPUT -t raw -p icmp -j CT --timeout test-icmp
-nfct timeout del test-icmp
+nfct del timeout test-icmp
 
 killall -15 conntrack
 
diff --git a/tests/nfct/timeout/00tcp b/tests/nfct/timeout/00tcp
index c9d7d24..ab2e6fc 100644
--- a/tests/nfct/timeout/00tcp
+++ b/tests/nfct/timeout/00tcp
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet tcp established 100 ; OK
+nfct add timeout test inet tcp established 100 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet tcp syn_sent 1 syn_recv 2 established 3 fin_wait 4 close_wait 5 last_ack 6 time_wait 7 close 8 syn_sent2 9 retrans 10 unacknowledged 11 ; OK
+nfct add timeout test inet tcp syn_sent 1 syn_recv 2 established 3 fin_wait 4 close_wait 5 last_ack 6 time_wait 7 close 8 syn_sent2 9 retrans 10 unacknowledged 11 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/01udp b/tests/nfct/timeout/01udp
index 952526c..f8097d6 100644
--- a/tests/nfct/timeout/01udp
+++ b/tests/nfct/timeout/01udp
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet udp unreplied 10 ; OK
+nfct add timeout test inet udp unreplied 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet udp unreplied 1 replied 2 ; OK
+nfct add timeout test inet udp unreplied 1 replied 2 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/02generic b/tests/nfct/timeout/02generic
index b6ca699..ffba138 100644
--- a/tests/nfct/timeout/02generic
+++ b/tests/nfct/timeout/02generic
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet generic timeout 10 ; OK
+nfct add timeout test inet generic timeout 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet generic timeout 1 ; OK
+nfct add timeout test inet generic timeout 1 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/03udplite b/tests/nfct/timeout/03udplite
index 69dda15..8ed3459 100644
--- a/tests/nfct/timeout/03udplite
+++ b/tests/nfct/timeout/03udplite
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet udplite unreplied 10 ; OK
+nfct add timeout test inet udplite unreplied 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet udplite unreplied 1 replied 2 ; OK
+nfct add timeout test inet udplite unreplied 1 replied 2 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/04icmp b/tests/nfct/timeout/04icmp
index 606e8b9..edb1c99 100644
--- a/tests/nfct/timeout/04icmp
+++ b/tests/nfct/timeout/04icmp
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet icmp timeout 10 ; OK
+nfct add timeout test inet icmp timeout 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet icmp timeout 1 ; OK
+nfct add timeout test inet icmp timeout 1 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/05icmpv6 b/tests/nfct/timeout/05icmpv6
index 16541f5..40ccc49 100644
--- a/tests/nfct/timeout/05icmpv6
+++ b/tests/nfct/timeout/05icmpv6
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet6 icmpv6 timeout 10 ; OK
+nfct add timeout test inet6 icmpv6 timeout 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet6 icmpv6 timeout 1 ; OK
+nfct add timeout test inet6 icmpv6 timeout 1 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/06sctp b/tests/nfct/timeout/06sctp
index f475215..62b44c6 100644
--- a/tests/nfct/timeout/06sctp
+++ b/tests/nfct/timeout/06sctp
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet sctp established 100 ; OK
+nfct add timeout test inet sctp established 100 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet sctp closed 1 cookie_wait 2 cookie_echoed 3 established 4 shutdown_sent 5 shutdown_recd 6 shutdown_ack_sent 7 ; OK
+nfct add timeout test inet sctp closed 1 cookie_wait 2 cookie_echoed 3 established 4 shutdown_sent 5 shutdown_recd 6 shutdown_ack_sent 7 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/07dccp b/tests/nfct/timeout/07dccp
index 1bd4fa5..1d88585 100644
--- a/tests/nfct/timeout/07dccp
+++ b/tests/nfct/timeout/07dccp
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet dccp request 100 ; OK
+nfct add timeout test inet dccp request 100 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet dccp request 1 respond 2 partopen 3 open 4 closereq 5 closing 6 timewait 7 ; OK
+nfct add timeout test inet dccp request 1 respond 2 partopen 3 open 4 closereq 5 closing 6 timewait 7 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
diff --git a/tests/nfct/timeout/08gre b/tests/nfct/timeout/08gre
index 7ef4bdb..709b943 100644
--- a/tests/nfct/timeout/08gre
+++ b/tests/nfct/timeout/08gre
@@ -1,16 +1,16 @@
 # add policy object `test'
-nfct timeout add test inet gre unreplied 10 ; OK
+nfct add timeout test inet gre unreplied 10 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
 # get unexistent policy object `dummy'
-nfct timeout get test ; BAD
+nfct get timeout test ; BAD
 # delete policy object `test', however, it does not exists anymore
-nfct timeout delete test ; BAD
+nfct delete timeout test ; BAD
 # add policy object `test'
-nfct timeout add test inet gre unreplied 1 replied 2 ; OK
+nfct add timeout test inet gre unreplied 1 replied 2 ; OK
 # get policy object `test'
-nfct timeout get test ; OK
+nfct get timeout test ; OK
 # delete policy object `test'
-nfct timeout delete test ; OK
+nfct delete timeout test ; OK
-- 
1.7.10.4

