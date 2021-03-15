Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA963C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83C364F35
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhCOQzc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40502 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhCOQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 85A0663539;
        Mon, 15 Mar 2021 17:49:38 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 3/6] conntrack: pass cmd to nfct_filter()
Date:   Mon, 15 Mar 2021 17:49:26 +0100
Message-Id: <20210315164929.23608-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315164929.23608-1-pablo@netfilter.org>
References: <20210315164929.23608-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the command object to the userspace filter routine.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 31630eb1f926..79053b7482c6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1640,9 +1640,11 @@ filter_network(const struct nf_conntrack *ct)
 }
 
 static int
-nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct,
+nfct_filter(struct ct_cmd *cmd, struct nf_conntrack *ct,
 	    const struct ct_tmpl *tmpl)
 {
+	struct nf_conntrack *obj = cmd->tmpl.ct;
+
 	if (filter_nat(obj, ct) ||
 	    filter_mark(ct, tmpl) ||
 	    filter_label(ct, tmpl) ||
@@ -1854,9 +1856,8 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 	unsigned int op_type = NFCT_O_DEFAULT;
-	struct ct_cmd *cmd = data;
-	struct nf_conntrack *obj = cmd->tmpl.ct;
 	enum nf_conntrack_msg_type type;
+	struct ct_cmd *cmd = data;
 	unsigned int op_flags = 0;
 	struct nf_conntrack *ct;
 	char buf[1024];
@@ -1886,7 +1887,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	if ((filter_family != AF_UNSPEC &&
 	     filter_family != nfh->nfgen_family) ||
-	    nfct_filter(obj, ct, cur_tmpl))
+	    nfct_filter(cmd, ct, cur_tmpl))
 		goto out;
 
 	if (output_mask & _O_SAVE) {
@@ -1941,13 +1942,12 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   struct nf_conntrack *ct,
 		   void *data)
 {
-	struct ct_cmd *cmd = data;
-	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
+	struct ct_cmd *cmd = data;
 	char buf[1024];
 
-	if (nfct_filter(obj, ct, cur_tmpl))
+	if (nfct_filter(cmd, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	if (output_mask & _O_SAVE) {
@@ -1983,14 +1983,13 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 		     struct nf_conntrack *ct,
 		     void *data)
 {
-	struct ct_cmd *cmd = data;
-	struct nf_conntrack *obj = cmd->tmpl.ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
+	struct ct_cmd *cmd = data;
 	char buf[1024];
 	int res;
 
-	if (nfct_filter(obj, ct, cur_tmpl))
+	if (nfct_filter(cmd, ct, cur_tmpl))
 		return NFCT_CB_CONTINUE;
 
 	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
-- 
2.20.1

