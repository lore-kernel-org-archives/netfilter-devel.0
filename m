Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129F3C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3247613E9
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 May 2021 20:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhEEVAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 May 2021 17:00:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45820 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhEEVAX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 May 2021 17:00:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 64ED1605AA
        for <netfilter-devel@vger.kernel.org>; Wed,  5 May 2021 22:58:41 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: remove BUG_ON() after skb_header_pointer()
Date:   Wed,  5 May 2021 22:59:21 +0200
Message-Id: <20210505205921.2885-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Several conntrack helpers and the TCP tracker assume that
skb_header_pointer() never fails based on upfront header validation.
Even if this should not ever happen, BUG_ON() is a too drastic measure,
remove them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_ftp.c       | 3 ++-
 net/netfilter/nf_conntrack_h323_main.c | 3 ++-
 net/netfilter/nf_conntrack_irc.c       | 3 ++-
 net/netfilter/nf_conntrack_pptp.c      | 4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++--
 net/netfilter/nf_conntrack_sane.c      | 3 ++-
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index b22801f97bce..1af5fe007e4e 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -413,7 +413,8 @@ static int help(struct sk_buff *skb,
 
 	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
-	BUG_ON(fb_ptr == NULL);
+	if (!fb_ptr)
+		return NF_ACCEPT;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
 	seq = ntohl(th->seq) + datalen;
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8ba037b76ad3..aafaff00baf1 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -146,7 +146,8 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 		/* Get first TPKT pointer */
 		tpkt = skb_header_pointer(skb, tcpdataoff, tcpdatalen,
 					  h323_buffer);
-		BUG_ON(tpkt == NULL);
+		if (!tpkt)
+			goto clear_out;
 
 		/* Validate TPKT identifier */
 		if (tcpdatalen < 4 || tpkt[0] != 0x03 || tpkt[1] != 0) {
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index e40988a2f22f..3881a237237d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -143,7 +143,8 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	spin_lock_bh(&irc_buffer_lock);
 	ib_ptr = skb_header_pointer(skb, dataoff, skb->len - dataoff,
 				    irc_buffer);
-	BUG_ON(ib_ptr == NULL);
+	if (!ib_ptr)
+		return NF_ACCEPT;
 
 	data = ib_ptr;
 	data_limit = ib_ptr + skb->len - dataoff;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 5105d4250012..7d5708b92138 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -544,7 +544,9 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 
 	nexthdr_off = protoff;
 	tcph = skb_header_pointer(skb, nexthdr_off, sizeof(_tcph), &_tcph);
-	BUG_ON(!tcph);
+	if (!tcph)
+		return NF_ACCEPT;
+
 	nexthdr_off += tcph->doff * 4;
 	datalen = tcplen - tcph->doff * 4;
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 318b8f723349..34e22416a721 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -338,7 +338,8 @@ static void tcp_options(const struct sk_buff *skb,
 
 	ptr = skb_header_pointer(skb, dataoff + sizeof(struct tcphdr),
 				 length, buff);
-	BUG_ON(ptr == NULL);
+	if (!ptr)
+		return;
 
 	state->td_scale =
 	state->flags = 0;
@@ -394,7 +395,8 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 
 	ptr = skb_header_pointer(skb, dataoff + sizeof(struct tcphdr),
 				 length, buff);
-	BUG_ON(ptr == NULL);
+	if (!ptr)
+		return;
 
 	/* Fast path for timestamp-only option */
 	if (length == TCPOLEN_TSTAMP_ALIGNED
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 1aebd6569d4e..276932e2ec2f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -95,7 +95,8 @@ static int help(struct sk_buff *skb,
 
 	spin_lock_bh(&nf_sane_lock);
 	sb_ptr = skb_header_pointer(skb, dataoff, datalen, sane_buffer);
-	BUG_ON(sb_ptr == NULL);
+	if (!sb_ptr)
+		return NF_ACCEPT;
 
 	if (dir == IP_CT_DIR_ORIGINAL) {
 		if (datalen != sizeof(struct sane_request))
-- 
2.30.2

