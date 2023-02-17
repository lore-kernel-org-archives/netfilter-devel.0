Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D01EC636D6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjBQQSB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjBQQRy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCD75FC46
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PaSanOGEJ6xUbfu0sxfHr2DGCwT8uBvAtLSvC3Ml2nU=; b=HIKz/iqUqUC6g1mWqeC+LGQyJr
        pL2Xy7PH2PBb1CLFg0rN72bt4ysyUkR1g1kfkcOHmk8c7p7o/GYO1C3wSXshxf4spU7VJzsAqWko7
        IyMkMil5l39F1BIiigi6MVfHeVUoizA3GVQiKzs25wFQWHBMYM7DHculqnkNiHefSUPZPNfbCg7MX
        FPlj75x9KbKUZtTO8FNg+05HMAn32McYNiSJqQcJ6nzk/g+nhZkUFuUrxuYvk2B+IlyihCk/9dDMA
        mW7NWN9WpoQe1dzy8+Hf/Ml3C5hgkjZvFA/6AapCobXV3+ft4z8JUKqHkOGr2t7zyWqblF+4adkyN
        yCUvn/2A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3QK-0003Vj-25
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/6] ebtables: ip and ip6 matches depend on protocol match
Date:   Fri, 17 Feb 2023 17:17:14 +0100
Message-Id: <20230217161715.26120-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217161715.26120-1-phil@nwl.cc>
References: <20230217161715.26120-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is consistent with legacy ebtables, also avoids invalid
combinations like '-p IPv6 --ip-source 1.2.3.4'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 83cbe31559d4b..b9983b203f6d0 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -104,11 +104,18 @@ static int
 nft_bridge_add_match(struct nft_handle *h, const struct ebt_entry *fw,
 		     struct nftnl_rule *r, struct xt_entry_match *m)
 {
-	if (!strcmp(m->u.user.name, "802_3") &&
-	    !(fw->bitmask & EBT_802_3))
+	if (!strcmp(m->u.user.name, "802_3") && !(fw->bitmask & EBT_802_3))
 		xtables_error(PARAMETER_PROBLEM,
 			      "For 802.3 DSAP/SSAP filtering the protocol must be LENGTH");
 
+	if (!strcmp(m->u.user.name, "ip") && fw->ethproto != htons(ETH_P_IP))
+		xtables_error(PARAMETER_PROBLEM,
+			      "For IP filtering the protocol must be specified as IPv4.");
+
+	if (!strcmp(m->u.user.name, "ip6") && fw->ethproto != htons(ETH_P_IPV6))
+		xtables_error(PARAMETER_PROBLEM,
+			      "For IPv6 filtering the protocol must be specified as IPv6.");
+
 	return add_match(h, r, m);
 }
 
-- 
2.38.0

