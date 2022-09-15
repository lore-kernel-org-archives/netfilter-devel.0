Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69954C32771
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Sep 2022 20:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIOUUH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Sep 2022 16:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiIOUUH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Sep 2022 16:20:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DBF5F99C;
        Thu, 15 Sep 2022 13:20:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oYvLA-0001hi-EZ; Thu, 15 Sep 2022 22:20:04 +0200
Date:   Thu, 15 Sep 2022 22:20:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix percpu memory leak at
 nf_tables_addchain()
Message-ID: <20220915202004.GB4385@breakpoint.cc>
References: <41e415f2-3ca4-8e8a-a4b5-5044e7043131@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41e415f2-3ca4-8e8a-a4b5-5044e7043131@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> It seems to me that percpu memory for chain stats started leaking since
> commit 3bc158f8d0330f0a ("netfilter: nf_tables: map basechain priority to
> hardware priority") when nft_chain_offload_priority() returned an error.

Also applied, thanks.
