Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D906C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F149320872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKUMds (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:33:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:40242 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbfKUMdq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 07:33:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9186DABD6;
        Thu, 21 Nov 2019 12:33:44 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Michal Rostecki <mrostecki@opensuse.org>
Subject: [PATCH nft] mnl: Fix -Wimplicit-function-declaration warnings
Date:   Thu, 21 Nov 2019 13:33:32 +0100
Message-Id: <20191121123332.5245-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This change fixes the following warnings:

mnl.c: In function ‘mnl_nft_flowtable_add’:
mnl.c:1442:14: warning: implicit declaration of function ‘calloc’ [-Wimplicit-function-declaration]
  dev_array = calloc(len, sizeof(char *));
              ^~~~~~
mnl.c:1442:14: warning: incompatible implicit declaration of built-in function ‘calloc’
mnl.c:1442:14: note: include ‘<stdlib.h>’ or provide a declaration of ‘calloc’
mnl.c:1449:2: warning: implicit declaration of function ‘free’ [-Wimplicit-function-declaration]
  free(dev_array);
  ^~~~
mnl.c:1449:2: warning: incompatible implicit declaration of built-in function ‘free’
mnl.c:1449:2: note: include ‘<stdlib.h>’ or provide a declaration of ‘free’

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 src/mnl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/mnl.c b/src/mnl.c
index fdba0af8..aa5b0b46 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -30,6 +30,7 @@
 #include <arpa/inet.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <stdlib.h>
 #include <utils.h>
 #include <nftables.h>
 
-- 
2.16.4

