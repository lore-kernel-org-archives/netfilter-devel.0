Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9081C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 13:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC8682080F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 13:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="SJas1X8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437933AbfIUNu0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 09:50:26 -0400
Received: from condef-03.nifty.com ([202.248.20.68]:52649 "EHLO
        condef-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437919AbfIUNu0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 09:50:26 -0400
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-03.nifty.com with ESMTP id x8LDlRT5028242
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Sep 2019 22:47:28 +0900
Received: from grover.flets-west.jp (softbank126021098169.bbtec.net [126.21.98.169]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id x8LDktRD010507;
        Sat, 21 Sep 2019 22:46:56 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com x8LDktRD010507
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569073616;
        bh=5xK4mZcFYP3ny+MZeQAf2c3rhdo7t2J/7fDHiLRieNc=;
        h=From:To:Cc:Subject:Date:From;
        b=SJas1X8NoFJ85mQNC+VMMlxMm5DsBKgz8PlYbi6nAJDoG2rLDF5DUGpVb2bPKhy20
         CPzJm5+9qLjI4jnYr07t1tRGcEGPQ7mFaPMK4ETqhQZoUmGq5r9gvbTKjD/FLDi5G1
         q2Ltzb4oCvWMSXwYyxBWAiXyzfAeDlWTVTuoFUyr/92k5DXBPLFfsAfrtWMT+dYPMP
         UrKwUxoL22NbdPgPULzQ2MrHluPT01kiYVNFCI18zjK9O3SL1SDFUvQfL21wDcdhj3
         tRRgWg+ii5G5yYPnnnIKRqPREONhriO6Zu7WSAPod7Vvo+hmY5NEvR3gAZ30tYs3CS
         +c70FVcZya/dw==
X-Nifty-SrcIP: [126.21.98.169]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: use __u8 instead of uint8_t in uapi header
Date:   Sat, 21 Sep 2019 22:46:48 +0900
Message-Id: <20190921134648.1259-1-yamada.masahiro@socionext.com>
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
index 77e0a0cd972a..faba1e5c3873 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -37,7 +37,6 @@ header-test- += linux/hdlc/ioctl.h
 header-test- += linux/ivtv.h
 header-test- += linux/kexec.h
 header-test- += linux/matroxfb.h
-header-test- += linux/netfilter_bridge/ebtables.h
 header-test- += linux/netfilter_ipv4/ipt_LOG.h
 header-test- += linux/netfilter_ipv6/ip6t_LOG.h
 header-test- += linux/nfc.h
-- 
2.17.1

