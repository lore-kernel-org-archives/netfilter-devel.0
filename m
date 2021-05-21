Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5BAC43461
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DFC613D6
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 12:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbhEUMKg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 08:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbhEUMKc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 08:10:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C10C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 05:09:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lk3xh-0005gs-TO; Fri, 21 May 2021 14:09:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] doc: add LISTING section
Date:   Fri, 21 May 2021 14:08:46 +0200
Message-Id: <20210521120846.1140-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521120846.1140-1-fw@strlen.de>
References: <20210521120846.1140-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mention various 'nft list' options, such as secmarks, flow tables, and
so on.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index a4333d9d55f3..245406fb1335 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -684,6 +684,18 @@ and subtraction can be used to set relative priority, e.g. filter + 5 equals to
 *list*:: List all flowtables.
 
 
+LISTING
+-------
+[verse]
+*list { secmarks | synproxys | flow tables | meters | hooks }* ['family']
+*list { secmarks | synproxys | flow tables | meters | hooks } table* ['family'] 'table'
+*list ct { timeout | expectation | helper | helpers } table* ['family'] 'table'
+
+Inspect configured objects.
+*list hooks* shows the full hook pipeline, including those registered by
+kernel modules, such as nf_conntrack.
+
+
 STATEFUL OBJECTS
 ----------------
 [verse]
@@ -691,6 +703,7 @@ STATEFUL OBJECTS
 *delete* 'type' ['family'] 'table' *handle* 'handle'
 *list counters* ['family']
 *list quotas* ['family']
+*list limits* ['family']
 
 Stateful objects are attached to tables and are identified by an unique name.
 They group stateful information from rules, to reference them in rules the
-- 
2.26.3

