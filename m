Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9EBC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F8420663
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfLJL0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:26:52 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47449 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbfLJL0w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 06:26:52 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id D81AE7EAF38
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2019 22:26:35 +1100 (AEDT)
Received: (qmail 11555 invoked by uid 501); 10 Dec 2019 11:26:34 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] New pktb_usebuf() function
Date:   Tue, 10 Dec 2019 22:26:33 +1100
Message-Id: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10 a=KODRzMIvjSYvv9NE35YA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pktb_usebuf() is a copy of pktb_alloc() with the first part modified to use
a supplied buffer rather than calloc() one. I thought this would give a
measurable performance boost and it does.
All the code after the memset() call is common to pktb_alloc(). If you like,
I can submit a v2 with this code in a static function called by both.

Duncan Roe (1):
  src: Add alternative function to pktb_alloc to avoid malloc / free
    overhead

 include/libnetfilter_queue/pktbuff.h |  2 +
 src/extra/pktbuff.c                  | 82 ++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

--
2.14.5

