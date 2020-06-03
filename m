Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6B1C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72FAF20674
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 03:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgFCDzR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:55:17 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34810 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbgFCDzR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jun 2020 23:55:17 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 3B0851A8191
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 13:55:15 +1000 (AEST)
Received: (qmail 17589 invoked by uid 501); 3 Jun 2020 03:55:12 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 0/1] Avoid packet copy in nfq_nlmsg_verdict_put_pkt
Date:   Wed,  3 Jun 2020 13:55:11 +1000
Message-Id: <20200603035512.17544-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=BS8Dn6BvwspdfiSx2HMA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch demonstrates using sendmsg() to avoid the memcpy() in
nfq_nlmsg_verdict_put_pkt().

This is a catch-up to the libnfnetlink-based nfq_set_verdict() function family
which already used sendmsg() to avoid data copy.

The logic is implemented in a number of static functions.
These functions are proposed as a starting point for additions to
libnetfilter_queue and libmnl.

This patch is an RFC on these functions.

Duncan Roe (1):
  examples: Use sendmsg() to avoid packet copy in
    nfq_nlmsg_verdict_put_pkt()

 examples/nf-queue.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 122 insertions(+), 6 deletions(-)

-- 
2.14.5

