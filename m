Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B44CC25B08
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Aug 2022 19:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiHTTWE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Aug 2022 15:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHTTWD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Aug 2022 15:22:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7F2CDD5
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Aug 2022 12:22:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oPU2h-0007uZ-QE; Sat, 20 Aug 2022 21:21:59 +0200
Date:   Sat, 20 Aug 2022 21:21:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Shell Chen <xierch@gmail.com>
Subject: Re: [PATCH nf] nefilter: nft_tproxy: restrict to prerouting hook
Message-ID: <20220820192159.GA27967@breakpoint.cc>
References: <CAAqMkDxLzFZ9YT-DiRh5cVQRha=JzZ+8RYcmkcn8iinrucA+GA@mail.gmail.com>
 <20220820155406.84029-1-fw@strlen.de>
 <CAKcfE+ZnxmsecpZe5V3jmBT9W6UC52UjDBt78L7jMK9ujHn3wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKcfE+ZnxmsecpZe5V3jmBT9W6UC52UjDBt78L7jMK9ujHn3wA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Balazs Scheidler <bazsi77@gmail.com> wrote:
> I think this is not correct. TPROXY can be used from output as well to
> divert locally generated traffic. I didn't look into the output null
> reference case posted earlier but that's also a use case to redirect local
> output to a proxy.

Are you sure?

The upstreamed TPROXY doesn't support this.
xt_TPROXY sets:
  .hooks          = 1 << NF_INET_PRE_ROUTING,

and the backend code assumes that the inout device in the hook state is
available, which is only guaranteed in prerouting and input hooks.

