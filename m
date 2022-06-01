Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C18CCA473
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jun 2022 14:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354215AbiFAOCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jun 2022 10:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354610AbiFAOAo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jun 2022 10:00:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 420CE18E05
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2022 06:57:07 -0700 (PDT)
Date:   Wed, 1 Jun 2022 15:56:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nat: really support inet nat without l3
 address
Message-ID: <Ypdv9l4gDGQtOUGB@salvia>
References: <20220601084735.79090-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220601084735.79090-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 01, 2022 at 10:47:35AM +0200, Florian Westphal wrote:
> When no l3 address is given, priv->family is set to NFPROTO_INET and
> the evaluation function isn't called.
> 
> Call it too so l4-only rewrite can work.
> Also add a test case for this.

Applied to nf, thanks
