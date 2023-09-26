Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555D8E7D27E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 19:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbjIZT4h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 15:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjIZT4g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 15:56:36 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D23F136
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 12:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M9oMYZKYcpe56BvwoDGMVu+S94n6PqNi8EjbOF8Ihqc=; b=OK4KXs9yGZK85iRSItF/Zx58pk
        DpybMfgMxq0M/71v5tdLIuB5q9DLrFQo6BECJYeCMwa5Xzmpz85rj153pekswjMhJZaFCMMwfrFOa
        93kTjC+V8lfOQm840hsNO2D6VOI72IAdaX1Sgp83OdKR00xV0iGehf36W0xlsFoIYB10u4CJjJo9Q
        J2hVR0+I3/bm2/yvQ2Vk+6YKz/MsL4Y/WFCQDWAQrXG/5vaMnnCL49wmv8/rAIFrBWvQyxM/Xjfav
        cfRvsjgXGQ6MVjJW+24zEUKcuULKwjYYkTJNoCuqbxIgZmoOJzvjMlvSZuKh4UvYKYQHcdlMKL/Yb
        xrVQGEKg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qlEAU-00073U-D7; Tue, 26 Sep 2023 21:56:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: features: Fix table owner flag check
Date:   Tue, 26 Sep 2023 21:56:22 +0200
Message-ID: <20230926195622.31984-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The keyword is "flags", not "flag". Resulted in a false-negative:

features/table_flag_owner.nft:4:2-5: Error: syntax error, unexpected string
	flag owner;
	^^^^

Fixes: 10373f0936cd3 ("tests: shell: skip flowtable-uaf if we lack table owner support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/table_flag_owner.nft | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/features/table_flag_owner.nft b/tests/shell/features/table_flag_owner.nft
index 6e6f608a7e940..aef122a0724bf 100644
--- a/tests/shell/features/table_flag_owner.nft
+++ b/tests/shell/features/table_flag_owner.nft
@@ -1,5 +1,5 @@
 # 6001a930ce03 ("netfilter: nftables: introduce table ownership")
 # v5.12-rc1~200^2~6^2
 table t {
-	flag owner;
+	flags owner;
 }
-- 
2.41.0

