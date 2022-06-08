Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62563C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbiFHQ1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbiFHQ1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24B73EF35
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L9iFX/eahQ+KC7Dt1iCge7XELueM3BumJTXK9cF6zxk=; b=CaHP0+X8T4TTw+BeLxdzVXTu4S
        7QbtTCZx8WsTUOFikYL7X1JRC1aUUDHnw0nB2QfDypb+KAq6pquDv6PfhXafvMgKjonTCu8ZQ3SUq
        dmWkbvkcIn/Wa/Or/U20ucybsnaHn9Xt7ci/GPI9MUf4mmQVjSzw8XCeFmwnEuIgHGDrkfU4fXamL
        5zyrimLaf+ew2Fgi7cFRC1pgTQ1uu39KT35S9YdTP7AuxIaXSu7HAHqMeJdAEVKi/mAuBDm0gGJ5r
        aJq62PBmA7hWI3wEx7mShSLf2v1W/Ey2fNB5Eg705/cIvGfizPw6jzv1WohHUZBlD7XQ8NkQT8Y1I
        kBZBoRNw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyX6-00085D-7z
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 8/9] extensions: string: Review parse_string() function
Date:   Wed,  8 Jun 2022 18:27:11 +0200
Message-Id: <20220608162712.31202-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

* Compare against sizeof(info->pattern) which is more clear than having
  to know that this buffer is of size XT_STRING_MAX_PATTERN_SIZE

* Invert the check and error early to reduce indenting

* Pass info->patlen to memcpy() to avoid reading past end of 's'

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index da05fad0f59c8..5d72a5cde008f 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -78,14 +78,13 @@ static void string_init(struct xt_entry_match *m)
 
 static void
 parse_string(const char *s, struct xt_string_info *info)
-{	
+{
 	/* xt_string does not need \0 at the end of the pattern */
-	if (strlen(s) <= XT_STRING_MAX_PATTERN_SIZE) {
-		memcpy(info->pattern, s, XT_STRING_MAX_PATTERN_SIZE);
-		info->patlen = strnlen(s, XT_STRING_MAX_PATTERN_SIZE);
-		return;
-	}
-	xtables_error(PARAMETER_PROBLEM, "STRING too long \"%s\"", s);
+	if (strlen(s) > sizeof(info->pattern))
+		xtables_error(PARAMETER_PROBLEM, "STRING too long \"%s\"", s);
+
+	info->patlen = strnlen(s, sizeof(info->pattern));
+	memcpy(info->pattern, s, info->patlen);
 }
 
 static void
-- 
2.34.1

