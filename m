Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9731CC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 08:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 583CF61176
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 08:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhEFIpK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 May 2021 04:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbhEFIpK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 May 2021 04:45:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56754C061574
        for <netfilter-devel@vger.kernel.org>; Thu,  6 May 2021 01:44:12 -0700 (PDT)
Received: from localhost ([::1]:46906 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1leZc9-00029F-IO; Thu, 06 May 2021 10:44:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: Reduce size of NAT statement synopsis
Date:   Thu,  6 May 2021 10:44:01 +0200
Message-Id: <20210506084401.1353-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce non-terminals representing address and port which may
represent ranges as well. Combined with dropping the distinction between
PR_FLAGS and PRF_FLAGS, all the lines for each nat statement type can be
combined.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/statements.txt | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 6fc0bda0a19fd..7c7240c82fabc 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -343,21 +343,16 @@ NAT STATEMENTS
 ~~~~~~~~~~~~~~
 [verse]
 ____
-*snat to* 'address' [*:*'port'] ['PRF_FLAGS']
-*snat to* 'address' *-* 'address' [*:*'port' *-* 'port'] ['PRF_FLAGS']
-*snat* { *ip* | *ip6* } *to* 'address' *-* 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
-*dnat to* 'address' [*:*'port'] ['PRF_FLAGS']
-*dnat to* 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
-*dnat* { *ip* | *ip6* } *to* 'address' [*:*'port' *-* 'port'] ['PR_FLAGS']
-*masquerade to* [*:*'port'] ['PRF_FLAGS']
-*masquerade to* [*:*'port' *-* 'port'] ['PRF_FLAGS']
-*redirect to* [*:*'port'] ['PRF_FLAGS']
-*redirect to* [*:*'port' *-* 'port'] ['PRF_FLAGS']
-
-'PRF_FLAGS' := 'PRF_FLAG' [*,* 'PRF_FLAGS']
-'PR_FLAGS'  := 'PR_FLAG' [*,* 'PR_FLAGS']
-'PRF_FLAG'  := 'PR_FLAG' | *fully-random*
-'PR_FLAG'   := *persistent* | *random*
+*snat* [[*ip* | *ip6*] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
+*dnat* [[*ip* | *ip6*] *to*] 'ADDR_SPEC' [*:*'PORT_SPEC'] ['FLAGS']
+*masquerade* [*to :*'PORT_SPEC'] ['FLAGS']
+*redirect* [*to :*'PORT_SPEC'] ['FLAGS']
+
+'ADDR_SPEC' := 'address' | 'address' *-* 'address'
+'PORT_SPEC' := 'port' | 'port' *-* 'port'
+
+'FLAGS'  := 'FLAG' [*,* 'FLAGS']
+'FLAG'  := *persistent* | *random* | *fully-random*
 ____
 
 The nat statements are only valid from nat chain types. +
-- 
2.31.0

