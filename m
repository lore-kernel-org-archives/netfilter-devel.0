Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DA9C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D42A23A6C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbhANWcy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:32:54 -0500
Received: from correo.us.es ([193.147.175.20]:44120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730737AbhANWcy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 17:32:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06B26303D0B
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E966CDA78A
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DEB8FDA73F; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BF28DA704;
        Thu, 14 Jan 2021 23:31:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Jan 2021 23:31:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0443D42DC700;
        Thu, 14 Jan 2021 23:31:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack-tools 2/3] conntrack: add struct ct_tmpl
Date:   Thu, 14 Jan 2021 23:32:01 +0100
Message-Id: <20210114223202.4758-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210114223202.4758-1-pablo@netfilter.org>
References: <20210114223202.4758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove the global template object, add it to struct ct_cmd. This patch
prepares for the batch support.

The global cur_tmpl pointer is used to access the template from the
callbacks and the exit_error() path.

Note that it should be possible to remove this global cur_tmpl pointer
by passing the new command object as parameter to the callbacks and
exit_error().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 231 +++++++++++++++++++++++++-----------------------
 1 file changed, 121 insertions(+), 110 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 12c9608c1003..019299645a0d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -79,7 +79,7 @@ struct u32_mask {
 };
 
 /* These are the template objects that are used to send commands. */
