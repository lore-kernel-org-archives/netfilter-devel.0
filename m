Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B06C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 17:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjKCRzX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjKCRzX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 13:55:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD29136;
        Fri,  3 Nov 2023 10:55:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyyO4-0007Hr-5V; Fri, 03 Nov 2023 18:55:16 +0100
Date:   Fri, 3 Nov 2023 18:55:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Simon Horman <horms@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 02/19] netfilter: nft_set_rbtree: prefer sync gc
 to async worker
Message-ID: <20231103175516.GH8035@breakpoint.cc>
References: <20231025212555.132775-1-pablo@netfilter.org>
 <20231025212555.132775-3-pablo@netfilter.org>
 <20231103173442.GB768996@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103173442.GB768996@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Simon Horman <horms@kernel.org> wrote:
> Hi Florian and Pablo,
> 
> I understand that this patch has been accepted upstream,
> and that by implication this feedback is rather slow,
> but I noticed that with this patch nft_net is now
> set but otherwise unused in this function.

There is a patch queued for this, we'll pass this to -net next week.
