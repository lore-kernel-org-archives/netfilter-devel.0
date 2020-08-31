Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A469CC433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C69F2068E
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 13:00:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ssPbtdbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgHaM76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 08:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgHaM7y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 08:59:54 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93ADC061573
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 05:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lHHO/veRb1FuPbJOeiTP2Oaad9aYoBgksTucS4LzGcM=; b=ssPbtdbEl9dyXVaUSLqbpnPYaQ
        k9wTh11FRzJGger6wVbszLz5psitBQptNpOqZbg2pvGrTLX/UDoLZ4Ai9vEXEkxtkNNxrPbqdFQWx
        90DTyz4ATkA6rp40pP0NqYQymB0oHMhI/VbQ780BcC4fh+YRsuhLPuBhn7rNCMftRq6JiJT9hIo3z
        6122fovjZo/z1SK9NT1ipsdFUpUtdZOVyBpsJyWDduffHj4kYT/FqAoE7Xjl8oWjfiYGdnmWCY+sa
        dwK/47sqoHcr+PErjWPiIQwMbTRx3s4389qmRT/6TvPVOA8E+WouyOKsYbYQtECVdyt1NPR9w2Qnf
        zboBR5Ag==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kCjPb-0002zd-VJ; Mon, 31 Aug 2020 13:59:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH 2/2] build: bump supported kernel version to 5.9.
Date:   Mon, 31 Aug 2020 13:59:48 +0100
Message-Id: <20200831125948.22891-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831125948.22891-1-jeremy@azazel.net>
References: <20200831125948.22891-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7d779964f77d..3e4755db3542 100644
--- a/configure.ac
+++ b/configure.ac
@@ -57,7 +57,7 @@ if test -n "$kbuilddir"; then
 		echo "WARNING: Version detection did not succeed. Continue at own luck.";
 	else
 		echo "$kmajor.$kminor.$kmicro.$kstable in $kbuilddir";
-		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 8; then
+		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 9; then
 			echo "WARNING: That kernel version is not officially supported yet. Continue at own luck.";
 		elif test "$kmajor" -eq 5 -a "$kminor" -ge 0; then
 			:
-- 
2.28.0

