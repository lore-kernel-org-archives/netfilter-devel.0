Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29F8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 22:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DFD6105A
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 22:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241080AbhJPW6m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 18:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhJPW6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 18:58:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E96C061765
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 15:56:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mbsbL-0007o1-AW; Sun, 17 Oct 2021 00:56:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] main: _exit() if setuid
Date:   Sun, 17 Oct 2021 00:56:23 +0200
Message-Id: <20211016225623.155790-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apparently some people think its a good idea to make nft setuid so
unrivilged users can change settings.

"nft -f /etc/shadow" is just one example of why this is a bad idea.
Disable this.  Do not print anything, fd cannot be trusted.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/main.c b/src/main.c
index 21096fc7398b..5847fc4ad514 100644
--- a/src/main.c
+++ b/src/main.c
@@ -363,6 +363,10 @@ int main(int argc, char * const *argv)
 	unsigned int len;
 	int i, val, rc;
 
+	/* nftables cannot be used with setuid in a safe way. */
+	if (getuid() != geteuid())
+		_exit(111);
+
 	if (!nft_options_check(argc, argv))
 		exit(EXIT_FAILURE);
 
-- 
2.31.1

