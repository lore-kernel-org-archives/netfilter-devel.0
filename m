Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3DBC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 19:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbhLQTET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 14:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbhLQTET (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 14:04:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3102CC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 11:04:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1myIWf-00008x-Ea; Fri, 17 Dec 2021 20:04:17 +0100
Date:   Fri, 17 Dec 2021 20:04:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Vitaly Zuevsky <vzuevsky@ns1.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
Message-ID: <20211217190417.GC17681@breakpoint.cc>
References: <20211209163926.25563-1-fw@strlen.de>
 <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
 <20211209171152.GA26636@breakpoint.cc>
 <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
 <CA+PiBLze0Qu-AdAeu_0K++HcHaaN+7p383drNyx3y0RdO2FCuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+PiBLze0Qu-AdAeu_0K++HcHaaN+7p383drNyx3y0RdO2FCuA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vitaly Zuevsky <vzuevsky@ns1.com> wrote:
> Hi Florian
> 
> Do you have any news on this?
> Meanwhile I cloned the repo git://git.netfilter.org/conntrack-tools,
> ran ./autogen.sh to produce configure, and the latter failed with:
> 
> checking for rpc/rpc_msg.h... yes
> ./configure: line 13329: syntax error near unexpected token `LIBTIRPC,'
> ./configure: line 13329: `  PKG_CHECK_MODULES(LIBTIRPC, libtirpc >= 0.1)'
> 
> Interestingly, PKG_CHECK_MODULES was never defined there. Is that
> repository for production code - I am confused?

Sure.  But the patch is for the kernel.
I already mentioned that this doesn't handle anything for non-nat case.

> > > Maybe 'conntrack -L unconfirmed' or 'conntrack -L dying' show something?

Still stands.

Also, is there really a discrepancy? Please show output of

conntrack -C
conntrack -L | wc -l
conntrack -C

"conntrack -L" reclaims dead/timed-out entries, conntrack -C currently
does not.
