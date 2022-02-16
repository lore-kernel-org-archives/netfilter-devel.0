Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9AEC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiBPS7d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 13:59:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiBPS7d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 13:59:33 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1792AD677
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id u18so5548263edt.6
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4dpLP6PDSzzpB4LSGv/1IQpTBV62dzfCuyzoMucloco=;
        b=ZlszMg6L57PDnvf5QZVK35wj4TPImB+lwc+ZKTgUBMDhFMDtDDi/fq4kgfbDDfSNh5
         /dFRCboN0UdKmF5XQCFxsJ7K+yQq+ijqw6qcv7+qlAH3yX6s3h6DYO/Rp5WwTkDKNHsu
         nwUpGctGaLe+y+wqPfxwoBv2FpIAGa424h9hH4UewuowgHZGN82c1E7Htf90sv0Hvaxm
         01CGy2aanlI3CISwi3fBeNx62HxEDanJa6MwshInfx4j/zk06BPbrSCXeg6eWqndhSrw
         KIaSbLLoRnvUrqwQPWcmXL/0md00Yyh8M+ei2ON+q7h1N7ABuybfNO3iWw1waNMCH7jq
         QtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4dpLP6PDSzzpB4LSGv/1IQpTBV62dzfCuyzoMucloco=;
        b=60+PJhIFYEO252NF+FiJB1t+hKItSNSWph19VBJk7jYCrk2cNYJq30tc1uwCezGLKB
         Vp9yoVV/EQRr6ej47wS1DjCpNeO1y4+GweLIqTMEfDVZmI0gVPCQmg1fQn+kdIyHdbAI
         R8EgxHO8VC14d+7gPRoL25dCGiBvVJYbcC9eQxE6WKtxzZJymhxYpxJPLqOPASmSvAhv
         He9ae+iC3JSFUEaTKcqLRzY2dnfYy/TJyw99rzdZCdjTNtpqAU0P+HBptSFESnKO0uuj
         wuK87xZhtqKESFwCyBE8gLatwYmM1m+xhZgazfCM0gqBpIU8yX/U0cCpx7hDjA/POK4S
         TG0A==
X-Gm-Message-State: AOAM530Dbhkh2T0ZWFWqrHLFeh+LBqKJG5J5dlgg9oySwJ+WCgn0hO2q
        7GjaO1v50MCKtshsDswMCtLvelAQmpCnfQ==
X-Google-Smtp-Source: ABdhPJxVicNYFiaTFd9nn8mJcgtq3isEC7Jm/mn2HS8gG5v4qK1JpBWl1cgz5CEnQgTEnsmBElWOWA==
X-Received: by 2002:a05:6402:4495:b0:410:a171:4444 with SMTP id er21-20020a056402449500b00410a1714444mr4605618edb.20.1645037958728;
        Wed, 16 Feb 2022 10:59:18 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf784.dynamic.kabel-deutschland.de. [95.91.247.132])
        by smtp.gmail.com with ESMTPSA id dz8sm2156167edb.96.2022.02.16.10.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:59:17 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 1/3] conntrack: use libmnl for updating conntrack table
Date:   Wed, 16 Feb 2022 19:58:24 +0100
Message-Id: <20220216185826.48218-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
References: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to update the conntrack
table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 268 +++++++++++++++++++++++++++++-------------------
 1 file changed, 163 insertions(+), 105 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index fe5574d..161e6a5 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -68,10 +68,13 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
-static struct nfct_mnl_socket {
+struct nfct_mnl_socket {
 	struct mnl_socket	*mnl;
 	uint32_t		portid;
-} _sock;
+};
+
+static struct nfct_mnl_socket _sock;
+static struct nfct_mnl_socket _modifier_sock;
 
 struct u32_mask {
 	uint32_t value;
@@ -2073,33 +2076,6 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static int print_cb(enum nf_conntrack_msg_type type,
-		    struct nf_conntrack *ct,
-		    void *data)
-{
-	char buf[1024];
-	unsigned int op_type = NFCT_O_DEFAULT;
-	unsigned int op_flags = 0;
-
-	if (output_mask & _O_SAVE) {
-		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
-		goto done;
-	}
-
-	if (output_mask & _O_XML)
-		op_type = NFCT_O_XML;
-	if (output_mask & _O_EXT)
-		op_flags = NFCT_OF_SHOW_LAYER3;
-	if (output_mask & _O_ID)
-		op_flags |= NFCT_OF_ID;
-
-	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
-done:
-	printf("%s\n", buf);
-
-	return NFCT_CB_CONTINUE;
-}
-
 static void copy_mark(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 		      const struct nf_conntrack *ct,
 		      const struct u32_mask *m)
@@ -2190,73 +2166,6 @@ static void copy_label(const struct ct_cmd *cmd, struct nf_conntrack *tmp,
 	}
 }
 
