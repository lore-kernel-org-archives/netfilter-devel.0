Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9600C432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 05:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 828DC20672
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 05:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKWFRN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 00:17:13 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54507 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbfKWFRN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 00:17:13 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 48C573A185D
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 16:16:57 +1100 (AEDT)
Received: (qmail 18350 invoked by uid 501); 23 Nov 2019 05:16:57 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] src: Comment-out code not needed since Linux 3.8 in examples/nf-queue.c
Date:   Sat, 23 Nov 2019 16:16:56 +1100
Message-Id: <20191123051657.18308-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10 a=FDdAsoSCZBkJDyaGnf4A:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the first in what I expect will be a number of patches to
examples/nf-queue.c as I update the documentation and maybe introduce new
helper functions.
An aspirational goal is to have all netfilter functions in nf-queue.c be
documented in the libnetfilter_queue web page.

Duncan Roe (1):
  src: Comment-out code not needed since Linux 3.8 in
    examples/nf-queue.c

 examples/nf-queue.c | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

-- 
2.14.5

