Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F4CC432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3B920872
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 11:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKULQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 06:16:12 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40942 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKULQM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 06:16:12 -0500
Received: from localhost ([::1]:54032 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXkRX-0001DQ-OZ; Thu, 21 Nov 2019 12:16:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [arptables PATCH 0/3] Some minor fixes
Date:   Thu, 21 Nov 2019 12:15:56 +0100
Message-Id: <20191121111559.27066-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are some patches I found while cleaning up the attic. They add a
gitignore file, fix for a compiler warning and simplify code in libarptc
a bit.

Phil Sutter (3):
  Add .gitignore
  Eliminate compiler warning about size passed to strncmp()
  libarptc: Simplify alloc_handle by using calloc()

 .gitignore               |  4 ++++
 arptables.c              |  3 +--
 libarptc/libarptc_incl.c | 11 +++--------
 3 files changed, 8 insertions(+), 10 deletions(-)
 create mode 100644 .gitignore

-- 
2.24.0

