Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A66C00140
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Aug 2022 09:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiHUJpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Aug 2022 05:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiHUJpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2022 05:45:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684511F639
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2022 02:45:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oPhVq-0003Xc-9k; Sun, 21 Aug 2022 11:44:58 +0200
Date:   Sun, 21 Aug 2022 11:44:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, abhishek.shah@columbia.edu
Subject: Re: [PATCH nf] netfilter: nf_tables: make table handle allocation
 per-netns friendly
Message-ID: <20220821094458.GC11586@breakpoint.cc>
References: <20220821085939.571378-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821085939.571378-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> mutex is per-netns, move table_netns to the pernet area.
> 
> *read-write* to 0xffffffff883a01e8 of 8 bytes by task 6542 on cpu 0:
>  nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>  nfnetlink_rcv+0xa6a/0x13a0 net/netfilter/nfnetlink.c:652
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x652/0x730 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x643/0x740 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg net/socket.c:725 [inline]
>  ____sys_sendmsg+0x348/0x4c0 net/socket.c:2413
>  ___sys_sendmsg net/socket.c:2467 [inline]
>  __sys_sendmsg+0x159/0x1f0 net/socket.c:2496
>  __do_sys_sendmsg net/socket.c:2505 [inline]
>  __se_sys_sendmsg net/socket.c:2503 [inline]
>  __x64_sys_sendmsg+0x47/0x50 net/socket.c:2503
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/c
> 
> Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")

Ah, that makes sense.

Reviewed-by: Florian Westphal <fw@strlen.de>
