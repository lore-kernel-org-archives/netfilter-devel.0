Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D43C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28882173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfBZJVG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:21:06 -0500
Received: from mx139-tc.baidu.com ([61.135.168.139]:22436 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbfBZJVF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 04:21:05 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 392941EBA007;
        Tue, 26 Feb 2019 17:20:52 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: [PATCH][v2] netfilter: ensure that CONNTRACK_LOCKS is power of 2
Date:   Tue, 26 Feb 2019 17:20:52 +0800
Message-Id: <1551172852-18056-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONNTRACK_LOCKS is divisor when computer array index,
if it is power of 2, compiler will optimize modulo
operation as bitwise AND, or else modulo will lower
performance

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
v1-->v2: do not replace modulo operation with AND, only ensure that CONNTRACK_LOCKS is power of 2

 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e139c256e269..f708c376f225 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2482,6 +2482,7 @@ int nf_conntrack_init_net(struct net *net)
 	int cpu;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
+	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
 	atomic_set(&net->ct.count, 0);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
-- 
2.16.2

