Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C37C43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 02:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E092077B
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 02:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfLFChb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Dec 2019 21:37:31 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54219 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfLFChb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Dec 2019 21:37:31 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 584703A2C92
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 13:37:13 +1100 (AEDT)
Received: (qmail 21161 invoked by uid 501); 6 Dec 2019 02:37:12 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, sbezverk@cisco.com
Subject: [PATCH nft v2] doc: Clarify conditions under which a reject verdict is permissible
Date:   Fri,  6 Dec 2019 13:37:12 +1100
Message-Id: <20191206023712.21119-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191203235010.GA11671@dimstar.local.net>
References: <20191203235010.GA11671@dimstar.local.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=HfSC1nUxtQM4WeKO09gA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A phrase like "input chain" is a throwback to xtables documentation.
In nft, chains are containers for rules. They do have a type, but what's
important here is which hook each uses.

v2: Show hook names in bold
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/statements.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 3b82436..ced311c 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -171,8 +171,9 @@ ____
 
 A reject statement is used to send back an error packet in response to the
 matched packet otherwise it is equivalent to drop so it is a terminating
-statement, ending rule traversal. This statement is only valid in the input,
-forward and output chains, and user-defined chains which are only called from
+statement, ending rule traversal. This statement is only valid in base chains
+using the *input*,
+*forward* or *output* hooks, and user-defined chains which are only called from
 those chains.
 
 .different ICMP reject variants are meant for use in different table families
-- 
2.14.5

