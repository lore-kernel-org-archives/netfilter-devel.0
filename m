Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF365C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 15:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35E92075E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 15:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBPBS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 11:01:18 -0400
Received: from mail.us.es ([193.147.175.20]:50728 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfEBPBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 11:01:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD42B12082D
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 17:01:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC0FBDA70F
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 17:01:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1727DA70E; Thu,  2 May 2019 17:01:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BB5CDA707
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 17:01:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 02 May 2019 17:01:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0E8594265A32
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 17:01:07 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 4/3] src: replace old libnfnetlink builder
Date:   Thu,  2 May 2019 17:01:04 +0200
Message-Id: <20190502150104.12046-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the new libmnl version, remove duplicated code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Better do this now :-)

 src/conntrack/build.c | 602 ++------------------------------------------------
 src/expect/build.c    |  91 ++------
 2 files changed, 28 insertions(+), 665 deletions(-)

diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index d13289094e02..b5a7061d5369 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -8,471 +8,7 @@
  */
 
 #include "internal/internal.h"
-
-static void __build_tuple_ip(struct nfnlhdr *req,
-			     size_t size,
-			     const struct __nfct_tuple *t)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_IP);
-
-	switch(t->l3protonum) {
-	case AF_INET:
-	        nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_SRC, &t->src.v4,
-			       sizeof(uint32_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_IP_V4_DST, &t->dst.v4,
-			       sizeof(uint32_t));
-		break;
-	case AF_INET6:
-		nfnl_addattr_l(&req->nlh, size, CTA_IP_V6_SRC, &t->src.v6,
-			       sizeof(struct in6_addr));
-		nfnl_addattr_l(&req->nlh, size, CTA_IP_V6_DST, &t->dst.v6,
-			       sizeof(struct in6_addr));
-		break;
-	default:
-		break;
-	}
-
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_tuple_proto(struct nfnlhdr *req,
-				size_t size,
-				const struct __nfct_tuple *t)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_PROTO);
-
-	nfnl_addattr_l(&req->nlh, size, CTA_PROTO_NUM, &t->protonum,
-		       sizeof(uint8_t));
-
-	switch(t->protonum) {
-	case IPPROTO_UDP:
-	case IPPROTO_TCP:
-	case IPPROTO_SCTP:
-	case IPPROTO_DCCP:
-	case IPPROTO_GRE:
-	case IPPROTO_UDPLITE:
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_SRC_PORT,
-			       &t->l4src.tcp.port, sizeof(uint16_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_DST_PORT,
-			       &t->l4dst.tcp.port, sizeof(uint16_t));
-		break;
-
-	case IPPROTO_ICMP:
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_CODE,
-			       &t->l4dst.icmp.code, sizeof(uint8_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_TYPE,
-			       &t->l4dst.icmp.type, sizeof(uint8_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
-			       &t->l4src.icmp.id, sizeof(uint16_t));
-		break;
-
-	case IPPROTO_ICMPV6:
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_CODE,
-			       &t->l4dst.icmp.code, sizeof(uint8_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_TYPE,
-			       &t->l4dst.icmp.type, sizeof(uint8_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMPV6_ID,
-			       &t->l4src.icmp.id, sizeof(uint16_t));
-		break;
-
-	default:
-		break;
-	}
-
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_tuple_raw(struct nfnlhdr *req, size_t size,
-			      const struct __nfct_tuple *t)
-{
-	__build_tuple_ip(req, size, t);
-	__build_tuple_proto(req, size, t);
-}
-
-void __build_tuple(struct nfnlhdr *req, size_t size,
-		   const struct __nfct_tuple *t, const int type)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, type);
-	__build_tuple_raw(req, size, t);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_protoinfo(struct nfnlhdr *req, size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest, *nest_proto;
-
-	switch(ct->head.orig.protonum) {
-	case IPPROTO_TCP:
-		/* Preliminary attribute check to avoid sending an empty
-		 * CTA_PROTOINFO_TCP nest, which results in EINVAL in
-		 * Linux kernel <= 2.6.25. */
-		if (!(test_bit(ATTR_TCP_STATE, ct->head.set) ||
-		      test_bit(ATTR_TCP_FLAGS_ORIG, ct->head.set) ||
-		      test_bit(ATTR_TCP_FLAGS_REPL, ct->head.set) ||
-		      test_bit(ATTR_TCP_MASK_ORIG, ct->head.set) ||
-		      test_bit(ATTR_TCP_MASK_REPL, ct->head.set) ||
-		      test_bit(ATTR_TCP_WSCALE_ORIG, ct->head.set) ||
-		      test_bit(ATTR_TCP_WSCALE_REPL, ct->head.set))) {
-			break;
-		}
-		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
-		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
-		if (test_bit(ATTR_TCP_STATE, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_TCP_STATE,
-				       &ct->protoinfo.tcp.state,
-				       sizeof(uint8_t));
-		if (test_bit(ATTR_TCP_FLAGS_ORIG, ct->head.set) &&
-		    test_bit(ATTR_TCP_MASK_ORIG, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_TCP_FLAGS_ORIGINAL,
-				       &ct->protoinfo.tcp.flags[0], 
-				       sizeof(struct nf_ct_tcp_flags));
-		if (test_bit(ATTR_TCP_FLAGS_REPL, ct->head.set) &&
-		    test_bit(ATTR_TCP_MASK_REPL, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_TCP_FLAGS_REPLY,
-				       &ct->protoinfo.tcp.flags[1], 
-				       sizeof(struct nf_ct_tcp_flags));
-		if (test_bit(ATTR_TCP_WSCALE_ORIG, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
-				       &ct->protoinfo.tcp.wscale[__DIR_ORIG],
-				       sizeof(uint8_t));
-		if (test_bit(ATTR_TCP_WSCALE_REPL, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_TCP_WSCALE_REPLY,
-				       &ct->protoinfo.tcp.wscale[__DIR_REPL],
-				       sizeof(uint8_t));
-		nfnl_nest_end(&req->nlh, nest_proto);
-		nfnl_nest_end(&req->nlh, nest);
-		break;
-	case IPPROTO_SCTP:
-		/* See comment above on TCP. */
-		if (!(test_bit(ATTR_SCTP_STATE, ct->head.set) ||
-		      test_bit(ATTR_SCTP_VTAG_ORIG, ct->head.set) ||
-		      test_bit(ATTR_SCTP_VTAG_REPL, ct->head.set))) {
-			break;
-		}
-		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
-		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_SCTP);
-		if (test_bit(ATTR_SCTP_STATE, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_SCTP_STATE,
-				       &ct->protoinfo.sctp.state,
-				       sizeof(uint8_t));
-		if (test_bit(ATTR_SCTP_VTAG_ORIG, ct->head.set))
-			nfnl_addattr32(&req->nlh, size,
-				    CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
-				    htonl(ct->protoinfo.sctp.vtag[__DIR_ORIG]));
-		if (test_bit(ATTR_SCTP_VTAG_REPL, ct->head.set))
-			nfnl_addattr32(&req->nlh, size,
-				    CTA_PROTOINFO_SCTP_VTAG_REPLY,
-				    htonl(ct->protoinfo.sctp.vtag[__DIR_REPL]));
-		nfnl_nest_end(&req->nlh, nest_proto);
-		nfnl_nest_end(&req->nlh, nest);
-		break;
-	case IPPROTO_DCCP:
-		/* See comment above on TCP. */
-		if (!(test_bit(ATTR_DCCP_STATE, ct->head.set) ||
-		      test_bit(ATTR_DCCP_ROLE, ct->head.set) ||
-		      test_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->head.set))) {
-			break;
-		}
-		nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
-		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_DCCP);
-		if (test_bit(ATTR_DCCP_STATE, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_DCCP_STATE,
-				       &ct->protoinfo.dccp.state,
-				       sizeof(uint8_t));
-		if (test_bit(ATTR_DCCP_ROLE, ct->head.set))
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_DCCP_ROLE,
-				       &ct->protoinfo.dccp.role,
-				       sizeof(uint8_t));
-		if (test_bit(ATTR_DCCP_HANDSHAKE_SEQ, ct->head.set)) {
-			/* FIXME: use __cpu_to_be64() instead which is the
-			 * correct operation. This is a semantic abuse but
-			 * we have no function to do it in libnfnetlink. */
-			uint64_t handshake_seq =
-				__be64_to_cpu(ct->protoinfo.dccp.handshake_seq);
-
-			nfnl_addattr_l(&req->nlh, size,
-				       CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
-				       &handshake_seq,
-				       sizeof(uint64_t));
-		}
-		nfnl_nest_end(&req->nlh, nest_proto);
-		nfnl_nest_end(&req->nlh, nest);
-	default:
-		break;
-	}
-}
-
-static inline void 
-__nat_seq_adj(struct nfnlhdr *req,
-	      size_t size,
-	      const struct nf_conntrack *ct,
-	      int dir)
-{
-	nfnl_addattr32(&req->nlh, 
-		       size, 
-		       CTA_NAT_SEQ_CORRECTION_POS,
-		       htonl(ct->natseq[dir].correction_pos));
-	nfnl_addattr32(&req->nlh, 
-		       size, 
-		       CTA_NAT_SEQ_OFFSET_BEFORE,
-		       htonl(ct->natseq[dir].offset_before));
-	nfnl_addattr32(&req->nlh, 
-		       size, 
-		       CTA_NAT_SEQ_OFFSET_AFTER,
-		       htonl(ct->natseq[dir].offset_after));
-}
-
-static void 
-__build_nat_seq_adj(struct nfnlhdr *req, 
-		    size_t size,
-		    const struct nf_conntrack *ct,
-		    int dir)
-{
-	struct nfattr *nest;
-	int type = (dir == __DIR_ORIG) ? CTA_NAT_SEQ_ADJ_ORIG : 
-					 CTA_NAT_SEQ_ADJ_REPLY;
-
-	nest = nfnl_nest(&req->nlh, size, type);
-	__nat_seq_adj(req, size, ct, dir);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_protonat(struct nfnlhdr *req,
-			     size_t size,
-			     const struct nf_conntrack *ct,
-			     const struct __nfct_nat *nat)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_PROTO);
-
-	switch (ct->head.orig.protonum) {
-	case IPPROTO_TCP:
-	case IPPROTO_UDP:
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_PORT_MIN,
-			       &nat->l4min.tcp.port, sizeof(uint16_t));
-		nfnl_addattr_l(&req->nlh, size, CTA_PROTONAT_PORT_MAX,
-			       &nat->l4max.tcp.port, sizeof(uint16_t));
-		break;
-	}
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_nat(struct nfnlhdr *req,
-			size_t size,
-			const struct __nfct_nat *nat,
-			uint8_t l3protonum)
-{
-	switch (l3protonum) {
-	case AF_INET:
-		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
-			       &nat->min_ip.v4, sizeof(uint32_t));
-		break;
-	case AF_INET6:
-		nfnl_addattr_l(&req->nlh, size, CTA_NAT_V6_MINIP,
-			       &nat->min_ip.v6, sizeof(struct in6_addr));
-		break;
-	default:
-		break;
-	}
-}
-
-static void __build_snat(struct nfnlhdr *req,
-			 size_t size,
-			 const struct nf_conntrack *ct,
-			 uint8_t l3protonum)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_nat(req, size, &ct->snat, l3protonum);
-	__build_protonat(req, size, ct, &ct->snat);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_snat_ipv4(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_nat(req, size, &ct->snat, AF_INET);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_snat_ipv6(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_nat(req, size, &ct->snat, AF_INET6);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_snat_port(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
-	__build_protonat(req, size, ct, &ct->snat);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_dnat(struct nfnlhdr *req,
-			 size_t size,
-			 const struct nf_conntrack *ct,
-			 uint8_t l3protonum)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-	__build_nat(req, size, &ct->dnat, l3protonum);
-	__build_protonat(req, size, ct, &ct->dnat);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_dnat_ipv4(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-	__build_nat(req, size, &ct->dnat, AF_INET);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_dnat_ipv6(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-	__build_nat(req, size, &ct->dnat, AF_INET6);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_dnat_port(struct nfnlhdr *req,
-			      size_t size,
-			      const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT_DST);
-        __build_protonat(req, size, ct, &ct->dnat);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_status(struct nfnlhdr *req,
-			   size_t size,
-			   const struct nf_conntrack *ct)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_STATUS,
-		       htonl(ct->status | IPS_CONFIRMED));
-}
-
-static void __build_timeout(struct nfnlhdr *req,
-			    size_t size,
-			    const struct nf_conntrack *ct)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_TIMEOUT, htonl(ct->timeout));
-}
-
-static void __build_mark(struct nfnlhdr *req,
-			 size_t size,
-			 const struct nf_conntrack *ct)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_MARK, htonl(ct->mark));
-}
-
-static void __build_secmark(struct nfnlhdr *req,
-			    size_t size,
-			    const struct nf_conntrack *ct)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_SECMARK, htonl(ct->secmark));
-}
-
-static void __build_helper_name(struct nfnlhdr *req,
-				size_t size,
-				const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_HELP);
-	nfnl_addattr_l(&req->nlh,
-		       size, 
-		       CTA_HELP_NAME,
-		       ct->helper_name,
-		       strlen(ct->helper_name)+1);
-	nfnl_nest_end(&req->nlh, nest);
-}
-
-static void __build_zone(struct nfnlhdr *req,
-			 size_t size,
-			 const struct nf_conntrack *ct)
-{
-	nfnl_addattr16(&req->nlh, size, CTA_ZONE, htons(ct->zone));
-}
-
-static void __build_labels(struct nfnlhdr *req,
-			   size_t size,
-			   const struct nf_conntrack *ct)
-{
-	struct nfct_bitmask *b = ct->connlabels;
-	unsigned int b_size = b->words * sizeof(b->bits[0]);
-
-	nfnl_addattr_l(&req->nlh,
-		       size,
-		       CTA_LABELS,
-		       b->bits,
-		       b_size);
-
-	if (test_bit(ATTR_CONNLABELS_MASK, ct->head.set)) {
-		b = ct->connlabels_mask;
-		if (b_size == (b->words * sizeof(b->bits[0])))
-			nfnl_addattr_l(&req->nlh,
-				       size,
-				       CTA_LABELS_MASK,
-				       b->bits,
-				       b_size);
-	}
-}
-
-static void __build_synproxy(struct nfnlhdr *req, size_t size,
-			     const struct nf_conntrack *ct)
-{
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_SYNPROXY);
-	nfnl_addattr32(&req->nlh, size, CTA_SYNPROXY_ISN,
-		       htonl(ct->synproxy.isn));
-	nfnl_addattr32(&req->nlh, size, CTA_SYNPROXY_ITS,
-		       htonl(ct->synproxy.its));
-	nfnl_addattr32(&req->nlh, size, CTA_SYNPROXY_TSOFF,
-		       htonl(ct->synproxy.tsoff));
-	nfnl_nest_end(&req->nlh, nest);
-}
+#include <libmnl/libmnl.h>
 
 int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      struct nfnlhdr *req,
