Return-Path: <SRS0=kOBD=7V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A149EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 07:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A61204EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jun 2020 07:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgFHHPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jun 2020 03:15:10 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:37646 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728958AbgFHHPI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jun 2020 03:15:08 -0400
Received: from dimstar.local.net (n175-34-64-112.sun1.vic.optusnet.com.au [175.34.64.112])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id 10184108FF8
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2020 17:15:05 +1000 (AEST)
Received: (qmail 14490 invoked by uid 501); 8 Jun 2020 07:15:01 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/2] Force 'make distcheck' to pass
Date:   Mon,  8 Jun 2020 17:14:59 +1000
Message-Id: <20200608071501.14448-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200607184716.GA20705@salvia>
References: <20200607184716.GA20705@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=keeXcwCgVCrAuxOn72dlvA==:117 a=keeXcwCgVCrAuxOn72dlvA==:17
        a=nTHF0DUjJn0A:10 a=RSmzAf-M6YYA:10 a=sCPzpq4Jc1WB1LuJ7jcA:9
        a=pHzHmUro8NiASowvMSCR:22 a=n87TN5wuljxrRezIQYnT:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Patch 1 below is the same as I sent previously.

Patch 2 forces 'make distcheck' to pass. The generated tar.bz2 is good.
The patch is not pretty, but the best I could do.

Cheers ... Duncan.

Duncan Roe (2):
  build: dist: Add fixmanpages.sh to distribution tree
  build: dist: Force 'make distcheck' to pass

 Makefile.am                              |  1 +
 doxygen/Makefile.am                      | 18 +++++++++++++++---
 fixmanpages.sh => doxygen/fixmanpages.sh |  2 +-
 3 files changed, 17 insertions(+), 4 deletions(-)
 rename fixmanpages.sh => doxygen/fixmanpages.sh (99%)

-- 
2.14.5

