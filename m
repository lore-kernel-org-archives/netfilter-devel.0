Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB96C6FD1B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCEMeT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCEMeQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7988EEC41
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XQd7qp0NHcVqEwIpOGdJmUtcxh3JSMsHzophDG1vQIE=; b=XGCXP0ihGx2YspLr1gGqtoviwu
        PBm5vL86U7bQu3KVoVN8hQ9iazmfGIhqvCqy+oOghOXD3GLdcga+0uKU6b933Kz3ijEu3eJstlElT
        obfNxFe1quXjValwhpTFs7SPNW1RUvJ0NhnHyn+XBUOr//+wYDl1xOV8i0wFC3+hLeHcS/VDHA7rO
        6iP8cG3qxXfJAyajBTMx1RULZQWx+cgwcU4pI2JSv9ixu7hzpD5Nbm4/1t3kdctCJ2ThknDBk1m6x
        HI32LHKu4x/lELF4pTHD8pGBYHnLDv/8XLIf7XINwUViUDaRxTSQnq8WFJUqZ3yiSGNLV0jdoTqPY
        jp71tIgA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ6-00E3og-LD
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 03/13] netfilter: nat: extend core support for shifted port-ranges
Date:   Sun,  5 Mar 2023 12:18:07 +0000
Message-Id: <20230305121817.2234734-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305121817.2234734-1-jeremy@azazel.net>
References: <20230305121817.2234734-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 2eb0f624b709 ("netfilter: add NAT support for shifted portmap
ranges") makes changes in the NAT core to add support for shifted
port-ranges to iptables DNAT.  Before adding support for these to the
nft NAT modules extend the core changes to support SNAT as well.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nf_nat_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ce829d434f13..9e3a9472df2f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -255,6 +255,9 @@ static int in_range(const struct nf_conntrack_tuple *tuple,
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED))
 		return 1;
 
+	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
+		return 0;
+
 	return l4proto_in_range(tuple, NF_NAT_MANIP_SRC,
 				&range->min_proto, &range->max_proto);
 }
-- 
2.39.2

