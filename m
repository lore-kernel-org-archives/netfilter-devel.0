Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FEBC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 10:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiCDKiE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 05:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiCDKiD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 05:38:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C4DE728E
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 02:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W1mP97XRqReOsyOMd/4kK/7IznVJTXlEGKoaXE9eU0Q=; b=JMYK14F+8FNxXB+bN+AoeSsUrB
        ks2DODfXCsHBN6SVPw3nWDhvzBRlkivWBCzM0lwe+t04UD2dZeSyV1JtDwTgTmznY1Bltjk2ZnKde
        dwWEZGheXfI2XEah1A+S21bZ+JNoURY0kA2Baa9svaVmwwAJaUuxUdUd7PH+30HsksTr8ibsadd6O
        VjtFtnOXN95d0Uw+0h5+C/02P0VehvHZBJfpiNp70ke1LpKrMDeu+mGaFjoHaod8R0WGhDSiEHY8p
        faq2Q9BtZ7T+SyX4wQQtj4oRhWHl4F3dtrdSljXBIjeGblcvAt7WGZJ0yNBw1LGngCTq/epEuzLp+
        N/i0NZ0A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nQ5JB-00032x-56; Fri, 04 Mar 2022 11:37:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] misspell: Avoid segfault with anonymous chains
Date:   Fri,  4 Mar 2022 11:37:11 +0100
Message-Id: <20220304103711.23355-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When trying to add a rule which contains an anonymous chain to a
non-existent chain, string_misspell_update() is called with a NULL
string because the anonymous chain has no name. Avoid this by making the
function NULL-pointer tolerant.

c330152b7f777 ("src: support for implicit chain bindings")

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/misspell.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/misspell.c b/src/misspell.c
index 6536d7557a445..f213a240005e6 100644
--- a/src/misspell.c
+++ b/src/misspell.c
@@ -80,8 +80,8 @@ int string_misspell_update(const char *a, const char *b,
 {
 	unsigned int len_a, len_b, max_len, min_len, distance, threshold;
 
-	len_a = strlen(a);
-	len_b = strlen(b);
+	len_a = a ? strlen(a) : 0;
+	len_b = b ? strlen(b) : 0;
 
 	max_len = max(len_a, len_b);
 	min_len = min(len_a, len_b);
-- 
2.34.1

