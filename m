Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C658CC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiLHPrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiLHPrX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEAD53EEF
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tLGtIK9XXbvP9Sb5QeP5gtqJFq5hXd6lRuug8+mwZ+0=; b=m2HF4324xop+I8JVhkstz0vIok
        UZAkLFsDPY6LrTPTVEpWvUSeCFAeLmzuxP8UFUfxZrGLoQFO/Jubxi9y4KtwVGLoLq9UU2i5iimqA
        +d2Hq1Jc3V4f6aXUNDAQ79ltxPOje9wTN9xk7qYJKsFGcLWaiyJpehP5HiCYAZ4qYsU4w4NcUhu21
        SBlJqhPKLUyVrjajTkItu9jOMm9IuMQVHW97w/ov/lnmm9DFUK+n5zwm3dCfFQzBjJF9GPv0orOuJ
        uHYGhabscDQMVyy3fml39yt1VYvU2CUxy3v9HzyuD+HU0YSYWB/TX17qT37Ln///ahc5yMFJr5Qx/
        1GkHltcQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J7I-0005hY-Jh; Thu, 08 Dec 2022 16:47:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 01/11] Drop INCOMPATIBILITIES file
Date:   Thu,  8 Dec 2022 16:46:06 +0100
Message-Id: <20221208154616.14622-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The problems described in there were relevant 17 years ago.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 INCOMPATIBILITIES | 14 --------------
 1 file changed, 14 deletions(-)
 delete mode 100644 INCOMPATIBILITIES

diff --git a/INCOMPATIBILITIES b/INCOMPATIBILITIES
deleted file mode 100644
index ddb24087c9696..0000000000000
--- a/INCOMPATIBILITIES
+++ /dev/null
@@ -1,14 +0,0 @@
-INCOMPATIBILITIES:
-
-- The REJECT target has an '--reject-with admin-prohib' option which used
-  with kernels that do not support it, will result in a plain DROP instead
-  of REJECT.  Use with caution.
-  Kernels that do support it:
-  	2.4 - since 2.4.22-pre9
-	2.6 - all
-
-- There are some issues related to upgrading from 1.2.x to 1.3.x on a system
-  with dynamic ruleset changes during runtime. (Please see 
-  https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=334).
-  After upgrading from 1.2 to 1.3, it suggest go do an iptables-save, then
-  iptables-restore to ensure your dynamic rule changes continue to work.
-- 
2.38.0

