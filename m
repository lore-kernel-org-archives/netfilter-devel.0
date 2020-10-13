Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2C7C433E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 12:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A2C5223BD
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 12:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Qb1AMXo5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgJMMbK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 08:31:10 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:22921 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgJMMbK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 08:31:10 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 08:31:10 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1210; q=dns/txt; s=iport;
  t=1602592270; x=1603801870;
  h=from:to:cc:subject:date:message-id;
  bh=imvnwR2b/Qb1Zv2bukYGNNj3ZK7ofBjSiQJ1wCM2eU0=;
  b=Qb1AMXo57LtrxlBaBNMnK/HmqrLWCvKNeE0cKacJDMr/wmVVBzjIDV7x
   j1LzxXaOvsMS9qggV2e4i/qPDTnYkXDrMQyzJN/3nmQHXZq+28NQwd9FO
   tffYusXuuQVkTGDlhqEnXusx0x07v0jeHZOqh9vcUDclZhgbTZkzzZ9A1
   s=;
X-IronPort-AV: E=Sophos;i="5.77,370,1596499200"; 
   d="scan'208";a="30256835"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Oct 2020 12:24:01 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09DCO1uJ011822;
        Tue, 13 Oct 2020 12:24:01 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net V2] netfilter: Drop fragmented ndisc packets assembled in netfilter
Date:   Tue, 13 Oct 2020 14:23:12 +0200
Message-Id: <20201013122312.8761-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fragmented ndisc packets assembled in netfilter not dropped as specified
in RFC 6980, section 5. This behaviour breaks TAHI IPv6 Core Conformance
Tests v6LC.2.1.22/23, V6LC.2.2.26/27 and V6LC.2.3.18.

Setting IP6SKB_FRAGMENTED flag during reassembly.

References: commit b800c3b966bc ("ipv6: drop fragmented ndisc packets by
default (RFC 6980)")
Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---

V2: Fix spelling of IPSKB_FRAGMENTED to IP6SKB_FRAGMENTED in comment

 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index fed9666..054d287 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -355,6 +355,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
 	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
+	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-- 
2.10.2

