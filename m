Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739B0C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B85205F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 20:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfDOUpZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:45:25 -0400
Received: from mail5.windriver.com ([192.103.53.11]:57634 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbfDOUpZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 16:45:25 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x3FKhmDm021097
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 15 Apr 2019 13:43:58 -0700
Received: from yow-cube1.wrs.com (128.224.56.98) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.439.0; Mon, 15 Apr 2019
 13:43:37 -0700
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     <netdev@vger.kernel.org>
CC:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: [PATCH -next 2/3] netfilter: nf_tables: fix implicit include of module.h
Date:   Mon, 15 Apr 2019 16:43:15 -0400
Message-ID: <1555360996-23684-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
References: <1555360996-23684-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This file clearly uses modular infrastructure but does not call
out the inclusion of <linux/module.h> explicitly.  We add that
include explicitly here, so we can tidy up some header usage
elsewhere w/o causing build breakage.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netfilter/nf_tables_set_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables_set_core.c
index 814789644bd3..a9fce8d10051 100644
--- a/net/netfilter/nf_tables_set_core.c
+++ b/net/netfilter/nf_tables_set_core.c
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/module.h>
 #include <net/netfilter/nf_tables_core.h>
 
 static int __init nf_tables_set_module_init(void)
-- 
2.7.4

