Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F66C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 22:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiERWDb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 18:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiERWDO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 18:03:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C74E8286FC2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 14:54:06 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] expr: fib: missing #include <assert.h>
Date:   Wed, 18 May 2022 23:54:02 +0200
Message-Id: <20220518215403.360178-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/fib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expr/fib.c b/src/expr/fib.c
index 59b335a72546..7e6c0dc4372d 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -15,6 +15,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <net/if.h>
+#include <assert.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include "internal.h"
-- 
2.30.2

