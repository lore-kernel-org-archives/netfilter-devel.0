Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0F2C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF2964E00
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhA2V0R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbhA2VZ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:25:58 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC01C061756
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:18 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kg20so15018580ejc.4
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdX61FgOUJrG/Flj3VHA/kEi/PjPOXhB4irw9aagjSc=;
        b=XJjRpEy1Ed5V+ck4B6wlmLVn1ix4RfwGTGpOu5MaaS9TfTpHOtvnI9MfR3ywg6DZOd
         ccN38XAfp56XxU5VhANaDvZ5FNakv81Ti9utmBJV7G17qxOp7H4H2IoczwB6l91Jpt2e
         PKXocqWTi0gKEpQZcgoadPg8y9Xo54CK+Ux+X/J3vN11nC3Gf+6eb/sabdaCJ8V2we7E
         c8Ff/TYqRH+10drrxBbt2i83/JRwQd9v8cQXVmmMCKGINTsrgHRdh27KcDgLy8DdhAA9
         wQPSb+XszkEfNfrlYu018CEPTcOrQzMrV7bnt/Krl96ZOfG+7TbtwT0PhhfaLoMc4rcP
         UJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WdX61FgOUJrG/Flj3VHA/kEi/PjPOXhB4irw9aagjSc=;
        b=Me9haaqxEO7+mWrYd5myQ2YlNHRLWrMy1aBoeeHYNa6BOWUYnJsyxPSP+e0+Nt8SpT
         WqiFqFakfwy9FwzVeK+5vdk0cpN/bph9P6hcnKQrEy++zfqaye5TEX15uts8mc8tuO5O
         X3E9YfXJCfAfHDNjhweS1fmB7rq/qtqtWJBou2ZFB+zwBaZjkVHO1xzWX/PyKRmisKF6
         zzI8WjNewz2tNw6swuvIwKWNW9vvUR9Llmqs50FjNr9DVOZ+6FnJ07a5+JN39eertaz4
         w4PEEGgHSphIgRpEbl9HvHUKSGkXCTwc648BBOUVgEToexJWH8jOQn+29IyH+hqKoMxE
         c0mg==
X-Gm-Message-State: AOAM532i3g1S0PCb6U49ffaA/UEkU3JMDQRqYNQg5GrHlDYXpwcFKgM+
        pw1moZEVQ1udCoaVcKADrRkaOZvnjbNUFQ==
X-Google-Smtp-Source: ABdhPJzmCk+2aTJGr/uF2UTvdplfx3x0Oi5+FAGqAK8ZyinRuOAJEl0RYfFOSFaquY27lGkF6ldydg==
X-Received: by 2002:a17:906:c0cd:: with SMTP id bn13mr6270483ejb.368.1611955516882;
        Fri, 29 Jan 2021 13:25:16 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:16 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 3/8] conntrack: per-command entries counters
Date:   Fri, 29 Jan 2021 22:24:47 +0100
Message-Id: <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a multicommand support preparation entry counters need
to be made per-command as well, e.g. for the case -D and -I
can be executed in a single batch, and we want to have separate
counters for them.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 117 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 81 insertions(+), 36 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a090542..4783825 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1663,8 +1663,48 @@ nfct_filter(const struct ct_cmd *cmd,
 	return 0;
 }
 
-static int counter;
 static int dump_xml_header_done = 1;
+static unsigned int cmd_executed = 0;
+static const unsigned int cmd_no_entries_ok = 0
+						| CT_LIST
+						| EXP_LIST
+						;
+static unsigned int cmd_counters[NUMBER_OF_CMD];
+
+static int
+print_cmd_counters(void)
+{
+	int i, ret = EXIT_FAILURE;
+
+	if (!cmd_executed)
+		return EXIT_SUCCESS;
+
+	for (i = 0;
+		i < (int)(sizeof(cmd_counters) / sizeof(cmd_counters[0]));
+		++i) {
+		if (cmd_executed & 1 << i) {
+			if (exit_msg[i][0]) {
+				fprintf(stderr, "%s v%s (conntrack-tools): ",
+							PROGNAME, VERSION);
+				fprintf(stderr, exit_msg[i], cmd_counters[i]);
+			}
+			/*
+			 * If there is at least one command which is supposed
+			 * to return success, EXIT_SUCCESS is returned.
+			 * I.e. for the --load-file case this would ensure that
+			 * e.g. -D followed by a series of -I's
+			 * would return success in case there are no entries
+			 * to be deleted with the -D command preceding the -I's
+			 */
+			if (!exit_msg[i][0]
+					|| cmd_counters[i] != 0
+					|| cmd_no_entries_ok & 1 << i)
+				ret &= EXIT_SUCCESS;
+		}
+	}
+	return ret;
+}
+
 
 static void __attribute__((noreturn))
 event_sighandler(int s)
@@ -1674,8 +1714,7 @@ event_sighandler(int s)
 		fflush(stdout);
 	}
 
-	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
-	fprintf(stderr, "%d flow events have been shown.\n", counter);
+	print_cmd_counters();
 	mnl_socket_close(sock.mnl);
 	exit(0);
 }
@@ -1688,8 +1727,7 @@ exp_event_sighandler(int s)
 		fflush(stdout);
 	}
 
-	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
-	fprintf(stderr, "%d expectation events have been shown.\n", counter);
+	print_cmd_counters();
 	nfct_close(cth);
 	exit(0);
 }
@@ -1938,7 +1976,7 @@ done:
 	}
 	fflush(stdout);
 
-	counter++;
+	cmd_counters[cmd->cmd]++;
 out:
 	nfct_destroy(ct);
 	return MNL_CB_OK;
