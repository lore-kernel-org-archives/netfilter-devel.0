Return-Path: <SRS0=HcD6=3P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27576C35240
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jan 2020 04:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2CF20720
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jan 2020 04:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAZECY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Jan 2020 23:02:24 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:49808 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728842AbgAZECY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Jan 2020 23:02:24 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 60A213A17E5
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jan 2020 15:02:03 +1100 (AEDT)
Received: (qmail 11279 invoked by uid 501); 26 Jan 2020 04:02:02 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 0/1] Simplify struct pkt_buff: remove tail
Date:   Sun, 26 Jan 2020 15:02:01 +1100
Message-Id: <20200126040202.11237-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200118204357.dg5b7qo5aqbesg4s@salvia>
References: <20200118204357.dg5b7qo5aqbesg4s@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=t4_DsRW3aEDjXT6e0GAA:9 a=pHzHmUro8NiASowvMSCR:22
        a=n87TN5wuljxrRezIQYnT:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This patch uses a static inline function as you requested.

I thought the macro would result in fewer instructions, but haven't checked.

Anyway you have both versions now.

Cheers ... Duncan.

Duncan Roe (1):
  Simplify struct pkt_buff: remove tail

 src/extra/ipv4.c    | 4 ++--
 src/extra/ipv6.c    | 8 ++++----
 src/extra/pktbuff.c | 6 +-----
 src/extra/tcp.c     | 6 +++---
 src/extra/udp.c     | 6 +++---
 src/internal.h      | 5 ++++-
 6 files changed, 17 insertions(+), 18 deletions(-)

-- 
2.14.5

