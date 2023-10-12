Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B6ECDB46E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 16:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379405AbjJLQIt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 12:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379320AbjJLQIt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 12:08:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9255C6
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2023 09:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xjVpTblw6WP0Rsh4RtyFzlMvMjQa8caCfvzxjRyNEkw=; b=M5E/ziHJWfdy7uMerN78rc9P1O
        x7bwm5jRhWbxpxmd4ZmWPHWVDs4H9x56Ct3q+Sy2z9cSoYNXMmO8G7oGfxtJ2gysgnX8jU/hVCA/9
        cihMxFTwLnFproVLFAEWrB4OOZUqfcNfFFPaW4mDzVdxcU2EQl5e9jk4tc2Z9+ExOeafFHp7XUiaV
        O1uCfp4pGjVruAl1fbri6xVkaCFQbDxmm8tD+VXIj03wkxxX9KuuylCIMMCMTR/kA8JLu5jih/DXT
        lKtLyXzyap29XN5CZ5De19MX+0wY7oNyIZ6R5aQWJ5ifsFc//0fjrggMDytuwtMCsx0iUPWPNwzxN
        y9PFPQkA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qqyEw-0006c5-8P
        for netfilter-devel@vger.kernel.org; Thu, 12 Oct 2023 18:08:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: string: Clarify description of --to
Date:   Thu, 12 Oct 2023 18:08:42 +0200
Message-ID: <20231012160842.18584-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

String match indeed returns a match as long as the given pattern starts
in the range of --from and --to, update the text accordingly.
Also add a note regarding fragment boundaries.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1707
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.man | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 2a470ece19c9d..efdda492ae78d 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -7,9 +7,13 @@ Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morri
 Set the offset from which it starts looking for any matching. If not passed, default is 0.
 .TP
 \fB\-\-to\fP \fIoffset\fP
-Set the offset up to which should be scanned. That is, byte \fIoffset\fP-1
-(counting from 0) is the last one that is scanned.
+Set the offset up to which should be scanned. If the pattern does not start
+within this offset, it is not considered a match.
 If not passed, default is the packet size.
+A second function of this parameter is instructing the kernel how much data
+from the packet should be provided. With non-linear skbuffs (e.g. due to
+fragmentation), a pattern extending past this offset may not be found. Also see
+the related note below about Boyer-Moore algorithm in these cases.
 .TP
 [\fB!\fP] \fB\-\-string\fP \fIpattern\fP
 Matches the given pattern.
-- 
2.41.0

