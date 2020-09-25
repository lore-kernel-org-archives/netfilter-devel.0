Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8528AC4727D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3134C206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="PLQmC5k/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgIYM6M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbgIYMtp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E1C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i26so3415544ejb.12
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZ9dxGnGnQosRgPh7WRMmql4CWxYsk3ROuZQTo0fLWo=;
        b=PLQmC5k/gUcXtk46wNVmoKtz1mQF7SvUy7e3noG+1n69W9QUYZI42H4at1/IQyaS6w
         OCSL3fJ3j/v/WQc6bM6EflQrTH9ZQ2yiOilqrYARS2VwnAxG3mE2cIcFPiRmwGVC0mq7
         uYdhXS/CXtipLsQpf2jt+r0C8/YtXIvNMPS4dyt0Ni8xe5NrtCyUC3BurSzn7IcBOwd6
         /IRGHr+sLmI7FZwYRxFztTlWZcA9LvNUtP36xapvcvChNlM5HVEGD0YoPfjIU2yxF0L5
         8uaXQCB4pPCFxSc24Z4ijDKaBNTAjYJBY9O0PtsExPoBjF1I1UcqtIee5QQI7ECn7Au0
         iBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZ9dxGnGnQosRgPh7WRMmql4CWxYsk3ROuZQTo0fLWo=;
        b=CobOBQwpMVCaRo9FlGxSKlj2LTJImZjugnW3ijOBHoSedFDDa47kOES33+Qvt8pzwU
         X2YGIDWMqrAma+WJFdeB1yCz4BJLSyIB+pNt+kiWJ5dFtOfXj9GLvTO/GuTgl96qHw7i
         WygGiunIoQsS7nQ+KeNRSKUNzv1yHHZErsaGQspuvSU14wW5zSzwU7TYREW+hz2/M8iB
         Dgi2G2GccNVZyozaJ1dU6x+IwlrEMMN3HrY3PItswskOTD6JJSCN9LoZ4foCGuu179Gt
         A9s3JFXGmsP1N77jR3pUUSKknxuFoq5y/xOyPsutC9Ehcyv+92N4luTgJXq4kiqKuRjh
         PtmQ==
X-Gm-Message-State: AOAM531OmStyMN08418TbtzQ9A22hcI7tsKo5SFWB7ynOOh1it8xuDLV
        +gO4Jyf4psZTpQs6dLBYnEZ85yf7472+3A==
X-Google-Smtp-Source: ABdhPJyjE0brKakFTJU3r4d5F/wynfCFi4JIWPegxbnn3BPZOC5ZC91FsuqCDtkoDIcnTYIaihj5Mg==
X-Received: by 2002:a17:906:6ce:: with SMTP id v14mr2446815ejb.451.1601038183775;
        Fri, 25 Sep 2020 05:49:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:43 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 3/8] conntrack: accept parameters from stdin
Date:   Fri, 25 Sep 2020 14:49:14 +0200
Message-Id: <20200925124919.9389-4-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit allows accepting multiple sets of ct entry-related
parameters on stdin.
This is useful when one needs to add/update/delete a large
set of ct entries with a single conntrack tool invocation.

Expected syntax is "conntrack [-I|-D|-U] [table] -".
When invoked like that, conntrack expects ct entry parameters
to be passed to the stdin, each line presenting a separate parameter
set.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 196 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 161 insertions(+), 35 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a26fa60..5834f2d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -96,15 +96,18 @@ static struct {
 	struct nfct_bitmask *label_modify;
 } tmpl;
 
+int cur_argc;
+char **cur_argv;
+
 static int alloc_tmpl_objects(void)
 {
+	memset(&tmpl, 0, sizeof(tmpl));
+
 	tmpl.ct = nfct_new();
 	tmpl.exptuple = nfct_new();
 	tmpl.mask = nfct_new();
 	tmpl.exp = nfexp_new();
 
-	memset(&tmpl.mark, 0, sizeof(tmpl.mark));
-
 	return tmpl.ct != NULL && tmpl.exptuple != NULL &&
 	       tmpl.mask != NULL && tmpl.exp != NULL;
 }
@@ -685,12 +688,18 @@ static void free_options(void)
 void __attribute__((noreturn))
 exit_error(enum exittype status, const char *msg, ...)
 {
+	int i;
 	va_list args;
 
 	free_options();
 	va_start(args, msg);
 	fprintf(stderr,"%s v%s (conntrack-tools): ", PROGNAME, VERSION);
 	vfprintf(stderr, msg, args);
+	if (cur_argc) {
+		fprintf(stderr, "\nargs:");
+		for (i = 1; i < cur_argc; ++i)
+			fprintf(stderr, " %s", cur_argv[i]);
+	}
 	fprintf(stderr, "\n");
 	va_end(args);
 	if (status == PARAMETER_PROBLEM)
@@ -2317,23 +2326,63 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 		nfct_set_attr_u16(ct, ATTR_DNAT_PORT,
 				  ntohs((uint16_t)atoi(port_str)));
 	}
