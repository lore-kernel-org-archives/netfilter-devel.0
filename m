Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8900BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C79B60F48
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 07:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhI0HeG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhI0HeG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 03:34:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2390C061570
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 00:32:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mUl7h-0005jo-Gk; Mon, 27 Sep 2021 09:32:25 +0200
Date:   Mon, 27 Sep 2021 09:32:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: Delete builtin chains compatibly
Message-ID: <YVFziSC+mLc/sDTF@strlen.de>
References: <20210922160632.15635-1-phil@nwl.cc>
 <20210922160632.15635-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922160632.15635-5-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Attempting to delete all chains if --delete-chain is called without
> argument has unwanted side-effects especially legacy iptables users are
> not aware of and won't expect:
> 
> * Non-default policies are ignored, a previously dropping firewall may
>   start accepting traffic.
> 
> * The kernel refuses to remove non-empty chains, causing program abort
>   even if no user-defined chain exists.
> 
> Fix this by requiring a rule cache in that situation and make builtin
> chain deletion depend on its policy and number of rules. Since this may
> change concurrently, check again when having to refresh the transaction.
> 
> Also, hide builtin chains from verbose output - their creation is
> implicit, so treat their removal as implicit, too.
> 
> When deleting a specific chain, do not allow to skip the job though.
> Otherwise deleting a builtin chain which is still in use will succeed
> although not executed.

Reviewed-by: Florian Westphal <fw@strlen.de>