-static struct {
+struct ct_tmpl {
 	struct nf_conntrack *ct;
 	struct nf_expect *exp;
 	/* Expectations require the expectation tuple and the mask. */
@@ -97,35 +97,39 @@ static struct {
 
 	/* Allows setting/removing specific ctlabels */
 	struct nfct_bitmask *label_modify;
-} tmpl;
+};
+
+static struct ct_tmpl *cur_tmpl;
 
-static int alloc_tmpl_objects(void)
+static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
 {
-	tmpl.ct = nfct_new();
-	tmpl.exptuple = nfct_new();
-	tmpl.mask = nfct_new();
-	tmpl.exp = nfexp_new();
+	tmpl->ct = nfct_new();
+	tmpl->exptuple = nfct_new();
+	tmpl->mask = nfct_new();
+	tmpl->exp = nfexp_new();
 
-	memset(&tmpl.mark, 0, sizeof(tmpl.mark));
+	memset(&tmpl->mark, 0, sizeof(tmpl->mark));
 
-	return tmpl.ct != NULL && tmpl.exptuple != NULL &&
-	       tmpl.mask != NULL && tmpl.exp != NULL;
+	cur_tmpl = tmpl;
+
+	return tmpl->ct != NULL && tmpl->exptuple != NULL &&
+	       tmpl->mask != NULL && tmpl->exp != NULL;
 }
 
-static void free_tmpl_objects(void)
+static void free_tmpl_objects(struct ct_tmpl *tmpl)
 {
-	if (tmpl.ct)
-		nfct_destroy(tmpl.ct);
-	if (tmpl.exptuple)
-		nfct_destroy(tmpl.exptuple);
-	if (tmpl.mask)
-		nfct_destroy(tmpl.mask);
-	if (tmpl.exp)
-		nfexp_destroy(tmpl.exp);
-	if (tmpl.label)
-		nfct_bitmask_destroy(tmpl.label);
-	if (tmpl.label_modify)
-		nfct_bitmask_destroy(tmpl.label_modify);
+	if (tmpl->ct)
+		nfct_destroy(tmpl->ct);
+	if (tmpl->exptuple)
+		nfct_destroy(tmpl->exptuple);
+	if (tmpl->mask)
+		nfct_destroy(tmpl->mask);
+	if (tmpl->exp)
+		nfexp_destroy(tmpl->exp);
+	if (tmpl->label)
+		nfct_bitmask_destroy(tmpl->label);
+	if (tmpl->label_modify)
+		nfct_bitmask_destroy(tmpl->label_modify);
 }
 
 enum ct_command {
@@ -945,7 +949,7 @@ exit_error(enum exittype status, const char *msg, ...)
 	if (status == PARAMETER_PROBLEM)
 		exit_tryhelp(status);
 	/* release template objects that were allocated in the setup stage. */
-	free_tmpl_objects();
+	free_tmpl_objects(cur_tmpl);
 	exit(status);
 }
 
@@ -1458,17 +1462,17 @@ usage(char *prog)
 static unsigned int output_mask;
 
 static int
-filter_label(const struct nf_conntrack *ct)
+filter_label(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 {
-	if (tmpl.label == NULL)
+	if (tmpl->label == NULL)
 		return 0;
 
 	const struct nfct_bitmask *ctb = nfct_get_attr(ct, ATTR_CONNLABELS);
 	if (ctb == NULL)
 		return 1;
 
-	for (unsigned int i = 0; i <= nfct_bitmask_maxbit(tmpl.label); i++) {
-		if (nfct_bitmask_test_bit(tmpl.label, i) &&
+	for (unsigned int i = 0; i <= nfct_bitmask_maxbit(tmpl->label); i++) {
+		if (nfct_bitmask_test_bit(tmpl->label, i) &&
 		    !nfct_bitmask_test_bit(ctb, i))
 				return 1;
 	}
@@ -1477,10 +1481,10 @@ filter_label(const struct nf_conntrack *ct)
 }
 
 static int
-filter_mark(const struct nf_conntrack *ct)
+filter_mark(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 {
 	if ((options & CT_OPT_MARK) &&
-	     !mark_cmp(&tmpl.mark, ct))
+	     !mark_cmp(&tmpl->mark, ct))
 		return 1;
 	return 0;
 }
@@ -1626,11 +1630,12 @@ filter_network(const struct nf_conntrack *ct)
 }
 
 static int
-nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct)
+nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct,
+	    const struct ct_tmpl *tmpl)
 {
 	if (filter_nat(obj, ct) ||
-	    filter_mark(ct) ||
-	    filter_label(ct) ||
+	    filter_mark(ct, tmpl) ||
+	    filter_label(ct, tmpl) ||
 	    filter_network(ct))
 		return 1;
 
@@ -1870,7 +1875,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	if ((filter_family != AF_UNSPEC &&
 	     filter_family != nfh->nfgen_family) ||
-	    nfct_filter(obj, ct))
+	    nfct_filter(obj, ct, cur_tmpl))
 		goto out;
 
 	if (output_mask & _O_SAVE) {
@@ -1930,7 +1935,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct))
+	if (nfct_filter(obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	if (output_mask & _O_SAVE) {
@@ -1972,7 +1977,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct))
+	if (nfct_filter(obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
@@ -2058,7 +2063,8 @@ static struct nfct_bitmask *xnfct_bitmask_clone(const struct nfct_bitmask *a)
 	return b;
 }
 
-static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
+static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct,
+		       const struct ct_tmpl *tmpl)
 {
 	struct nfct_bitmask *ctb, *newmask;
 	unsigned int i;
@@ -2072,7 +2078,7 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 	if (options & CT_OPT_ADD_LABEL) {
 		if (ctb == NULL) {
 			nfct_set_attr(tmp, ATTR_CONNLABELS,
-					xnfct_bitmask_clone(tmpl.label_modify));
+					xnfct_bitmask_clone(tmpl->label_modify));
 			return;
 		}
 		/* If we send a bitmask shorter than the kernel sent to us, the bits we
@@ -2086,7 +2092,7 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		newmask = nfct_bitmask_new(nfct_bitmask_maxbit(ctb));
 
 		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
-			if (nfct_bitmask_test_bit(tmpl.label_modify, i)) {
+			if (nfct_bitmask_test_bit(tmpl->label_modify, i)) {
 				nfct_bitmask_set_bit(ctb, i);
 				nfct_bitmask_set_bit(newmask, i);
 			} else if (nfct_bitmask_test_bit(ctb, i)) {
@@ -2099,7 +2105,7 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
 	} else if (ctb != NULL) {
 		/* CT_OPT_DEL_LABEL */
-		if (tmpl.label_modify == NULL) {
+		if (tmpl->label_modify == NULL) {
 			newmask = nfct_bitmask_new(0);
 			if (newmask)
 				nfct_set_attr(tmp, ATTR_CONNLABELS, newmask);
@@ -2107,11 +2113,11 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		}
 
 		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
-			if (nfct_bitmask_test_bit(tmpl.label_modify, i))
+			if (nfct_bitmask_test_bit(tmpl->label_modify, i))
 				nfct_bitmask_unset_bit(ctb, i);
 		}
 
-		newmask = xnfct_bitmask_clone(tmpl.label_modify);
+		newmask = xnfct_bitmask_clone(tmpl->label_modify);
 		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
 	}
 }
@@ -2124,7 +2130,7 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	struct nf_conntrack *obj = data, *tmp;
 
 	if (filter_nat(obj, ct) ||
-	    filter_label(ct) ||
+	    filter_label(ct, cur_tmpl) ||
 	    filter_network(ct))
 		return NFCT_CB_CONTINUE;
 
@@ -2143,9 +2149,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 
 	nfct_copy(tmp, ct, NFCT_CP_ORIG);
 	nfct_copy(tmp, obj, NFCT_CP_META);
