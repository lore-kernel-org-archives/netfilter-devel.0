Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ADFC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF3C20651
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 19:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfCSTJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 15:09:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35356 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfCSTJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 15:09:46 -0400
Received: from localhost ([::1]:48446 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h6K7M-0007M0-Tu; Tue, 19 Mar 2019 20:09:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH 0/3] Misc items found in Fedora package
Date:   Tue, 19 Mar 2019 20:09:35 +0100
Message-Id: <20190319190938.20751-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 is something I discovered when dealing with the rest. Patches 2
and 3 stem from Fedora package. Actually, I wrote patch 2 from scratch
(to avoid patching Makefile) and slightly adjusted patch 3 so it
compiles with current sources.

Phil Sutter (3):
  extensions: Drop Makefile
  Allow customizing lockfile location at configure time
  extensions: Add AUDIT target

 Makefile.am                        |   6 +-
 configure.ac                       |   3 +
 extensions/Makefile                |  30 --------
 extensions/ebt_AUDIT.c             | 110 +++++++++++++++++++++++++++++
 include/linux/netfilter/xt_AUDIT.h |  30 ++++++++
 libebtc.c                          |   7 +-
 6 files changed, 147 insertions(+), 39 deletions(-)
 delete mode 100644 extensions/Makefile
 create mode 100644 extensions/ebt_AUDIT.c
 create mode 100644 include/linux/netfilter/xt_AUDIT.h

-- 
2.21.0

