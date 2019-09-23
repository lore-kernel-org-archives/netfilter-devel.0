Return-Path: <SRS0=FqmY=XS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC46CC432C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 22:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62CF2207FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 22:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="qm6ynigy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392513AbfIWWlY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 18:41:24 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:22620 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392282AbfIWWlX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 18:41:23 -0400
Received: from grover.flets-west.jp (softbank126021098169.bbtec.net [126.21.98.169]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id x8NMeEuJ017051;
        Tue, 24 Sep 2019 07:40:15 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com x8NMeEuJ017051
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569278415;
        bh=QLpqgwiwdHsVJ7lYAMtFWzbVRcNyLxBKNZxEbuiniCM=;
        h=From:To:Cc:Subject:Date:From;
        b=qm6ynigy6gEkhspkwQmqf/q+uQz6jl90Xidb6J6R5+ckOxnq8t5m0Z+spHOVmEska
         C5TKt7JXhzLBDghbbsoQy1pjxhl8SBlG5hMc4ncLPIw26GHX6SjRcUDFxYjCk5uzxp
         vC3a1IX3N6HCeM7JUPHnjYVZP5JLYoHRThPwfKdgoMK/OrAf9104vYPITF7ZNwnJs+
         tQXTgbeDY3PdU1vAHjxuHGZCeSfayrbJ7WRrPltV/EVRARta7FZ//IoolLr/8U9IgA
         V6TDxBxQ7zikO8pNXDbR1rJvyAPD4lS+z4s2QBSNeCJmuYQNozeyA4vxKHB/y4y/dy
         j9tKsc05mkmhg==
X-Nifty-SrcIP: [126.21.98.169]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] netfilter: use __u8 instead of uint8_t in uapi header
Date:   Tue, 24 Sep 2019 07:40:06 +0900
Message-Id: <20190923224007.20179-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When CONFIG_UAPI_HEADER_TEST=y, exported headers are compile-tested to
make sure they can be included from user-space.

Currently, linux/netfilter_bridge/ebtables.h is excluded from the test
coverage. To make it join the compile-test, we need to fix the build
errors attached below.

For a case like this, we decided to use __u{8,16,32,64} variable types
in this discussion:

  https://lkml.org/lkml/2019/6/5/18

Build log:

  CC      usr/include/linux/netfilter_bridge/ebtables.h.s
In file included from <command-line>:32:0:
./usr/include/linux/netfilter_bridge/ebtables.h:126:4: error: unknown type name ‘uint8_t’
    uint8_t revision;
    ^~~~~~~
./usr/include/linux/netfilter_bridge/ebtables.h:139:4: error: unknown type name ‘uint8_t’
    uint8_t revision;
    ^~~~~~~
./usr/include/linux/netfilter_bridge/ebtables.h:152:4: error: unknown type name ‘uint8_t’
    uint8_t revision;
    ^~~~~~~

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

Changes in v2:
 - Rebase on the latest Linus tree (commit 9f7582d15f82)

 include/uapi/linux/netfilter_bridge/ebtables.h | 6 +++---
 usr/include/Makefile                           | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index 3b86c14ea49d..8076c940ffeb 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -123,7 +123,7 @@ struct ebt_entry_match {
 	union {
 		struct {
 			char name[EBT_EXTENSION_MAXNAMELEN];
-			uint8_t revision;
+			__u8 revision;
 		};
 		struct xt_match *match;
 	} u;
@@ -136,7 +136,7 @@ struct ebt_entry_watcher {
 	union {
 		struct {
 			char name[EBT_EXTENSION_MAXNAMELEN];
-			uint8_t revision;
+			__u8 revision;
 		};
 		struct xt_target *watcher;
 	} u;
@@ -149,7 +149,7 @@ struct ebt_entry_target {
 	union {
 		struct {
 			char name[EBT_EXTENSION_MAXNAMELEN];
-			uint8_t revision;
+			__u8 revision;
 		};
 		struct xt_target *target;
 	} u;
diff --git a/usr/include/Makefile b/usr/include/Makefile
index 05c71ef42f51..c9449aaf438d 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -38,7 +38,6 @@ header-test- += linux/ivtv.h
 header-test- += linux/jffs2.h
 header-test- += linux/kexec.h
 header-test- += linux/matroxfb.h
-header-test- += linux/netfilter_bridge/ebtables.h
 header-test- += linux/netfilter_ipv4/ipt_LOG.h
 header-test- += linux/netfilter_ipv6/ip6t_LOG.h
 header-test- += linux/nfc.h
-- 
2.17.1