-	copy_mark(tmp, ct, &tmpl.mark);
+	copy_mark(tmp, ct, &cur_tmpl->mark);
 	copy_status(tmp, ct);
-	copy_label(tmp, ct);
+	copy_label(tmp, ct, cur_tmpl);
 
 	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
 	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
@@ -2578,7 +2584,8 @@ static void labelmap_init(void)
 }
 
 static void
-nfct_network_attr_prepare(const int family, enum ct_direction dir)
+nfct_network_attr_prepare(const int family, enum ct_direction dir,
+			  const struct ct_tmpl *tmpl)
 {
 	const union ct_address *address, *netmask;
 	enum nf_conntrack_attr attr;
@@ -2587,8 +2594,8 @@ nfct_network_attr_prepare(const int family, enum ct_direction dir)
 
 	attr = famdir2attr[family == AF_INET6][dir];
 
-	address = nfct_get_attr(tmpl.ct, attr);
-	netmask = nfct_get_attr(tmpl.mask, attr);
+	address = nfct_get_attr(tmpl->ct, attr);
+	netmask = nfct_get_attr(tmpl->mask, attr);
 
 	switch(family) {
 	case AF_INET:
@@ -2603,11 +2610,11 @@ nfct_network_attr_prepare(const int family, enum ct_direction dir)
 	memcpy(&net->netmask, netmask, sizeof(union ct_address));
 
 	/* avoid exact source matching */
-	nfct_attr_unset(tmpl.ct, attr);
+	nfct_attr_unset(tmpl->ct, attr);
 }
 
 static void
-nfct_filter_init(const int family)
+nfct_filter_init(const int family, const struct ct_tmpl *tmpl)
 {
 	filter_family = family;
 	if (options & CT_OPT_MASK_SRC) {
@@ -2615,7 +2622,7 @@ nfct_filter_init(const int family)
 		if (!(options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-src without --src");
-		nfct_network_attr_prepare(family, DIR_SRC);
+		nfct_network_attr_prepare(family, DIR_SRC, tmpl);
 	}
 
 	if (options & CT_OPT_MASK_DST) {
@@ -2623,7 +2630,7 @@ nfct_filter_init(const int family)
 		if (!(options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-dst without --dst");
-		nfct_network_attr_prepare(family, DIR_DST);
+		nfct_network_attr_prepare(family, DIR_DST, tmpl);
 	}
 }
 
@@ -2770,6 +2777,7 @@ struct ct_cmd {
 	int		family;
 	int		protonum;
 	size_t		socketbuffersize;
+	struct ct_tmpl	tmpl;
 };
 
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
@@ -2778,10 +2786,17 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	int protonum = 0, family = AF_UNSPEC;
 	size_t socketbuffersize = 0;
 	unsigned int command = 0;
+	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
 	int c, cmd;
 
+	/* we release these objects in the exit_error() path. */
+	if (!alloc_tmpl_objects(&ct_cmd->tmpl))
+		exit_error(OTHER_PROBLEM, "out of memory");
+
+	tmpl = &ct_cmd->tmpl;
+
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
 
@@ -2835,17 +2850,17 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.ct,
-						 tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(c, optarg, tmpl->ct,
+						 tmpl->mask, &ad, &family);
 			break;
 		case '[':
 		case ']':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.exptuple,
-						 tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(c, optarg, tmpl->exptuple,
+						 tmpl->mask, &ad, &family);
 			break;
 		case '{':
 		case '}':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.mask,
+			nfct_parse_addr_from_opt(c, optarg, tmpl->mask,
 						 NULL, &ad, &family);
 			break;
 		case 'p':
@@ -2860,18 +2875,18 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			if (opts == NULL)
 				exit_error(OTHER_PROBLEM, "out of memory");
 
-			nfct_set_attr_u8(tmpl.ct, ATTR_L4PROTO, protonum);
+			nfct_set_attr_u8(tmpl->ct, ATTR_L4PROTO, protonum);
 			break;
 		case 't':
 			options |= CT_OPT_TIMEOUT;
-			nfct_set_attr_u32(tmpl.ct, ATTR_TIMEOUT, atol(optarg));
-			nfexp_set_attr_u32(tmpl.exp,
+			nfct_set_attr_u32(tmpl->ct, ATTR_TIMEOUT, atol(optarg));
+			nfexp_set_attr_u32(tmpl->exp,
 					   ATTR_EXP_TIMEOUT, atol(optarg));
 			break;
 		case 'u':
 			options |= CT_OPT_STATUS;
 			parse_parameter(optarg, &status, PARSE_STATUS);
-			nfct_set_attr_u32(tmpl.ct, ATTR_STATUS, status);
+			nfct_set_attr_u32(tmpl->ct, ATTR_STATUS, status);
 			break;
 		case 'e':
 			options |= CT_OPT_EVENT_MASK;
@@ -2904,18 +2919,18 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 						       &nat_address,
 						       &port_str);
 				nfct_parse_addr_from_opt(c, nat_address,
-							 tmpl.ct, NULL,
+							 tmpl->ct, NULL,
 							 &ad, &family);
 				if (c == 'j') {
 					/* Set details on both src and dst
 					 * with any-nat
 					 */
-					nfct_set_nat_details('g', tmpl.ct, &ad,
+					nfct_set_nat_details('g', tmpl->ct, &ad,
 							     port_str, family);
-					nfct_set_nat_details('n', tmpl.ct, &ad,
+					nfct_set_nat_details('n', tmpl->ct, &ad,
 							     port_str, family);
 				} else {
-					nfct_set_nat_details(c, tmpl.ct, &ad,
+					nfct_set_nat_details(c, tmpl->ct, &ad,
 							     port_str, family);
 				}
 			}
@@ -2924,23 +2939,23 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case '(':
 		case ')':
 			options |= opt2type[c];
-			nfct_set_attr_u16(tmpl.ct,
+			nfct_set_attr_u16(tmpl->ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
 			break;
 		case 'i':
 		case 'c':
 			options |= opt2type[c];
-			nfct_set_attr_u32(tmpl.ct,
+			nfct_set_attr_u32(tmpl->ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
 			break;
 		case 'm':
 			options |= opt2type[c];
-			parse_u32_mask(optarg, &tmpl.mark);
-			tmpl.filter_mark_kernel.val = tmpl.mark.value;
-			tmpl.filter_mark_kernel.mask = tmpl.mark.mask;
-			tmpl.filter_mark_kernel_set = true;
+			parse_u32_mask(optarg, &tmpl->mark);
+			tmpl->filter_mark_kernel.val = tmpl->mark.value;
+			tmpl->filter_mark_kernel.mask = tmpl->mark.mask;
+			tmpl->filter_mark_kernel_set = true;
 			break;
 		case 'l':
 		case '<':
@@ -2971,9 +2986,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 			/* join "-l foo -l bar" into single bitmask object */
 			if (c == 'l') {
-				merge_bitmasks(&tmpl.label, b);
+				merge_bitmasks(&tmpl->label, b);
 			} else {
-				merge_bitmasks(&tmpl.label_modify, b);
+				merge_bitmasks(&tmpl->label_modify, b);
 			}
 
 			free(optarg2);
@@ -3006,10 +3021,10 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 				   "unknown option `%s'", argv[optind-1]);
 			break;
 		default:
-			if (h && h->parse_opts 
-			    &&!h->parse_opts(c - h->option_offset, tmpl.ct,
-			    		     tmpl.exptuple, tmpl.mask,
-					     &l4flags))
+			if (h && h->parse_opts &&
+			    !h->parse_opts(c - h->option_offset, tmpl->ct,
+					   tmpl->exptuple, tmpl->mask,
+					   &l4flags))
 				exit_error(PARAMETER_PROBLEM, "parse error");
 			break;
 		}
@@ -3058,7 +3073,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		}
 	}
 	if (!(command & CT_HELP) && h && h->final_check)
-		h->final_check(l4flags, cmd, tmpl.ct);
+		h->final_check(l4flags, cmd, tmpl->ct);
 
 	ct_cmd->command = command;
 	ct_cmd->cmd = cmd;
@@ -3074,10 +3089,6 @@ int main(int argc, char *argv[])
 	struct ct_cmd _cmd = {}, *cmd = &_cmd;
 	int res = 0;
 
-	/* we release these objects in the exit_error() path. */
-	if (!alloc_tmpl_objects())
-		exit_error(OTHER_PROBLEM, "out of memory");
-
 	register_tcp();
 	register_udp();
 	register_udplite();
@@ -3125,18 +3136,18 @@ int main(int argc, char *argv[])
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
 
-		nfct_filter_init(cmd->family);
+		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
 
-		if (tmpl.filter_mark_kernel_set) {
+		if (cmd->tmpl.filter_mark_kernel_set) {
 			nfct_filter_dump_set_attr(filter_dump,
 						  NFCT_FILTER_DUMP_MARK,
-						  &tmpl.filter_mark_kernel);
+						  &cmd->tmpl.filter_mark_kernel);
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
@@ -3175,37 +3186,37 @@ int main(int argc, char *argv[])
 
 	case CT_CREATE:
 		if ((options & CT_OPT_ORIG) && !(options & CT_OPT_REPL))
-		    	nfct_setobjopt(tmpl.ct, NFCT_SOPT_SETUP_REPLY);
+			nfct_setobjopt(cmd->tmpl.ct, NFCT_SOPT_SETUP_REPLY);
 		else if (!(options & CT_OPT_ORIG) && (options & CT_OPT_REPL))
-			nfct_setobjopt(tmpl.ct, NFCT_SOPT_SETUP_ORIGINAL);
+			nfct_setobjopt(cmd->tmpl.ct, NFCT_SOPT_SETUP_ORIGINAL);
 
 		if (options & CT_OPT_MARK)
-			nfct_set_attr_u32(tmpl.ct, ATTR_MARK, tmpl.mark.value);
+			nfct_set_attr_u32(cmd->tmpl.ct, ATTR_MARK, cmd->tmpl.mark.value);
 
 		if (options & CT_OPT_ADD_LABEL)
-			nfct_set_attr(tmpl.ct, ATTR_CONNLABELS,
-					xnfct_bitmask_clone(tmpl.label_modify));
+			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
+					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		res = nfct_query(cth, NFCT_Q_CREATE, tmpl.ct);
+		res = nfct_query(cth, NFCT_Q_CREATE, cmd->tmpl.ct);
 		if (res != -1)
 			counter++;
 		nfct_close(cth);
 		break;
 
 	case EXP_CREATE:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASTER, tmpl.ct);
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.exptuple);
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASK, tmpl.mask);
+		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_MASTER, cmd->tmpl.ct);
+		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_EXPECTED, cmd->tmpl.exptuple);
+		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_MASK, cmd->tmpl.mask);
 
 		cth = nfct_open(EXPECT, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		res = nfexp_query(cth, NFCT_Q_CREATE, tmpl.exp);
+		res = nfexp_query(cth, NFCT_Q_CREATE, cmd->tmpl.exp);
 		nfct_close(cth);
 		break;
 
@@ -3216,9 +3227,9 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family);
+		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd->tmpl.ct);
 
 		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(ith);
@@ -3231,18 +3242,18 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family);
+		nfct_filter_init(cmd->family, &cmd->tmpl);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd->tmpl.ct);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
 			exit_error(OTHER_PROBLEM, "OOM");
 
