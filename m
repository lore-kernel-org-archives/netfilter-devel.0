Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80574EB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 15:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjGCPXX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 11:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjGCPXX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 11:23:23 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BF7E62;
        Mon,  3 Jul 2023 08:23:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qGLOC-0000cR-Qj; Mon, 03 Jul 2023 17:22:56 +0200
Date:   Mon, 3 Jul 2023 17:22:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florent Revest <revest@chromium.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kpsingh@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: conntrack: Avoid nf_ct_helper_hash uses
 after free
Message-ID: <20230703152256.GC7043@breakpoint.cc>
References: <20230703145216.1096265-1-revest@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230703145216.1096265-1-revest@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florent Revest <revest@chromium.org> wrote:
> If nf_conntrack_init_start() fails (for example due to a
> register_nf_conntrack_bpf() failure), the nf_conntrack_helper_fini()
> clean-up path frees the nf_ct_helper_hash map.
> 
> When built with NF_CONNTRACK=y, further netfilter modules (e.g:
> netfilter_conntrack_ftp) can still be loaded and call
> nf_conntrack_helpers_register(), independently of whether nf_conntrack
> initialized correctly. This accesses the nf_ct_helper_hash dangling
> pointer and causes a uaf, possibly leading to random memory corruption.
> 
> This patch guards nf_conntrack_helper_register() from accessing a freed
> or uninitialized nf_ct_helper_hash pointer and fixes possible
> uses-after-free when loading a conntrack module.

Reviewed-by: Florian Westphal <fw@strlen.de>
