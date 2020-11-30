Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC75C64E8A
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C6652087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 13:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgK3NGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 08:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgK3NGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 08:06:02 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C6DC0613D3
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 05:05:22 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id E801359BD6199; Mon, 30 Nov 2020 14:05:20 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id E502D59BD6195;
        Mon, 30 Nov 2020 14:05:19 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] Update .gitignore
Date:   Mon, 30 Nov 2020 14:05:19 +0100
Message-Id: <20201130130519.20880-2-jengelh@inai.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130130519.20880-1-jengelh@inai.de>
References: <20201130130519.20880-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git .gitignore .gitignore
index a0fc139..525628e 100644
--- .gitignore
+++ .gitignore
@@ -2,6 +2,7 @@
 .libs/
 Makefile
 Makefile.in
+.dirstamp
 *.o
 *.la
 *.lo
@@ -12,6 +13,9 @@ Makefile.in
 /config.*
 /configure
 /libtool
+/stamp-h1
 
 /doxygen.cfg
 /libnetfilter_queue.pc
+
+/examples/nf-queue
-- 
2.29.2