@@ -1981,7 +2019,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 done:
 	printf("%s\n", buf);
 
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2022,7 +2060,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 done:
 	printf("%s\n", buf);
 
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2207,7 +2245,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	nfct_destroy(tmp);
 	nfct_callback_unregister(ith);
 
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2217,6 +2255,7 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 		      void *data)
 {
 	char buf[1024];
+	struct ct_cmd *cmd = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
@@ -2239,7 +2278,7 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 
 	nfexp_snprintf(buf,sizeof(buf), exp, NFCT_T_UNKNOWN, op_type, op_flags);
 	printf("%s\n", buf);
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2248,6 +2287,7 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 			struct nf_expect *exp, void *data)
 {
 	char buf[1024];
+	struct ct_cmd *cmd = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
@@ -2271,7 +2311,7 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 	nfexp_snprintf(buf,sizeof(buf), exp, type, op_type, op_flags);
 	printf("%s\n", buf);
 	fflush(stdout);
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2280,7 +2320,9 @@ static int count_exp_cb(enum nf_conntrack_msg_type type,
 			struct nf_expect *exp,
 			void *data)
 {
-	counter++;
+	struct ct_cmd *cmd = data;
+
+	cmd_counters[cmd->cmd]++;
 	return NFCT_CB_CONTINUE;
 }
 
@@ -2396,7 +2438,9 @@ static void nfct_mnl_socket_close(void)
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_dump(uint16_t subsys, uint16_t type,
+		      mnl_cb_t cb, void *data,
+		      uint8_t family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -2411,7 +2455,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
 	while (res > 0) {
 		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
-					 cb, NULL);
+					 cb, data);
 		if (res <= MNL_CB_STOP)
 			break;
 
@@ -2581,6 +2625,7 @@ static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nf_conntrack *ct;
 	char buf[4096];
+	struct ct_cmd *cmd = data;
 
 	ct = nfct_new();
 	if (ct == NULL)
@@ -2593,7 +2638,7 @@ static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfct_destroy(ct);
 
-	counter++;
+	cmd_counters[cmd->cmd]++;
 
 	return MNL_CB_OK;
 }
@@ -3051,6 +3096,10 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		}
 	}
 
+	if (!command)
+		/* invalid args */
+		exit_error(PARAMETER_PROBLEM, "invalid cmd line syntax");
+
 	/* default family only for the following commands */
 	if (family == AF_UNSPEC) {
 		switch (command) {
@@ -3106,11 +3155,14 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	ct_cmd->socketbuffersize = socketbuffersize;
 }
 
-static int do_command_ct(const char *progname, struct ct_cmd *cmd)
+static void do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
 	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
+	assert(cmd->cmd < sizeof(cmd_counters) / sizeof(cmd_counters[0]));
+	cmd_executed |= cmd->command;
+
 	switch(cmd->command) {
 	case CT_LIST:
 		if (cmd->type == CT_TABLE_DYING) {
@@ -3119,7 +3171,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
-					    mnl_nfct_dump_cb, cmd->family);
+					    mnl_nfct_dump_cb, cmd, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3129,7 +3181,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
-					    mnl_nfct_dump_cb, cmd->family);
+					    mnl_nfct_dump_cb, cmd, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3182,7 +3234,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
+		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, cmd);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(cth);
 
@@ -3211,7 +3263,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		res = nfct_query(cth, NFCT_Q_CREATE, cmd->tmpl.ct);
 		if (res != -1)
-			counter++;
+			cmd_counters[cmd->cmd]++;
 		nfct_close(cth);
 		break;
 
@@ -3303,7 +3355,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
+		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, cmd);
 		res = nfexp_query(cth, NFCT_Q_GET, cmd->tmpl.exp);
 		nfct_close(cth);
 		break;
@@ -3424,7 +3476,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 		signal(SIGINT, exp_event_sighandler);
 		signal(SIGTERM, exp_event_sighandler);
-		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, NULL);
+		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, cmd);
 		res = nfexp_catch(cth);
 		nfct_close(cth);
 		break;
@@ -3468,10 +3520,10 @@ try_proc_count:
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, NULL);
+		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, cmd);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(cth);
-		printf("%d\n", counter);
+		printf("%d\n", cmd_counters[cmd->cmd]);
 		break;
 	case CT_STATS:
 		/* If we fail with netlink, fall back to /proc to ensure
@@ -3482,7 +3534,7 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
-				    nfct_stats_cb, AF_UNSPEC);
+				    nfct_stats_cb, NULL, AF_UNSPEC);
 
 		nfct_mnl_socket_close();
 
@@ -3501,7 +3553,7 @@ try_proc_count:
 
 		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
-				    nfexp_stats_cb, AF_UNSPEC);
+				    nfexp_stats_cb, NULL, AF_UNSPEC);
 
 		nfct_mnl_socket_close();
 
@@ -3533,15 +3585,6 @@ try_proc:
 	free_options();
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
-
-	if (cmd->command && exit_msg[cmd->cmd][0]) {
-		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
-		fprintf(stderr, exit_msg[cmd->cmd], counter);
-		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
-			return EXIT_FAILURE;
-	}
-
-	return EXIT_SUCCESS;
 }
 
 int main(int argc, char *argv[])
@@ -3560,5 +3603,7 @@ int main(int argc, char *argv[])
 
 	do_parse(cmd, argc, argv);
 
-	return do_command_ct(argv[0], cmd);
+	do_command_ct(argv[0], cmd);
+
+	return print_cmd_counters();
 }
-- 
2.25.1

