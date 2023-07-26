Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E820C001DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 14:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjGZOfh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 10:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjGZOfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 10:35:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD76B4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:35:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qOfbx-0000s4-84; Wed, 26 Jul 2023 16:35:33 +0200
Date:   Wed, 26 Jul 2023 16:35:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 patch ping
Message-ID: <20230726143533.GB2963@breakpoint.cc>
References: <20230725191128.GE84273@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725191128.GE84273@celephais.dreamlands>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> There is a ulogd2 patch of mine from the end of last that is still under
> review in Patchwork:
> 
>   https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221208222208.681865-1-jeremy@azazel.net/
> 
> It would be great to get a yea or nay.

Sorry, I don't use ulogd2 at all so I have no clue if this is good
or not.

I'll apply it on Friday in case noone objects until then.
