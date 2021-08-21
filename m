Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20675C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 10:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE26961051
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 10:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhHUKUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbhHUKUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 06:20:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9EBC061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 03:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ki8/UcW3jgxOCrHdvWgsfJa/gElF9oYywWlWOSmCg/c=; b=NcolI7wC6CKuakLsNisog4xuOS
        u4XkdHDcHSlhCH2KNZsEekS5zphMCszh983HUlxIQYATLllOQkdjnNlnRBPHhONzyhNaXLG39uK+S
        zXSV/QYmGvZDzEbyXJq8TR4l//WXfGkgrw5oUv/d1apbm9uZBoHT3MhZglACUl55Jq0ciiXWJmvVV
        aZ0HBOEgvvy1HS522T9T359js9cK/dhKsJkVYn2pYPbNl1LLOYlCHzO/MuoVnwm/M4qw3gVwkamoj
        vy80ASsrZVg0CXOvFZXsYUaR7RTNQP0BR6DiTi56HDrqYXM/xXhmfc3RxCuKg4QcrZ+7UJNuE49Gz
        sShceokw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHO6J-0076kf-OD; Sat, 21 Aug 2021 11:19:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] Add DWARF object files to .gitignore.
Date:   Sat, 21 Aug 2021 11:17:24 +0100
Message-Id: <20210821101724.602037-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If we build against a kernel with `CONFIG_DEBUG_INFO_SPLIT` enabled, the
kernel compiler flags will include `-gsplit-dwarf`, and the linker will
emit .dwo files.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 2ebbe0e89fe7..005e7f978d47 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,3 +1,4 @@
+*.dwo
 *.gcno
 *.la
 *.lo
-- 
2.32.0