@@ -482,6 +18,9 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      const struct nf_conntrack *ct)
 {
 	uint8_t l3num = ct->head.orig.l3protonum;
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+	char *buf;
 
 	if (!test_bit(ATTR_ORIG_L3PROTO, ct->head.set)) {
 		errno = EINVAL;
@@ -490,129 +29,16 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 
 	memset(req, 0, size);
 
-	nfnl_fill_hdr(ssh, &req->nlh, 0, l3num, 0, type, flags);
-
-	if (test_bit(ATTR_ORIG_IPV4_SRC, ct->head.set) ||
-	    test_bit(ATTR_ORIG_IPV4_DST, ct->head.set) ||
-	    test_bit(ATTR_ORIG_IPV6_SRC, ct->head.set) ||
-	    test_bit(ATTR_ORIG_IPV6_DST, ct->head.set) ||
-	    test_bit(ATTR_ORIG_PORT_SRC, ct->head.set) ||
-	    test_bit(ATTR_ORIG_PORT_DST, ct->head.set) ||
-	    test_bit(ATTR_ORIG_L3PROTO, ct->head.set)  ||
-	    test_bit(ATTR_ORIG_L4PROTO, ct->head.set)  ||
-	    test_bit(ATTR_ORIG_ZONE, ct->head.set)     ||
-	    test_bit(ATTR_ICMP_TYPE, ct->head.set) 	  ||
-	    test_bit(ATTR_ICMP_CODE, ct->head.set)	  ||
-	    test_bit(ATTR_ICMP_ID, ct->head.set)) {
-		const struct __nfct_tuple *t = &ct->head.orig;
-		struct nfattr *nest;
-
-		nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_ORIG);
-		__build_tuple_raw(req, size, t);
-		if (test_bit(ATTR_ORIG_ZONE, ct->head.set))
-			nfnl_addattr16(&req->nlh, size, CTA_TUPLE_ZONE,
-				       htons(t->zone));
-		nfnl_nest_end(&req->nlh, nest);
-	}
-
-	if (test_bit(ATTR_REPL_IPV4_SRC, ct->head.set) ||
-	    test_bit(ATTR_REPL_IPV4_DST, ct->head.set) ||
-	    test_bit(ATTR_REPL_IPV6_SRC, ct->head.set) ||
-	    test_bit(ATTR_REPL_IPV6_DST, ct->head.set) ||
-	    test_bit(ATTR_REPL_PORT_SRC, ct->head.set) ||
-	    test_bit(ATTR_REPL_PORT_DST, ct->head.set) ||
-	    test_bit(ATTR_REPL_L3PROTO, ct->head.set)  ||
-	    test_bit(ATTR_REPL_L4PROTO, ct->head.set)  ||
-	    test_bit(ATTR_REPL_ZONE, ct->head.set)) {
-		const struct __nfct_tuple *t = &ct->repl;
-		struct nfattr *nest;
-
-		nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_REPLY);
-		__build_tuple_raw(req, size, t);
-		if (test_bit(ATTR_REPL_ZONE, ct->head.set))
-			nfnl_addattr16(&req->nlh, size, CTA_TUPLE_ZONE,
-				       htons(t->zone));
-		nfnl_nest_end(&req->nlh, nest);
-	}
-
-	if (test_bit(ATTR_MASTER_IPV4_SRC, ct->head.set) ||
-	    test_bit(ATTR_MASTER_IPV4_DST, ct->head.set) ||
-	    test_bit(ATTR_MASTER_IPV6_SRC, ct->head.set) ||
-	    test_bit(ATTR_MASTER_IPV6_DST, ct->head.set) ||
-	    test_bit(ATTR_MASTER_PORT_SRC, ct->head.set) ||
-	    test_bit(ATTR_MASTER_PORT_DST, ct->head.set) ||
-	    test_bit(ATTR_MASTER_L3PROTO, ct->head.set) ||
-	    test_bit(ATTR_MASTER_L4PROTO, ct->head.set))
-	    	__build_tuple(req, size, &ct->master, CTA_TUPLE_MASTER);
-
-	if (test_bit(ATTR_STATUS, ct->head.set))
-		__build_status(req, size, ct);
-	else {
-		/* build IPS_CONFIRMED if we're creating a new conntrack */
-		if (type == IPCTNL_MSG_CT_NEW && flags & NLM_F_CREATE)
-			__build_status(req, size, ct);
-	}
-
-	if (test_bit(ATTR_TIMEOUT, ct->head.set))
-		__build_timeout(req, size, ct);
-
-	if (test_bit(ATTR_MARK, ct->head.set))
-		__build_mark(req, size, ct);
-
-	if (test_bit(ATTR_SECMARK, ct->head.set))
-		__build_secmark(req, size, ct);
-
-	__build_protoinfo(req, size, ct);
-
-	if (test_bit(ATTR_SNAT_IPV4, ct->head.set) &&
-	    test_bit(ATTR_SNAT_PORT, ct->head.set))
-		__build_snat(req, size, ct, AF_INET);
-	else if (test_bit(ATTR_SNAT_IPV6, ct->head.set) &&
-		 test_bit(ATTR_SNAT_PORT, ct->head.set))
-		__build_snat(req, size, ct, AF_INET6);
-	else if (test_bit(ATTR_SNAT_IPV4, ct->head.set))
-		__build_snat_ipv4(req, size, ct);
-	else if (test_bit(ATTR_SNAT_IPV6, ct->head.set))
-		__build_snat_ipv6(req, size, ct);
-	else if (test_bit(ATTR_SNAT_PORT, ct->head.set))
-		__build_snat_port(req, size, ct);
-
-	if (test_bit(ATTR_DNAT_IPV4, ct->head.set) &&
-	    test_bit(ATTR_DNAT_PORT, ct->head.set))
-		__build_dnat(req, size, ct, AF_INET);
-	else if (test_bit(ATTR_DNAT_IPV6, ct->head.set) &&
-		 test_bit(ATTR_DNAT_PORT, ct->head.set))
-		__build_dnat(req, size, ct, AF_INET6);
-	else if (test_bit(ATTR_DNAT_IPV4, ct->head.set))
-		__build_dnat_ipv4(req, size, ct);
-	else if (test_bit(ATTR_DNAT_IPV6, ct->head.set))
-		__build_dnat_ipv6(req, size, ct);
-	else if (test_bit(ATTR_DNAT_PORT, ct->head.set))
-		__build_dnat_port(req, size, ct);
-
-	if (test_bit(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ct->head.set) &&
-	    test_bit(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ct->head.set) &&
-	    test_bit(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ct->head.set))
-	    	__build_nat_seq_adj(req, size, ct, __DIR_ORIG);
-
-	if (test_bit(ATTR_REPL_NAT_SEQ_CORRECTION_POS, ct->head.set) &&
-	    test_bit(ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, ct->head.set) &&
-	    test_bit(ATTR_REPL_NAT_SEQ_OFFSET_AFTER, ct->head.set))
-	    	__build_nat_seq_adj(req, size, ct, __DIR_REPL);
-
-	if (test_bit(ATTR_HELPER_NAME, ct->head.set))
-		__build_helper_name(req, size, ct);
-
-	if (test_bit(ATTR_ZONE, ct->head.set))
-		__build_zone(req, size, ct);
-
-	if (test_bit(ATTR_CONNLABELS, ct->head.set))
-		__build_labels(req, size, ct);
+	buf = (char *)&req->nlh;
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | type;
+	nlh->nlmsg_flags = flags;
+	nlh->nlmsg_seq = 0;
 
