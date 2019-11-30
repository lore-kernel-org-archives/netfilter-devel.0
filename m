Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BD1C43215
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 11:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2739320801
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 11:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="E1tJCVIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfK3La7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 06:30:59 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40034 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfK3La7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 06:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IBzbDWZAyfDn0no7Jwm6TRp26FZyu5quc2OyG+TFtak=; b=E1tJCVIq62twsi75KfpbSnuBKt
        D4Z7178hPVGSzcHcKQTv68UNtKQF97PzfvpUksQOLwezLWUwKqir4qaFPI6JJNDnaSkm78cOlffis
        mAC/zdW/DdcrYPtJuenZeNIt94sWiTG5vi95pqeyyonIvGq5Fe4u9ltagGMFNw0Y7v0S6SotGMbzM
        rvrL9IzqGkiKyqSPI5yMDGigUIzXbaShbxc4jTTwladgK1Hcg0sLfn0gnWgbXlUNaGJek5HuQQCno
        r2Zvp7UDq9c/fs6AlXb1RVwo2xT5fvAzBU/ngyNoO8Nu1q3XowFJrVh3yZ/RDL3NgFCHYPUneBxSY
        LbW0WPSA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib0xl-0002b0-Rg; Sat, 30 Nov 2019 11:30:57 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2] doc: fix inconsistency in set statement documentation.
Date:   Sat, 30 Nov 2019 11:30:57 +0000
Message-Id: <20191130113057.293776-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191130113057.293776-1-jeremy@azazel.net>
References: <20191130113057.293776-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The description of the set statement asserts that the set must have been
created with the "dynamic" flag.  However, this is not the case, and it
is contradicted by the following example in which the "dynamic" flag
does not appear.

In fact, one or both of the "dynamic" or the "timeout" flags need to be
used, depending on what the set statement contains.  Amend the
description to explain this more accurately.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 489bdc299d07..433ee98e3aec 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -669,10 +669,15 @@ SET STATEMENT
 ~~~~~~~~~~~~~
 The set statement is used to dynamically add or update elements in a set from
 the packet path. The set setname must already exist in the given table and must
-have been created with the dynamic flag. Furthermore, these sets must specify
-both a maximum set size (to prevent memory exhaustion) and a timeout (so that
-number of entries in set will not grow indefinitely). The set statement can be
-used to e.g. create dynamic blacklists.
+have been created with one or both of the dynamic and the timeout flags. The
+dynamic flag is required if the set statement expression includes a stateful
+object. The timeout flag is implied if the set is created with a timeout, and is
+required if the set statement updates elements, rather than adding them.
+Furthermore, these sets should specify both a maximum set size (to prevent
+memory exhaustion), and their elements should have a timeout (so their number
+will not grow indefinitely) either from the set definition or from the statement
+that adds or updates them. The set statement can be used to e.g. create dynamic
+blacklists.
 
 [verse]
 {*add* | *update*} *@*'setname' *{* 'expression' [*timeout* 'timeout'] [*comment* 'string'] *}*
-- 
2.24.0

