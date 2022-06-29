Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E179C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiF2RKD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiF2RKC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:10:02 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877C1A80C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:10:00 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id mf9so33983477ejb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+4tJ73sJesZGYgGlzdyczkoFuCk2M7tZ9C9M619lC/4=;
        b=dSLu5DTR4faPy6r3wqfaU889A24+2Og1vEMEbC3WCp6gAszE/16O7L2oR1VwPCGRbN
         XcFm6NdRdwPV3KmafiU5GdAvPOf3TEi6i6PDtG1njOmiYGF33cerKsHcjIqy9SmXleCH
         vwt5vqzJEXaW2EBKJ6lsck9iaPcKXaE5UY+F9BPFx8jSvPbH8Zpuw7U++0fhjHKbvGEs
         3Wh0qHZBWhS7RQNTvEgSsmIN3d4ROK3hcayiU6y05QIM1dh3dUV9sGjqhK6HOlVNZPuW
         dJjtHw3g8vOpe6LXDfleuMkt5J2ZsH+1is08JvqOdPoxbUsCypZPqN6Qx91iPwQzJlnI
         rEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+4tJ73sJesZGYgGlzdyczkoFuCk2M7tZ9C9M619lC/4=;
        b=2T2hRghUa1+dIm7F9QxZ3TV6er+xTCNj2e/Pv4g8AqjpUNzGn+ZwF0o8bGyyIcV9ej
         8kBJ4VOuUPveQGxFwmkytg9xgx91hYkHB7RveluoM5O5kmheZ9OzEWyu60IiUwKcs58F
         IGmXQjrJIzs/k5kGf/HDXVW2hZ4BrZM14yzzg4UVkrt11/AEnoEyLjHALLnTRZsa+x+r
         InKRhxL3YnQ5dNekYv50ymQ7gDxjawYet0voPFsgGknG9n37QTe/6k9dWAgoFPrWv9FY
         8wINstsQ+78yRlMtwSQLJpYUpHMe5CxVkZiXdTT3NZnOeGJ5MA7hxbqbq2ZDP+crYoyT
         p1SA==
X-Gm-Message-State: AJIora8YedzYk1m4I2iWutNG+0SbzQmMDrWfzyqiDpEJWf57ASZo+qKE
        fdA43LsDlh0ipOuDG6/DZzhGvJHD1gMvig==
X-Google-Smtp-Source: AGRyM1sz+l6lw+ErkYjK96TnNJM9FUz3ihoJuRRbUBuktgw6//cgXfb6UlOtar3BZU5uvolwe+OptQ==
X-Received: by 2002:a17:907:7256:b0:722:e5a8:e3a3 with SMTP id ds22-20020a170907725600b00722e5a8e3a3mr4347798ejc.599.1656522598523;
        Wed, 29 Jun 2022 10:09:58 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([85.214.13.132])
        by smtp.gmail.com with ESMTPSA id s6-20020a1709062ec600b00711d88ae162sm8008829eji.24.2022.06.29.10.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:09:57 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 3/3] conntrack: introduce new -A command
Date:   Wed, 29 Jun 2022 19:09:41 +0200
Message-Id: <20220629170941.46219-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
References: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The -A command works exactly the same way as -I except that it
does not fail if the ct entry already exists.
This command is useful for the batched ct loads to not abort if
some entries being applied exist.

The ct entry dump in the "save" format is now switched to use the
-A command as well for the generated output.
Also tests added to cover the -A command.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 extensions/libct_proto_dccp.c     |  1 +
 extensions/libct_proto_gre.c      |  1 +
 extensions/libct_proto_icmp.c     |  1 +
 extensions/libct_proto_icmpv6.c   |  1 +
 extensions/libct_proto_sctp.c     |  1 +
 extensions/libct_proto_tcp.c      |  1 +
 extensions/libct_proto_udp.c      |  1 +
 extensions/libct_proto_udplite.c  |  1 +
 include/conntrack.h               |  5 +++-
 src/conntrack.c                   | 25 ++++++++++------
 tests/conntrack/testsuite/08stdin | 47 ++++++++++++++++++++++++++++++-
 tests/conntrack/testsuite/10add   | 42 +++++++++++++++++++++++++++
 12 files changed, 117 insertions(+), 10 deletions(-)
 create mode 100644 tests/conntrack/testsuite/10add

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index 6103117..0204929 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -83,6 +83,7 @@ static char dccp_commands_v_options[NUMBER_OF_CMD][DCCP_OPT_MAX] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,1,0,0,1},
 };
 
 static const char *dccp_states[DCCP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index c619db3..2f216b9 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -82,6 +82,7 @@ static char gre_commands_v_options[NUMBER_OF_CMD][GRE_OPT_MAX] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index 304018f..9f67cf4 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -56,6 +56,7 @@ static char icmp_commands_v_options[NUMBER_OF_CMD][ICMP_NUMBER_OF_OPT] =
 	[EXP_GET_BIT]		= {0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0},
+	[CT_ADD_BIT]		= {1,1,2},
 };
 
 static void help(void)
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index 114bcac..216757e 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -59,6 +59,7 @@ static char icmpv6_commands_v_options[NUMBER_OF_CMD][ICMPV6_NUMBER_OF_OPT] =
 	[EXP_GET_BIT]		= {0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0},
