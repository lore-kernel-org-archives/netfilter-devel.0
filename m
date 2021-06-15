Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACB3C48BE5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 16:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0246A61465
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 16:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhFOQEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 12:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhFOQEE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 12:04:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF13C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 09:01:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ltBVl-0001Jk-EQ; Tue, 15 Jun 2021 18:01:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 0/3] fix icmpv6 id dependeny handling
Date:   Tue, 15 Jun 2021 18:01:48 +0200
Message-Id: <20210615160151.10594-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2: in patch 1, make sure set has elements and is anonymous.

Pablo reported following bug:

input: icmpv6 id 1
output: icmpv6 type { echo-request, echo-reply } icmpv6 parameter-problem 65536/16

First patch fixes delinearization to handle this correctly.
Second patch fixes a bug related to dependency removal.
Third patch adds test cases for this bug.

 src/netlink_delinearize.c         |   68 ++++++++++++++++++++++++++++++++++++--
 src/payload.c                     |   61 ++++++++++++++++++++--------------
 tests/py/ip/icmp.t                |    1 
 tests/py/ip/icmp.t.json           |   28 +++++++++++++++
 tests/py/ip/icmp.t.payload.ip     |    9 +++++
 tests/py/ip6/icmpv6.t             |    3 +
 tests/py/ip6/icmpv6.t.json        |   61 ++++++++++++++++++++++++++++++++++
 tests/py/ip6/icmpv6.t.payload.ip6 |   21 +++++++++++
 8 files changed, 225 insertions(+), 27 deletions(-)

