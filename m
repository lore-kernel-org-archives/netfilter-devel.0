Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6618EE14AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbjIFWlt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 18:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbjIFWlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 18:41:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3AA19AE;
        Wed,  6 Sep 2023 15:41:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qe1DN-00013g-D8; Thu, 07 Sep 2023 00:41:37 +0200
Date:   Thu, 7 Sep 2023 00:41:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net 6/6] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPkAIUSuc0lZl3yu@strlen.de>
References: <20230906162525.11079-1-fw@strlen.de>
 <20230906162525.11079-7-fw@strlen.de>
 <ZPjyB48c+y6P9MOZ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPjyB48c+y6P9MOZ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Wed, Sep 06, 2023 at 06:25:12PM +0200, Florian Westphal wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Deliver audit log from __nf_tables_dump_rules(), table dereference at
> > the end of the table list loop might point to the list head, leading to
> > this crash.
> 
> There are a few issues with this patch, can we please drop it from this
> MR for now?

If this were a change that *adds* a kernel crash, then, sure.
But this fixes a crash, so I see no reason to keep it back.

Please do an incremental followup instead.

Thanks.