-	if (test_bit(ATTR_SYNPROXY_ISN, ct->head.set) &&
-	    test_bit(ATTR_SYNPROXY_ITS, ct->head.set) &&
-	    test_bit(ATTR_SYNPROXY_TSOFF, ct->head.set))
-		__build_synproxy(req, size, ct);
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = l3num;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
 
-	return 0;
+	return nfct_nlmsg_build(nlh, ct);
 }
diff --git a/src/expect/build.c b/src/expect/build.c
index da59022b7dfa..2e0f968f36da 100644
--- a/src/expect/build.c
+++ b/src/expect/build.c
@@ -8,46 +8,7 @@
  */
 
 #include "internal/internal.h"
-
-static void __build_timeout(struct nfnlhdr *req,
-			    size_t size,
-			    const struct nf_expect *exp)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_EXPECT_TIMEOUT,htonl(exp->timeout));
-}
-
-static void __build_zone(struct nfnlhdr *req, size_t size,
-			 const struct nf_expect *exp)
-{
-	nfnl_addattr16(&req->nlh, size, CTA_EXPECT_ZONE, htons(exp->zone));
-}
-
-static void __build_flags(struct nfnlhdr *req,
-			  size_t size, const struct nf_expect *exp)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_EXPECT_FLAGS,htonl(exp->flags));
-}
-
-static void __build_class(struct nfnlhdr *req,
-			  size_t size,
-			  const struct nf_expect *exp)
-{
-	nfnl_addattr32(&req->nlh, size, CTA_EXPECT_CLASS, htonl(exp->class));
-}
-
-static void __build_helper_name(struct nfnlhdr *req, size_t size,
-			 const struct nf_expect *exp)
-{
-	nfnl_addattr_l(&req->nlh, size, CTA_EXPECT_HELP_NAME,
-			exp->helper_name, strlen(exp->helper_name)+1);
-}
-
-static void __build_expectfn(struct nfnlhdr *req,
-			     size_t size, const struct nf_expect *exp)
-{
-	nfnl_addattr_l(&req->nlh, size, CTA_EXPECT_FN,
-			exp->expectfn, strlen(exp->expectfn)+1);
-}
+#include <libmnl/libmnl.h>
 
 int __build_expect(struct nfnl_subsys_handle *ssh,
 		   struct nfnlhdr *req,
@@ -56,7 +17,10 @@ int __build_expect(struct nfnl_subsys_handle *ssh,
 		   uint16_t flags,
 		   const struct nf_expect *exp)
 {
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
 	uint8_t l3num;
+	char *buf;
 
 	if (test_bit(ATTR_ORIG_L3PROTO, exp->master.set))
 		l3num = exp->master.orig.l3protonum;
@@ -67,43 +31,16 @@ int __build_expect(struct nfnl_subsys_handle *ssh,
 
 	memset(req, 0, size);
 
-	nfnl_fill_hdr(ssh, &req->nlh, 0, l3num, 0, type, flags);
-
-	if (test_bit(ATTR_EXP_EXPECTED, exp->set)) {
-		__build_tuple(req, size, &exp->expected.orig, CTA_EXPECT_TUPLE);
-	}
-
-	if (test_bit(ATTR_EXP_MASTER, exp->set)) {
-		__build_tuple(req, size, &exp->master.orig, CTA_EXPECT_MASTER);
-	}
-
-	if (test_bit(ATTR_EXP_MASK, exp->set)) {
-		__build_tuple(req, size, &exp->mask.orig, CTA_EXPECT_MASK);
-	}
-
-	if (test_bit(ATTR_EXP_NAT_TUPLE, exp->set) &&
-	    test_bit(ATTR_EXP_NAT_DIR, exp->set)) {
-		struct nfattr *nest;
-
-		nest = nfnl_nest(&req->nlh, size, CTA_EXPECT_NAT);
-		__build_tuple(req, size, &exp->nat.orig, CTA_EXPECT_NAT_TUPLE);
-		nfnl_addattr32(&req->nlh, size, CTA_EXPECT_NAT_DIR,
-				htonl(exp->nat_dir));
-		nfnl_nest_end(&req->nlh, nest);
-	}
+	buf = (char *)&req->nlh;
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK_EXP << 8) | type;
+	nlh->nlmsg_flags = flags;
+	nlh->nlmsg_seq = 0;
 
-	if (test_bit(ATTR_EXP_TIMEOUT, exp->set))
-		__build_timeout(req, size, exp);
-	if (test_bit(ATTR_EXP_FLAGS, exp->set))
-		__build_flags(req, size, exp);
-	if (test_bit(ATTR_EXP_ZONE, exp->set))
-		__build_zone(req, size, exp);
-	if (test_bit(ATTR_EXP_CLASS, exp->set))
-		__build_class(req, size, exp);
-	if (test_bit(ATTR_EXP_HELPER_NAME, exp->set))
-		__build_helper_name(req, size, exp);
-	if (test_bit(ATTR_EXP_FN, exp->set))
-		__build_expectfn(req, size, exp);
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = l3num;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
 
-	return 0;
+	return nfexp_nlmsg_build(nlh, exp);
 }
-- 
2.11.0

