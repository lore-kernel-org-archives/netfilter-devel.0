Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60B0C46495
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 22:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD20D218A4
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 22:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGDW7a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 18:59:30 -0400
Received: from mail.us.es ([193.147.175.20]:51642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbfGDW73 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 18:59:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F2AA114560
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 00:59:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91553DA708
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 00:59:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87081DA732; Fri,  5 Jul 2019 00:59:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92743CE158;
        Fri,  5 Jul 2019 00:59:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 00:59:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 678AC4265A31;
        Fri,  5 Jul 2019 00:59:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 3/3] cli: remove useless #include headers
Date:   Fri,  5 Jul 2019 00:59:20 +0200
Message-Id: <20190704225920.3671-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190704225920.3671-1-pablo@netfilter.org>
References: <20190704225920.3671-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cli.h | 1 +
 src/cli.c     | 8 +-------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 3780e0917969..c1819d464327 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -1,6 +1,7 @@
 #ifndef _NFT_CLI_H_
 #define _NFT_CLI_H_
 
+#include <nftables/libnftables.h>
 #include <config.h>
 
 struct parser_state;
diff --git a/src/cli.c b/src/cli.c
index bbdd0fdbeeb8..f1e89926f2bc 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -24,14 +24,8 @@
 #include <readline/readline.h>
 #include <readline/history.h>
 
-#include <nftables.h>
-#include <parser.h>
-#include <erec.h>
-#include <utils.h>
-#include <iface.h>
 #include <cli.h>
-
-#include <libmnl/libmnl.h>
+#include <list.h>
 
 #define CMDLINE_HISTFILE	".nft.history"
 
-- 
2.11.0

