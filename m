Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37CEC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiBDN1L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358702AbiBDN1K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 08:27:10 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B16AC061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 05:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g4uaHLQZryEV5VPYpeznUbdkB1ph2StM4U+RjpVDLZg=; b=qMPbxWrHf3rVGH/WfilrckubpM
        qEYhOe9l23kSNZxRCwc/0G0zLxK6ooLZB1gbTI4qvngE66KNoX9zR9aFOHwp8/kT9R8aWqBAdR4Tv
        be4W44m4jcmZwFSJHA9NxG3pa1UFDJW2nNwENiOZdXgkuPPUPM0pgh3MO3RYxxZHt/ZAwFZ1Wdcty
        FEIFiSlN/+CR8vrvyuMTqvR+4H29b+OuG+hJ+qzdbe4UH++h2cI+FxzJxFA9UkniXetexoor8udwM
        iiYBdCNBX0TUvoHyasedIBQObS53eCplAYxm0FLXGz4F2/12T0n1W7WYacOwW1CXoZc5upEJCYWvm
        UxuCBY4g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nFycG-00BLdH-KR; Fri, 04 Feb 2022 13:27:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [xtables-addons PATCH 2/2] build: bump supported kernel version to 5.17
Date:   Fri,  4 Feb 2022 13:26:43 +0000
Message-Id: <20220204132643.1212741-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204132643.1212741-1-jeremy@azazel.net>
References: <20220204132643.1212741-1-jeremy@azazel.net>
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
index 44148d2cf349..1670ab942098 100644
--- a/configure.ac
+++ b/configure.ac
@@ -59,7 +59,7 @@ AS_IF([test -n "$kbuilddir"], [
 		yoff
 	], [
 		echo "$kmajor.$kminor.$kmicro.$kstable in $kbuilddir";
-		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 16; then
+		if test "$kmajor" -gt 5 -o "$kmajor" -eq 5 -a "$kminor" -gt 17; then
 			yon
 			echo "WARNING: That kernel version is not officially supported yet. Continue at own luck.";
 			yoff
-- 
2.34.1

