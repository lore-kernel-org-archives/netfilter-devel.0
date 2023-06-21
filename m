Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9886EB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjFUPpd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 11:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjFUPpB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 11:45:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B61A19A9
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 08:44:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qC00u-0000Fd-OQ; Wed, 21 Jun 2023 17:44:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH nf] netfilter: conntrack: dccp: copy entire header to stack buffer, not just basic one
Date:   Wed, 21 Jun 2023 17:44:51 +0200
Message-Id: <20230621154451.8176-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Dumazet says:
  nf_conntrack_dccp_packet() has an unique:

  dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);

  And nothing more is 'pulled' from the packet, depending on the content.
  dh->dccph_doff, and/or dh->dccph_x ...)
  So dccp_ack_seq() is happily reading stuff past the _dh buffer.

BUG: KASAN: stack-out-of-bounds in nf_conntrack_dccp_packet+0x1134/0x11c0
Read of size 4 at addr ffff000128f66e0c by task syz-executor.2/29371
[..]

Fix this by increasing the stack buffer to also include room for
the extra sequence numbers and all the known dccp packet type headers,
then pull again after the initial validation of the basic header.

While at it, mark packets invalid that lack 48bit sequence bit but
where RFC says the type MUST use them.

Compile tested only.

Heads-up: I intend to remove dccp conntrack support later this year.

Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol support")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 50 ++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index c1557d47ccd1..745a1f76c249 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -432,9 +432,19 @@ static bool dccp_error(const struct dccp_hdr *dh,
 		       struct sk_buff *skb, unsigned int dataoff,
 		       const struct nf_hook_state *state)
 {
+	static const unsigned long require_seq48 = 1 << DCCP_PKT_REQUEST |
+						   1 << DCCP_PKT_RESPONSE |
+						   1 << DCCP_PKT_CLOSEREQ |
+						   1 << DCCP_PKT_CLOSE |
+						   1 << DCCP_PKT_RESET |
+						   1 << DCCP_PKT_SYNC |
+						   1 << DCCP_PKT_SYNCACK;
 	unsigned int dccp_len = skb->len - dataoff;
 	unsigned int cscov;
 	const char *msg;
+	u8 type;
+
+	BUILD_BUG_ON(DCCP_PKT_INVALID >= BITS_PER_LONG);
 
 	if (dh->dccph_doff * 4 < sizeof(struct dccp_hdr) ||
 	    dh->dccph_doff * 4 > dccp_len) {
@@ -459,26 +469,57 @@ static bool dccp_error(const struct dccp_hdr *dh,
 		goto out_invalid;
 	}
 
-	if (dh->dccph_type >= DCCP_PKT_INVALID) {
+	type = dh->dccph_type;
+	if (type >= DCCP_PKT_INVALID) {
 		msg = "nf_ct_dccp: reserved packet type ";
 		goto out_invalid;
 	}
+
+	if (test_bit(type, &require_seq48) && !dh->dccph_x) {
+		msg = "nf_ct_dccp: type lacks 48bit sequence numbers";
+		goto out_invalid;
+	}
+
 	return false;
 out_invalid:
 	nf_l4proto_log_invalid(skb, state, IPPROTO_DCCP, "%s", msg);
 	return true;
 }
 
+struct nf_conntrack_dccp_buf {
+	struct dccp_hdr _dh;	 /* must be first */
+	struct dccp_hdr_ext ext; /* optional depending dh->dccph_x */
+	union {			 /* depends on header type */
+		struct dccp_hdr_ack_bits ack;
+		struct dccp_hdr_request req;
+		struct dccp_hdr_response response;
+		struct dccp_hdr_reset rst;
+	} u;
+};
+
+static struct dccp_hdr *
+dccp_header_pointer(const struct sk_buff *skb, int offset, const struct dccp_hdr *dh,
+		    struct nf_conntrack_dccp_buf *buf)
+{
+	unsigned int hdrlen = __dccp_hdr_len(dh);
+
+	if (hdrlen > sizeof(*buf))
+		return NULL;
+
+	return skb_header_pointer(skb, offset, hdrlen, buf);
+}
+
 int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 			     unsigned int dataoff,
 			     enum ip_conntrack_info ctinfo,
 			     const struct nf_hook_state *state)
 {
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	struct dccp_hdr _dh, *dh;
+	struct nf_conntrack_dccp_buf _dh;
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 	unsigned int *timeouts;
+	struct dccp_hdr *dh;
 
 	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (!dh)
@@ -487,6 +528,11 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	if (dccp_error(dh, skb, dataoff, state))
 		return -NF_ACCEPT;
 
+	/* pull again, including possible 48 bit sequences and subtype header */
+	dh = dccp_header_pointer(skb, dataoff, dh, &_dh);
+	if (!dh)
+		return NF_DROP;
+
 	type = dh->dccph_type;
 	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
 		return -NF_ACCEPT;
-- 
2.39.3

