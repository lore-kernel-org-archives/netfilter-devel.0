Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B2BC6FA99
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjCGXbk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCGXbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:31:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A727A8C5E
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ymf/oMxa+WxyfhPIOTUOmo/6lrxHMSbBW18nO/brCoY=; b=pSFh5AhGc+Cvs00QG7yJKI4mFo
        0QRlSkkGS0xPI8BUYcLH3WLmzcbJIgTgpip/z0b3fgFL7/mWLOfHyrCOeRp0OCKXMep9F/0a290u0
        PukSPNLuUmNgRt2j7vEOpN+cygAHH6hrL2hw0cnsDqEtNYVr5uIJGQ0bxFvotYTtvagI9yqPqx3n6
        VpJM2bbxR7PM+U9PmXMxqafeJrAMGQsBQan9y+25a3rMP5bXjdKM930UFI0Eg1VVYMLYHJALt5mET
        8l4FrbDyTlkaVVNOXFuk5YpkkIxWfQyLoatqhYOmPFe//P/E+ww3eQlbtnYWpIPYGpqp+Z7B+xWVC
        8pC/D4Ag==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgmM-00H2Ov-TL
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:31:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 2/9] netfilter: nat: fix indentation of function arguments
Date:   Tue,  7 Mar 2023 23:30:49 +0000
Message-Id: <20230307233056.2681361-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307233056.2681361-1-jeremy@azazel.net>
References: <20230307233056.2681361-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A couple of arguments to a function call are incorrectly indented.
Fix them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nf_nat_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index e29e4ccb5c5a..ce829d434f13 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -549,8 +549,8 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
-			          &range->min_proto,
-			          &range->max_proto) &&
+					     &range->min_proto,
+					     &range->max_proto) &&
 			    (range->min_proto.all == range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
 				return;
-- 
2.39.2

