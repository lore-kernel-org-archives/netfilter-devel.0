Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FC8C4321E
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E72D61260
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhIYPQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343911AbhIYPQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:10 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B875FC061765
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JoVyz8sY2sJ/wXvjDqjc2/a1b1Cu6BKrzGPuaoZwiZc=; b=SzRC0wivUSYKSWcbFkNCLlFcOa
        fF4xZOvNeLT/bTUFiMYe2iuo0602HiZxU3s0n+B8ZvA7HtSbji4CWI65fYInkZihSo3glyqmiF4UI
        nfHHsdO0TiXJBMJv10FKe1lNKTkIU6d58n8e5TtaW8NfDOEJqe4Zcy9p60SfUwgToAawlkFnOQoAH
        1/5yv2jSk3iJfbjp3J82wzNQ4BinfdNSBFnmnEd8+x30uHe4nUXRYAZk4glGZd1KLy2zhOrdOsSe/
        lcReYDkzW2v7lXv18AmMdIdg3hSYzLzpKbBV7MfIcDNaURYkmdAsJYBWmd8nzMeS/i7pExsyDCbWi
        QxxsFSdA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nl-00Cses-CM; Sat, 25 Sep 2021 16:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 2/6] build: quote AC_INIT arguments
Date:   Sat, 25 Sep 2021 16:10:31 +0100
Message-Id: <20210925151035.850310-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210925151035.850310-1-jeremy@azazel.net>
References: <20210925151035.850310-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 5ff8921b6fc8..c690a92be5fd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT(conntrack-tools, 1.4.6, pablo@netfilter.org)
+AC_INIT([conntrack-tools],[1.4.6],[pablo@netfilter.org])
 AC_CONFIG_AUX_DIR([build-aux])
 
 AC_CANONICAL_HOST
-- 
2.33.0

