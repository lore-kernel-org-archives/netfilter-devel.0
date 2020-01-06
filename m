Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC9C32767
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2171E21582
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 03:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgAFDRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 22:17:30 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55141 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727369AbgAFDRa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 22:17:30 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 151CE7E9E2E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 14:17:15 +1100 (AEDT)
Received: (qmail 12432 invoked by uid 501); 6 Jan 2020 03:17:14 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 0/1] New pktb_make() function
Date:   Mon,  6 Jan 2020 14:17:13 +1100
Message-Id: <20200106031714.12390-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
References: <20191210112634.11511-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=x2bQSVbeq4-Tbz7z0HMA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch offers a faster alternative / replacement function to pktb_alloc().

pktb_make() is a copy of the first part of pktb_alloc() modified to use a
supplied buffer rather than calloc() one. It then calls the second part of
pktb_alloc() which is modified to be a static function.

Can't think of a use case where one would choose to use pktb_alloc over
pktb_make.
In a furure documentation update, might relegate pktb_alloc and pktb_free to
"other functions".

Duncan Roe (1):
  src: Add alternative function to pktb_alloc to avoid malloc / free
    overhead

 include/libnetfilter_queue/pktbuff.h |  1 +
 src/extra/pktbuff.c                  | 60 ++++++++++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 2 deletions(-)

v2: - Function name changed to pktb_make (was pktb_usebuf)
    - Cvt 2nd 1/2 of pktb_malloc into a static function common to pktb_make

-- 
2.14.5

