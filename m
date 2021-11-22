Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E284EC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Nov 2021 17:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbhKVRJJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:09:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:33338 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237649AbhKVRJI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 12:09:08 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8E6AB64A8F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Nov 2021 18:03:50 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cli: remove #include <editline/history.h>
Date:   Mon, 22 Nov 2021 18:05:56 +0100
Message-Id: <20211122170556.534226-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This header is not required to compile nftables with editline, remove
it, this unbreak compilation in several distros which have no symlink
from history.h to editline.h

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/cli.c b/src/cli.c
index 4845e5cf1454..cbbf45652ba0 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -25,7 +25,6 @@
 #include <readline/readline.h>
 #include <readline/history.h>
 #elif defined(HAVE_LIBEDIT)
-#include <editline/readline.h>
 #include <editline/history.h>
 #else
 #include <linenoise.h>
-- 
2.30.2

