Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FC1C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E1BE205F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfDOUpj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:45:39 -0400
Received: from mail5.windriver.com ([192.103.53.11]:57638 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfDOUpj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 16:45:39 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x3FKhmDp021097
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 15 Apr 2019 13:44:34 -0700
Received: from yow-cube1.wrs.com (128.224.56.98) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Apr 2019
 13:44:10 -0700
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     <netdev@vger.kernel.org>
CC:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "Florian Westphal" <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: [PATCH -next 3/3] netfilter: nf_tables: drop include of module.h from nf_tables.h
Date:   Mon, 15 Apr 2019 16:43:16 -0400
Message-ID: <1555360996-23684-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
References: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ideally, header files under include/linux shouldn't be adding
includes of other headers, in anticipation of their consumers,
but just the headers needed for the header itself to pass
parsing with CPP.

The module.h is particularly bad in this sense, as it itself does
include a whole bunch of other headers, due to the complexity of
module support.

Since nf_tables.h is not going into a module struct looking for
specific fields, we can just let it know that module is a struct,
just like about 60 other include/linux headers already do.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 706f744f7308..5b8624ae4a27 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,7 +2,6 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
-#include <linux/module.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -13,6 +12,8 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 
+struct module;
+
 #define NFT_JUMP_STACK_SIZE	16
 
 struct nft_pktinfo {
-- 
2.7.4

