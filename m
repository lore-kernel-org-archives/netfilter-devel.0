Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375E7C43618
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CA74613CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344023AbhDFMWK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:22:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34442 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbhDFMWB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:22:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 25E6863E61;
        Tue,  6 Apr 2021 14:21:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/28] netfilter: ipset: Remove duplicate declaration
Date:   Tue,  6 Apr 2021 14:21:15 +0200
Message-Id: <20210406122133.1644-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

struct ip_set is declared twice. One is declared at 79th line,
so remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 46d9a0c26c67..10279c4830ac 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -124,8 +124,6 @@ struct ip_set_ext {
 	bool target;
 };
 
-struct ip_set;
-
 #define ext_timeout(e, s)	\
 ((unsigned long *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_TIMEOUT]))
 #define ext_counter(e, s)	\
-- 
2.30.2

