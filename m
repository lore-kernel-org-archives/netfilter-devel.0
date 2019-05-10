Return-Path: <SRS0=jxct=TK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E15C04A6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 16:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A53320882
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 May 2019 16:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfEJQYN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 May 2019 12:24:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38134 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfEJQYN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 May 2019 12:24:13 -0400
Received: from localhost ([::1]:51224 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hP8Jf-0005wN-Lf; Fri, 10 May 2019 18:24:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Laine Stump <laine@redhat.com>
Subject: [ebtables PATCH] Fix incorrect IPv6 prefix formatting
Date:   Fri, 10 May 2019 18:24:13 +0200
Message-Id: <20190510162413.28609-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Due to a typo, 127bit prefixes were omitted instead of 128bit ones.

Reported-by: Laine Stump <laine@redhat.com>
Fixes: a88e4b4ac1a1b ("Print IPv6 prefixes in CIDR notation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 useful_functions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/useful_functions.c b/useful_functions.c
index bf4393712fa44..133ae2fd61eae 100644
--- a/useful_functions.c
+++ b/useful_functions.c
@@ -445,7 +445,7 @@ char *ebt_ip6_mask_to_string(const struct in6_addr *msk)
 	int l = ebt_ip6mask_to_cidr(msk);
 	static char buf[51+1];
 
-	if (l == 127)
+	if (l == 128)
 		*buf = '\0';
 	else if (l == -1)
 		sprintf(buf, "/%s", ebt_ip6_to_numeric(msk));
-- 
2.21.0

