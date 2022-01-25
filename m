Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ECCC41535
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1587199AbiAYQ6j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356264AbiAYQz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:55:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3EC0613EE
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP46-0001d3-NX; Tue, 25 Jan 2022 17:53:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 0/7] iptables: prefer native expressions for udp and tcp matches
Date:   Tue, 25 Jan 2022 17:52:54 +0100
Message-Id: <20220125165301.5960-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series switches iptables-nft to use native nft expressions
(payload, cmp, range, bitwise) to match on ports and tcp flags.

Patches are split up to first add delinearization support and
then switch the add/insert side over to generating those expressions.

Florian Westphal (7):
  nft-shared: support native tcp port delinearize
  nft-shared: support native tcp port range delinearize
  nft-shared: support native udp port delinearize
  nft: prefer native expressions instead of udp match
  nft: prefer native expressions instead of tcp match
  nft-shared: add tcp flag dissection
  nft: add support for native tcp flag matching

 iptables/nft-shared.c | 436 +++++++++++++++++++++++++++++++++++++++++-
 iptables/nft-shared.h |   5 +
 iptables/nft.c        | 182 ++++++++++++++++++
 3 files changed, 621 insertions(+), 2 deletions(-)

-- 
2.34.1

