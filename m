Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1673AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238868AbiATKdI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiATKdH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 05:33:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BE2C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 02:33:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nAUkb-0002Gp-2E; Thu, 20 Jan 2022 11:33:05 +0100
Date:   Thu, 20 Jan 2022 11:33:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Fix response to unprivileged users
Message-ID: <20220120103305.GC31905@breakpoint.cc>
References: <20220120101653.28280-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120101653.28280-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Expected behaviour in both variants is:
> 
> * Print help without error, append extension help if -m and/or -j
>   options are present
> * Indicate lack of permissions in an error message for anything else
> 
> With iptables-nft, this was broken basically from day 1. Shared use of
> do_parse() then somewhat broke legacy: it started complaining about
> inability to create a lock file.
> 
> Fix this by making iptables-nft assume extension revision 0 is present
> if permissions don't allow to verify. This is consistent with legacy.
> 
> Second part is to exit directly after printing help - this avoids having
> to make the following code "nop-aware" to prevent privileged actions.

Thanks!

Reviewed-by: Florian Westphal <fw@strlen.de>
