Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9728C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 May 2022 16:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiE3Ql2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 May 2022 12:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236918AbiE3Ql1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 May 2022 12:41:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 194BE70374
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2022 09:41:27 -0700 (PDT)
Date:   Mon, 30 May 2022 18:41:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chander Govindarajan <mail@chandergovind.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nft: simplify chain lookup in do_list_chain
Message-ID: <YpTzszIxgiL8s14e@salvia>
References: <9e9387c5-7416-3325-32c0-49b21b95b21e@chandergovind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e9387c5-7416-3325-32c0-49b21b95b21e@chandergovind.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 25, 2022 at 03:25:43PM +0530, Chander Govindarajan wrote:
> use the chain_cache_find function for faster lookup of chain instead of
> iterating over all chains in table

Applied, thanks
