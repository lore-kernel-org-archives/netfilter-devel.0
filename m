Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F38BC11F66
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 13:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6496128B
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jul 2021 13:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhGMNYI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jul 2021 09:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236283AbhGMNYI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jul 2021 09:24:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519ECC0613DD;
        Tue, 13 Jul 2021 06:21:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m3ILL-0000YP-FG; Tue, 13 Jul 2021 15:20:59 +0200
Date:   Tue, 13 Jul 2021 15:20:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] audit: fix memory leak in nf_tables_commit
Message-ID: <20210713132059.GB11179@breakpoint.cc>
References: <20210713130344.473646-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713130344.473646-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> free the adp variable.
> 
> Fix this by freeing the linked list with head adl.
> 
> backtrace:
>   kmalloc include/linux/slab.h:591 [inline]
>   kzalloc include/linux/slab.h:721 [inline]
>   nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
>   nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
>   nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
>   sock_sendmsg_nosec net/socket.c:702 [inline]
>   sock_sendmsg+0x56/0x80 net/socket.c:722
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
> v1->v2: fix the compile issue
>  net/netfilter/nf_tables_api.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 390d4466567f..7f45b291be13 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8444,6 +8444,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
>  	return 0;
>  }
>  
> +static void nf_tables_commit_free(struct list_head *adl)

nf_tables_commit_audit_free?

Aside from that, there should be a followup patch (for nf-next),
adding empty inline functions in case of CONFIG_AUDITSYSCALL=n.

Right now it does pointless aggregation for the AUDIT=n case.
