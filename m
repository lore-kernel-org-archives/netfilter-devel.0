Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27256C4320A
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073B8613D0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Aug 2021 15:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhHWP6U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbhHWP6T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 11:58:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F12C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z9so26894996wrh.10
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Aug 2021 08:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5BGIkMUCtZVzH6R0mEIno3xo0LV67Jn/FXC5JWppxZg=;
        b=MVUkZh6Mj4ubtOa3IMuBQ6LGjCcpOVWUDpSCdG42HFAfmFrbmMHb5DZafAqiSDAB3e
         nF6+JOrKfHxPYKiUavrzE4jxVKf2R7IgO/qjxIljIBUA0uxSPQ2XMbymw8Mfg58UNHXR
         TncDkmKMLrfV/E0fR1HIIVImRW7EEJUb2/37HUKMmpYDY5fM6Ok84rfpTpvfYU/sJ7Na
         Wa4K0Q7v0wi1V+5I3jP6+KA1VnPZZeq09DQDsdGM17lLRd/EaUzi7bm0d6z/9u89jeVa
         v54h9gHeYi1zwHAagyu9jy5FAvqqDrfz0uulrF7R4Ydv0tooW3rSX6RckAJGlcTstPVa
         puEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5BGIkMUCtZVzH6R0mEIno3xo0LV67Jn/FXC5JWppxZg=;
        b=TiyvN6+1pbkYRPPGivtHmv2jR6z6Sl7GZg24Xbfbs7l7MquEU2eB4/kNzRu7yRUk9H
         kSSyc5RyPZp6/F7uqOh0NuXjOjoDJok2D67r2XPAAblc0iNt+X7YGX2vSd0vcHpXRx1M
         dRuk7aP/xmUKKd2N4+VQIR+b2s/y5f3tLYG8hfd4O6Y4Mkge9Uot9K7Q4D/48PRe4Zgy
         Q+PqVO79eE6eB1tumufzDx9v3/XxNgxd+Nrjk4SEabyesd1V2xpfaMvomRkLoZPVwpwl
         s1K+wQPP3zcN15zKQwV9enxG+VHil69j90JJsimgC/vfPp1D99cpQEQ3V4oe8YeS7600
         JDTQ==
X-Gm-Message-State: AOAM533vJua5vsNGEmY6sbv1FW3YFwDjcnr+kZcqJMrAbRpoqe8A1iE3
        9rLWTtRGUzNPGJhCgu3hQ0rF4muFP0daqA==
X-Google-Smtp-Source: ABdhPJwYQLAr0dIvhVdkl0pD6PvuqFbCZOwOBA3Wy96YzPjKobRhQJVKHf5UTinBe4JAasW2DwA/fA==
X-Received: by 2002:adf:eb02:: with SMTP id s2mr14340937wrn.294.1629734253895;
        Mon, 23 Aug 2021 08:57:33 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf74b.dynamic.kabel-deutschland.de. [95.91.247.75])
        by smtp.gmail.com with ESMTPSA id m16sm3744501wmq.8.2021.08.23.08.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 08:57:32 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 2/2] conntrack: use same nfct handle for all entries
