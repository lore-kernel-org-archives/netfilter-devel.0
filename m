Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715B4C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 18:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A992081C
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 18:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AKRz2LKz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AKRz2LKz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfECSjQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 14:39:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43530 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfECSjQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 14:39:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CB1A4607DE; Fri,  3 May 2019 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556908755;
        bh=zENbYrmlDA+6v7volbsHgAXI1mHU9IOJBD+ztnEtoKw=;
        h=From:To:Cc:Subject:Date:From;
        b=AKRz2LKzvIyRhQU7KL9zqavRgKtRmlT8s5uQFMhM3Zcx7zWBViEaiGCgy9MKwwA+m
         xuOZi4gGN1+5BTojxGBvwyRszwlUgZAQDa3FlqpBVNDU2KKFOqx37CUTTAAGQs/8qK
         6LXRItH8vaVmrdGLfYETXgdCYoeRm8vn+KbW83gc=
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F051A6076C;
        Fri,  3 May 2019 18:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556908755;
        bh=zENbYrmlDA+6v7volbsHgAXI1mHU9IOJBD+ztnEtoKw=;
        h=From:To:Cc:Subject:Date:From;
        b=AKRz2LKzvIyRhQU7KL9zqavRgKtRmlT8s5uQFMhM3Zcx7zWBViEaiGCgy9MKwwA+m
         xuOZi4gGN1+5BTojxGBvwyRszwlUgZAQDa3FlqpBVNDU2KKFOqx37CUTTAAGQs/8qK
         6LXRItH8vaVmrdGLfYETXgdCYoeRm8vn+KbW83gc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F051A6076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     fw@strlen.de, pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf v2] netfilter: nf_conntrack_h323: Remove deprecated config check
Date:   Fri,  3 May 2019 12:39:08 -0600
Message-Id: <1556908748-22202-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONFIG_NF_CONNTRACK_IPV6 has been deprecated so replace it with
a check for IPV6 instead.

v1->v2: Use nf_ip6_route6() instead of v6ops->route() and keep
the IS_MODULE() in nf_ipv6_ops as mentioned by Florian so that
direct calls are used when IPV6 is builtin and indirect calls
are used only when IPV6 is a module.

Fixes: a0ae2562c6c4b2 ("netfilter: conntrack: remove l3proto abstraction")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/netfilter/nf_conntrack_h323_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 005589c..12de403 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -748,24 +748,19 @@ static int callforward_do_filter(struct net *net,
 		}
 		break;
 	}
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6: {
-		const struct nf_ipv6_ops *v6ops;
 		struct rt6_info *rt1, *rt2;
 		struct flowi6 fl1, fl2;
 
-		v6ops = nf_get_ipv6_ops();
-		if (!v6ops)
-			return 0;
-
 		memset(&fl1, 0, sizeof(fl1));
 		fl1.daddr = src->in6;
 
 		memset(&fl2, 0, sizeof(fl2));
 		fl2.daddr = dst->in6;
-		if (!v6ops->route(net, (struct dst_entry **)&rt1,
+		if (!nf_ip6_route(net, (struct dst_entry **)&rt1,
 				  flowi6_to_flowi(&fl1), false)) {
-			if (!v6ops->route(net, (struct dst_entry **)&rt2,
+			if (!nf_ip6_route(net, (struct dst_entry **)&rt2,
 					  flowi6_to_flowi(&fl2), false)) {
 				if (ipv6_addr_equal(rt6_nexthop(rt1, &fl1.daddr),
 						    rt6_nexthop(rt2, &fl2.daddr)) &&
-- 
1.9.1

