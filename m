Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BA8C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD04264E06
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhA2V0J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbhA2VZ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:25:58 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8CC06174A
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:17 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id g12so14987942ejf.8
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YubcwJXXkiJc7BfPcfZ5LcRhlXUjrrhcjqHpifWX72U=;
        b=exGa7Q11k3VhikksMo5eK7Dlv7cwdtMga4CGgRWN5ReDmIVHTCY3iJ8dyoY/wGRoga
         BPh+RZwt3BF2i5364M7/ebtq6tYxK00ftfutVqJAq3Z5j1zPctV/OYsrs0VTAO9hZk2c
         Bf3MHSVFNQRv0lcYpbDJYiHc/IIydo4D6Z5bVy8BEzAjfNdD5sov3I877DKO97YpnMb7
         ySw2GAu3T856F6cFtoaZ9n1qct+c/2/Wg5EA+I6P5Gk1INWMdFRYbriUaT3gc8yuEbtp
         sKPRDXxG5C8TsmjtLzBQnS1a+IubFIQ2Fp/gnWa63fcM2g9QCuCnPkgs02myv7T+RLFo
         fF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YubcwJXXkiJc7BfPcfZ5LcRhlXUjrrhcjqHpifWX72U=;
        b=RBL6MJSijuAfi4ALGdVLsSDLtjxzYwHOTOdaYKd2oA0V0FeacV+py37WnHz8yDUlYX
         YaP9xSRcZg0TjVGpI7Dgu51B+gIDgw+KQrv8M5jLthFUQaDgNE+aDPn7QICq5nDmY1C+
         6K50fFchrA2FtwVAexGs2VDNbaNvtbzTKrxWvoukO66G0ztg7n9Hd8B0ZtITADFW4Ppi
         Vva2Fv7ApjR7sBfAgcY28dbq5oMi68KrK1ZlZETQ1EF1sToYkbHJ2L4dkhBqc35L6vF5
         y52h1xv1MyFkNWAGnbg61Ma49EGzARCl6Qa62GuYLIBVWy8ZuIctjmiFDViRyopQdHiA
         /Dng==
X-Gm-Message-State: AOAM533joLastib6v5mAFQsMyeMURtm0p3xoP9Uuo6vjUQRqdVirudQQ
        3d3yGbXh7T8ui9eWbiestbimaIH1L+3OVg==
X-Google-Smtp-Source: ABdhPJyt/1F+vaxj2hYHmhCub8fgSEfDUSmf44N3NLRUk6NE84hjOxllkTJtHlPNEjUUd8fbL+LXHA==
X-Received: by 2002:a17:906:3c41:: with SMTP id i1mr6557051ejg.443.1611955516099;
        Fri, 29 Jan 2021 13:25:16 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:15 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 2/8] conntrack: move global options to struct ct_cmd
Date:   Fri, 29 Jan 2021 22:24:46 +0100
Message-Id: <20210129212452.45352-3-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a multicommand support preparation options must be done
per-command es well.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 src/conntrack.c | 205 ++++++++++++++++++++++++++----------------------
 1 file changed, 113 insertions(+), 92 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index c582d86..a090542 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -600,7 +600,6 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 
 static LIST_HEAD(proto_list);
 
-static unsigned int options;
 static struct nfct_labelmap *labelmap;
 static int filter_family;
 
@@ -1460,6 +1459,19 @@ static void usage(const char *prog)
 
 static unsigned int output_mask;
 