-static int update_cb(enum nf_conntrack_msg_type type,
-		     struct nf_conntrack *ct,
-		     void *data)
-{
-	struct ct_cmd *cmd = data;
-	struct nf_conntrack *obj = cmd->tmpl.ct, *tmp;
-	int res;
-
-	if (filter_nat(cmd, ct) ||
-	    filter_label(ct, cur_tmpl) ||
-	    filter_network(cmd, ct))
-		return NFCT_CB_CONTINUE;
-
-	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
-	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
-	    	return NFCT_CB_CONTINUE;
-
-	if (cmd->options & CT_OPT_TUPLE_ORIG &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
-		return NFCT_CB_CONTINUE;
-	if (cmd->options & CT_OPT_TUPLE_REPL &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_REPL))
-		return NFCT_CB_CONTINUE;
-
-	tmp = nfct_new();
-	if (tmp == NULL)
-		exit_error(OTHER_PROBLEM, "out of memory");
-
-	nfct_copy(tmp, ct, NFCT_CP_ORIG);
-	nfct_copy(tmp, obj, NFCT_CP_META);
-	copy_mark(cmd, tmp, ct, &cur_tmpl->mark);
-	copy_status(cmd, tmp, ct);
-	copy_label(cmd, tmp, ct, cur_tmpl);
-
-	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
-	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
-		nfct_destroy(tmp);
-		return NFCT_CB_CONTINUE;
-	}
-
-	res = nfct_query(ith, NFCT_Q_UPDATE, tmp);
-	if (res < 0)
-		fprintf(stderr,
-			   "Operation failed: %s\n",
-			   err2str(errno, CT_UPDATE));
-	nfct_callback_register(ith, NFCT_T_ALL, print_cb, NULL);
-
-	res = nfct_query(ith, NFCT_Q_GET, tmp);
-	if (res < 0) {
-		nfct_destroy(tmp);
-		/* the entry has vanish in middle of the update */
-		if (errno == ENOENT) {
-			nfct_callback_unregister(ith);
-			return NFCT_CB_CONTINUE;
-		}
-		exit_error(OTHER_PROBLEM,
-			   "Operation failed: %s",
-			   err2str(errno, CT_UPDATE));
-	}
-	nfct_destroy(tmp);
-	nfct_callback_unregister(ith);
-
-	counter++;
-
-	return NFCT_CB_CONTINUE;
-}
-
 static int dump_exp_cb(enum nf_conntrack_msg_type type,
 		      struct nf_expect *exp,
 		      void *data)
@@ -2529,6 +2438,45 @@ nfct_mnl_create(struct nfct_mnl_socket *sock, uint16_t subsys, uint16_t type,
 	return nfct_mnl_talk(sock, nlh, NULL);
 }
 
+static int
+nfct_mnl_set_ct(struct nfct_mnl_socket *sock,
+		uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int res;
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type,
+				    NLM_F_ACK,
+				    nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO));
+
+	res = nfct_nlmsg_build(nlh, ct);
+	if (res < 0)
+		return res;
+
+	return nfct_mnl_talk(sock, nlh, NULL);
+}
+
+static int
+nfct_mnl_request(struct nfct_mnl_socket *sock,
+		uint16_t subsys, uint16_t type, const struct nf_conntrack *ct,
+		mnl_cb_t cb)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int res;
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type,
+				    NLM_F_ACK,
+				    nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO));
+
+	res = nfct_nlmsg_build(nlh, ct);
+	if (res < 0)
+		return res;
+
+	return nfct_mnl_recv(sock, nlh, cb, NULL);
+}
+
 #define UNKNOWN_STATS_NUM 4
 
 static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
