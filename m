Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4BCC4332D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A90364F36
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhCOQzd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40496 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhCOQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:02 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 12:55:02 EDT
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7874A6353C;
        Mon, 15 Mar 2021 17:49:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 5/6] conntrack: move options flag to ct_cmd object
Date:   Mon, 15 Mar 2021 17:49:28 +0100
Message-Id: <20210315164929.23608-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315164929.23608-1-pablo@netfilter.org>
References: <20210315164929.23608-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for the batch support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 107 ++++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 48 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 152063e9329e..b9b0e31c8269 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -106,6 +106,7 @@ struct ct_cmd {
 	unsigned int	cmd;
 	unsigned int	type;
 	unsigned int	event_mask;
+	int		options;
 	int		family;
 	int		protonum;
 	size_t		socketbuffersize;
@@ -611,7 +612,6 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 
 static LIST_HEAD(proto_list);
 
-static unsigned int options;
 static struct nfct_labelmap *labelmap;
 static int filter_family;
 
@@ -1494,7 +1494,7 @@ static int filter_mark(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
 	const struct ct_tmpl *tmpl = &cmd->tmpl;
 
-	if ((options & CT_OPT_MARK) &&
+	if ((cmd->options & CT_OPT_MARK) &&
 	     !mark_cmp(&tmpl->mark, ct))
 		return 1;
 	return 0;
@@ -1502,14 +1502,14 @@ static int filter_mark(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 
 static int filter_nat(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
-	int check_srcnat = options & CT_OPT_SRC_NAT ? 1 : 0;
-	int check_dstnat = options & CT_OPT_DST_NAT ? 1 : 0;
+	int check_srcnat = cmd->options & CT_OPT_SRC_NAT ? 1 : 0;
+	int check_dstnat = cmd->options & CT_OPT_DST_NAT ? 1 : 0;
 	struct nf_conntrack *obj = cmd->tmpl.ct;
 	int has_srcnat = 0, has_dstnat = 0;
 	uint32_t ip;
 	uint16_t port;
 
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		check_srcnat = check_dstnat = 1;
 
 	if (check_srcnat) {
@@ -1572,13 +1572,14 @@ static int filter_nat(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 		     nfct_getobjopt(ct, NFCT_GOPT_IS_DPAT)))
 			has_dstnat = 1;
 	}
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		return !(has_srcnat || has_dstnat);
-	else if ((options & CT_OPT_SRC_NAT) && (options & CT_OPT_DST_NAT))
+	else if ((cmd->options & CT_OPT_SRC_NAT) &&
+		 (cmd->options & CT_OPT_DST_NAT))
 		return !(has_srcnat && has_dstnat);
-	else if (options & CT_OPT_SRC_NAT)
+	else if (cmd->options & CT_OPT_SRC_NAT)
 		return !has_srcnat;
-	else if (options & CT_OPT_DST_NAT)
+	else if (cmd->options & CT_OPT_DST_NAT)
 		return !has_dstnat;
 
 	return 0;
@@ -1628,12 +1629,12 @@ nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_direction d
 static int
 filter_network(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
-	if (options & CT_OPT_MASK_SRC) {
+	if (cmd->options & CT_OPT_MASK_SRC) {
 		if (nfct_filter_network_direction(ct, DIR_SRC))
 			return 1;
 	}
 
-	if (options & CT_OPT_MASK_DST) {
+	if (cmd->options & CT_OPT_MASK_DST) {
 		if (nfct_filter_network_direction(ct, DIR_DST))
 			return 1;
 	}
@@ -1652,7 +1653,7 @@ nfct_filter(struct ct_cmd *cmd, struct nf_conntrack *ct,
 	    filter_network(cmd, ct))
 		return 1;
 
-	if (options & CT_COMPARISON &&
+	if (cmd->options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return 1;
 
@@ -2047,20 +2048,21 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static void copy_mark(struct nf_conntrack *tmp,
+static void copy_mark(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 		      const struct nf_conntrack *ct,
 		      const struct u32_mask *m)
 {
-	if (options & CT_OPT_MARK) {
+	if (cmd->options & CT_OPT_MARK) {
 		uint32_t mark = nfct_get_attr_u32(ct, ATTR_MARK);
 		mark = (mark & ~m->mask) ^ m->value;
 		nfct_set_attr_u32(tmp, ATTR_MARK, mark);
 	}
 }
 
-static void copy_status(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
+static void copy_status(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
+			const struct nf_conntrack *ct)
 {
-	if (options & CT_OPT_STATUS) {
+	if (cmd->options & CT_OPT_STATUS) {
 		/* copy existing flags, we only allow setting them. */
 		uint32_t status = nfct_get_attr_u32(ct, ATTR_STATUS);
 		status |= nfct_get_attr_u32(tmp, ATTR_STATUS);
@@ -2076,19 +2078,20 @@ static struct nfct_bitmask *xnfct_bitmask_clone(const struct nfct_bitmask *a)
 	return b;
 }
 
-static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct,
+static void copy_label(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
+		       const struct nf_conntrack *ct,
 		       const struct ct_tmpl *tmpl)
 {
 	struct nfct_bitmask *ctb, *newmask;
 	unsigned int i;
 
-	if ((options & (CT_OPT_ADD_LABEL|CT_OPT_DEL_LABEL)) == 0)
+	if ((cmd->options & (CT_OPT_ADD_LABEL|CT_OPT_DEL_LABEL)) == 0)
 		return;
 
 	nfct_copy_attr(tmp, ct, ATTR_CONNLABELS);
 	ctb = (void *) nfct_get_attr(tmp, ATTR_CONNLABELS);
 
-	if (options & CT_OPT_ADD_LABEL) {
+	if (cmd->options & CT_OPT_ADD_LABEL) {
 		if (ctb == NULL) {
 			nfct_set_attr(tmp, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(tmpl->label_modify));
@@ -2152,9 +2155,11 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
 	    	return NFCT_CB_CONTINUE;
 
-	if (options & CT_OPT_TUPLE_ORIG && !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
+	if (cmd->options & CT_OPT_TUPLE_ORIG &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
 		return NFCT_CB_CONTINUE;
-	if (options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
+	if (cmd->options & CT_OPT_TUPLE_REPL &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_REPL))
 		return NFCT_CB_CONTINUE;
 
 	tmp = nfct_new();
@@ -2163,9 +2168,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 
 	nfct_copy(tmp, ct, NFCT_CP_ORIG);
 	nfct_copy(tmp, obj, NFCT_CP_META);
-	copy_mark(tmp, ct, &cur_tmpl->mark);
-	copy_status(tmp, ct);
-	copy_label(tmp, ct, cur_tmpl);
+	copy_mark(cmd, tmp, ct, &cur_tmpl->mark);
+	copy_status(cmd, tmp, ct);
+	copy_label(cmd, tmp, ct, cur_tmpl);
 
 	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
 	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
@@ -2633,17 +2638,17 @@ static void nfct_filter_init(const struct ct_cmd *cmd)
 	int family = cmd->family;
 
 	filter_family = family;
-	if (options & CT_OPT_MASK_SRC) {
+	if (cmd->options & CT_OPT_MASK_SRC) {
 		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_SRC))
+		if (!(cmd->options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-src without --src");
 		nfct_network_attr_prepare(family, DIR_SRC, tmpl);
 	}
 
-	if (options & CT_OPT_MASK_DST) {
+	if (cmd->options & CT_OPT_MASK_DST) {
 		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_DST))
+		if (!(cmd->options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-dst without --dst");
 		nfct_network_attr_prepare(family, DIR_DST, tmpl);
@@ -2714,9 +2719,9 @@ nfct_set_addr_only(const int opt, struct nf_conntrack *ct, union ct_address *ad,
 
 static void
 nfct_set_addr_opt(const int opt, struct nf_conntrack *ct, union ct_address *ad,
-		  const int l3protonum)
+		  const int l3protonum, unsigned int *options)
 {
-	options |= opt2type[opt];
+	*options |= opt2type[opt];
 	nfct_set_addr_only(opt, ct, ad, l3protonum);
 	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
 }
@@ -2725,7 +2730,8 @@ static void
 nfct_parse_addr_from_opt(const int opt, const char *arg,
 			 struct nf_conntrack *ct,
 			 struct nf_conntrack *ctmask,
-			 union ct_address *ad, int *family)
+			 union ct_address *ad, int *family,
+			 unsigned int *options)
 {
 	int mask, maskopt;
 
@@ -2745,7 +2751,7 @@ nfct_parse_addr_from_opt(const int opt, const char *arg,
 		           "Invalid netmask");
 	}
 
-	nfct_set_addr_opt(opt, ct, ad, l3protonum);
+	nfct_set_addr_opt(opt, ct, ad, l3protonum, options);
 
 	/* bail if we don't have a netmask to set*/
 	if (mask == -1 || !maskopt || ctmask == NULL)
@@ -2764,7 +2770,7 @@ nfct_parse_addr_from_opt(const int opt, const char *arg,
 		break;
 	}
 
-	nfct_set_addr_opt(maskopt, ctmask, ad, l3protonum);
+	nfct_set_addr_opt(maskopt, ctmask, ad, l3protonum, options);
 }
 
 static void
@@ -2791,6 +2797,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	int protonum = 0, family = AF_UNSPEC;
 	size_t socketbuffersize = 0;
 	unsigned int command = 0;
+	unsigned int options = 0;
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
@@ -2856,17 +2863,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'r':
 		case 'q':
 			nfct_parse_addr_from_opt(c, optarg, tmpl->ct,
-						 tmpl->mask, &ad, &family);
+						 tmpl->mask, &ad, &family,
+						 &options);
 			break;
 		case '[':
 		case ']':
 			nfct_parse_addr_from_opt(c, optarg, tmpl->exptuple,
-						 tmpl->mask, &ad, &family);
+						 tmpl->mask, &ad, &family,
+						 &options);
 			break;
 		case '{':
 		case '}':
 			nfct_parse_addr_from_opt(c, optarg, tmpl->mask,
-						 NULL, &ad, &family);
+						 NULL, &ad, &family, &options);
 			break;
 		case 'p':
 			options |= CT_OPT_PROTO;
@@ -2925,7 +2934,8 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 						       &port_str);
 				nfct_parse_addr_from_opt(c, nat_address,
 							 tmpl->ct, NULL,
-							 &ad, &family);
+							 &ad, &family,
+							 &options);
 				if (c == 'j') {
 					/* Set details on both src and dst
 					 * with any-nat
@@ -3082,6 +3092,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 	ct_cmd->command = command;
 	ct_cmd->cmd = cmd;
+	ct_cmd->options = options;
 	ct_cmd->family = family;
 	ct_cmd->type = type;
 	ct_cmd->protonum = protonum;
@@ -3122,8 +3133,8 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		if (options & CT_COMPARISON && 
-		    options & CT_OPT_ZERO)
+		if (cmd->options & CT_COMPARISON &&
+		    cmd->options & CT_OPT_ZERO)
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
 
@@ -3144,7 +3155,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					     NFCT_FILTER_DUMP_L3NUM,
 					     cmd->family);
 
-		if (options & CT_OPT_ZERO)
+		if (cmd->options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
 					filter_dump);
 		else
@@ -3176,15 +3187,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_CREATE:
-		if ((options & CT_OPT_ORIG) && !(options & CT_OPT_REPL))
+		if ((cmd->options & CT_OPT_ORIG) && !(cmd->options & CT_OPT_REPL))
 			nfct_setobjopt(cmd->tmpl.ct, NFCT_SOPT_SETUP_REPLY);
-		else if (!(options & CT_OPT_ORIG) && (options & CT_OPT_REPL))
+		else if (!(cmd->options & CT_OPT_ORIG) && (cmd->options & CT_OPT_REPL))
 			nfct_setobjopt(cmd->tmpl.ct, NFCT_SOPT_SETUP_ORIGINAL);
 
-		if (options & CT_OPT_MARK)
+		if (cmd->options & CT_OPT_MARK)
 			nfct_set_attr_u32(cmd->tmpl.ct, ATTR_MARK, cmd->tmpl.mark.value);
 
-		if (options & CT_OPT_ADD_LABEL)
+		if (cmd->options & CT_OPT_ADD_LABEL)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
@@ -3312,7 +3323,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
 			if (cmd->event_mask & CT_EVENT_F_NEW)
@@ -3332,7 +3343,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		if (options & CT_OPT_BUFFERSIZE) {
+		if (cmd->options & CT_OPT_BUFFERSIZE) {
 			size_t socketbuffersize = cmd->socketbuffersize;
 
 			socklen_t socklen = sizeof(socketbuffersize);
@@ -3385,7 +3396,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case EXP_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
 			if (cmd->event_mask & CT_EVENT_F_NEW)
@@ -3500,7 +3511,7 @@ try_proc:
 		break;
 	case CT_HELP:
 		usage(progname);
-		if (options & CT_OPT_PROTO)
+		if (cmd->options & CT_OPT_PROTO)
 			extension_help(h, cmd->protonum);
 		break;
 	default:
-- 
2.20.1

