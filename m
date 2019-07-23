Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A69FC7618E
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A2F5218F0
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 13:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbfGWNX3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 09:23:29 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48428 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfGWNX3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 09:23:29 -0400
Received: from localhost ([::1]:33286 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpulL-0007vi-KQ; Tue, 23 Jul 2019 15:23:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/2] src: Call bison with -Wno-yacc to silence warnings
Date:   Tue, 23 Jul 2019 15:23:13 +0200
Message-Id: <20190723132313.13238-3-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190723132313.13238-1-phil@nwl.cc>
References: <20190723132313.13238-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bison-3.3 significantly increased warnings for POSIX incompatibilities,
it now complains about missing support for %name-prefix, %define,
%destructor and string literals. The latter applies to parameter of
%name-prefix and all relevant %token statements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index e2b531390cefb..740c21f2cac85 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -22,7 +22,7 @@ AM_CFLAGS = -Wall								\
 	    -Waggregate-return -Wunused -Wwrite-strings ${GCC_FVISIBILITY_HIDDEN}
 
 
-AM_YFLAGS = -d
+AM_YFLAGS = -d -Wno-yacc
 
 BUILT_SOURCES = parser_bison.h
 
-- 
2.22.0