@@ -2717,6 +2665,116 @@ done:
 	return MNL_CB_OK;
 }
 
+static int mnl_nfct_print_cb(const struct nlmsghdr *nlh, void *data)
+{
+	char buf[1024];
+	unsigned int op_type = NFCT_O_DEFAULT;
+	unsigned int op_flags = 0;
+	struct nf_conntrack *ct;
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
+	if (output_mask & _O_XML)
+		op_type = NFCT_O_XML;
+	if (output_mask & _O_EXT)
+		op_flags = NFCT_OF_SHOW_LAYER3;
+	if (output_mask & _O_ID)
+		op_flags |= NFCT_OF_ID;
+
+	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
+	printf("%s\n", buf);
+
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
+static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct ct_cmd *cmd = data;
+	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
+	struct nf_conntrack *ct, *obj = cmd->tmpl.ct, *tmp = NULL;
+	int res;
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	if (filter_nat(cmd, ct) ||
+	    filter_label(ct, cur_tmpl) ||
+	    filter_network(cmd, ct))
+		goto destroy_ok;
+
+	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
+	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
+		goto destroy_ok;
+
+	if (cmd->options & CT_OPT_TUPLE_ORIG &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
+		goto destroy_ok;
+	if (cmd->options & CT_OPT_TUPLE_REPL &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_REPL))
+		goto destroy_ok;
+
+	tmp = nfct_new();
+	if (tmp == NULL)
+		exit_error(OTHER_PROBLEM, "out of memory");
+
+	nfct_copy(tmp, ct, NFCT_CP_ORIG);
+	nfct_copy(tmp, obj, NFCT_CP_META);
+	copy_mark(cmd, tmp, ct, &cur_tmpl->mark);
+	copy_status(cmd, tmp, ct);
+	copy_label(cmd, tmp, ct, cur_tmpl);
+
+	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
+	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+		goto destroy_ok;
+
+	res = nfct_mnl_set_ct(modifier_sock,
+			      NFNL_SUBSYS_CTNETLINK,
+			      IPCTNL_MSG_CT_NEW,
+			      tmp);
+	if (res < 0)
+		fprintf(stderr,
+			"Operation failed: %s\n",
+			err2str(errno, CT_UPDATE));
+
+	res = nfct_mnl_request(modifier_sock,
+			     NFNL_SUBSYS_CTNETLINK,
+			     IPCTNL_MSG_CT_GET,
+			     tmp,
+			     mnl_nfct_print_cb);
+	if (res < 0) {
+		/* the entry has vanish in middle of the update */
+		if (errno == ENOENT)
+			goto destroy_ok;
+		exit_error(OTHER_PROBLEM,
+			   "Operation failed: %s",
+			   err2str(errno, CT_UPDATE));
+	}
+
+	counter++;
+
+destroy_ok:
+	if (tmp)
+		nfct_destroy(tmp);
+	nfct_destroy(ct);
+
+	return MNL_CB_OK;
+}
+
 static struct ctproto_handler *h;
 
 static void labelmap_init(void)
@@ -3253,6 +3311,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 {
 	struct nfct_mnl_socket *sock = &_sock;
+	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
 	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
@@ -3373,19 +3432,18 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_UPDATE:
-		cth = nfct_open(CONNTRACK, 0);
-		/* internal handler for delete_cb, otherwise we hit EILSEQ */
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
+		if (nfct_mnl_socket_open(sock, 0) < 0
+		    || nfct_mnl_socket_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, cmd);
-
-		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
-		nfct_close(ith);
-		nfct_close(cth);
+		res = nfct_mnl_dump(sock,
+				    NFNL_SUBSYS_CTNETLINK,
+				    IPCTNL_MSG_CT_GET,
+				    mnl_nfct_update_cb, cmd, NULL);
+		nfct_mnl_socket_close(modifier_sock);
+		nfct_mnl_socket_close(sock);
 		break;
 
 	case CT_DELETE:
-- 
2.25.1

