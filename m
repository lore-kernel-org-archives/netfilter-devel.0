Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA8AC19F2A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Aug 2022 17:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiHKRNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Aug 2022 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiHKRNd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Aug 2022 13:13:33 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Aug 2022 09:54:23 PDT
Received: from smtp-out-2.tiscali.co.uk (smtp-out-2.tiscali.co.uk [62.24.135.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A9297D66
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Aug 2022 09:54:23 -0700 (PDT)
Received: from nabal.armitage.org.uk ([92.27.6.192])
        by smtp.talktalk.net with SMTP
        id MBQtocKhLzHAsMBQtoEude; Thu, 11 Aug 2022 17:53:19 +0100
X-Originating-IP: [92.27.6.192]
Received: from localhost (nabal.armitage.org.uk [127.0.0.1])
        by nabal.armitage.org.uk (Postfix) with ESMTP id 42DA42E452C;
        Thu, 11 Aug 2022 17:53:12 +0100 (BST)
Authentication-Results: nabal.armitage.org.uk (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=armitage.org.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=armitage.org.uk;
         h=content-transfer-encoding:mime-version:x-mailer:message-id
        :date:date:subject:subject:from:from:received; s=20200110; t=
        1660236775; x=1661100776; bh=PhtXAcup8zcHRzp3aPBL9UQviSbC+rz55rM
        puFG/1lg=; b=pNaV4zAuj0SmlCyx5koqTPAny7ZDMBkAXPg3U3J0qBzgQZMew1w
        UKH9TR4Fxv+0neRestaSEYSOgNVzRSMEqOOgGJmFxmHdnwKTXTCiRmpvNx48aas8
        Y27oehIP4t/mr6OCMbJM8whTPQxi9PBuNMUuev0NbjamS4PdQ6RfSlgc=
X-Virus-Scanned: amavisd-new at armitage.org.uk
Received: from samson.armitage.org.uk (samson.armitage.org.uk [IPv6:2001:470:69dd:35::210])
        by nabal.armitage.org.uk (Postfix) with ESMTPSA id 6B8202E4524;
        Thu, 11 Aug 2022 17:52:55 +0100 (BST)
From:   Quentin Armitage <quentin@armitage.org.uk>
To:     netfilter-devel@vger.kernel.org
Cc:     Quentin Armitage <quentin@armitage.org.uk>
Subject: [PATCH] ipset-translate: allow invoking with a path name
Date:   Thu, 11 Aug 2022 17:52:18 +0100
Message-Id: <20220811165218.59854-1-quentin@armitage.org.uk>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfPvZ99TE3hiRAA53wB5sS3X7/T3exFsl7lVGyqMr0nOkEDXxI1fIGRP1wxYAqIK9tjy9yTNs5qE9tcnQMsSUa07mIk4OywvV5FHIcO1Xtd37/Scm6JYJ
 F4Uo/V4BxizYsWivQO3pcaIsQTaAqWUgb6AA1ktjgAkpMbQHRR6S2foT5EwDFpUjaqAYB03vLrfQnjFaHJlruTW66lNqsOQKpkk=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
---
 src/ipset.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/ipset.c b/src/ipset.c
index 6d42b60..e53ffb1 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -6,6 +6,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#define _GNU_SOURCE
+
 #include <assert.h>			/* assert */
 #include <stdio.h>			/* fprintf */
 #include <stdlib.h>			/* exit */
@@ -31,7 +33,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 
-	if (!strcmp(argv[0], "ipset-translate")) {
+	if (!strcmp(basename(argv[0]), "ipset-translate")) {
 		ret = ipset_xlate_argv(ipset, argc, argv);
 	} else {
 		ret = ipset_parse_argv(ipset, argc, argv);
-- 
2.34.3

