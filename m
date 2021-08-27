Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9B8C432BE
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 17:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E90600D4
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 17:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhH0Roy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 13:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhH0Roy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 13:44:54 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD92EC061757
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 10:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JBMLsZIk7Q3PE/BGruPet2mzgsPL3TCHhk+JwErS1yI=; b=XMAQj+cEV+NCtSYnBYjaX8fNlV
        YBQkHYKNHF5oXWgXw0F+ad7FJOepE+1Z2aV+q2L86tAFOdGe3AtkKZmhAa52cmh0xZdsU9rON35Ew
        rtb89wFA7Bxh7XUcUGXpwqqRU36xqVypm497xYQ9PFxZbWTqYvjOHlYKWhDJTwn9TN7/tOtZf3wuR
        A7IlSTlaCYkgG0xsE5Ljf4bzRW7tHCDhW4OTpe2E4ONNBbawf7HHHiPY8LCnlzS6YjLGOrOFVBfHF
        Av89Req+7sqkZnFnD/k81rGEVTFC2eLBeWz5sx36YINSDPpKGcpXue2oOLJI+oqYn2ZYN5fk8K/hS
        lgscc27Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mJftZ-00ERf1-2y; Fri, 27 Aug 2021 18:44:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log] build: remove broken code from autogen.sh.
Date:   Fri, 27 Aug 2021 18:41:43 +0100
Message-Id: <20210827174143.1094883-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `include` function, which is intended to include a copy of the
kernel's nfnetlink_log.h into the source distribution, has been broken
since 2012 when the header file was moved from where the function
expects to find it.  The header is manually sync'ed when necessary.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 autogen.sh | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 2b2995306786..5e1344a85402 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,39 +1,4 @@
 #!/bin/sh -e
 
-include ()
-{
-    # If we keep a copy of the kernel header in the SVN tree, we'll have
-    # to worry about synchronization issues forever. Instead, we just copy 
-    # the headers that we need from the lastest kernel version at autogen
-    # stage.
-
-    INCLUDEDIR=${KERNEL_DIR:-/lib/modules/`uname -r`/build}/include/linux
-    if [ -f $INCLUDEDIR/netfilter/nfnetlink_log.h ]
-    then
-    	TARGET=include/libnetfilter_log/linux_nfnetlink_log.h
-    	echo "Copying nfnetlink_log.h to linux_nfnetlink_log.h"
-    	cp $INCLUDEDIR/netfilter/nfnetlink_log.h $TARGET
-	TEMP=`tempfile`
-	sed 's/linux\/netfilter\/nfnetlink.h/libnfnetlink\/linux_nfnetlink.h/g' $TARGET > $TEMP
-	# Add aligned_u64 definition after #define _NFNETLINK_LOG_H
-	awk '{
-        if ( $0 == "#define _NFNETLINK_LOG_H" ) {
-		print $0
-		getline
-		print $0
-		print "#ifndef aligned_u64"
-		print "#define aligned_u64 unsigned long long __attribute__((aligned(8)))"
-		print "#endif"
-	}
-
-	print $0
-	}' $TEMP > $TARGET
-    else
-    	echo "can't find nfnetlink_log.h kernel file in $INCLUDEDIR"
-    	exit 1
-    fi
-}
-
-[ "x$1" = "xdistrib" ] && include
 autoreconf -fi
 rm -Rf autom4te.cache
-- 
2.33.0

