Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8443C33C9B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 07:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B920421734
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 07:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgAFHJ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 02:09:29 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45164 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726569AbgAFHJ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 02:09:29 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id EB2013A271C
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 18:09:16 +1100 (AEDT)
Received: (qmail 4744 invoked by uid 501); 6 Jan 2020 07:09:15 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 0/1] Make usable man pages
Date:   Mon,  6 Jan 2020 18:09:14 +1100
Message-Id: <20200106070915.4700-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10 a=yhr0tdMM4F9ZTAK7YRcA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

fixmanpages.sh generates a top-level man page file tree such that man/man3
contains an entry for every documented nfq function. This is what users expect.

See main commit for how fixmanpages.sh works.

Itwould be nice to have "make" run "doxygen doxygen.cfg; ./fixmanpages.sh" and
"make install" install the man pages but I'm not yet that good with autotools.

There could be a similar script for libmnl.

Duncan Roe (1):
  doc: setup: Add shell script fixmanpages.sh to make usable man pages

 fixmanpages.sh | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100755 fixmanpages.sh

-- 
2.14.5

