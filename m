Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBDEC43217
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A3661ABB
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355161AbhJARr0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355137AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5F6C0613E2
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cp+dsN8bxedox04sctX+JaBULyXR+ytH1tFE6L981ZA=; b=czi5CJtIaI+lfO+o/lcNqNQsyb
        7D20aIOTepePMywMdZ2q0q83e8g//v2A9GcA9MXuopOQLhywldKQ2Ufmq36hzBHmFBw84eJ3iSBiT
        db1JdcXdJ1YunYpSr22TZphWarR1dUNy/fWYiAZ9S2dNRx1V7Cv4hyqg/y7MJK4r/fCd576iCdc2j
        3gKPkNLy97v6aTa27Y3KZGNt14rBBMt+XQqvUuzAk72qKnoz5GeqW3HFydDOIf0MGGBXOJnPb4Q+g
        fGPdFPks/jcqQ5IK+TfObjD+49G6Uz/WhzfPKAvn4hvfyxKWm+1b0WChO4ZtOtXV32j0Yxam9FHkb
        Uciqna5Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbG-002RLP-TZ; Fri, 01 Oct 2021 18:45:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 4/8] extensions: libxt_NFLOG: disable `--nflog-range` Python test-cases
Date:   Fri,  1 Oct 2021 18:41:38 +0100
Message-Id: <20211001174142.1267726-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kyle Bowman <kbowman@cloudflare.com>

nft has no equivalent to `--nflog-range`, so we cannot emulate it and
the Python unit-tests for it fail.  However, since `--nflog-range` is
broken and doesn't do anything, the tests are not testing anything
useful.

Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 933fa22160e5..eefb058be30e 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -3,10 +3,12 @@
 -j NFLOG --nflog-group 65535;=;OK
 -j NFLOG --nflog-group 65536;;FAIL
 -j NFLOG --nflog-group 0;-j NFLOG;OK
--j NFLOG --nflog-range 1;=;OK
--j NFLOG --nflog-range 4294967295;=;OK
--j NFLOG --nflog-range 4294967296;;FAIL
--j NFLOG --nflog-range -1;;FAIL
+# `--nflog-range` is broken and only supported by xtables-legacy.  It
+# has been superseded by `--nflog--group`.
+# -j NFLOG --nflog-range 1;=;OK
+# -j NFLOG --nflog-range 4294967295;=;OK
+# -j NFLOG --nflog-range 4294967296;;FAIL
+# -j NFLOG --nflog-range -1;;FAIL
 -j NFLOG --nflog-size 0;=;OK
 -j NFLOG --nflog-size 1;=;OK
 -j NFLOG --nflog-size 4294967295;=;OK
-- 
2.33.0

