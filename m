Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510FFC47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3916561360
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFBP0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhFBP0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D5DC061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:24 -0700 (PDT)
Received: from localhost ([::1]:43100 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjG-0007P3-Pu; Wed, 02 Jun 2021 17:24:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/9] extensions: libebt_ip6: Drop unused variables
Date:   Wed,  2 Jun 2021 17:23:56 +0200
Message-Id: <20210602152403.5689-3-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are being assigned to but never read.

Fixes: 5c8ce9c6aede0 ("ebtables-compat: add 'ip6' match extension")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip6.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index b8a5a5d8c3a92..301bed9aadefd 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -250,9 +250,8 @@ static void brip6_init(struct xt_entry_match *match)
 static struct in6_addr *numeric_to_addr(const char *num)
 {
 	static struct in6_addr ap;
-	int err;
 
-	if ((err=inet_pton(AF_INET6, num, &ap)) == 1)
+	if (inet_pton(AF_INET6, num, &ap) == 1)
 		return &ap;
 	return (struct in6_addr *)NULL;
 }
@@ -292,7 +291,6 @@ static void ebt_parse_ip6_address(char *address, struct in6_addr *addr, struct i
 	char buf[256];
 	char *p;
 	int i;
-	int err;
 
 	strncpy(buf, address, sizeof(buf) - 1);
 	/* first the mask */
@@ -309,7 +307,7 @@ static void ebt_parse_ip6_address(char *address, struct in6_addr *addr, struct i
 	if (!memcmp(msk, &in6addr_any, sizeof(in6addr_any)))
 		strcpy(buf, "::");
 
-	if ((err=inet_pton(AF_INET6, buf, addr)) < 1) {
+	if (inet_pton(AF_INET6, buf, addr) < 1) {
 		xtables_error(PARAMETER_PROBLEM, "Invalid IPv6 Address '%s' specified", buf);
 		return;
 	}
-- 
2.31.1