-		if (tmpl.filter_mark_kernel_set) {
+		if (cmd->tmpl.filter_mark_kernel_set) {
 			nfct_filter_dump_set_attr(filter_dump,
 						  NFCT_FILTER_DUMP_MARK,
-						  &tmpl.filter_mark_kernel);
+						  &cmd->tmpl.filter_mark_kernel);
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
@@ -3257,13 +3268,13 @@ int main(int argc, char *argv[])
 		break;
 
 	case EXP_DELETE:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.ct);
+		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_EXPECTED, cmd->tmpl.ct);
 
 		cth = nfct_open(EXPECT, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		res = nfexp_query(cth, NFCT_Q_DESTROY, tmpl.exp);
+		res = nfexp_query(cth, NFCT_Q_DESTROY, cmd->tmpl.exp);
 		nfct_close(cth);
 		break;
 
@@ -3272,20 +3283,20 @@ int main(int argc, char *argv[])
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
-		res = nfct_query(cth, NFCT_Q_GET, tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
+		res = nfct_query(cth, NFCT_Q_GET, cmd->tmpl.ct);
 		nfct_close(cth);
 		break;
 
 	case EXP_GET:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASTER, tmpl.ct);
+		nfexp_set_attr(cmd->tmpl.exp, ATTR_EXP_MASTER, cmd->tmpl.ct);
 
 		cth = nfct_open(EXPECT, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_GET, tmpl.exp);
+		res = nfexp_query(cth, NFCT_Q_GET, cmd->tmpl.exp);
 		nfct_close(cth);
 		break;
 
@@ -3377,7 +3388,7 @@ int main(int argc, char *argv[])
 					   strerror(errno));
 				break;
 			}
-			res = mnl_cb_run(buf, res, 0, 0, event_cb, tmpl.ct);
+			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd->tmpl.ct);
 		}
 		mnl_socket_close(sock.mnl);
 		break;
@@ -3510,7 +3521,7 @@ try_proc:
 		exit_error(OTHER_PROBLEM, "Operation failed: %s",
 			   err2str(errno, cmd->command));
 
-	free_tmpl_objects();
+	free_tmpl_objects(&cmd->tmpl);
 	free_options();
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
-- 
2.20.1

