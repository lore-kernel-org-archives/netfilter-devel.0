Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12F1C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 14:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B2C26A54
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 14:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfEaOR5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 10:17:57 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45540 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfEaOR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 10:17:57 -0400
Received: from localhost ([::1]:58630 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hWiM0-0000Wl-Cl; Fri, 31 May 2019 16:17:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/2] Fix and simplify mnl_batch_talk()
Date:   Fri, 31 May 2019 16:17:41 +0200
Message-Id: <20190531141743.15049-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As requested, here's the mnl_batch_talk() fix extracted from previous
series. To make things more clear, I've split this into a very minimal
FD_SET/select reordering fix and a follow-up simplifying the code a bit.

Feel free to fold into your own series and/or dismiss second patch at
your own convenience. :)

Phil Sutter (2):
  mnl: Initialize fd_set before select(), not after
  mnl: Simplify mnl_batch_talk()

 src/mnl.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

-- 
2.21.0

