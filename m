Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB981C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 07:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiFHHqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 03:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiFHHp0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 03:45:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B70CD2348CF
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 00:09:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrackd: build: always add ports to sync message
Date:   Wed,  8 Jun 2022 09:09:12 +0200
Message-Id: <20220608070912.316768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ports are used to uniquely identify the flow, this information must be
included inconditionally to sync message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/build.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/build.c b/src/build.c
index 63e47c796230..c234a0c34147 100644
--- a/src/build.c
+++ b/src/build.c
@@ -133,11 +133,12 @@ static enum nf_conntrack_attr nat_type[] =
 /* ICMP, UDP and TCP are always loaded with nf_conntrack_ipv4 */
 static void build_l4proto_tcp(const struct nf_conntrack *ct, struct nethdr *n)
 {
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
+
 	if (!nfct_attr_is_set(ct, ATTR_TCP_STATE))
 		return;
 
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_TCP_STATE, n, NTA_TCP_STATE);
 	if (CONFIG(sync).tcp_window_tracking) {
 		ct_build_u8(ct, ATTR_TCP_WSCALE_ORIG, n, NTA_TCP_WSCALE_ORIG);
@@ -147,12 +148,13 @@ static void build_l4proto_tcp(const struct nf_conntrack *ct, struct nethdr *n)
 
 static void build_l4proto_sctp(const struct nf_conntrack *ct, struct nethdr *n)
 {
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
+
 	/* SCTP is optional, make sure nf_conntrack_sctp is loaded */
 	if (!nfct_attr_is_set(ct, ATTR_SCTP_STATE))
 		return;
 
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_SCTP_STATE, n, NTA_SCTP_STATE);
 	ct_build_u32(ct, ATTR_SCTP_VTAG_ORIG, n, NTA_SCTP_VTAG_ORIG);
 	ct_build_u32(ct, ATTR_SCTP_VTAG_REPL, n, NTA_SCTP_VTAG_REPL);
@@ -160,12 +162,13 @@ static void build_l4proto_sctp(const struct nf_conntrack *ct, struct nethdr *n)
 
 static void build_l4proto_dccp(const struct nf_conntrack *ct, struct nethdr *n)
 {
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
+
 	/* DCCP is optional, make sure nf_conntrack_dccp is loaded */
 	if (!nfct_attr_is_set(ct, ATTR_DCCP_STATE))
 		return;
 
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_DCCP_STATE, n, NTA_DCCP_STATE);
 	ct_build_u8(ct, ATTR_DCCP_ROLE, n, NTA_DCCP_ROLE);
 }
-- 
2.30.2

