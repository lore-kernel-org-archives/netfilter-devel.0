Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA99C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbjKCQfY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjKCQfX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:35:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B49F111
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:35:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyx8h-0006t5-Rq; Fri, 03 Nov 2023 17:35:19 +0100
Date:   Fri, 3 Nov 2023 17:35:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/4] arptables-nft: use ARPT_INV flags
 consistently
Message-ID: <20231103163519.GE8035@breakpoint.cc>
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-2-fw@strlen.de>
 <ZUUYMEGTRN2OFBwn@orbyte.nwl.cc>
 <20231103160129.GD8035@breakpoint.cc>
 <ZUUdXyKzjKzIYae/@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUUdXyKzjKzIYae/@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Indeed, I broke the checks for ARPT_INV_ARPHLN in there. That needs a
> fix either way.
> 
> The ARPT_INV_* defines are part of UAPI. They can't be removed without
> breaking (or also converting?) legacy arptables.

Its just a cached header.

> Either way, we're
> breaking third-party arptables DSOs using them. Right now, they are only
> broken with arptables-nft. No idea if such DSOs exist, but if
> compatibility is to be taken seriously, there's no way around reverting
> above commit (and reintroducing do_commandarp() or at least a wrapper
> around the shared do_parse()).

arptables-legacy doesn't support runtime extension loading.

I'll post a patch to convert libarpt_mangle.c.
