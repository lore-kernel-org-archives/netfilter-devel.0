Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEEBC43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389C164EFD
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 16:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhCOQzc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:55:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40500 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbhCOQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 12:55:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 155606353A;
        Mon, 15 Mar 2021 17:49:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack 4/6] conntrack: pass cmd to filter nat, mark and network functions
Date:   Mon, 15 Mar 2021 17:49:27 +0100
Message-Id: <20210315164929.23608-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315164929.23608-1-pablo@netfilter.org>
References: <20210315164929.23608-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass the command object to the nat, mark and IP address userspace
filters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 79053b7482c6..152063e9329e 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1490,20 +1490,21 @@ filter_label(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
 	return 0;
 }
 
-static int
-filter_mark(const struct nf_conntrack *ct, const struct ct_tmpl *tmpl)
+static int filter_mark(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
+	const struct ct_tmpl *tmpl = &cmd->tmpl;
+
 	if ((options & CT_OPT_MARK) &&
 	     !mark_cmp(&tmpl->mark, ct))
 		return 1;
 	return 0;
 }
 
-static int 
-filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
+static int filter_nat(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
 	int check_srcnat = options & CT_OPT_SRC_NAT ? 1 : 0;
 	int check_dstnat = options & CT_OPT_DST_NAT ? 1 : 0;
+	struct nf_conntrack *obj = cmd->tmpl.ct;
 	int has_srcnat = 0, has_dstnat = 0;
 	uint32_t ip;
 	uint16_t port;
@@ -1625,7 +1626,7 @@ nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_direction d
 }
 
 static int
-filter_network(const struct nf_conntrack *ct)
+filter_network(const struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
 	if (options & CT_OPT_MASK_SRC) {
 		if (nfct_filter_network_direction(ct, DIR_SRC))
@@ -1645,10 +1646,10 @@ nfct_filter(struct ct_cmd *cmd, struct nf_conntrack *ct,
 {
 	struct nf_conntrack *obj = cmd->tmpl.ct;
 
-	if (filter_nat(obj, ct) ||
-	    filter_mark(ct, tmpl) ||
+	if (filter_nat(cmd, ct) ||
+	    filter_mark(cmd, ct) ||
 	    filter_label(ct, tmpl) ||
-	    filter_network(ct))
+	    filter_network(cmd, ct))
 		return 1;
 
 	if (options & CT_COMPARISON &&
@@ -2142,9 +2143,9 @@ static int update_cb(enum nf_conntrack_msg_type type,
 	struct nf_conntrack *obj = cmd->tmpl.ct, *tmp;
 	int res;
 
-	if (filter_nat(obj, ct) ||
+	if (filter_nat(cmd, ct) ||
 	    filter_label(ct, cur_tmpl) ||
-	    filter_network(ct))
+	    filter_network(cmd, ct))
 		return NFCT_CB_CONTINUE;
 
 	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
-- 
2.20.1

