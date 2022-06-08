Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979CCCCA47B
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbiFHQ1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245461AbiFHQ1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800891CAD20
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VPWW6CmZvS9Qz/76uGToDMc+n4X8GlQ+osUYuh3/Tx0=; b=i9e/0i184V8srkhQ8+/fX67sr2
        SiJnqdXHkb+LF1ryHVtYY07y/dDByRXVWlUVB5+/vZt+EagGqdfEy19EP4duT6U/hGxkPUSb5vfO/
        RkwrkvAYSXEJ05lzjvxwP+9aXp36aJLq3J3x+z21H/bmk7SNdWdXdebObwwCYpMhxpFuO/eFAY1H7
        Igz6gKxumJp1GoNiudHVptG4l++RtOJ+Y9298RsbAAI614oyDavg04TfccXB2uGVfiPbdJoQ6aLsp
        czx0yiBAHGBEZB7RDqk+ADo3ajvdVkaPmABv3EeO1mVfhevZP9jd2ovXvo/O4eToaNcS34ZhJSb7E
        dunpxCtw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyWv-000854-Gn
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 7/9] extensions: string: Do not print default --to value
Date:   Wed,  8 Jun 2022 18:27:10 +0200
Message-Id: <20220608162712.31202-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Default value is UINT16_MAX, not 0. Fix the conditional printing.

Fixes: c6fbf41cdd157 ("update string match to reflect new kernel implementation (Pablo Neira)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 739a8e7fd66b6..da05fad0f59c8 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -269,7 +269,7 @@ string_print(const void *ip, const struct xt_entry_match *match, int numeric)
 	printf(" ALGO name %s", info->algo);
 	if (info->from_offset != 0)
 		printf(" FROM %u", info->from_offset);
-	if (info->to_offset != 0)
+	if (info->to_offset != UINT16_MAX)
 		printf(" TO %u", info->to_offset);
 	if (revision > 0 && info->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
 		printf(" ICASE");
@@ -293,7 +293,7 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 	printf(" --algo %s", info->algo);
 	if (info->from_offset != 0)
 		printf(" --from %u", info->from_offset);
-	if (info->to_offset != 0)
+	if (info->to_offset != UINT16_MAX)
 		printf(" --to %u", info->to_offset);
 	if (revision > 0 && info->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
 		printf(" --icase");
-- 
2.34.1

