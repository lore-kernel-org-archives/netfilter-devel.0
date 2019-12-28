Return-Path: <SRS0=8lzl=2S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD09C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 01:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E68E207E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 01:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfL1BYN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 20:24:13 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37991 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfL1BYN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 20:24:13 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id D37C57EAF40
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Dec 2019 12:23:58 +1100 (AEDT)
Received: (qmail 2518 invoked by uid 501); 28 Dec 2019 01:23:57 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/2] src: doc: fix remaining doxygen warnings
Date:   Sat, 28 Dec 2019 12:23:55 +1100
Message-Id: <20191228012357.2474-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10 a=S04WeiWhttRWC8itjJIA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These 2 patches eliminate the last warnings from "doxygen doxygen.cfg".

I plan 1 more (large-ish) round of documentation polish then move on
to some kind of Library Setup [CURRENT] topic.

Duncan Roe (2):
  src: tcp.c: change 1 remaining pkt formal arg to pktb
  src: tcp.c: fix remaining doxygen warnings

 src/extra/tcp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--
2.14.5

