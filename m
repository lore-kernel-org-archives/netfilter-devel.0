Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16502C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbhLAMDk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 07:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347651AbhLAMDX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 07:03:23 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2548C061748
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 04:00:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1msOHJ-0005FQ-CT; Wed, 01 Dec 2021 13:00:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] netlink_delinearize cleanups
Date:   Wed,  1 Dec 2021 12:59:53 +0100
Message-Id: <20211201115956.13252-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No indended behavioural changes here.
binop postprocessing has been extended a lot and in a few places
things only work because expr->map and expr->left alias to the same
location.

 src/netlink_delinearize.c |    2 -
 src/netlink_delinearize.c |   74 +++++++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 32 deletions(-)

