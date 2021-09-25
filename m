Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C00EC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27B54610F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbhIYPQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343924AbhIYPQL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:11 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1204DC06176A
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fP6cOnCtwW3n7n/RWENRXncp2yCXVUXstIwDJAUKs10=; b=hiVcj1KVaOlSeVjExf4RyaIIQ3
        1YQDiaqS85pJGJJhhX1GVLJKUHiB38JF6tAdVEAYzjXzaftz9GxwjVpmbLN/bjzkKn9d4zaV9Gw2g
        TA4Nh2TmH7FhsX6IowwVNHIWgZMnyjKT/KYQIUzRNdd1p9aa3ybRyZeBft5Qvn6g2ME/c3SzekBGf
        XGNqoIZX/gAa1jolX6dHynNvoVJzpj6bh6pD9UhgWfHsE2Ku0zio0beXOoY8v3HCrvgwQAnw+qPAU
        KO7nzNkOaz5bAhqExzz+JjX/daEr+XUxskXAt0ESmW7shhf/xJGsT0RcgJGCeHhicyGM5iHjVlzCS
        bD7Ye5cA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9No-00Cses-Ba; Sat, 25 Sep 2021 16:14:32 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 6/6] build: fix dependency-tracking of yacc-generated header
Date:   Sat, 25 Sep 2021 16:10:35 +0100
Message-Id: <20210925151035.850310-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210925151035.850310-1-jeremy@azazel.net>
References: <20210925151035.850310-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

List it as a built source in order to force make to create it before
compilation.  Otherwise, a parallel make can end up attempting to
compile the output of lex before yacc has finished generating its own
output:

  $ make -j17
  [...]
  YACC     read_config_yy.c
  LEX      read_config_lex.c
  CC       stack.o
  CC       resync.o
  CC       cthelper.o
  CC       helpers.o
  CC       utils.o
  CC       expect.o
  CC       systemd.o
  CC       nfct.o
  CC       nfct-extensions/helper.o
  CC       nfct-extensions/timeout.o
  CC       read_config_lex.o
  read_config_lex.l:25:10: fatal error: read_config_yy.h: No such file or directory
  25 | #include "read_config_yy.h"
  |          ^~~~~~~~~~~~~~~~~~
  compilation terminated.
  make[2]: *** [Makefile:701: read_config_lex.o] Error 1
  make[2]: *** Waiting for unfinished jobs....
  updating read_config_yy.h
  make[2]: Leaving directory '/space/azazel/work/git/netfilter/conntrack-tools/src'
  make[1]: *** [Makefile:743: all-recursive] Error 1
  make[1]: Leaving directory '/space/azazel/work/git/netfilter/conntrack-tools/src'
  make: *** [Makefile:541: all-recursive] Error 1

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/Makefile.am b/src/Makefile.am
index 85ea18888e97..1f234749d35d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,7 @@ endif
 
 AM_YFLAGS = -d
 
+BUILT_SOURCES = read_config_yy.h
 MAINTAINERCLEANFILES = read_config_yy.c read_config_yy.h read_config_lex.c
 
 sbin_PROGRAMS = conntrack conntrackd nfct
-- 
2.33.0