+}
+
+static int line_to_argcv(char *cmd, char *line, char ***pargv, size_t *pargv_size)
+{
+	char *arg;
+	int argc;
+	char **argv = *pargv;
+	size_t argv_size = *pargv_size;
+	int argc_max = argv_size / sizeof(*argv);
+
+#define _ARG_ADD(_arg) do { \
+		if (argc == argc_max) { \
+			argc_max += 20; \
+			argv_size = argc_max * sizeof (argv[0]); \
+			argv = realloc(argv, argv_size); \
+			if (!argv) \
+				exit_error(OTHER_PROBLEM, "out of memory"); \
+		} \
+		argv[argc] = _arg; \
+		++argc; \
+} while (0)
+
+#define _ARG_SEP " \t\n\r"
+	for (argc = 0, arg = strtok (line, _ARG_SEP);
+			arg;
+			arg = strtok (NULL, _ARG_SEP)) {
+		/*
+		 * getopt_long expects argv[0] to be the command name,
+		 * and would always skip it so we need to include it here
+		 */
+		if (!argc && cmd)
+			_ARG_ADD(cmd);
+		_ARG_ADD(arg);
+	}
+
+#undef _ARG_ADD
+#undef _ARG_SEP
 
+	*pargv = argv;
+	*pargv_size = argv_size;
+
+	return argc;
 }
 
 int main(int argc, char *argv[])
 {
 	int c, cmd;
-	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
+	unsigned int type = 0, event_mask = 0, l4flags, status = 0;
 	int res = 0, partial;
-	size_t socketbuffersize = 0;
-	int family = AF_UNSPEC;
-	int protonum = 0;
+	size_t socketbuffersize;
+	int family;
+	int protonum;
 	union ct_address ad;
 	unsigned int command = 0;
-
-	/* we release these objects in the exit_error() path. */
-	if (!alloc_tmpl_objects())
-		exit_error(OTHER_PROBLEM, "out of memory");
+	FILE *opts_file = NULL;
+	char **argv_buf = NULL, *getline_buf = NULL;
+	size_t argv_buf_size = 0, getline_buf_size = 0;
 
 	register_tcp();
 	register_udp();
@@ -2348,6 +2397,23 @@ int main(int argc, char *argv[])
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
 
+parse_opts:
+
+	options = 0;
+	filter_family = 0;
+	memset(dir2network, 0, sizeof(dir2network));
+	/* all allocate-able objects get freed zero-inited
+	 * at the end of each iteration */
+
+	l4flags = 0;
+	family = AF_UNSPEC;
+	socketbuffersize = 0;
+	protonum = 0;
+
+	/* we release these objects in the exit_error() path. */
+	if (!alloc_tmpl_objects())
+		exit_error(OTHER_PROBLEM, "out of memory");
+
 	while ((c = getopt_long(argc, argv, getopt_str, opts, NULL)) != -1) {
 	switch(c) {
 		/* commands */
@@ -2585,6 +2651,26 @@ int main(int argc, char *argv[])
 					      "`--dst-nat' with `--any-nat'");
 	}
 	cmd = bit2cmd(command);
+
+	if (!opts_file && optind == argc - 1 && !strcmp(argv[optind], "-")) {
+		switch (command) {
+		case CT_CREATE:
+		case EXP_CREATE:
+		case CT_UPDATE:
+		case CT_DELETE:
+		case EXP_DELETE:
+			break;
+		default:
+			exit_error(PARAMETER_PROBLEM, "stdin mode not supported "
+					"for this command!");
+		}
+		if (options)
+			exit_error(PARAMETER_PROBLEM, "no extra options are expected "
+					"with stdin read mode!");
+		opts_file = stdin;
+		goto next_opts;
+	}
+
 	res = generic_opt_check(options, NUMBER_OF_OPT,
 				commands_v_options[cmd], optflags,
 				addr_valid_flags, ADDR_VALID_FLAGS_MAX,
@@ -2670,8 +2756,8 @@ int main(int argc, char *argv[])
 			printf("</conntrack>\n");
 			fflush(stdout);
 		}
-
 		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case EXP_LIST:
@@ -2681,12 +2767,13 @@ int main(int argc, char *argv[])
 
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
-		nfct_close(cth);
 
 		if (dump_xml_header_done == 0) {
 			printf("</expect>\n");
 			fflush(stdout);
 		}
+		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case CT_CREATE:
@@ -2702,14 +2789,15 @@ int main(int argc, char *argv[])
 			nfct_set_attr(tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(tmpl.label_modify));
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (!cth) {
+			cth = nfct_open(CONNTRACK, 0);
+			if (!cth)
+				exit_error(OTHER_PROBLEM, "Can't open handler");
+		}
 
 		res = nfct_query(cth, NFCT_Q_CREATE, tmpl.ct);
 		if (res != -1)
 			counter++;
-		nfct_close(cth);
 		break;
 
 	case EXP_CREATE:
@@ -2717,18 +2805,21 @@ int main(int argc, char *argv[])
 		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.exptuple);
 		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASK, tmpl.mask);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (!cth) {
+			cth = nfct_open(EXPECT, 0);
+			if (!cth)
+				exit_error(OTHER_PROBLEM, "Can't open handler");
+		}
 
 		res = nfexp_query(cth, NFCT_Q_CREATE, tmpl.exp);
