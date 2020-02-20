Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78C8C11D07
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 10:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9EA82465D
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 10:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgBTKwo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 05:52:44 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:54124 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgBTKwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 05:52:43 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j4jRh-0000Wb-2W; Thu, 20 Feb 2020 11:52:41 +0100
Date:   Thu, 20 Feb 2020 11:52:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nf-next v4 0/9] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20200220105240.GG20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1579647351.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

When playing with adding multiple elements, I suddenly noticed a
disturbance in the force (general protection fault). Here's a
reproducer:

| $NFT -f - <<EOF
| table t {
|         set s {
|                 type ipv4_addr . inet_service
|                 flags interval
|         }
| }
| EOF
| 
| $NFT add element t s '{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
| $NFT flush set t s
| $NFT add element t s '{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'

It is pretty reliable, though sometimes needs a second call. Looks like some
things going on in parallel which shouldn't. Here's a typical last breath:

[   71.319848] general protection fault, probably for non-canonical address 0x6f6b6e696c2e756e: 0000 [#1] PREEMPT SMP PTI
[   71.321540] CPU: 3 PID: 1201 Comm: kworker/3:2 Not tainted 5.6.0-rc1-00377-g2bb07f4e1d861 #192
[   71.322746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
[   71.324430] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
[   71.325387] RIP: 0010:nft_set_elem_destroy+0xa5/0x110 [nf_tables]
[   71.326164] Code: 89 d4 84 c0 74 0e 8b 77 44 0f b6 f8 48 01 df e8 41 ff ff ff 45 84 e4 74 36 44 0f b6 63 08 45 84 e4 74 2c 49 01 dc 49 8b 04 24 <48> 8b 40 38 48 85 c0 74 4f 48 89 e7 4c 8b
[   71.328423] RSP: 0018:ffffc9000226fd90 EFLAGS: 00010282
[   71.329225] RAX: 6f6b6e696c2e756e RBX: ffff88813ab79f60 RCX: ffff88813931b5a0
[   71.330365] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88813ab79f9a
[   71.331473] RBP: ffff88813ab79f60 R08: 0000000000000008 R09: 0000000000000000
[   71.332627] R10: 000000000000021c R11: 0000000000000000 R12: ffff88813ab79fc2
[   71.333615] R13: ffff88813b3adf50 R14: dead000000000100 R15: ffff88813931b8a0
[   71.334596] FS:  0000000000000000(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[   71.335780] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   71.336577] CR2: 000055ac683710f0 CR3: 000000013a222003 CR4: 0000000000360ee0
[   71.337533] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   71.338557] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   71.339718] Call Trace:
[   71.340093]  nft_pipapo_destroy+0x7a/0x170 [nf_tables_set]
[   71.340973]  nft_set_destroy+0x20/0x50 [nf_tables]
[   71.341879]  nf_tables_trans_destroy_work+0x246/0x260 [nf_tables]
[   71.342916]  process_one_work+0x1d5/0x3c0
[   71.343601]  worker_thread+0x4a/0x3c0
[   71.344229]  kthread+0xfb/0x130
[   71.344780]  ? process_one_work+0x3c0/0x3c0
[   71.345477]  ? kthread_park+0x90/0x90
[   71.346129]  ret_from_fork+0x35/0x40
[   71.346748] Modules linked in: nf_tables_set nf_tables nfnetlink 8021q [last unloaded: nfnetlink]
[   71.348153] ---[ end trace 2eaa8149ca759bcc ]---
[   71.349066] RIP: 0010:nft_set_elem_destroy+0xa5/0x110 [nf_tables]
[   71.350016] Code: 89 d4 84 c0 74 0e 8b 77 44 0f b6 f8 48 01 df e8 41 ff ff ff 45 84 e4 74 36 44 0f b6 63 08 45 84 e4 74 2c 49 01 dc 49 8b 04 24 <48> 8b 40 38 48 85 c0 74 4f 48 89 e7 4c 8b
[   71.350017] RSP: 0018:ffffc9000226fd90 EFLAGS: 00010282
[   71.350019] RAX: 6f6b6e696c2e756e RBX: ffff88813ab79f60 RCX: ffff88813931b5a0
[   71.350019] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88813ab79f9a
[   71.350020] RBP: ffff88813ab79f60 R08: 0000000000000008 R09: 0000000000000000
[   71.350021] R10: 000000000000021c R11: 0000000000000000 R12: ffff88813ab79fc2
[   71.350022] R13: ffff88813b3adf50 R14: dead000000000100 R15: ffff88813931b8a0
[   71.350025] FS:  0000000000000000(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[   71.350026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   71.350027] CR2: 000055ac683710f0 CR3: 000000013a222003 CR4: 0000000000360ee0
[   71.350028] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   71.350028] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   71.350030] Kernel panic - not syncing: Fatal exception
[   71.350412] Kernel Offset: disabled
[   71.365922] ---[ end Kernel panic - not syncing: Fatal exception ]---

Cheers, Phil
