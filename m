Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3689CC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 16:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbjKCQzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjKCQzp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 12:55:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AEBD47
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 09:55:41 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qyxSO-0007EX-3l; Fri, 03 Nov 2023 17:55:40 +0100
Date:   Fri, 3 Nov 2023 17:55:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 1/4] arptables-nft: use ARPT_INV flags
 consistently
Message-ID: <ZUUmDCXkVtssSuKc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231103102330.27578-1-fw@strlen.de>
 <20231103102330.27578-2-fw@strlen.de>
 <ZUUYMEGTRN2OFBwn@orbyte.nwl.cc>
 <20231103160129.GD8035@breakpoint.cc>
 <ZUUdXyKzjKzIYae/@orbyte.nwl.cc>
 <20231103163519.GE8035@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103163519.GE8035@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 05:35:19PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Indeed, I broke the checks for ARPT_INV_ARPHLN in there. That needs a
> > fix either way.
> > 
> > The ARPT_INV_* defines are part of UAPI. They can't be removed without
> > breaking (or also converting?) legacy arptables.
> 
> Its just a cached header.

Ah, you mean dropping them locally just to prevent reuse. Yeah, why not.

> > Either way, we're
> > breaking third-party arptables DSOs using them. Right now, they are only
> > broken with arptables-nft. No idea if such DSOs exist, but if
> > compatibility is to be taken seriously, there's no way around reverting
> > above commit (and reintroducing do_commandarp() or at least a wrapper
> > around the shared do_parse()).
> 
> arptables-legacy doesn't support runtime extension loading.

Ah, that's great news!

> I'll post a patch to convert libarpt_mangle.c.

Cool, thanks!
