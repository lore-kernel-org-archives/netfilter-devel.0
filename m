Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35119C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CDD422CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="B5jeqmXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfIBXci (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:38 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44142 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r9S7Dxs7DO9XiJ41OrTPUN98EC2kOoXhONqBWFJaaFo=; b=B5jeqmXG8i+j2/rATJx2IO6D8m
        UTKANUqhvejhhOH0AE9tWWx5EjUMH8kCq9edq0kpUS90CV13j+juwkbHvTZiYlFab2z4S1SczkkDx
        V2sltHvgoWhtu/yfefe58DWkN3dFUxG/aNwSzsxkDsSFvu8OmnDpQ0QTI5RdQjvtY7npb/j5qs1xu
        3KeQnilbmHYRvrjFQ4vGMj61dW+OU6H6ZhjFYjrPO3yuTmSP3Oj1TS465UFW2FRyJPwcQaRx+vpoA
        PzkdOv7uxPcGDKq7qs1JazmJSd/B40q0+GUxbJ1pzvrVZHz0wmHD7f5MStmom2dJ3OLL6Tce6m0jm
        +OwwWlsQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPS-0004la-9v; Tue, 03 Sep 2019 00:06:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 23/30] netfilter: wrap some nat-related conntrack code in a CONFIG_NF_NAT check.
Date:   Tue,  3 Sep 2019 00:06:43 +0100
Message-Id: <20190902230650.14621-24-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_update uses nf_nat_hook to do some nat stuff.  However, it
will only be not NULL if CONFIG_NF_NAT is enabled.  Wrap the code in a
CONFIG_NF_NAT check to skip it altogether.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nf_conntrack_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81a8ef42b88d..c597b3e8450b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1885,7 +1885,9 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 	enum ip_conntrack_info ctinfo;
+#if IS_ENABLED(CONFIG_NF_NAT)
 	struct nf_nat_hook *nat_hook;
+#endif
 	unsigned int status;
 	struct nf_conn *ct;
 	int dataoff;
@@ -1935,6 +1937,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	ct = nf_ct_tuplehash_to_ctrack(h);
 	nf_ct_set(skb, ct, ctinfo);
 
+#if IS_ENABLED(CONFIG_NF_NAT)
 	nat_hook = rcu_dereference(nf_nat_hook);
 	if (!nat_hook)
 		return 0;
@@ -1948,6 +1951,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_DST,
 				IP_CT_DIR_ORIGINAL) == NF_DROP)
 		return -1;
+#endif
 
 	return 0;
 }
-- 
2.23.0.rc1

