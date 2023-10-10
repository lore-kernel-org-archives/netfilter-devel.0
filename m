Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C815CD8CA9
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 17:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjJJRID (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 13:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbjJJRIC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 13:08:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D9B97
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 10:07:59 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qqGD7-0006Ve-At; Tue, 10 Oct 2023 19:07:57 +0200
Date:   Tue, 10 Oct 2023 19:07:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft,v2] doc: remove references to timeout in reset command
Message-ID: <ZSWE7YWwe8Uu/CEg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20231010151615.56391-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010151615.56391-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 10, 2023 at 05:16:15PM +0200, Pablo Neira Ayuso wrote:
> After Linux kernel's patch ("netfilter: nf_tables: do not refresh
> timeout when resetting element") timers are not reset anymore, update
> documentation to keep this in sync.
> 
> Fixes: 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>
