Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08998C2BA2B
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29032078E
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 07:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgDKHYz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 03:24:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58039 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDKHYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 03:24:55 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id CE70E58B97A
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2020 17:24:51 +1000 (AEST)
Received: (qmail 7401 invoked by uid 501); 11 Apr 2020 07:24:50 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] src & doc: pktb_alloc2
Date:   Sat, 11 Apr 2020 17:24:49 +1000
Message-Id: <20200411072450.7359-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200219180410.e56psjovne3y43rc@salvia>
References: <20200219180410.e56psjovne3y43rc@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=cl8xLZFz6L8A:10 a=RSmzAf-M6YYA:10
        a=OnwhO_VJ0YFIgi24MisA:9 a=pHzHmUro8NiASowvMSCR:22
        a=n87TN5wuljxrRezIQYnT:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Herewith pktb_alloc2() as you suggested.
There is no malloc/free and data is only moved if extra > 0.

Cheers ... Duncan.

Duncan Roe (1):
  New faster pktb_alloc2 replaces pktb_alloc & pktb_free

 fixmanpages.sh                       |   6 +-
 include/libnetfilter_queue/pktbuff.h |   2 +
 src/extra/pktbuff.c                  | 204 +++++++++++++++++++++++++++++------
 src/nlmsg.c                          |  14 ++-
 4 files changed, 185 insertions(+), 41 deletions(-)

--
2.14.5

