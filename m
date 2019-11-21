Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EB5C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B08E20872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKULQX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:16:23 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40954 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKULQX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 06:16:23 -0500
Received: from localhost ([::1]:54044 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXkRi-0001E8-AW; Thu, 21 Nov 2019 12:16:22 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [arptables PATCH 1/3] Add .gitignore
Date:   Thu, 21 Nov 2019 12:15:57 +0100
Message-Id: <20191121111559.27066-2-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121111559.27066-1-phil@nwl.cc>
References: <20191121111559.27066-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ignore temporary files, created arptables-legacy binary and any present
tags file.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000000000..b2ea4a177d410
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,4 @@
+*.a
+*.o
+/arptables-legacy
+/tags
-- 
2.24.0

