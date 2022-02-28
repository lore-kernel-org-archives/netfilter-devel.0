Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A70BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 21:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiB1VfJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiB1VfI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 16:35:08 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8F5B1375BB
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 13:34:29 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E86B360201;
        Mon, 28 Feb 2022 22:33:03 +0100 (CET)
Date:   Mon, 28 Feb 2022 22:34:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: egress: silence egress hook lockdep splats
Message-ID: <Yh0/4G8oqlvF/JjK@salvia>
References: <20220228031805.32347-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220228031805.32347-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 28, 2022 at 04:18:05AM +0100, Florian Westphal wrote:
> Netfilter assumes its called with rcu_read_lock held, but in egress
> hook case it may be called with BH readlock.
> 
> This triggers lockdep splat.
> 
> In order to avoid to change all rcu_dereference() to
> rcu_dereference_check(..., rcu_read_lock_bh_held()), wrap nf_hook_slow
> with read lock/unlock pair.

Applied, thanks
