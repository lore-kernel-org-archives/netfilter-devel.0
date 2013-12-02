From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] mnl: fix name of called build_hdr functions
Date: Mon, 02 Dec 2013 17:07:18 +0100
Message-ID: <20131202160718.19252.73477.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37009 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751830Ab3LBQHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:07:24 -0500
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BE70951EEB0
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2013 16:07:21 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dncfwclZds75 for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Dec 2013 17:07:21 +0100 (CET)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 9821251EEA5
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2013 17:07:19 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think that using the right keyword improves readability.

Minor fix, given that all those functions are aliases.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/mnl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 27b181a..2f27b17 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -270,7 +270,7 @@ int mnl_nft_rule_batch_add(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			flags|NLM_F_ACK|NLM_F_CREATE, seqnum);
@@ -287,7 +287,7 @@ int mnl_nft_rule_batch_del(struct nft_rule *nlr, unsigned int flags,
 {
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_DELRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			NLM_F_ACK, seqnum);
@@ -309,7 +309,7 @@ int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			flags|NLM_F_ACK|NLM_F_CREATE, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
@@ -323,7 +323,7 @@ int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE,
 			nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY),
 			NLM_F_ACK, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
@@ -385,7 +385,7 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK|flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
@@ -399,7 +399,7 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_DELCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
@@ -463,7 +463,7 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN,
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY),
 			NLM_F_ACK|flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);

