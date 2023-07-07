Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC12EB64D9
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jul 2023 20:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjGGUVA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jul 2023 16:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGGUU7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2023 16:20:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883E26A5;
        Fri,  7 Jul 2023 13:20:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qHrw9-00066o-F8; Fri, 07 Jul 2023 22:20:17 +0200
Date:   Fri, 7 Jul 2023 22:20:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, kadlec@netfilter.org, pabeni@redhat.com,
        dsahern@kernel.org, fw@strlen.de, daniel@iogearbox.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 3/6] netfilter: bpf: Prevent defrag module
 unload while link active
Message-ID: <20230707202017.GD11622@breakpoint.cc>
References: <cover.1688748455.git.dxu@dxuuu.xyz>
 <7549d65daa702ba89aa3e43d5a1bbd562d569a99.1688748455.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7549d65daa702ba89aa3e43d5a1bbd562d569a99.1688748455.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> While in practice we could handle the module being unloaded while a
> netfilter link (that requested defrag) was active, it's a better user
> experience to prevent the defrag module from going away. It would
> violate user expectations if fragmented packets started showing up if
> some other part of the system tried to unload defrag module.

Reviewed-by: Florian Westphal <fw@strlen.de>
