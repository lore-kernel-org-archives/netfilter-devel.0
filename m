Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6AFC6379F
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 13:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBQNt0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBQNtZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 08:49:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CE9692B3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 05:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IiTBqOeL5z0yDmqVlqDSX31/N2ggktDQCmHCmaCrk88=; b=fb7kuDuUPqBJ8QVXHsqr6KtvA4
        xuO0ubq++iejhlSmNIDsXJstu/P/C6UBpLMllBZ1iUeGtag2E+WyrZ+EnD6pffZiiX+/U5O7EsdDi
        dP9W4uTS6s6oJnccjdAF58MaK6P7Qm0wBDcamEsioV6xBaq0+FS3mtKeWxLw9vsdDdGVm6z1Nl4sJ
        QhwLYnMUhwVxHlJzrAFFysYEL7YMKi22A4zDeHkJy1Kk8DPHlySLAw8J7XQsXTkC02fUbsLG5l/rI
        49o8xt5dzSMw7AZeCiSahL358dJWn5HwYcXND/ILleUgKjb1r3/l4sbfMKyiGFI8Up1Z2hND6RBdB
        0MutOCYg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT16r-0001vb-PX
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 14:49:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] tests: xlate: Properly split input in replay mode
Date:   Fri, 17 Feb 2023 14:48:54 +0100
Message-Id: <20230217134855.17247-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Source command may contain quotes, using shlex.split() does the right
thing there.

Fixes: 7705b2daa3bdc ("tests: xlate: Use --check to verify replay")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/xlate-test.py b/xlate-test.py
index 1b544600aa242..09e3b67a853df 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -64,7 +64,7 @@ xtables_nft_multi = 'xtables-nft-multi'
     if sourceline.find(';') >= 0:
         sourceline, searchline = sourceline.split(';')
 
-    srcwords = sourceline.split()
+    srcwords = shlex.split(sourceline)
 
     srccmd = srcwords[0]
     ipt = srccmd.split('-')[0]
-- 
2.38.0

