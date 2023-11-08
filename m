Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D4DC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 03:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjKHDbi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 22:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjKHDbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 22:31:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CDC10C9
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 19:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rmv9j8JfORrsDRCOQDCuhIFBMAvzY7yUl8x8tv5OkxU=; b=OuwaBMGfdlb9JVDnlE4uARVAQu
        10HcdG0gEELvUJ1t4CneAwgFFrDhVu2fZnisYggPdF0M+ud5m0O2tCUKJLBVDpylQ0WhtAPo9PEeb
        07i13j5K/BkGpAvfr4hnO+ZtvoJylPLBBESRQC1P8IQhpi9Sat8LLcoi/SjpiPH76mU2htzFfBmNl
        9Tlnn3bPgJYoM4LgGr9LW5GcNjDO5KobBsu28+TPEnkuMHy4+on1HFZrc5UcA1pwLS0Y3gP8rz4To
        T3Hdg0o5xIpRjqciLhtPN5FG1gL+1PfT3cgTjGvVsjyaDbSrw2kMSyiY5rl8xagtNKu4q3EYhCOte
        iI1BdOfA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r0ZHy-0002N9-FQ; Wed, 08 Nov 2023 04:31:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] extensions: libarpt_standard.t: Add a rule with builtin option masks
Date:   Wed,  8 Nov 2023 04:31:30 +0100
Message-ID: <20231108033130.18747-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231108033130.18747-1-phil@nwl.cc>
References: <20231108033130.18747-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just some random values in hope this starts failing if masks support
changes or breaks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_standard.t | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libarpt_standard.t b/extensions/libarpt_standard.t
index b9a3560660372..153540903f786 100644
--- a/extensions/libarpt_standard.t
+++ b/extensions/libarpt_standard.t
@@ -20,3 +20,4 @@
 --proto-type 10/10;--proto-type 0xa/0xa;OK
 --proto-type 0x10;=;OK
 --proto-type 0x10/0x10;=;OK
+--h-length 6/15 --opcode 1/235 --h-type 0x8/0xcf --proto-type 0x800/0xde00;=;OK
-- 
2.41.0

