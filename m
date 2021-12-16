Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B082C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 16:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhLPQhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 11:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhLPQhb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 11:37:31 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37536C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 08:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WjQimTst4Y+8mdCYKGS64aM/dXtiJAPlR1rJtGM7J4I=; b=gBGE5D667f6ErzRgd8n04I+WQ4
        kWp2IYdrkkQZQEhvVTZxDGn/+HXjXPTYOAVEzSeBcXXJewNrdDuDrnT6Dfl6o1EwWRp9mslBmLkDV
        94SFF3Bb2gq8mH0uG0m7g1mTHU1cTTs9WuFaruarkqOtWlc6TF734EjV+0Q9hrrwFatvzuI4j1GYr
        2vzoWSvoWtDruWbckSr+leXl1jsYCJ8gmaYQWKcaAfWHqAl/k/x/cKqod9/FOBcJA/GbAWZ8b1omd
        gLsoi7sZtrIKCZs/i+iIAvPZ+o/TUjlcUfAJ+qO+lhdhKJshEpwKH6DG5DsIm+NDK0y/EbvYdgtto
        2BniqOkw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxtl1-009VFY-76
        for netfilter-devel@vger.kernel.org; Thu, 16 Dec 2021 16:37:27 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH] build: remove scanner.c and parser_bison.c with `maintainer-clean`
Date:   Thu, 16 Dec 2021 16:37:20 +0000
Message-Id: <20211216163720.180125-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

automake recommends shipping the output of bison and lex in distribution
tar-balls and runs bison and lex during `make dist` (this has the
advantage that end-users don't need to have bison or lex installed to
compile the software).  Accordingly, automake also recommends removing
these files with `make maintainer-clean` and generates rules to do so.
Therefore, remove scanner.c and parser_bison.c from `CLEANFILES`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 01c12c81bce7..6ab0752337b2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,8 +2,6 @@ include $(top_srcdir)/Make_global.am
 
 sbin_PROGRAMS = nft
 
-CLEANFILES = scanner.c parser_bison.c
-
 AM_CPPFLAGS = -I$(top_srcdir)/include
 AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\"" \
 		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
-- 
2.34.1

