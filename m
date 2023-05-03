Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C778C7EE23
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 11:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjECLtj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 07:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjECLtg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 07:49:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7D5B5592
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 04:49:34 -0700 (PDT)
Date:   Wed, 3 May 2023 13:49:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        Rvfg <i@rvf6.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix ct untracked match breakage
Message-ID: <ZFJKSmEMis6a867U@calendula>
References: <20230503100018.74845-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230503100018.74845-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 03, 2023 at 12:00:18PM +0200, Florian Westphal wrote:
> "ct untracked" no longer works properly due to erroneous NFT_BREAK.
> We have to check ctinfo enum first.

Applied, thanks
