Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A73C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 May 2022 18:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387000AbiEBTCb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 May 2022 15:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386995AbiEBTCa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 May 2022 15:02:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0782654C
        for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2022 11:59:00 -0700 (PDT)
Date:   Mon, 2 May 2022 20:58:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] nftables: add support for wildcard interfaces
Message-ID: <YnAp8E2JIjD8fm/6@salvia>
References: <20220429183239.5569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429183239.5569-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 29, 2022 at 08:32:36PM +0200, Florian Westphal wrote:
> First patch is needed so kernel doesn't think end is before start,
> second patch allows to dump "x .foo*" correctly, without this
> nft tries to represent the start/end "name" with a range.
> This doesn't work well because end range uses \ff padding.
> 
> Patch 3 adds tests.

LGTM, thanks
