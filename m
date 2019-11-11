Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA5CC17441
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 04:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102EE2086A
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 04:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfKKERa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Nov 2019 23:17:30 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48184 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbfKKER3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Nov 2019 23:17:29 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 594EF12DDA7
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2019 15:17:24 +1100 (AEDT)
Received: (qmail 30702 invoked by uid 501); 11 Nov 2019 04:17:23 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/2] Miscellaneous fixes
Date:   Mon, 11 Nov 2019 15:17:21 +1100
Message-Id: <20191111041723.30660-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10 a=WcJxYfz_WUf2vjIbR_gA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I came across these while updating documentation.
So, I haven't actually exercised the code.

Duncan Roe (2):
  src: pktb_trim() was not updating tail after updating len
  src: Make sure pktb_alloc() works for AF_INET6 since we document that
    it does

 src/extra/pktbuff.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.14.5

