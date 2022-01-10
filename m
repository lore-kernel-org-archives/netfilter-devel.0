Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC72C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 17:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbiAJRhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 12:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238197AbiAJRhd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 12:37:33 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93852C06173F
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jan 2022 09:37:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n6ybq-0000eB-5t; Mon, 10 Jan 2022 18:37:30 +0100
Date:   Mon, 10 Jan 2022 18:37:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft -f fails to restore ruleset listing with cetain dynamic set
 types
Message-ID: <20220110173730.GA32500@breakpoint.cc>
References: <20220110152820.GE317@breakpoint.cc>
 <YdxtKNCoNJ2IGXIQ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdxtKNCoNJ2IGXIQ@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Any suggestions on how to fix this?
> 
> Could you set on the dynamic flag from the evaluation path?

I'll give this a shot.
