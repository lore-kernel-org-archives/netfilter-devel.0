Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B3DC001E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jul 2023 20:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjGGUMO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbjGGUME (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2023 16:12:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D75FE;
        Fri,  7 Jul 2023 13:11:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qHrnp-00062T-8e; Fri, 07 Jul 2023 22:11:41 +0200
Date:   Fri, 7 Jul 2023 22:11:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, kadlec@netfilter.org, pabeni@redhat.com,
        dsahern@kernel.org, fw@strlen.de, daniel@iogearbox.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/6] netfilter: defrag: Add glue hooks for
 enabling/disabling defrag
Message-ID: <20230707201141.GB11622@breakpoint.cc>
References: <cover.1688748455.git.dxu@dxuuu.xyz>
 <8a20b0a3fff75bce1bed207631fe4f56abc3e99d.1688748455.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a20b0a3fff75bce1bed207631fe4f56abc3e99d.1688748455.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> We want to be able to enable/disable IP packet defrag from core
> bpf/netfilter code. In other words, execute code from core that could
> possibly be built as a module.
> 
> To help avoid symbol resolution errors, use glue hooks that the modules
> will register callbacks with during module init.

Reviewed-by: Florian Westphal <fw@strlen.de>