+struct ct_cmd {
+	struct list_head list_entry;
+	unsigned int	command;
+	unsigned int	cmd;
+	int             options;
+	unsigned int	type;
+	unsigned int	event_mask;
+	int		family;
+	int		protonum;
+	size_t		socketbuffersize;
+	struct ct_tmpl	tmpl;
+};
+
 static int
 filter_label(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 {
@@ -1480,24 +1492,27 @@ filter_label(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 }
 
 static int
-filter_mark(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
+filter_mark(const struct ct_cmd *cmd,
+		const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 {
-	if ((options & CT_OPT_MARK) &&
+	if ((cmd->options & CT_OPT_MARK) &&
 	     !mark_cmp(&tmpl->mark, ct))
 		return 1;
 	return 0;
 }
 
 static int 
-filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
+filter_nat(const struct ct_cmd *cmd,
+		const struct nf_conntrack *obj,
+		const struct nf_conntrack *ct)
 {
-	int check_srcnat = options & CT_OPT_SRC_NAT ? 1 : 0;
-	int check_dstnat = options & CT_OPT_DST_NAT ? 1 : 0;
+	int check_srcnat = cmd->options & CT_OPT_SRC_NAT ? 1 : 0;
+	int check_dstnat = cmd->options & CT_OPT_DST_NAT ? 1 : 0;
 	int has_srcnat = 0, has_dstnat = 0;
 	uint32_t ip;
 	uint16_t port;
 
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		check_srcnat = check_dstnat = 1;
 
 	if (check_srcnat) {
@@ -1560,13 +1575,14 @@ filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 		     nfct_getobjopt(ct, NFCT_GOPT_IS_DPAT)))
 			has_dstnat = 1;
 	}
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		return !(has_srcnat || has_dstnat);
-	else if ((options & CT_OPT_SRC_NAT) && (options & CT_OPT_DST_NAT))
+	else if ((cmd->options & CT_OPT_SRC_NAT)
+			&& (cmd->options & CT_OPT_DST_NAT))
 		return !(has_srcnat && has_dstnat);
-	else if (options & CT_OPT_SRC_NAT)
+	else if (cmd->options & CT_OPT_SRC_NAT)
 		return !has_srcnat;
-	else if (options & CT_OPT_DST_NAT)
+	else if (cmd->options & CT_OPT_DST_NAT)
 		return !has_dstnat;
 
 	return 0;
@@ -1614,14 +1630,14 @@ nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_direction d
 }
 
 static int
-filter_network(const struct nf_conntrack *ct)
+filter_network(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
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
@@ -1629,16 +1645,18 @@ filter_network(const struct nf_conntrack *ct)
 }
 
 static int
-nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct,
+nfct_filter(const struct ct_cmd *cmd,
+		const struct nf_conntrack *obj,
+		struct nf_conntrack *ct,
 	    const struct ct_tmpl *tmpl)
 {
-	if (filter_nat(obj, ct) ||
-	    filter_mark(ct, tmpl) ||
+	if (filter_nat(cmd, obj, ct) ||
+	    filter_mark(cmd, ct, tmpl) ||
 	    filter_label(ct, tmpl) ||
-	    filter_network(ct))
+	    filter_network(cmd, ct))
 		return 1;
 
-	if (options & CT_COMPARISON &&
+	if (cmd->options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return 1;
 
@@ -1843,7 +1861,8 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 	unsigned int op_type = NFCT_O_DEFAULT;
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	enum nf_conntrack_msg_type type;
 	unsigned int op_flags = 0;
 	struct nf_conntrack *ct;
@@ -1874,7 +1893,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	if ((filter_family != AF_UNSPEC &&
 	     filter_family != nfh->nfgen_family) ||
-	    nfct_filter(obj, ct, cur_tmpl))
+	    nfct_filter(cmd, obj, ct, cur_tmpl))
 		goto out;
 
 	if (output_mask & _O_SAVE) {
@@ -1930,11 +1949,12 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   void *data)
 {
 	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct, cur_tmpl))
+	if (nfct_filter(cmd, obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	if (output_mask & _O_SAVE) {
@@ -1972,11 +1992,12 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 {
 	int res;
 	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct, cur_tmpl))
+	if (nfct_filter(cmd, obj, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
@@ -2033,20 +2054,23 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static void copy_mark(struct nf_conntrack *tmp,
+static void copy_mark(const struct ct_cmd *cmd,
+		      struct nf_conntrack *tmp,
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
+static void copy_status(const struct ct_cmd *cmd,
+		      struct nf_conntrack *tmp,
+		      const struct nf_conntrack *ct)
 {
-	if (options & CT_OPT_STATUS) {
+	if (cmd->options & CT_OPT_STATUS) {
 		/* copy existing flags, we only allow setting them. */
 		uint32_t status = nfct_get_attr_u32(ct, ATTR_STATUS);
 		status |= nfct_get_attr_u32(tmp, ATTR_STATUS);
@@ -2062,19 +2086,21 @@ static struct nfct_bitmask *xnfct_bitmask_clone(const struct nfct_bitmask *a)
 	return b;
 }
 
-static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct,
-		       const struct ct_tmpl *tmpl)
+static void copy_label(const struct ct_cmd *cmd,
+		      struct nf_conntrack *tmp,
+			  const struct nf_conntrack *ct,
+		      const struct ct_tmpl *tmpl)
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
@@ -2126,20 +2152,21 @@ static int update_cb(enum nf_conntrack_msg_type type,
 		     void *data)
 {
 	int res;
-	struct nf_conntrack *obj = data, *tmp;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->tmpl.ct, *tmp;
 
-	if (filter_nat(obj, ct) ||
+	if (filter_nat(cmd, obj, ct) ||
 	    filter_label(ct, cur_tmpl) ||
-	    filter_network(ct))
+	    filter_network(cmd, ct))
 		return NFCT_CB_CONTINUE;
 
 	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
 	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
 	    	return NFCT_CB_CONTINUE;
 
-	if (options & CT_OPT_TUPLE_ORIG && !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
+	if (cmd->options & CT_OPT_TUPLE_ORIG && !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
 		return NFCT_CB_CONTINUE;
-	if (options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
+	if (cmd->options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
 		return NFCT_CB_CONTINUE;
 
 	tmp = nfct_new();
@@ -2148,9 +2175,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 
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
@@ -2613,23 +2640,23 @@ nfct_network_attr_prepare(const int family, enum ct_direction dir,
 }
 
 static void
-nfct_filter_init(const int family, const struct ct_tmpl *tmpl)
+nfct_filter_init(struct ct_cmd *cmd)
 {
-	filter_family = family;
-	if (options & CT_OPT_MASK_SRC) {
-		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_SRC))
+	filter_family = cmd->family;
+	if (cmd->options & CT_OPT_MASK_SRC) {
+		assert(cmd->family != AF_UNSPEC);
+		if (!(cmd->options & CT_OPT_ORIG_SRC))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-src without --src");
-		nfct_network_attr_prepare(family, DIR_SRC, tmpl);
+		nfct_network_attr_prepare(cmd->family, DIR_SRC, &cmd->tmpl);
 	}
 
-	if (options & CT_OPT_MASK_DST) {
-		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_DST))
+	if (cmd->options & CT_OPT_MASK_DST) {
+		assert(cmd->family != AF_UNSPEC);
+		if (!(cmd->options & CT_OPT_ORIG_DST))
 			exit_error(PARAMETER_PROBLEM,
 			           "Can't use --mask-dst without --dst");
-		nfct_network_attr_prepare(family, DIR_DST, tmpl);
+		nfct_network_attr_prepare(cmd->family, DIR_DST, &cmd->tmpl);
 	}
 }
 
@@ -2696,16 +2723,19 @@ nfct_set_addr_only(const int opt, struct nf_conntrack *ct, union ct_address *ad,
 }
 
 static void
-nfct_set_addr_opt(const int opt, struct nf_conntrack *ct, union ct_address *ad,
-		  const int l3protonum)
+nfct_set_addr_opt(unsigned int *options,
+			 const int opt,
+			 struct nf_conntrack *ct,
+			 union ct_address *ad,
+			 const int l3protonum)
 {
-	options |= opt2type[opt];
+	*options |= opt2type[opt];
 	nfct_set_addr_only(opt, ct, ad, l3protonum);
 	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
 }
 
 static void
-nfct_parse_addr_from_opt(const int opt, const char *arg,
+nfct_parse_addr_from_opt(unsigned int *options, const int opt, const char *arg,
 			 struct nf_conntrack *ct,
 			 struct nf_conntrack *ctmask,
 			 union ct_address *ad, int *family)
@@ -2728,7 +2758,7 @@ nfct_parse_addr_from_opt(const int opt, const char *arg,
 		           "Invalid netmask");
 	}
 
-	nfct_set_addr_opt(opt, ct, ad, l3protonum);
+	nfct_set_addr_opt(options, opt, ct, ad, l3protonum);
 
 	/* bail if we don't have a netmask to set*/
 	if (mask == -1 || !maskopt || ctmask == NULL)
@@ -2747,7 +2777,7 @@ nfct_parse_addr_from_opt(const int opt, const char *arg,
 		break;
 	}
 
-	nfct_set_addr_opt(maskopt, ctmask, ad, l3protonum);
+	nfct_set_addr_opt(options, maskopt, ctmask, ad, l3protonum);
 }
 
 static void
@@ -2768,23 +2798,13 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 
 }
 
-struct ct_cmd {
-	unsigned int	command;
-	unsigned int	cmd;
-	unsigned int	type;
-	unsigned int	event_mask;
-	int		family;
-	int		protonum;
-	size_t		socketbuffersize;
-	struct ct_tmpl	tmpl;
-};
-
 static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
 	int protonum = 0, family = AF_UNSPEC;
 	size_t socketbuffersize = 0;
 	unsigned int command = 0;
+	unsigned int options = 0;
 	struct ct_tmpl *tmpl;
 	int res = 0, partial;
 	union ct_address ad;
@@ -2851,17 +2871,17 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			nfct_parse_addr_from_opt(c, optarg, tmpl->ct,
+			nfct_parse_addr_from_opt(&options, c, optarg, tmpl->ct,
 						 tmpl->mask, &ad, &family);
 			break;
 		case '[':
 		case ']':
-			nfct_parse_addr_from_opt(c, optarg, tmpl->exptuple,
+			nfct_parse_addr_from_opt(&options, c, optarg, tmpl->exptuple,
 						 tmpl->mask, &ad, &family);
 			break;
 		case '{':
 		case '}':
-			nfct_parse_addr_from_opt(c, optarg, tmpl->mask,
+			nfct_parse_addr_from_opt(&options, c, optarg, tmpl->mask,
 						 NULL, &ad, &family);
 			break;
 		case 'p':
@@ -2919,7 +2939,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 				split_address_and_port(optional_arg,
 						       &nat_address,
 						       &port_str);
-				nfct_parse_addr_from_opt(c, nat_address,
+				nfct_parse_addr_from_opt(&options, c, nat_address,
 							 tmpl->ct, NULL,
 							 &ad, &family);
 				if (c == 'j') {
@@ -3078,6 +3098,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 
 	ct_cmd->command = command;
 	ct_cmd->cmd = cmd;
+	ct_cmd->options = options;
 	ct_cmd->family = family;
 	ct_cmd->type = type;
 	ct_cmd->protonum = protonum;
@@ -3118,14 +3139,14 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		if (options & CT_COMPARISON && 
-		    options & CT_OPT_ZERO)
+		if (cmd->options & CT_COMPARISON &&
+			cmd->options & CT_OPT_ZERO)
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
@@ -3140,7 +3161,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					     NFCT_FILTER_DUMP_L3NUM,
 					     cmd->family);
 
-		if (options & CT_OPT_ZERO)
+		if (cmd->options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
 					filter_dump);
 		else
@@ -3172,15 +3193,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
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
 
@@ -3214,9 +3235,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
 
 		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(ith);
@@ -3229,9 +3250,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
@@ -3270,7 +3291,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd->tmpl.ct);
+		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, cmd);
 		res = nfct_query(cth, NFCT_Q_GET, cmd->tmpl.ct);
 		nfct_close(cth);
 		break;
@@ -3308,7 +3329,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
 			if (cmd->event_mask & CT_EVENT_F_NEW)
@@ -3328,7 +3349,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		if (options & CT_OPT_BUFFERSIZE) {
+		if (cmd->options & CT_OPT_BUFFERSIZE) {
 			size_t socketbuffersize = cmd->socketbuffersize;
 
 			socklen_t socklen = sizeof(socketbuffersize);
@@ -3350,7 +3371,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					socketbuffersize);
 		}
 
-		nfct_filter_init(cmd->family, &cmd->tmpl);
+		nfct_filter_init(cmd);
 
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
@@ -3375,13 +3396,13 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 					   strerror(errno));
 				break;
 			}
-			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd->tmpl.ct);
+			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
 		mnl_socket_close(sock.mnl);
 		break;
 
 	case EXP_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
 			if (cmd->event_mask & CT_EVENT_F_NEW)
@@ -3496,7 +3517,7 @@ try_proc:
 		break;
 	case CT_HELP:
 		usage(progname);
-		if (options & CT_OPT_PROTO)
+		if (cmd->options & CT_OPT_PROTO)
 			extension_help(h, cmd->protonum);
 		break;
 	default:
-- 
2.25.1

