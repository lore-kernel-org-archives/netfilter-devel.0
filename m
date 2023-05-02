Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9E5C77B73
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 May 2023 17:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjEBRTs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 May 2023 13:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbjEBRTp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2023 13:19:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B79AB
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2023 10:19:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pttfC-00063F-KH; Tue, 02 May 2023 19:19:42 +0200
Date:   Tue, 2 May 2023 19:19:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] doc: add nat examples
Message-ID: <20230502171942.GB22029@breakpoint.cc>
References: <20230501101009.386454-1-fw@strlen.de>
 <ZFDBbQ+u85XkfWMx@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFDBbQ+u85XkfWMx@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 01, 2023 at 12:10:09PM +0200, Florian Westphal wrote:
> > nftables nat is much more capable than what the existing
> > documentation describes.
> > 
> > In particular, nftables can fully emulate iptables
> > NETMAP target and can perform n:m address mapping.
> > 
> > Add a new example section extracted from commit log
> > messages when those features got added.
> 
> LGTM, thanks for documenting this, I should have done this myself.

No problem, I've pushed this with your suggested change.
