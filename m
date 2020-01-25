Return-Path: <SRS0=x4bV=3O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2976FC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 17:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E14C2070A
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Jan 2020 17:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgAYRej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Jan 2020 12:34:39 -0500
Received: from correo.us.es ([193.147.175.20]:35488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgAYRe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Jan 2020 12:34:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4EC7D12C1E4
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jan 2020 18:34:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F415DA70F
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jan 2020 18:34:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35032DA705; Sat, 25 Jan 2020 18:34:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28FD1DA709;
        Sat, 25 Jan 2020 18:34:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 25 Jan 2020 18:34:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0557442EE38E;
        Sat, 25 Jan 2020 18:34:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/7] net: Fix skb->csum update in inet_proto_csum_replace16().
Date:   Sat, 25 Jan 2020 18:34:15 +0100
Message-Id: <20200125173415.191571-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200125173415.191571-1-pablo@netfilter.org>
References: <20200125173415.191571-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Praveen Chaudhary <praveen5582@gmail.com>

skb->csum is updated incorrectly, when manipulation for
NF_NAT_MANIP_SRC\DST is done on IPV6 packet.

Fix:
There is no need to update skb->csum in inet_proto_csum_replace16(),
because update in two fields a.) IPv6 src/dst address and b.) L4 header
checksum cancels each other for skb->csum calculation. Whereas
inet_proto_csum_replace4 function needs to update skb->csum, because
update in 3 fields a.) IPv4 src/dst address, b.) IPv4 Header checksum
and c.) L4 header checksum results in same diff as L4 Header checksum
for skb->csum calculation.

[ pablo@netfilter.org: a few comestic documentation edits ]
Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
Signed-off-by: Andy Stracner <astracner@linkedin.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/utils.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 6b6e51db9f3b..1f31a39236d5 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -438,6 +438,23 @@ void inet_proto_csum_replace4(__sum16 *sum, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(inet_proto_csum_replace4);
 
+/**
+ * inet_proto_csum_replace16 - update layer 4 header checksum field
+ * @sum: Layer 4 header checksum field
+ * @skb: sk_buff for the packet
+ * @from: old IPv6 address
+ * @to: new IPv6 address
+ * @pseudohdr: True if layer 4 header checksum includes pseudoheader
+ *
+ * Update layer 4 header as per the update in IPv6 src/dst address.
+ *
+ * There is no need to update skb->csum in this function, because update in two
+ * fields a.) IPv6 src/dst address and b.) L4 header checksum cancels each other
+ * for skb->csum calculation. Whereas inet_proto_csum_replace4 function needs to
+ * update skb->csum, because update in 3 fields a.) IPv4 src/dst address,
+ * b.) IPv4 Header checksum and c.) L4 header checksum results in same diff as
+ * L4 Header checksum for skb->csum calculation.
+ */
 void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 			       const __be32 *from, const __be32 *to,
 			       bool pseudohdr)
@@ -449,9 +466,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		*sum = csum_fold(csum_partial(diff, sizeof(diff),
 				 ~csum_unfold(*sum)));
-		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
-			skb->csum = ~csum_partial(diff, sizeof(diff),
-						  ~skb->csum);
 	} else if (pseudohdr)
 		*sum = ~csum_fold(csum_partial(diff, sizeof(diff),
 				  csum_unfold(*sum)));
-- 
2.11.0

