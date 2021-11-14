Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B81C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4428F60F41
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhKNOFI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbhKNOE0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:04:26 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432EBC061767
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2cG2kbJoxCdqgMLOiGDaI7VMPqLqlgie6AEtJKwSrYE=; b=LwlT2tugbCBVHDA1mcgGYe1EdF
        1AWDg6JNjW/B+Ff2+erZsCjn0RP5iViBvVJRK0yf2bpl9WLUL0cihsNt/w6OY2Booi3fNV2PcjgQy
        2FhJ44bsRRx+ZRapblLZKIZap2+vFwjyPj10G/L33tGlYH1YhSNAWkb6QqOyk9gteafDiVoXQN9U7
        dzeqoEhUqZmVRhTfs2CsV5KpNlgzmbOEPakJLE05kdSPaZeCMCfeCzLqwoel6cvFV1Jz3pwf4P4j4
        cA4PxJBiiMEkv1BPoOA+LYluWWNX2g8odZ5mwhtX6RMk2bFbytYihgsEMhFsskA2tMrnCdHSwkoU5
        plklG05w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4E-00Cdsh-Or
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 02/16] gitignore: ignore .dirstamp
Date:   Sun, 14 Nov 2021 14:00:44 +0000
Message-Id: <20211114140058.752394-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's created by automake while making sure that build directories (utils/
and utils/.deps/, in this case) exist if the `subdir-objects` option is
enabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 3f218218dfc9..3eb592245c0d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,6 +6,7 @@
 *.lo
 *.o
 .deps/
+.dirstamp
 .libs/
 Makefile
 Makefile.in
-- 
2.33.0