Date:   Mon, 23 Aug 2021 17:57:15 +0200
Message-Id: <20210823155715.81729-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
References: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For bulk ct entry loads (with -R option) reusing the same nftc handle
for all entries results in ~two-time reduction of entries creation
time. This becomes signifficant when loading tens of thouthand of
entries.
E.g. in the tests performed with the tests/conntrack/bulk-load-stress.sh
the time used for loading of 131070 ct entries (2 * 0xffff)
was 1.05s when this single nfct handle adjustment and 1.88s w/o it .

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 160 ++++++++++++++++++++++++++++--------------------
 1 file changed, 95 insertions(+), 65 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index ef7f604..7a86420 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -105,6 +105,59 @@ struct ct_tmpl {
 
 static struct ct_tmpl *cur_tmpl;
 
+
+struct ct_ctx {
+	struct nfct_handle *cth;
+	struct nfct_handle *ith;
+	uint8_t cur_subsys_id;
+	unsigned cur_subscriptions;
+} ct_ctx;
+
+static void ct_ctx_term(void)
+{
+	if (ct_ctx.cth)
+		nfct_close(ct_ctx.cth);
+	if (ct_ctx.ith)
+		nfct_close(ct_ctx.ith);
+	memset(&ct_ctx, 0, sizeof(ct_ctx));
+}
+
+static inline struct nfct_handle* _ct_ctx_get(struct nfct_handle **ph,
+		uint8_t subsys_id, unsigned subscriptions)
+{
+	struct nfct_handle *h = *ph;
+
+	if (!ct_ctx.cur_subsys_id) {
+		ct_ctx.cur_subsys_id = subsys_id;
+		ct_ctx.cur_subscriptions = subscriptions;
+	} else if (ct_ctx.cur_subsys_id != subsys_id
+			|| ct_ctx.cur_subscriptions != subscriptions) {
+		exit_error(OTHER_PROBLEM, "handler parameters mismatch!");
+	}
+
+	if (!h) {
+		h = nfct_open(subsys_id, subscriptions);
+		if (!h)
+			exit_error(OTHER_PROBLEM, "Can't open handler");
+		*ph = h;
+	}
+
+	return h;
+}
+
+static struct nfct_handle* ct_ctx_get_cth(
+		uint8_t subsys_id, unsigned subscriptions)
+{
+	return _ct_ctx_get(&ct_ctx.cth, subsys_id, subscriptions);
+}
+
+static struct nfct_handle* ct_ctx_get_ith(
+		uint8_t subsys_id, unsigned subscriptions)
+{
+	return _ct_ctx_get(&ct_ctx.ith, subsys_id, subscriptions);
+}
+
+
 struct ct_cmd {
 	struct list_head list;
 	unsigned int	command;
@@ -605,7 +658,6 @@ static const char usage_parameters[] =
 
 #define OPTION_OFFSET 256
 
-static struct nfct_handle *cth, *ith;
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
@@ -1739,7 +1791,7 @@ exp_event_sighandler(int s)
 
 	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
 	fprintf(stderr, "%d expectation events have been shown.\n", counter);
-	nfct_close(cth);
+	ct_ctx_term();
 	exit(0);
 }
 
@@ -2046,7 +2098,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 	if (nfct_filter(cmd, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
-	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
+	res = nfct_query(ct_ctx.ith, NFCT_Q_DESTROY, ct);
 	if (res < 0)
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
@@ -2230,19 +2282,19 @@ static int update_cb(enum nf_conntrack_msg_type type,
 		return NFCT_CB_CONTINUE;
 	}
 
-	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
+	res = nfct_query(ct_ctx.ith, NFCT_Q_UPDATE, tmp);
 	if (res < 0)
 		fprintf(stderr,
 			   "Operation failed: %s\n",
 			   err2str(errno, CT_UPDATE));
-	nfct_callback_register(ith, NFCT_T_ALL, print_cb, NULL);
+	nfct_callback_register(ct_ctx.ith, NFCT_T_ALL, print_cb, NULL);
 
-	res = nfct_query(ith, NFCT_Q_GET, tmp);
+	res = nfct_query(ct_ctx.ith, NFCT_Q_GET, tmp);
 	if (res < 0) {
 		nfct_destroy(tmp);
 		/* the entry has vanish in middle of the update */
 		if (errno == ENOENT) {
-			nfct_callback_unregister(ith);
+			nfct_callback_unregister(ct_ctx.ith);
 			return NFCT_CB_CONTINUE;
 		}
 		exit_error(OTHER_PROBLEM,
@@ -2250,7 +2302,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 			   err2str(errno, CT_UPDATE));
 	}
 	nfct_destroy(tmp);
-	nfct_callback_unregister(ith);
+	nfct_callback_unregister(ct_ctx.ith);
 
 	counter++;
 
@@ -3178,6 +3230,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
+	struct nfct_handle *cth;
 	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
@@ -3205,9 +3258,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			break;
 		}
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
 
 		if (cmd->options & CT_COMPARISON &&
 		    cmd->options & CT_OPT_ZERO)
@@ -3248,17 +3299,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			fflush(stdout);
 		}
 
-		nfct_close(cth);
 		break;
 
 	case EXP_LIST:
-		cth = nfct_open(EXPECT, 0);
+		cth = ct_ctx_get_cth(EXPECT, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
-		nfct_close(cth);
 
 		if (dump_xml_header_done == 0) {
 			printf("</expect>\n");
@@ -3279,14 +3328,11 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
 
 		res = nfct_query(cth, NFCT_Q_CREATE, cmd->tmpl.ct);
 		if (res != -1)
 			counter++;
-		nfct_close(cth);
 		break;
 
 	case EXP_CREATE:
@@ -3294,35 +3340,41 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_EXPECTED, cmd->tmpl.exptuple);
 		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_MASK, cmd->tmpl.mask);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(EXPECT, 0);
 
 		res = nfexp_query(cth, NFCT_Q_CREATE, cmd->tmpl.exp);
-		nfct_close(cth);
 		break;
 
 	case CT_UPDATE:
-		cth = nfct_open(CONNTRACK, 0);
-		/* internal handler for delete_cb, otherwise we hit EILSEQ */
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
+		/*
+		 * Internal handler for update_cb, otherwise we hit EILSEQ.
+		 *
+		 * Don't need a return value here, just need it to be initialized
+		 * to be used in the update_cb.
+		 * In case the ith handle creation fails, the ct_ctx_get_ith will do
+		 * exit_error internally.
+		 */
+		ct_ctx_get_ith(CONNTRACK, 0);
 
 		nfct_filter_init(cmd);
 
 		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
 
 		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
-		nfct_close(ith);
-		nfct_close(cth);
 		break;
 
 	case CT_DELETE:
-		cth = nfct_open(CONNTRACK, 0);
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
+		/*
+		 * Internal handler for delete_cb, otherwise we hit EILSEQ.
+		 *
+		 * Don't need a return value here, just need it to be initialized
+		 * to be used in the delete_cb.
+		 * In case the ith handle creation fails, the ct_ctx_get_ith will do
+		 * exit_error internally.
+		 */
+		ct_ctx_get_ith(CONNTRACK, 0);
 
 		nfct_filter_init(cmd);
 
@@ -3345,59 +3397,42 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_close(ith);
-		nfct_close(cth);
 		break;
 
 	case EXP_DELETE:
 		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_EXPECTED, cmd->tmpl.ct);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(EXPECT, 0);
 
 		res = nfexp_query(cth, NFCT_Q_DESTROY, cmd->tmpl.exp);
