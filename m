Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6BFC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BD920857
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDIMVc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:21:32 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33812 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfDIMVb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:21:31 -0400
Received: from localhost ([::1]:46902 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hDpko-0004SO-57; Tue, 09 Apr 2019 14:21:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH] Fix segfault with missing lockfile directory
Date:   Tue,  9 Apr 2019 14:21:25 +0200
Message-Id: <20190409122125.29658-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apparently, dirname() modifies the buffer passed to it. Given a
read-only location, this leads to a segfault. Use a buffer initialized
(and tailored) to the content of LOCKFILE macro at compile-time instead.

Fixes: f45756c1ca3b5 ("Allow customizing lockfile location at configure time")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libebtc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libebtc.c b/libebtc.c
index f2a2b500ea751..2a9ab87ac99c0 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -140,12 +140,13 @@ int use_lockfd;
  * or -2 on any other error. */
 static int lock_file()
 {
+	char pathbuf[] = LOCKFILE;
 	int fd, try = 0;
 
 retry:
 	fd = open(LOCKFILE, O_CREAT, 00600);
 	if (fd < 0) {
-		if (try == 1 || mkdir(dirname(LOCKFILE), 00700))
+		if (try == 1 || mkdir(dirname(pathbuf), 00700))
 			return -2;
 		try = 1;
 		goto retry;
-- 
2.21.0

