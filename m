Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7BFC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 12:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80ED360E74
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 12:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhJLMI3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbhJLMI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 08:08:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD96C061570;
        Tue, 12 Oct 2021 05:06:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1maGY2-0006eg-3h; Tue, 12 Oct 2021 14:06:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lvs-devel@vger.kernel.org, ja@ssi.bg, horms@verge.net.au,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: ipvs: remove unneeded hook wrappers
Date:   Tue, 12 Oct 2021 14:06:04 +0200
Message-Id: <20211012120608.21827-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series reduces the number of different hook function
implementations by merging the ipv4 and ipv6 hooks into
common code.

selftests/netfilter/ipvs.sh passes.

Florian Westphal (4):
  netfilter: ipvs: prepare for hook function reduction
  netfilter: ipvs: remove unneeded output wrappers
  netfilter: ipvs: remove unneeded input wrappers
  netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers

 net/netfilter/ipvs/ip_vs_core.c | 166 ++++++--------------------------
 1 file changed, 32 insertions(+), 134 deletions(-)

-- 
2.32.0

