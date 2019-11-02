Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB80BCA9ED1
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD7220862
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfKBKaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Nov 2019 06:30:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48199 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726229AbfKBKaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Nov 2019 06:30:10 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 0289D3A0B65
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Nov 2019 21:29:53 +1100 (AEDT)
Received: (qmail 17954 invoked by uid 501); 2 Nov 2019 10:29:52 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/2] src: doc: Main Page updates
Date:   Sat,  2 Nov 2019 21:29:50 +1100
Message-Id: <20191102102952.17912-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=quZDEtWZU54zi4_x0EwA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a first pass at modernising the Main Page.
Please, get back to me quickly with any disagreement about the new content:
the next phase of updates will be modifying the same file.
(next phase is to address the numerous doxygen warnings regarding argument
descriptions that don't match prototype).
I suspect the Privileges section should also specify CAP_NET_RAW,
but haven't had time to test this.

Duncan Roe (2):
  src: whitespace: Eliminate useless spaces before tabs
  src: doc: Update the Main Page to be nft-focusssed

 src/libnetfilter_queue.c | 83 ++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 35 deletions(-)

-- 
2.14.5

