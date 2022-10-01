Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D98FC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 23:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJAXjX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 19:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJAXjW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 19:39:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36C02CE35
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 16:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6zHBykh5Iuxc64Mz7XFTejex3CjuBDMZa5olLZMG0Es=; b=BxOvdAJVHzyXWpxIT1X6v1TotI
        4L9Rptwt/MI54ASRsSKiZ+nXaPw3scMxM3j0/dfSaixem1xt3i6GgWUX/1FUJ7RYeEGLwxaf8faCl
        KwKHUaaAeChbRW+wM9nWcj4B7Tf31zyeP7DRFG4lkv9/VB9fSxtK2ibXBkjMTQrs5Bd+/Gd1mI1/2
        n84C4cp6Mj65hGWkh6Sbo1pkvtQ5fptmZQmhR/Qrks2gz//cMtTMxETOgoAUbDOzTHqhiX26Hfi1E
        krBo+dvdkkcALqCNpa3oWQbp4YJp3h/4DLaUi+/ptq+Yb0kYq5UucIIE05+cYOu9Vx0rt7OnBE9oR
        9lnuUsEA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oem4m-0004qL-4Q
        for netfilter-devel@vger.kernel.org; Sun, 02 Oct 2022 01:39:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] extensions: libebt_stp: Eliminate duplicate space in output
Date:   Sun,  2 Oct 2022 01:39:04 +0200
Message-Id: <20221001233906.5386-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need for print_range() to print a trailing whitespace, caller does
this already.

Fixes: fd8d7d7e5d911 ("ebtables-nft: add stp match")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_stp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 3e9e24474eb61..41059baae7078 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -146,9 +146,9 @@ static int parse_range(const char *portstring, void *lower, void *upper,
 static void print_range(unsigned int l, unsigned int u)
 {
 	if (l == u)
-		printf("%u ", l);
+		printf("%u", l);
 	else
-		printf("%u:%u ", l, u);
+		printf("%u:%u", l, u);
 }
 
 static int
-- 
2.34.1

