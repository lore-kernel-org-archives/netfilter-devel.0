Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6B9C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiLGRpl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiLGRpf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246125C758
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tLGtIK9XXbvP9Sb5QeP5gtqJFq5hXd6lRuug8+mwZ+0=; b=IY6uMxLvfXR0GvKIxUiciHZYvT
        hgZZj+hZQRZeeWsisg23AjtGEgdmK/NIJoqsixzLQuU4pjc1JZO0MunqyJUARaP4ACLM4u1+uCJd/
        oQmnHfMjNHte8IKRIbsM2DoSn3LdNp8NMgcjRGQGr28RU3hoKv5zTgVvcbFkc0g4l+YuVm3evrlk3
        ZkwZ8pY0cte6dO8h7Cgz1mP/BzoLTYieZNYjwGwwkCZp/fn5yObjYjsBh2CCenrqb1z5F6z3GfrsU
        bBeEeRB1qejCjlX6RhaunjNhW4ggqlEAw/wkLlbm4iRa12TU5js4EE0Mujzs5QqjyfB34ebTy4ab3
        4U1kh5+w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yU8-0000iV-IA
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/11] Drop INCOMPATIBILITIES file
Date:   Wed,  7 Dec 2022 18:44:20 +0100
Message-Id: <20221207174430.4335-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
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

