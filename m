Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F192C46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 17:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjAKR45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbjAKR4z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 12:56:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7217B13F6D
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 09:56:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] conntrack: add sanity check to netlink socket filter API
Date:   Wed, 11 Jan 2023 18:56:50 +0100
Message-Id: <20230111175650.160768-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Validate that filtering by layer 4 protocol number and protocol state
fits into the existing maps that is used internally.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack/filter.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index 4cbc116454cf..57b22945fc3b 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -11,18 +11,31 @@
 
 static void filter_attr_l4proto(struct nfct_filter *filter, const void *value)
 {
+	int protonum;
+
 	if (filter->l4proto_len >= __FILTER_L4PROTO_MAX)
 		return;
 
-	set_bit(*((int *) value), filter->l4proto_map);
+	protonum = *(int *)value;
+	if (protonum >= IPPROTO_MAX)
+		return;
+
+	set_bit(protonum, filter->l4proto_map);
 	filter->l4proto_len++;
 }
 
-static void 
+#ifndef BITS_PER_BYTE
+#define BITS_PER_BYTE	8
+#endif
+
+static void
 filter_attr_l4proto_state(struct nfct_filter *filter, const void *value)
 {
 	const struct nfct_filter_proto *this = value;
 
+	if (this->state >= sizeof(filter->l4proto_state[0].map) * BITS_PER_BYTE)
+		return;
+
 	set_bit_u16(this->state, &filter->l4proto_state[this->proto].map);
 	filter->l4proto_state[this->proto].len++;
 }
-- 
2.30.2