+	[CT_ADD_BIT]		= {1,1,2},
 };
 
 static void help(void)
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index 723a2cd..8099b83 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -86,6 +86,7 @@ static char sctp_commands_v_options[NUMBER_OF_CMD][SCTP_OPT_MAX] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,1,0,0,1,1},
 };
 
 static const char *sctp_states[SCTP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 7e4500c..27f5833 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -70,6 +70,7 @@ static char tcp_commands_v_options[NUMBER_OF_CMD][TCP_NUMBER_OF_OPT] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,1,0,0},
 };
 
 static const char *tcp_states[TCP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index fce489d..a78857f 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -78,6 +78,7 @@ static char udp_commands_v_options[NUMBER_OF_CMD][UDP_NUMBER_OF_OPT] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index 8d42d1a..3df3142 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -86,6 +86,7 @@ static char udplite_commands_v_options[NUMBER_OF_CMD][UDP_OPT_MAX] =
 	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
 	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
 	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/include/conntrack.h b/include/conntrack.h
index bc17af0..6dad4a1 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -71,7 +71,10 @@ enum ct_command {
 	EXP_STATS_BIT	= 18,
 	EXP_STATS	= (1 << EXP_STATS_BIT),
 
-	_CT_BIT_MAX	= 19,
+	CT_ADD_BIT	= 19,
+	CT_ADD		= (1 << CT_ADD_BIT),
+
+	_CT_BIT_MAX	= 20,
 };
 
 #define NUMBER_OF_CMD   _CT_BIT_MAX
diff --git a/src/conntrack.c b/src/conntrack.c
index e96e42d..763e4d6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -291,6 +291,7 @@ static const char *optflags[NUMBER_OF_OPT] = {
 static struct option original_opts[] = {
 	{"dump", 2, 0, 'L'},
 	{"create", 2, 0, 'I'},
+	{"add", 2, 0, 'A'},
 	{"delete", 2, 0, 'D'},
 	{"update", 2, 0, 'U'},
 	{"get", 2, 0, 'G'},
@@ -334,7 +335,7 @@ static struct option original_opts[] = {
 	{0, 0, 0, 0}
 };
 
-static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
+static const char *getopt_str = ":L::I::U::D::G::E::F::A::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
 				"g::c:b:C::Sj::w:l:<:>::(:):";
 
@@ -371,6 +372,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 	[EXP_COUNT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 	[CT_STATS_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 	[EXP_STATS_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_ADD_BIT]		= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
 };
 
 static const int cmd2type[][2] = {
@@ -385,6 +387,7 @@ static const int cmd2type[][2] = {
 	['C']	= { CT_COUNT,	EXP_COUNT },
 	['S']	= { CT_STATS,	EXP_STATS },
 	['U']	= { CT_UPDATE,	0 },
+	['A']	= { CT_ADD,	0 },
 };
 
 static const int opt2type[] = {
@@ -488,6 +491,7 @@ static char exit_msg[NUMBER_OF_CMD][64] = {
 	[CT_EVENT_BIT]		= "%d flow events have been shown.\n",
 	[EXP_LIST_BIT]		= "%d expectations have been shown.\n",
 	[EXP_DELETE_BIT]	= "%d expectations have been shown.\n",
+	[CT_ADD_BIT]		= "%d flow entries have been added.\n",
 };
 
 static const char usage_commands[] =
@@ -745,7 +749,7 @@ static int ct_save_snprintf(char *buf, size_t len,
 
 	switch (type) {
 	case NFCT_T_NEW:
-		ret = snprintf(buf + offset, len, "-I ");
+		ret = snprintf(buf + offset, len, "-A ");
 		BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFCT_T_UPDATE:
@@ -1054,11 +1058,11 @@ err2str(int err, enum ct_command command)
 	  { { CT_LIST, ENOTSUPP, "function not implemented" },
 	    { 0xFFFF, EINVAL, "invalid parameters" },
 	    { CT_CREATE, EEXIST, "Such conntrack exists, try -U to update" },
-	    { CT_CREATE|CT_GET|CT_DELETE, ENOENT, 
+	    { CT_CREATE|CT_GET|CT_DELETE|CT_ADD, ENOENT,
 		    "such conntrack doesn't exist" },
-	    { CT_CREATE|CT_GET, ENOMEM, "not enough memory" },
+	    { CT_CREATE|CT_GET|CT_ADD, ENOMEM, "not enough memory" },
 	    { CT_GET, EAFNOSUPPORT, "protocol not supported" },
-	    { CT_CREATE, ETIME, "conntrack has expired" },
+	    { CT_CREATE|CT_ADD, ETIME, "conntrack has expired" },
 	    { EXP_CREATE, ENOENT, "master conntrack not found" },
 	    { EXP_CREATE, EINVAL, "invalid parameters" },
 	    { ~0U, EPERM, "sorry, you must be root or get "
@@ -2881,7 +2885,8 @@ static int print_stats(const struct ct_cmd *cmd)
 	if (cmd->command && exit_msg[cmd->cmd][0]) {
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr, exit_msg[cmd->cmd], counter);
-		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
+		if (counter == 0 &&
+		    !(cmd->command & (CT_LIST | EXP_LIST | CT_ADD)))
 			return -1;
 	}
 
@@ -2935,6 +2940,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'C':
 		case 'S':
 		case 'U':
+		case 'A':
 			type = check_type(argc, argv);
 			if (type == CT_TABLE_DYING ||
 			    type == CT_TABLE_UNCONFIRMED) {
@@ -3286,6 +3292,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 		break;
 
 	case CT_CREATE:
+	case CT_ADD:
 		if ((cmd->options & CT_OPT_ORIG) && !(cmd->options & CT_OPT_REPL))
 			nfct_setobjopt(cmd->tmpl.ct, NFCT_SOPT_SETUP_REPLY);
 		else if (!(cmd->options & CT_OPT_ORIG) && (cmd->options & CT_OPT_REPL))
@@ -3304,7 +3311,8 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 				       NULL, cmd->tmpl.ct, NULL);
 		if (res >= 0)
 			counter++;
-
+		else if (errno == EEXIST && cmd->command == CT_ADD)
+			res = 0;
 		break;
 
 	case EXP_CREATE:
@@ -3810,7 +3818,8 @@ int main(int argc, char *argv[])
 		ct_parse_file(&cmd_list, argv[0], argv[2]);
 
 		list_for_each_entry(cmd, &cmd_list, list) {
-			if (!(cmd->command & (CT_CREATE | CT_UPDATE | CT_DELETE | CT_FLUSH)))
+			if (!(cmd->command &
+			      (CT_CREATE | CT_ADD | CT_UPDATE | CT_DELETE | CT_FLUSH)))
 				exit_error(PARAMETER_PROBLEM,
 					   "Cannot use command `%s' with --load-file",
 					   ct_unsupp_cmd_file(cmd));
diff --git a/tests/conntrack/testsuite/08stdin b/tests/conntrack/testsuite/08stdin
index 1d31176..158c4c3 100644
--- a/tests/conntrack/testsuite/08stdin
+++ b/tests/conntrack/testsuite/08stdin
@@ -77,4 +77,49 @@
 -D -w 123 ;
 -R - ; OK
 # validate it via standard command line way
--D -w 123 ; BAD
\ No newline at end of file
+-D -w 123 ; BAD
+# create with -A
+# create a conntrack
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# create again
+-I -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+-I -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# repeat, it should succeed
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ;
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ;
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+-R - ; OK
+# delete
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# empty lines should be just ignored
+;
+;
+# delete reverse
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ;
+# empty lines with spaces or tabs should be ignored as well
+ ;
+	;
+		;
+  ;
+	    ;
+	    	    	;
+# delete v6 conntrack
+-D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ;
+# delete icmp ping request entry
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ;
+;
+;
+-R - ; OK
diff --git a/tests/conntrack/testsuite/10add b/tests/conntrack/testsuite/10add
new file mode 100644
index 0000000..4f9f3b9
--- /dev/null
+++ b/tests/conntrack/testsuite/10add
@@ -0,0 +1,42 @@
+#missing destination
+-A -s 1.1.1.1 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing source
+-A -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing protocol
+-A -s 1.1.1.1 -d 2.2.2.2 --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing source port
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing destination port
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+#missing timeout
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY ; BAD
+# create a conntrack
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again
+-A -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# delete again
+-D -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
+# create from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again from reply
+-A -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete reverse
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; OK
+# delete reverse again
+-D -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 ; BAD
+# create a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# create again a v6 conntrack
+-A -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+# delete v6 conntrack
+-D -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; OK
+# mismatched address family
+-A -s 2001:DB8::1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; BAD
+# creae icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# creae again icmp ping request entry
+-A -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# delete icmp ping request entry
+-D -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
-- 
2.25.1

