From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools] conntrackd: build: fix crash when optional kernel module are not loaded
Date: Fri, 13 Jun 2014 12:56:35 +0200
Message-ID: <1402656995-21617-1-git-send-email-pablo@netfilter.org>
Cc: jann@wh-netz.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34846 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaFMK4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:56:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix a possible crash if conntrackd sees DCCP, SCTP and ICMPv6 traffic
and the corresponding kernel modules that track this traffic are not
available.

Fixes: http://bugzilla.netfilter.org/show_bug.cgi?id=910
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/build.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/src/build.c b/src/build.c
index 5799b51..ab9e561 100644
--- a/src/build.c
+++ b/src/build.c
@@ -105,14 +105,14 @@ static enum nf_conntrack_attr nat_type[] =
 	  ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ATTR_REPL_NAT_SEQ_CORRECTION_POS,
 	  ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, ATTR_REPL_NAT_SEQ_OFFSET_AFTER };
 
+/* ICMP, UDP and TCP are already loaded with nf_conntrack_ipv4 */
 static void build_l4proto_tcp(const struct nf_conntrack *ct, struct nethdr *n)
 {
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
-
 	if (!nfct_attr_is_set(ct, ATTR_TCP_STATE))
 		return;
 
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_TCP_STATE, n, NTA_TCP_STATE);
 	if (CONFIG(sync).tcp_window_tracking) {
 		ct_build_u8(ct, ATTR_TCP_WSCALE_ORIG, n, NTA_TCP_WSCALE_ORIG);
@@ -122,12 +122,12 @@ static void build_l4proto_tcp(const struct nf_conntrack *ct, struct nethdr *n)
 
 static void build_l4proto_sctp(const struct nf_conntrack *ct, struct nethdr *n)
 {
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
-
+	/* SCTP is optional, make sure nf_conntrack_sctp is loaded */
 	if (!nfct_attr_is_set(ct, ATTR_SCTP_STATE))
 		return;
 
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_SCTP_STATE, n, NTA_SCTP_STATE);
 	ct_build_u32(ct, ATTR_SCTP_VTAG_ORIG, n, NTA_SCTP_VTAG_ORIG);
 	ct_build_u32(ct, ATTR_SCTP_VTAG_REPL, n, NTA_SCTP_VTAG_REPL);
@@ -135,18 +135,22 @@ static void build_l4proto_sctp(const struct nf_conntrack *ct, struct nethdr *n)
 
 static void build_l4proto_dccp(const struct nf_conntrack *ct, struct nethdr *n)
 {
-	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
-		      sizeof(struct nfct_attr_grp_port));
-
+	/* DCCP is optional, make sure nf_conntrack_dccp is loaded */
 	if (!nfct_attr_is_set(ct, ATTR_DCCP_STATE))
 		return;
 
+	ct_build_group(ct, ATTR_GRP_ORIG_PORT, n, NTA_PORT,
+		      sizeof(struct nfct_attr_grp_port));
 	ct_build_u8(ct, ATTR_DCCP_STATE, n, NTA_DCCP_STATE);
 	ct_build_u8(ct, ATTR_DCCP_ROLE, n, NTA_DCCP_ROLE);
 }
 
 static void build_l4proto_icmp(const struct nf_conntrack *ct, struct nethdr *n)
 {
+	/* This is also used with IPv6, but nf_conntrack_ipv6 is optional */
+	if (!nfct_attr_is_set(ct, ATTR_ICMP_TYPE))
+		return;
+
 	ct_build_u8(ct, ATTR_ICMP_TYPE, n, NTA_ICMP_TYPE);
 	ct_build_u8(ct, ATTR_ICMP_CODE, n, NTA_ICMP_CODE);
 	ct_build_u16(ct, ATTR_ICMP_ID, n, NTA_ICMP_ID);
-- 
1.7.10.4

