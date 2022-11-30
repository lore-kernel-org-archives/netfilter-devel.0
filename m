Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901B4C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiK3TO1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiK3TO1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:27 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B666B62E8C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nsbi1ZNj67NQtY9RqGE+fQD3PpkE4QkX/XH8Z/PmN64=; b=og5C4o8k91wi2ctP7g+dAFqYQF
        K4BaOpY4DZJPes+Hak/smHAC75jHDFmI2qaI6KjT2PsqiThxyY2rK/PK+tKmrOKKRF1NRGt1xOuX3
        HapgOFPVI8reaTp9UzzEmjhDl4WPI58PnOs0ceG19YFwU9fxbxW4jVLN7eHsfrwliBC19SRh4bTHp
        dmVANSLDgy4bYcUXcltUxX8uwM3CIR8jUBPhNzx4A0hG3RQftSTbVTATcc4Tnu5gAt1rwSWuTBdWk
        Ecaqoxrema039XgpW/ciYYju3OTCk7FbDVLeF1VJSCLdnb9xBZ/kje3DUGu4DjstEo8c/+m7LoKKf
        x1opcMKw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SXJ-0001BP-2f
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 9/9] libiptc: Eliminate garbage access
Date:   Wed, 30 Nov 2022 20:13:45 +0100
Message-Id: <20221130191345.14543-10-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When adding a rule, valgrind prints:

Syscall param socketcall.setsockopt(optval) points to uninitialised byte(s)
   at 0x4A8165A: setsockopt (in /lib64/libc.so.6)
   by 0x4857A48: iptc_commit (libiptc.c:2676)
   by 0x10E4BB: iptables_main (iptables-standalone.c:61)
   by 0x49A3349: (below main) (in /lib64/libc.so.6)
 Address 0x4b63788 is 40 bytes inside a block of size 1,448 alloc'd
   at 0x484659F: calloc (vg_replace_malloc.c:1328)
   by 0x4857654: iptc_commit (libiptc.c:2564)
   by 0x10E4BB: iptables_main (iptables-standalone.c:61)
   by 0x49A3349: (below main) (in /lib64/libc.so.6)

This is because repl->counters is not initialized upon allocation. Since
the field is an array, make use of calloc() which implicitly does the
initialization.

Fixes: e37c0dc100c51 ("Revert the recent addition of memset()'s to TC_COMMIT. One of them is bogus and the other one needs more investigation to why valgrind is complaining.")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libiptc/libiptc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 97823f935d1ee..f9b7779efdba5 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2554,8 +2554,8 @@ TC_COMMIT(struct xtc_handle *handle)
 			+ sizeof(STRUCT_COUNTERS) * new_number;
 
 	/* These are the old counters we will get from kernel */
-	repl->counters = malloc(sizeof(STRUCT_COUNTERS)
-				* handle->info.num_entries);
+	repl->counters = calloc(handle->info.num_entries,
+				sizeof(STRUCT_COUNTERS));
 	if (!repl->counters) {
 		errno = ENOMEM;
 		goto out_free_repl;
-- 
2.38.0

