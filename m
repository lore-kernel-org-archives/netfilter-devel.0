Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83790C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 11:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CFE611C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 11:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346274AbhESLan (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 07:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhESLan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 07:30:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C71C06175F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 04:29:23 -0700 (PDT)
Received: from localhost ([::1]:56796 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ljKO9-0005jh-HA; Wed, 19 May 2021 13:29:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Extend monitor description by trace
Date:   Wed, 19 May 2021 13:29:13 +0200
Message-Id: <20210519112913.9238-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Briefly describe 'nft monitor trace' command functionality.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 55747036f947c..a4333d9d55f31 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -805,13 +805,26 @@ These are some additional commands included in nft.
 MONITOR
 ~~~~~~~~
 The monitor command allows you to listen to Netlink events produced by the
-nf_tables subsystem, related to creation and deletion of objects. When they
+nf_tables subsystem. These are either related to creation and deletion of
+objects or to packets for which *meta nftrace* was enabled. When they
 occur, nft will print to stdout the monitored events in either JSON or
 native nft format. +
 
-To filter events related to a concrete object, use one of the keywords 'tables', 'chains', 'sets', 'rules', 'elements', 'ruleset'. +
+[verse]
+____
+*monitor* [*new* | *destroy*] 'MONITOR_OBJECT'
+*monitor* *trace*
+
+'MONITOR_OBJECT' := *tables* | *chains* | *sets* | *rules* | *elements* | *ruleset*
+____
 
-To filter events related to a concrete action, use keyword 'new' or 'destroy'.
+To filter events related to a concrete object, use one of the keywords in
+'MONITOR_OBJECT'.
+
+To filter events related to a concrete action, use keyword *new* or *destroy*.
+
+The second form of invocation takes no further options and exclusively prints
+events generated for packets with *nftrace* enabled.
 
 Hit ^C to finish the monitor operation.
 
@@ -835,6 +848,12 @@ Hit ^C to finish the monitor operation.
 % nft monitor ruleset
 ---------------------
 
+.Trace incoming packets from host 10.0.0.1
+------------------------------------------
+% nft add rule filter input ip saddr 10.0.0.1 meta nftrace set 1
+% nft monitor trace
+------------------------------------------
+
 ERROR REPORTING
 ---------------
 When an error is detected, nft shows the line(s) containing the error, the
-- 
2.31.1