-		nfct_close(cth);
 		break;
 
 	case CT_GET:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
 
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 		res = nfct_query(cth, NFCT_Q_GET, cmd->tmpl.ct);
-		nfct_close(cth);
 		break;
 
 	case EXP_GET:
 		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_MASTER, cmd->tmpl.ct);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(EXPECT, 0);
 
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_GET, cmd->tmpl.exp);
-		nfct_close(cth);
 		break;
 
 	case CT_FLUSH:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(CONNTRACK, 0);
 		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &cmd->family);
-		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
 
 	case EXP_FLUSH:
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		cth = ct_ctx_get_cth(EXPECT, 0);
 		res = nfexp_query(cth, NFCT_Q_FLUSH, &cmd->family);
-		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"expectation table has been emptied.\n");
 		break;
@@ -3486,21 +3521,18 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_DESTROY;
 
-			cth = nfct_open(CONNTRACK, nl_events);
+			cth = ct_ctx_get_cth(CONNTRACK, nl_events);
 		} else {
-			cth = nfct_open(EXPECT,
+			cth = ct_ctx_get_cth(EXPECT,
 					NF_NETLINK_CONNTRACK_EXP_NEW |
 					NF_NETLINK_CONNTRACK_EXP_UPDATE |
 					NF_NETLINK_CONNTRACK_EXP_DESTROY);
 		}
 
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
 		signal(SIGINT, exp_event_sighandler);
 		signal(SIGTERM, exp_event_sighandler);
 		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, NULL);
 		res = nfexp_catch(cth);
-		nfct_close(cth);
 		break;
 	case CT_COUNT:
 		/* If we fail with netlink, fall back to /proc to ensure
@@ -3538,13 +3570,9 @@ try_proc_count:
 		break;
 	}
 	case EXP_COUNT:
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
+		cth = ct_ctx_get_cth(EXPECT, 0);
 		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, NULL);
 		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
-		nfct_close(cth);
 		printf("%d\n", counter);
 		break;
 	case CT_STATS:
@@ -3840,5 +3868,7 @@ int main(int argc, char *argv[])
 		free(cmd);
 	}
 
+	ct_ctx_term();
+
 	return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1

