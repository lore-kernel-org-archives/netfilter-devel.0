Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DD7C41513
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjHHRo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbjHHRoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:44:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E894EAA151;
        Tue,  8 Aug 2023 09:20:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qTM2X-0000LW-5P; Tue, 08 Aug 2023 14:42:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH next-next 4/5] netfilter: h323: Remove unused function declarations
Date:   Tue,  8 Aug 2023 14:41:47 +0200
Message-ID: <20230808124159.19046-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808124159.19046-1-fw@strlen.de>
References: <20230808124159.19046-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yue Haibing <yuehaibing@huawei.com>

Commit f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
declared but never implemented these.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_h323.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 9e937f64a1ad..81286c499325 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -34,10 +34,6 @@ struct nf_ct_h323_master {
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr, union nf_inet_addr *addr,
 		  __be16 *port);
-void nf_conntrack_h245_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this);
-void nf_conntrack_q931_expect(struct nf_conn *new,
-			      struct nf_conntrack_expect *this);
 
 struct nfct_h323_nat_hooks {
 	int (*set_h245_addr)(struct sk_buff *skb, unsigned int protoff,
-- 
2.41.0