-		nfct_close(cth);
 		break;
 
 	case CT_UPDATE:
-		cth = nfct_open(CONNTRACK, 0);
+		if (!cth)
+			cth = nfct_open(CONNTRACK, 0);
 		/* internal handler for delete_cb, otherwise we hit EILSEQ */
-		ith = nfct_open(CONNTRACK, 0);
+		if (!ith)
+			ith = nfct_open(CONNTRACK, 0);
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
@@ -2737,13 +2828,13 @@ int main(int argc, char *argv[])
 		nfct_callback_register(cth, NFCT_T_ALL, update_cb, tmpl.ct);
 
 		res = nfct_query(cth, NFCT_Q_DUMP, &family);
-		nfct_close(ith);
-		nfct_close(cth);
 		break;
 		
 	case CT_DELETE:
-		cth = nfct_open(CONNTRACK, 0);
-		ith = nfct_open(CONNTRACK, 0);
+		if (!cth)
+			cth = nfct_open(CONNTRACK, 0);
+		if (!ith)
+			ith = nfct_open(CONNTRACK, 0);
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
@@ -2768,19 +2859,18 @@ int main(int argc, char *argv[])
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_close(ith);
-		nfct_close(cth);
 		break;
 
 	case EXP_DELETE:
 		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.ct);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (!cth) {
+			cth = nfct_open(EXPECT, 0);
+			if (!cth)
+				exit_error(OTHER_PROBLEM, "Can't open handler");
+		}
 
 		res = nfexp_query(cth, NFCT_Q_DESTROY, tmpl.exp);
-		nfct_close(cth);
 		break;
 
 	case CT_GET:
@@ -2791,6 +2881,7 @@ int main(int argc, char *argv[])
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
 		res = nfct_query(cth, NFCT_Q_GET, tmpl.ct);
 		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case EXP_GET:
@@ -2803,6 +2894,7 @@ int main(int argc, char *argv[])
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_GET, tmpl.exp);
 		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case CT_FLUSH:
@@ -2810,9 +2902,10 @@ int main(int argc, char *argv[])
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 		res = nfct_query(cth, NFCT_Q_FLUSH, &family);
-		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
+		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case EXP_FLUSH:
@@ -2820,9 +2913,10 @@ int main(int argc, char *argv[])
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 		res = nfexp_query(cth, NFCT_Q_FLUSH, &family);
-		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"expectation table has been emptied.\n");
+		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case CT_EVENT:
@@ -2894,6 +2988,8 @@ int main(int argc, char *argv[])
 			res = mnl_cb_run(buf, res, 0, 0, event_cb, tmpl.ct);
 		}
 		mnl_socket_close(sock.mnl);
+		nfct_close(cth);
+		cth = NULL;
 		break;
 
 	case EXP_EVENT:
@@ -2922,6 +3018,7 @@ int main(int argc, char *argv[])
 		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, NULL);
 		res = nfexp_catch(cth);
 		nfct_close(cth);
+		cth = NULL;
 		break;
 	case CT_COUNT:
 		/* If we fail with netlink, fall back to /proc to ensure
@@ -2966,6 +3063,7 @@ try_proc_count:
 		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
 		nfct_close(cth);
+		cth = NULL;
 		printf("%d\n", counter);
 		break;
 	case CT_STATS:
@@ -3024,10 +3122,35 @@ try_proc:
 		exit_error(OTHER_PROBLEM, "Operation failed: %s",
 			   err2str(errno, command));
 
+next_opts:
 	free_tmpl_objects();
 	free_options();
-	if (labelmap)
+	if (labelmap) {
 		nfct_labelmap_destroy(labelmap);
+		labelmap = NULL;
+	}
+
+	if (opts_file) {
+		while ((res = getline(&getline_buf, &getline_buf_size, opts_file)) >= 0) {
+			if (!res)
+				continue;
+			argc = line_to_argcv(argv[0], getline_buf, &argv_buf, &argv_buf_size);
+			if (!argc)
+				continue;
+			argv = argv_buf;
+
+			cur_argc = argc;
+			cur_argv = argv;
+
+			optind = 0;
+			goto parse_opts;
+		}
+	}
+
+	if (ith)
+		nfct_close(ith);
+	if (cth)
+		nfct_close(cth);
 
 	if (command && exit_msg[cmd][0]) {
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
@@ -3036,5 +3159,8 @@ try_proc:
 			return EXIT_FAILURE;
 	}
 
+	free(argv_buf);
+	free(getline_buf);
+
 	return EXIT_SUCCESS;
 }
-- 
2.25.1

