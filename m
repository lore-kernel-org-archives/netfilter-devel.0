Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25638C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 17:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 028D92173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 17:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfCLR7i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 13:59:38 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45768 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbfCLRNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 13:13:32 -0400
Received: from localhost ([::1]:58858 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h3ky2-0000ZL-OE; Tue, 12 Mar 2019 18:13:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH] Adjust .gitignore to renamed files
Date:   Tue, 12 Mar 2019 18:13:27 +0100
Message-Id: <20190312171327.26523-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 6218f812d894f ("ebtables: legacy renaming")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index c1fae5463a355..9940c85762fa0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -17,11 +17,11 @@ Makefile.in
 /libtool
 /stamp-h1
 
-/ebtables
+/ebtables-legacy
 /ebtables-config
-/ebtables-restore
-/ebtables-save
-/ebtables.8
+/ebtables-legacy-restore
+/ebtables-legacy-save
+/ebtables-legacy.8
 /ebtablesd
 /ebtablesu
 /static
-- 
2.21.0

