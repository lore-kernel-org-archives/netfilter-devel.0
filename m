Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0151C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 03:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjEPD6O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 May 2023 23:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjEPD6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2023 23:58:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B5DC30F3;
        Mon, 15 May 2023 20:58:07 -0700 (PDT)
Date:   Tue, 16 May 2023 05:58:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Patch for -stable, 6.3.x
Message-ID: <ZGL/S2D68bm29hC4@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg, Sasha,

Could you cherry-pick the follow patch into 6.3.x? Thanks.

commit f057b63bc11d86a98176de31b437e46789f44d8f
Author: Florian Westphal <fw@strlen.de>
Date:   Wed May 3 12:00:18 2023 +0200

    netfilter: nf_tables: fix ct untracked match breakage
    
    "ct untracked" no longer works properly due to erroneous NFT_BREAK.
    We have to check ctinfo enum first.
    
    Fixes: d9e789147605 ("netfilter: nf_tables: avoid retpoline overhead for some ct expression calls")
    Reported-by: Rvfg <i@rvf6.com>
    Link: https://marc.info/?l=netfilter&m=168294996212038&w=2
    Signed-off-by: Florian Westphal <fw@strlen.de>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
