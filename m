Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB15CC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8885B2146E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 07:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfCTHG0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 03:06:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36634 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfCTHG0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 03:06:26 -0400
Received: from localhost ([::1]:49724 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h6VIv-00026T-2T; Wed, 20 Mar 2019 08:06:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH 1/3] extensions: Drop Makefile
Date:   Tue, 19 Mar 2019 20:09:36 +0100
Message-Id: <20190319190938.20751-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190319190938.20751-1-phil@nwl.cc>
References: <20190319190938.20751-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sources contained in there are built from toplevel Makefile.am. This
seems like a leftover from commit 131920089dc21 ("build: move to
automake").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/Makefile | 30 ------------------------------
 1 file changed, 30 deletions(-)
 delete mode 100644 extensions/Makefile

diff --git a/extensions/Makefile b/extensions/Makefile
deleted file mode 100644
index daa11fce36e5e..0000000000000
--- a/extensions/Makefile
+++ /dev/null
@@ -1,30 +0,0 @@
-#! /usr/bin/make
-
-EXT_FUNC+=802_3 nat arp arpreply ip ip6 standard log redirect vlan mark_m mark \
-          pkttype stp among limit ulog nflog string
-EXT_TABLES+=filter nat broute
-EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/ebt_$(T).o)
-EXT_OBJS+=$(foreach T,$(EXT_TABLES), extensions/ebtable_$(T).o)
-EXT_LIBS+=$(foreach T,$(EXT_FUNC), extensions/libebt_$(T).so)
-EXT_LIBS+=$(foreach T,$(EXT_TABLES), extensions/libebtable_$(T).so)
-EXT_LIBSI+=$(foreach T,$(EXT_FUNC), -lebt_$(T))
-EXT_LIBSI+=$(foreach T,$(EXT_TABLES), -lebtable_$(T))
-
-extensions/ebt_%.so: extensions/ebt_%.o
-	$(CC) $(LDFLAGS) -shared -o $@ -lc $<
-
-extensions/libebt_%.so: extensions/ebt_%.so
-	mv $< $@
-
-extensions/ebtable_%.so: extensions/ebtable_%.o
-	$(CC) $(LDFLAGS) -shared -o $@ -lc $<
-
-extensions/libebtable_%.so: extensions/ebtable_%.so
-	mv $< $@
-
-extensions/ebt_%.o: extensions/ebt_%.c include/ebtables_u.h
-	$(CC) $(CFLAGS) $(CFLAGS_SH_LIB) $(PROGSPECS) -c -o $@ $< -I$(KERNEL_INCLUDES)
-
-extensions/ebtable_%.o: extensions/ebtable_%.c
-	$(CC) $(CFLAGS) $(CFLAGS_SH_LIB) $(PROGSPECS) -c -o $@ $< -I$(KERNEL_INCLUDES)
-
-- 
2.21.0

