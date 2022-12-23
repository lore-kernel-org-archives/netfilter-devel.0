Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388F6C3DA79
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Dec 2022 16:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiLWQY6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 11:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiLWQY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 11:24:57 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C539F2BDB
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2022 08:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gxl7IsWbMTSzTGXBVD8XBSZjvIcU5Vsy7seFUfbrH0M=; b=aR7qMTJGARZUeICxtJjqxYRE8o
        ierQEbkJyopMIaMYPibqITMyor9Bh4nDXTuRFXjq6s1wR/DQTMKtNvymQRRFGp2vowZ8JiAy8I93Z
        7KqhfREImaSusefQHUtYmZQGsPsYIj66uDYqTs6JbXYrPu4CvqlOwSOPaPiop0/0Xb5jZokEFwZzf
        BRw6ex1Bp/ahT05Qhr+ccaQQlAig1ITNpyQHd4NQNvY1Z9u/vW5d6RwAYMb0rINiCAuNxGYZYB9Ir
        hrjCSGm/ZCThVoOWuQ+89fTMPnuFPluZJQf9YCRHcNiQ/NgpbXZ3jnt5k+lh4o1bLUqMO6+FlmEjW
        m4O6n1WA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p8kqt-005e5T-4v
        for netfilter-devel@vger.kernel.org; Fri, 23 Dec 2022 16:24:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_conntrack 2/2] conntrack: simplify calculation of `struct sock_fprog` length
Date:   Fri, 23 Dec 2022 16:24:41 +0000
Message-Id: <20221223162441.2692988-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221223162441.2692988-1-jeremy@azazel.net>
References: <20221223162441.2692988-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When assigning the length to the `struct sock_fprog` object, we
calculate it by multiplying the number of `struct sock_filter` objects,
`j`, by `sizeof(struct sock_filter)` and then dividing by
`sizeof(bsf[0])`, which, since `bsf[0]` is a `struct sock_filter`, is
equal to `sizeof(struct sock_filter)`.

Remove the `sizeof` expressions and just assign `j`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/conntrack/bsf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 589bfd8e5d18..35cc8b7690c0 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -783,7 +783,7 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *f)
 	show_filter(bsf, from, j, "---- final verdict ----");
 	from = j;
 
-	sf.len = (sizeof(struct sock_filter) * j) / sizeof(bsf[0]);
+	sf.len = j;
 	sf.filter = bsf;
 
 	return setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &sf, sizeof(sf));
-- 
2.35.1

