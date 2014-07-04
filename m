From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: check for NLM_F_DUMP_INTR when dumping object lists
Date: Fri,  4 Jul 2014 12:32:22 +0200
Message-ID: <1404469942-6263-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaGDKcd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:32:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This flag allows to detect that an update has ocurred while dumping
any of the object lists.

<cmdline>:1:1-17: Error: Could not receive rules from kernel: Interrupted system call
list table filter
^^^^^^^^^^^^^^^^^

Basically, the user has to retry to make sure that it saves the current
rule-set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index a816106..d3c91b4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -363,6 +363,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_rule_list *nlr_list = data;
 	struct nft_rule *r;
 
+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
+		return MNL_CB_ERROR;
+
 	r = nft_rule_alloc();
 	if (r == NULL)
 		memory_allocation_error();
@@ -474,6 +477,9 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_chain_list *nlc_list = data;
 	struct nft_chain *c;
 
+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
+		return MNL_CB_ERROR;
+
 	c = nft_chain_alloc();
 	if (c == NULL)
 		memory_allocation_error();
@@ -603,6 +609,9 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_table_list *nlt_list = data;
 	struct nft_table *t;
 
+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
+		return MNL_CB_ERROR;
+
 	t = nft_table_alloc();
 	if (t == NULL)
 		memory_allocation_error();
@@ -736,6 +745,9 @@ static int set_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_set_list *nls_list = data;
 	struct nft_set *s;
 
+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
+		return MNL_CB_ERROR;
+
 	s = nft_set_alloc();
 	if (s == NULL)
 		memory_allocation_error();
@@ -839,6 +851,9 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 {
+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
+		return MNL_CB_ERROR;
+
 	nft_set_elems_nlmsg_parse(nlh, data);
 	return MNL_CB_OK;
 }
-- 
1.7.10.4

