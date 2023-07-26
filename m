Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7343BC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jul 2023 08:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjGZIip (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jul 2023 04:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbjGZIiO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2023 04:38:14 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Jul 2023 01:27:22 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D9B5266;
        Wed, 26 Jul 2023 01:27:22 -0700 (PDT)
Received: from [46.222.121.5] (port=4658 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qOZUY-005FWq-Qp; Wed, 26 Jul 2023 10:03:33 +0200
Date:   Wed, 26 Jul 2023 10:03:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Kernel oops with 6.4.4 - flow offloads - NULL pointer deref
Message-ID: <ZMDTUHlPmns/85Kk@calendula>
References: <CAA85sZsTF21va8HhwrJc_yuVgVU6+dppEd-SdQpDjqLNFtcneQ@mail.gmail.com>
 <20230724142415.03a9d133@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230724142415.03a9d133@kernel.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Jul 24, 2023 at 02:24:15PM -0700, Jakub Kicinski wrote:
> Adding netfilter to CC.
>
> On Sun, 23 Jul 2023 16:44:50 +0200 Ian Kumlien wrote:
> > Running vanilla 6.4.4 with cherry picked:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.4.5&id=7a59f29961cf97b98b02acaadf5a0b1f8dde938c
> >
[...]
> > [108431.305700] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> > [108431.311107] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> > 0000000000000001
> > [108431.318420] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> > ffff9ebeda71ce58
> > [108431.325735] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> > ffff9ebe3d7fad58
> > [108431.333068] R10: 0000000000000000 R11: 0000000000000003 R12:
> > ffff9ebfafab0000
> > [108431.340415] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> > ffff9ebd79a0f780
> > [108431.347764] FS:  0000000000000000(0000) GS:ffff9ebfafa80000(0000)
> > knlGS:0000000000000000
> > [108431.356069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [108431.362012] CR2: 0000000000000081 CR3: 000000045e99e000 CR4:
> > 00000000003526e0
> > [108431.369361] Call Trace:
> > [108431.371999]  <TASK>
> > [108431.374296] ? __die (arch/x86/kernel/dumpstack.c:421
> > arch/x86/kernel/dumpstack.c:434)
> > [108431.377553] ? page_fault_oops (arch/x86/mm/fault.c:707)
> > [108431.381850] ? load_balance (kernel/sched/fair.c:10926)
> > [108431.385884] ? exc_page_fault (arch/x86/mm/fault.c:1279
> > arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> > [108431.390094] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
> > [108431.394482] ? flow_offload_teardown
> > (./arch/x86/include/asm/bitops.h:75
> > ./include/asm-generic/bitops/instrumented-atomic.h:42
> > net/netfilter/nf_flow_table_core.c:362)
> > [108431.399036] nf_flow_offload_gc_step
> > (./arch/x86/include/asm/bitops.h:207
> > ./arch/x86/include/asm/bitops.h:239
> > ./include/asm-generic/bitops/instrumented-non-atomic.h:142
> > net/netfilter/nf_flow_table_core.c:436)

This crash points here.

static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
                                    struct flow_offload *flow, void *data)
{
        if (nf_flow_has_expired(flow) ||
            nf_ct_is_dying(flow->ct) ||
            nf_flow_is_outdated(flow))
                flow_offload_teardown(flow);

        if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) { <--

Is this always reproducible on your testbed?

Thanks.
