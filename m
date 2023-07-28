Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D40C00528
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 09:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjG1JxQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 05:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbjG1Jwy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 05:52:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA6411D;
        Fri, 28 Jul 2023 02:52:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qPK9K-0001Yf-9S; Fri, 28 Jul 2023 11:52:42 +0200
Date:   Fri, 28 Jul 2023 11:52:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     daniel@iogearbox.net, kadlec@netfilter.org, edumazet@google.com,
        ast@kernel.org, fw@strlen.de, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, andrii@kernel.org, davem@davemloft.net,
        alexei.starovoitov@gmail.com, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH bpf-next v6 2/5] netfilter: bpf: Support
 BPF_F_NETFILTER_IP_DEFRAG in netfilter link
Message-ID: <20230728095242.GB15474@breakpoint.cc>
References: <cover.1689970773.git.dxu@dxuuu.xyz>
 <5cff26f97e55161b7d56b09ddcf5f8888a5add1d.1689970773.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cff26f97e55161b7d56b09ddcf5f8888a5add1d.1689970773.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> This commit adds support for enabling IP defrag using pre-existing
> netfilter defrag support. Basically all the flag does is bump a refcnt
> while the link the active. Checks are also added to ensure the prog
> requesting defrag support is run _after_ netfilter defrag hooks.
> 
> We also take care to avoid any issues w.r.t. module unloading -- while
> defrag is active on a link, the module is prevented from unloading.

Reviewed-by: Florian Westphal <fw@strlen.de>
