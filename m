Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8280C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 10:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880E621773
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 10:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfC1KFW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 06:05:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47102 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfC1KFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 06:05:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h9RuI-0004eI-C5; Thu, 28 Mar 2019 11:05:10 +0100
Date:   Thu, 28 Mar 2019 11:05:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Potapenko <glider@google.com>
Cc:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        dvyukov@google.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: initialize ct->timeout
Message-ID: <20190328100510.g5zxthxm3ymsw6q5@breakpoint.cc>
References: <20190328094720.25399-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328094720.25399-1-glider@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexander Potapenko <glider@google.com> wrote:
> KMSAN started reporting an error when accessing ct->timeout for the
> first time without initialization:
> 
>  BUG: KMSAN: uninit-value in __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
>  ...
>  dump_stack+0x173/0x1d0 lib/dump_stack.c:113
>  kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:624
>  __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
>  __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
>  nf_ct_refresh_acct ./include/net/netfilter/nf_conntrack.h:201
>  nf_conntrack_udp_packet+0xb44/0x1040 net/netfilter/nf_conntrack_proto_udp.c:122
>  nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1605
>  nf_conntrack_in+0x1250/0x26c9 net/netfilter/nf_conntrack_core.c:1696
>  ...
>  Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205
>  kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:159
>  kmsan_kmalloc+0xa9/0x130 mm/kmsan/kmsan_hooks.c:173
>  kmem_cache_alloc+0x554/0xb10 mm/slub.c:2789
>  __nf_conntrack_alloc+0x16f/0x690 net/netfilter/nf_conntrack_core.c:1342
>  init_conntrack+0x6cb/0x2490 net/netfilter/nf_conntrack_core.c:1421

Acked-by: Florian Westphal <fw@strlen.de>
