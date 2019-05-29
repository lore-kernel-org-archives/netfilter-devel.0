Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DEEC28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561A2205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 13:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfE2NOQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 09:14:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40290 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfE2NOQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 09:14:16 -0400
Received: from localhost ([::1]:53378 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVyPG-0006xf-Gn; Wed, 29 May 2019 15:14:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH 0/4] Fix ENOBUFS error in large transactions with --echo
Date:   Wed, 29 May 2019 15:13:42 +0200
Message-Id: <20190529131346.23659-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When committing a larger transaction (e.g. adding 300 rules) with echo
output turned on, mnl_batch_talk() would report ENOBUFS after the first
call to mnl_socket_recvfrom(). (ENOBUFS indicates congestion in netlink
socket.)

The problem in mnl_batch_talk() was a combination of unmodified socket
recv buffer, use of select() and unhandled ENOBUFS condition (abort
instead of retry).

This series solves the issue, admittedly a bit in sledge hammer method:
Maximize nf_sock receive buffer size for all users, make
mnl_batch_talk() fetch more messages at once and retry upon ENOBUFS
instead of just giving up.

There was also a problem with select() use which motivated the loop
rewrite in Patch 3. Actually, replacing the whole loop by a simple call
to nft_mnl_recv() worked and was even sufficient in avoiding ENOBUFS
condition, but I am not sure if that has other side-effects.

Phil Sutter (4):
  mnl: Maximize socket receive buffer by default
  mnl: Increase receive buffer in mnl_batch_talk()
  mnl: Fix and simplify mnl_batch_talk()
  tests/shell: Test large transaction with echo output

 src/mnl.c                                     | 82 ++++++++++---------
 tests/shell/testcases/transactions/0049huge_0 | 14 ++++
 2 files changed, 58 insertions(+), 38 deletions(-)
 create mode 100755 tests/shell/testcases/transactions/0049huge_0

-- 
2.21.0

