Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8BAC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 19:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiCYTgx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiCYTgU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 15:36:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3282E51A0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 12:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=brdocWpQkRDSZM2eunBJxrRxuydrXyho6N3sUEw5AJE=; b=AMo/4Y1CDGZKCuOjYsWIcuDI7m
        4riFQqvDCwq2CSaMrMi1BY0j/oeXJ6tmsNEk46EVefbpcy4y7/qV/kaB4nINOqMtQ3azryPs6T3hx
        q29wU0phEvXvzcmShnU21taIw0Al6L44fQ4IXjQgTFZW1VzP37wUbE/OOLXpUx5S0/zIQOQR9InIb
        znlSbsg4W/mXbdwvZRej9qdVUJrC3LJr7o9Ovwx5qA1EDpZbce+eqPvvz9KgvWDW9zDIhQfAcqLzv
        klTyuwDNB/I+uYBfdCAA0j+rvwd12duAQV41rduLIJJqycSzViHCNvxBLG5h1EqOg5fn3FvyUiDwq
        vNq2FjBA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXnpZ-0004MF-IJ; Fri, 25 Mar 2022 18:34:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnfnetlink PATCH 1/2] include: Silence gcc warning in linux_list.h
Date:   Fri, 25 Mar 2022 18:34:25 +0100
Message-Id: <20220325173426.11493-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Compiler complained about empty prefetch() macro:

| ../include/linux_list.h:385:66: warning: right-hand operand of comma expression has no effect [-Wunused-value]
|   385 |         for (pos = list_entry((head)->next, typeof(*pos), member),      \
|       |                                                                  ^

Use nftables' variant instead which gcc seems to like more.

Fixes: 36d2ed3de20a3 ("major cleanup of index2name infrastructure: use linux list (and fix leak in the nlif_close path)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux_list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux_list.h b/include/linux_list.h
index de182a4764706..cf71837f18347 100644
--- a/include/linux_list.h
+++ b/include/linux_list.h
@@ -29,7 +29,7 @@
 	1; \
 })
 
-#define prefetch(x)		1
+#define prefetch(x) ((void)0)
 
 /* empty define to make this work in userspace -HW */
 #ifndef smp_wmb
-- 
2.34.1

