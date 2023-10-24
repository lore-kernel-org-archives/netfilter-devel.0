Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E2FC25B6C
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 11:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjJXLoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 07:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjJXLoG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 07:44:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02868128
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J+LlrZYqpwNYB8UCsT8iXwrV88ZTAN6PbEa5eC/oJaQ=; b=WqGGVxl1gdPg8s2XklD243UfCy
        kYGClevJJBerJ8r6aBBsfN0avrdnitYIccpj7VFHf7kBANUmIHN2He1IL5wJIaX7OVNhCmiDP1ZEu
        PUHLWu+D1vbomeuGK24sPRe0ocrV0yj+8h6nOqb0H25AOsDk/pgmUIgzOyuvn2269Muy+GlD4EyHD
        +z9zBrW8l0rUO+IGGJ297WU0dt4RgeCoMnOQixTQnmVGAHvAN3xSGsWkZcFQcEQi/2cOiy9ggoGZl
        L6oDqA+qLdJ/wbnOpG8SaHNSM2jBS99osECpPzn4JMvDixMGrue2UFAUuqB1HGgb6Uyhsd4LM03WK
        aNSZ3oAQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qvFpJ-000077-5w; Tue, 24 Oct 2023 13:44:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 1/2] Revert "extensions: string: Clarify description of --to"
Date:   Tue, 24 Oct 2023 13:43:56 +0200
Message-ID: <20231024114357.23271-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231024114357.23271-1-phil@nwl.cc>
References: <20231024114357.23271-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit 920ece2b392fb83bd26416e0e6f8f6a847aacbaa.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.man | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index efdda492ae78d..2a470ece19c9d 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -7,13 +7,9 @@ Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morri
 Set the offset from which it starts looking for any matching. If not passed, default is 0.
 .TP
 \fB\-\-to\fP \fIoffset\fP
-Set the offset up to which should be scanned. If the pattern does not start
-within this offset, it is not considered a match.
+Set the offset up to which should be scanned. That is, byte \fIoffset\fP-1
+(counting from 0) is the last one that is scanned.
 If not passed, default is the packet size.
-A second function of this parameter is instructing the kernel how much data
-from the packet should be provided. With non-linear skbuffs (e.g. due to
-fragmentation), a pattern extending past this offset may not be found. Also see
-the related note below about Boyer-Moore algorithm in these cases.
 .TP
 [\fB!\fP] \fB\-\-string\fP \fIpattern\fP
 Matches the given pattern.
-- 
2.41.0

