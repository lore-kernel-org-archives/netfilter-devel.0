Return-Path: <SRS0=2TpG=4X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93E7C10DCE
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F37208C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Mar 2020 16:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCFQ6S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:58:18 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58360 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgCFQ6S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 11:58:18 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jAGIi-0001Gz-3W; Fri, 06 Mar 2020 17:58:16 +0100
Date:   Fri, 6 Mar 2020 17:58:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nft_chain_nat: inet family is missing
 module ownership
Message-ID: <20200306165816.GO979@breakpoint.cc>
References: <20200306163728.76733-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306163728.76733-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Set owner to THIS_MODULE, otherwise the nft_chain_nat module might be
> removed while there are still inet/nat chains in place.
> 
> [  117.942096] BUG: unable to handle page fault for address: ffffffffa0d5e040
> [  117.942101] #PF: supervisor read access in kernel mode
> [  117.942103] #PF: error_code(0x0000) - not-present page
> [  117.942106] PGD 200c067 P4D 200c067 PUD 200d063 PMD 3dc909067 PTE 0
> [  117.942113] Oops: 0000 [#1] PREEMPT SMP PTI
> [  117.942118] CPU: 3 PID: 27 Comm: kworker/3:0 Not tainted 5.6.0-rc3+ #348
> [  117.942133] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
> [  117.942145] RIP: 0010:nf_tables_chain_destroy.isra.0+0x94/0x15a [nf_tables]
> [  117.942149] Code: f6 45 54 01 0f 84 d1 00 00 00 80 3b 05 74 44 48 8b 75 e8 48 c7 c7 72 be de a0 e8 56 e6 2d e0 48 8b 45 e8 48 c7 c7 7f be de a0 <48> 8b 30 e8 43 e6 2d e0 48 8b 45 e8 48 8b 40 10 48 85 c0 74 5b 8b
> [  117.942152] RSP: 0018:ffffc9000015be10 EFLAGS: 00010292
> [  117.942155] RAX: ffffffffa0d5e040 RBX: ffff88840be87fc2 RCX: 0000000000000007
> [  117.942158] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffffffffa0debe7f
> [  117.942160] RBP: ffff888403b54b50 R08: 0000000000001482 R09: 0000000000000004
> [  117.942162] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8883eda7e540
> [  117.942164] R13: dead000000000122 R14: dead000000000100 R15: ffff888403b3db80
> [  117.942167] FS:  0000000000000000(0000) GS:ffff88840e4c0000(0000) knlGS:0000000000000000
> [  117.942169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  117.942172] CR2: ffffffffa0d5e040 CR3: 00000003e4c52002 CR4: 00000000001606e0
> [  117.942174] Call Trace:
> [  117.942188]  nf_tables_trans_destroy_work.cold+0xd/0x12 [nf_tables]
> [  117.942196]  process_one_work+0x1d6/0x3b0
> [  117.942200]  worker_thread+0x45/0x3c0
> [  117.942203]  ? process_one_work+0x3b0/0x3b0
> [  117.942210]  kthread+0x112/0x130
> [  117.942214]  ? kthread_create_worker_on_cpu+0x40/0x40
> [  117.942221]  ret_from_fork+0x35/0x40
> 
> nf_tables_chain_destroy() crashes on module_put().

Argh :-/

Thanks for fixing this.
