Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA80C47254
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 21:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE6C208C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 21:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgEAVJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 17:09:58 -0400
Received: from smail.fem.tu-ilmenau.de ([141.24.220.41]:49316 "EHLO
        smail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAVJ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 17:09:57 -0400
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id 6ECC6201B9;
        Fri,  1 May 2020 23:09:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 3C08C61DE;
        Fri,  1 May 2020 23:09:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z0mv-4GFgHPV; Fri,  1 May 2020 23:09:50 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Fri,  1 May 2020 23:09:50 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id 9625C56050;
        Fri,  1 May 2020 23:09:50 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 78EB4306A950; Fri,  1 May 2020 23:09:50 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] tests: dump generated use new nft tool
Date:   Fri,  1 May 2020 23:09:49 +0200
Message-Id: <20200501210949.2712-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of using an (possibly outdated) system nft to generate dumps,
use the newly build tool.

This fixes the dump output being corrupted if the system tool does
not support parsing new features.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 tests/shell/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 2c415489..26f8f46d 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -122,7 +122,7 @@ do
 
 			if [ "$DUMPGEN" == "y" ] && [ "$rc_got" == 0 ] && [ ! -f "${dumpfile}" ]; then
 				mkdir -p "${dumppath}"
-				nft list ruleset > "${dumpfile}"
+				$NFT list ruleset > "${dumpfile}"
 			fi
 		else
 			((failed++))
-- 
2.20.1

