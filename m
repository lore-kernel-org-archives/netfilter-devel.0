Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4804C4360D
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FE221D7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 20:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393113AbfIYUaZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 16:30:25 -0400
Received: from correo.us.es ([193.147.175.20]:44664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393036AbfIYUaZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 16:30:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8AF97C5170
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BEA1A6AB
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 22:30:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 71743A594; Wed, 25 Sep 2019 22:30:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E25D1A7DB2;
        Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B73484265A5A;
        Wed, 25 Sep 2019 22:30:15 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: ebtables: use __u8 instead of uint8_t in uapi header
Date:   Wed, 25 Sep 2019 22:30:02 +0200
Message-Id: <20190925203003.20112-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190925203003.20112-1-pablo@netfilter.org>
References: <20190925203003.20112-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 1fb6abe29b2f..379cc5abc162 100644
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
2.11.0

