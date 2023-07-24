Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D5EEB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jul 2023 21:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbjGXVYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jul 2023 17:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjGXVYU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2023 17:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8810C125
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2023 14:24:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 074E4613DC
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389D3C433C8;
        Mon, 24 Jul 2023 21:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690233856;
        bh=/ePTC90N0jfKqdgywr43mFXcpqi4NTcraGIGAOByEok=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gtUv+nTX3e4eDwsOZAiR5OBV/wJUWIvsbKY86Fni+n6M/He59/p/7e98z5gHOmI0S
         8N13qdfCkBU9bZm836POY+RkxCnWRqgXiktJvFRNe5LMfHULapmrYzzNpR9K0gO11s
         8oZetdqb61fuoF00FeNVklnym8L8ElT3T/9ckt96GTNj2/dKaSeg2Tg3n8j1OEiRwG
         kCiDDSSTwCoJilpeE98L4+jheuE3A/Yt+fx3G8wySPkl+B09NkezNHtkl0iAGrBTEO
         qL2BUPzep1EvMml/31IM4rf04Iav1iKCM0zoMgMOGDPksYPWxLKmC6qAtE0TvAhK1r
         8MSXMwu5isxxA==
Date:   Mon, 24 Jul 2023 14:24:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Kernel oops with 6.4.4 - flow offloads - NULL pointer deref
Message-ID: <20230724142415.03a9d133@kernel.org>
In-Reply-To: <CAA85sZsTF21va8HhwrJc_yuVgVU6+dppEd-SdQpDjqLNFtcneQ@mail.gmail.com>
References: <CAA85sZsTF21va8HhwrJc_yuVgVU6+dppEd-SdQpDjqLNFtcneQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adding netfilter to CC.

On Sun, 23 Jul 2023 16:44:50 +0200 Ian Kumlien wrote:
> Running vanilla 6.4.4 with cherry picked:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.4.5&id=7a59f29961cf97b98b02acaadf5a0b1f8dde938c
> 
> cat bug.txt | ./scripts/decode_stacktrace.sh vmlinux
> [108431.234344] BUG: kernel NULL pointer dereference, address: 0000000000000081
> [108431.241509] #PF: supervisor write access in kernel mode
> [108431.246912] #PF: error_code(0x0002) - not-present page
> [108431.252226] PGD 0 P4D 0
> [108431.254938] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [108431.259472] CPU: 2 PID: 76217 Comm: kworker/2:0 Not tainted 6.4.4-dirty #381
> [108431.266698] Hardware name: Supermicro Super
> Server/A2SDi-12C-HLN4F, BIOS 1.7a 10/13/2022
> [108431.274967] Workqueue: events_power_efficient nf_flow_offload_work_gc
> [108431.281599] RIP: 0010:flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.286746] Code: 00 00 e9 96 fd ff ff 66 0f 1f 44 00 00 48 83 c7
> 08 be 32 00 00 00 e9 82 fd ff ff 66 90 48 8b 87 b0 00 00 00 48 05 81
> 00 00 00 <f0> 80 20 bf f0 80 8f b8 00 00 00 04 48 8b 97 b0 00 00 00 0f
> b6 42
> All code
> ========
>    0: 00 00                add    %al,(%rax)
>    2: e9 96 fd ff ff        jmp    0xfffffffffffffd9d
>    7: 66 0f 1f 44 00 00    nopw   0x0(%rax,%rax,1)
>    d: 48 83 c7 08          add    $0x8,%rdi
>   11: be 32 00 00 00        mov    $0x32,%esi
>   16: e9 82 fd ff ff        jmp    0xfffffffffffffd9d
>   1b: 66 90                xchg   %ax,%ax
>   1d: 48 8b 87 b0 00 00 00 mov    0xb0(%rdi),%rax
>   24: 48 05 81 00 00 00    add    $0x81,%rax
>   2a:* f0 80 20 bf          lock andb $0xbf,(%rax) <-- trapping instruction
>   2e: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>   35: 04
>   36: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   3d: 0f                    .byte 0xf
>   3e: b6 42                mov    $0x42,%dh
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f0 80 20 bf          lock andb $0xbf,(%rax)
>    4: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>    b: 04
>    c: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   13: 0f                    .byte 0xf
>   14: b6 42                mov    $0x42,%dh
> [108431.305700] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> [108431.311107] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> 0000000000000001
> [108431.318420] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> ffff9ebeda71ce58
> [108431.325735] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> ffff9ebe3d7fad58
> [108431.333068] R10: 0000000000000000 R11: 0000000000000003 R12:
> ffff9ebfafab0000
> [108431.340415] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> ffff9ebd79a0f780
> [108431.347764] FS:  0000000000000000(0000) GS:ffff9ebfafa80000(0000)
> knlGS:0000000000000000
> [108431.356069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.362012] CR2: 0000000000000081 CR3: 000000045e99e000 CR4:
> 00000000003526e0
> [108431.369361] Call Trace:
> [108431.371999]  <TASK>
> [108431.374296] ? __die (arch/x86/kernel/dumpstack.c:421
> arch/x86/kernel/dumpstack.c:434)
> [108431.377553] ? page_fault_oops (arch/x86/mm/fault.c:707)
> [108431.381850] ? load_balance (kernel/sched/fair.c:10926)
> [108431.385884] ? exc_page_fault (arch/x86/mm/fault.c:1279
> arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> [108431.390094] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
> [108431.394482] ? flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.399036] nf_flow_offload_gc_step
> (./arch/x86/include/asm/bitops.h:207
> ./arch/x86/include/asm/bitops.h:239
> ./include/asm-generic/bitops/instrumented-non-atomic.h:142
> net/netfilter/nf_flow_table_core.c:436)
> [108431.403675] nf_flow_offload_work_gc
> (net/netfilter/nf_flow_table_core.c:407
> net/netfilter/nf_flow_table_core.c:452
> net/netfilter/nf_flow_table_core.c:460)
> [108431.408321] process_one_work (kernel/workqueue.c:2413)
> [108431.412533] worker_thread (./include/linux/list.h:292
> kernel/workqueue.c:2556)
> [108431.416396] ? rescuer_thread (kernel/workqueue.c:2498)
> [108431.420608] kthread (kernel/kthread.c:379)
> [108431.423944] ? kthread_complete_and_exit (kernel/kthread.c:332)
> [108431.428937] ret_from_fork (arch/x86/entry/entry_64.S:314)
> [108431.432710]  </TASK>
> [108431.435087] Modules linked in: chaoskey
> [108431.439119] CR2: 0000000000000081
> [108431.442633] ---[ end trace 0000000000000000 ]---
> [108431.455408] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [108431.462591] #PF: supervisor read access in kernel mode
> [108431.464358] pstore: backend (erst) writing error (-28)
> [108431.467928] #PF: error_code(0x0000) - not-present page
> [108431.468038] RIP: 0010:flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.468148] PGD 0
> [108431.468254] Code: 00 00 e9 96 fd ff ff 66 0f 1f 44 00 00 48 83 c7
> 08 be 32 00 00 00 e9 82 fd ff ff 66 90 48 8b 87 b0 00 00 00 48 05 81
> 00 00 00 <f0> 80 20 bf f0 80 8f b8 00 00 00 04 48 8b 97 b0 00 00 00 0f
> b6 42
> All code
> ========
>    0: 00 00                add    %al,(%rax)
>    2: e9 96 fd ff ff        jmp    0xfffffffffffffd9d
>    7: 66 0f 1f 44 00 00    nopw   0x0(%rax,%rax,1)
>    d: 48 83 c7 08          add    $0x8,%rdi
>   11: be 32 00 00 00        mov    $0x32,%esi
>   16: e9 82 fd ff ff        jmp    0xfffffffffffffd9d
>   1b: 66 90                xchg   %ax,%ax
>   1d: 48 8b 87 b0 00 00 00 mov    0xb0(%rdi),%rax
>   24: 48 05 81 00 00 00    add    $0x81,%rax
>   2a:* f0 80 20 bf          lock andb $0xbf,(%rax) <-- trapping instruction
>   2e: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>   35: 04
>   36: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   3d: 0f                    .byte 0xf
>   3e: b6 42                mov    $0x42,%dh
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f0 80 20 bf          lock andb $0xbf,(%rax)
>    4: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>    b: 04
>    c: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   13: 0f                    .byte 0xf
>   14: b6 42                mov    $0x42,%dh
> [108431.473471] P4D 0
> [108431.473571] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> [108431.473740]
> [108431.473841]
> [108431.473949] Oops: 0000 [#2] PREEMPT SMP NOPTI
> [108431.474047] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> 0000000000000001
> [108431.474150] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D
>     6.4.4-dirty #381
> [108431.474253] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> ffff9ebeda71ce58
> [108431.474382] Hardware name: Supermicro Super
> Server/A2SDi-12C-HLN4F, BIOS 1.7a 10/13/2022
> [108431.474511] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> ffff9ebe3d7fad58
> [108431.474640] RIP: 0010:memcmp (lib/string.c:681)
> [108431.474768] R10: 0000000000000000 R11: 0000000000000003 R12:
> ffff9ebfafab0000
> [108431.474898] Code: cc cc cc 48 85 c0 75 f3 0f b6 4f 01 48 83 c7 01
> 84 c9 75 bc eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 eb 14
> 48 8b 06 <48> 39 07 75 17 48 83 c7 08 48 83 c6 08 48 83 ea 08 48 83 fa
> 07 77
> All code
> ========
>    0: cc                    int3
>    1: cc                    int3
>    2: cc                    int3
>    3: 48 85 c0              test   %rax,%rax
>    6: 75 f3                jne    0xfffffffffffffffb
>    8: 0f b6 4f 01          movzbl 0x1(%rdi),%ecx
>    c: 48 83 c7 01          add    $0x1,%rdi
>   10: 84 c9                test   %cl,%cl
>   12: 75 bc                jne    0xffffffffffffffd0
>   14: eb e3                jmp    0xfffffffffffffff9
>   16: 66 66 2e 0f 1f 84 00 data16 cs nopw 0x0(%rax,%rax,1)
>   1d: 00 00 00 00
>   21: 0f 1f 40 00          nopl   0x0(%rax)
>   25: eb 14                jmp    0x3b
>   27: 48 8b 06              mov    (%rsi),%rax
>   2a:* 48 39 07              cmp    %rax,(%rdi) <-- trapping instruction
>   2d: 75 17                jne    0x46
>   2f: 48 83 c7 08          add    $0x8,%rdi
>   33: 48 83 c6 08          add    $0x8,%rsi
>   37: 48 83 ea 08          sub    $0x8,%rdx
>   3b: 48 83 fa 07          cmp    $0x7,%rdx
>   3f: 77                    .byte 0x77
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 48 39 07              cmp    %rax,(%rdi)
>    3: 75 17                jne    0x1c
>    5: 48 83 c7 08          add    $0x8,%rdi
>    9: 48 83 c6 08          add    $0x8,%rsi
>    d: 48 83 ea 08          sub    $0x8,%rdx
>   11: 48 83 fa 07          cmp    $0x7,%rdx
>   15: 77                    .byte 0x77
> [108431.475001] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> ffff9ebd79a0f780
> [108431.475129] RSP: 0018:ffffac2500200ae8 EFLAGS: 00010216
> [108431.475297] FS:  0000000000000000(0000) GS:ffff9ebfafa80000(0000)
> knlGS:0000000000000000
> [108431.475426]
> [108431.475534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.475664] RAX: 000000008a00000a RBX: ffff9ebc413b4250 RCX:
> 0000000000000000
> [108431.475764] CR2: 0000000000000081 CR3: 000000045e99e000 CR4:
> 00000000003526e0
> [108431.475872] RDX: 0000000000000032 RSI: ffffac2500200ba0 RDI:
> 0000000000000008
> [108431.476001] note: kworker/2:0[76217] exited with irqs disabled
> [108431.476128] RBP: ffff9ebd42b18058 R08: 000000000000000a R09:
> 0000000000000028
> [108431.653260] R10: 00000000000000f0 R11: 00000000000000f0 R12:
> 0000000000000000
> [108431.660609] R13: ffff9ebc413b4260 R14: ffff9ebd42b18000 R15:
> 0000000000000000
> [108431.667958] FS:  0000000000000000(0000) GS:ffff9ebfafb80000(0000)
> knlGS:0000000000000000
> [108431.676260] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.682203] CR2: 0000000000000008 CR3: 0000000109310000 CR4:
> 00000000003526e0
> [108431.689555] Call Trace:
> [108431.692193]  <IRQ>
> [108431.694401] ? __die (arch/x86/kernel/dumpstack.c:421
> arch/x86/kernel/dumpstack.c:434)
> [108431.697657] ? page_fault_oops (arch/x86/mm/fault.c:707)
> [108431.701954] ? vhost_poll_wakeup (drivers/vhost/vhost.c:179)
> [108431.706244] ? __wake_up_common (kernel/sched/wait.c:108)
> [108431.710546] ? exc_page_fault (arch/x86/mm/fault.c:1279
> arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> [108431.714756] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
> [108431.719136] ? memcmp (lib/string.c:681)
> [108431.722385] flow_offload_hash_cmp (net/netfilter/nf_flow_table_core.c:253)
> [108431.726854] flow_offload_lookup (./include/linux/rhashtable.h:608
> ./include/linux/rhashtable.h:646
> net/netfilter/nf_flow_table_core.c:376)
> [108431.731234] nf_flow_offload_ip_hook (net/netfilter/nf_flow_table_ip.c:363)
> [108431.736050] ? netlink_broadcast (net/netlink/af_netlink.c:1548)
> [108431.740517] nf_hook_slow (./include/linux/netfilter.h:143
> net/netfilter/core.c:626)
> [108431.744208] __netif_receive_skb_core.constprop.0
> (./include/linux/netfilter_netdev.h:34 net/core/dev.c:5274
> net/core/dev.c:5361)
> [108431.750163] __netif_receive_skb_list_core (net/core/dev.c:5570)
> [108431.755500] netif_receive_skb_list_internal (net/core/dev.c:5638
> net/core/dev.c:5727)
> [108431.761011] napi_complete_done (./include/linux/list.h:37
> ./include/net/gro.h:434 ./include/net/gro.h:429 net/core/dev.c:6067)
> [108431.765308] ixgbe_poll (drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:3191)
> [108431.769093] __napi_poll (net/core/dev.c:6498)
> [108431.772779] net_rx_action (net/core/dev.c:6567 net/core/dev.c:6698)
> [108431.776723] __do_softirq (./arch/x86/include/asm/jump_label.h:27
> ./include/linux/jump_label.h:207 ./include/trace/events/irq.h:142
> kernel/softirq.c:572)
> [108431.780501] irq_exit_rcu (kernel/softirq.c:445
> kernel/softirq.c:650 kernel/softirq.c:662)
> [108431.784194] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> [108431.788232]  </IRQ>
> [108431.790518]  <TASK>
> [108431.792808] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:636)
> [108431.797194] RIP: 0010:cpuidle_enter_state (drivers/cpuidle/cpuidle.c:291)
> [108431.802358] Code: 00 e8 52 14 fd fe e8 7d fa ff ff 8b 53 04 49 89
> c5 0f 1f 44 00 00 31 ff e8 cb 83 fc fe 45 84 ff 0f 85 60 02 00 00 fb
> 45 85 f6 <0f> 88 8e 01 00 00 49 63 ce 4c 8b 14 24 48 8d 04 49 48 8d 14
> 81 48
> All code
> ========
>    0: 00 e8                add    %ch,%al
>    2: 52                    push   %rdx
>    3: 14 fd                adc    $0xfd,%al
>    5: fe                    (bad)
>    6: e8 7d fa ff ff        call   0xfffffffffffffa88
>    b: 8b 53 04              mov    0x4(%rbx),%edx
>    e: 49 89 c5              mov    %rax,%r13
>   11: 0f 1f 44 00 00        nopl   0x0(%rax,%rax,1)
>   16: 31 ff                xor    %edi,%edi
>   18: e8 cb 83 fc fe        call   0xfffffffffefc83e8
>   1d: 45 84 ff              test   %r15b,%r15b
>   20: 0f 85 60 02 00 00    jne    0x286
>   26: fb                    sti
>   27: 45 85 f6              test   %r14d,%r14d
>   2a:* 0f 88 8e 01 00 00    js     0x1be <-- trapping instruction
>   30: 49 63 ce              movslq %r14d,%rcx
>   33: 4c 8b 14 24          mov    (%rsp),%r10
>   37: 48 8d 04 49          lea    (%rcx,%rcx,2),%rax
>   3b: 48 8d 14 81          lea    (%rcx,%rax,4),%rdx
>   3f: 48                    rex.W
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 0f 88 8e 01 00 00    js     0x194
>    6: 49 63 ce              movslq %r14d,%rcx
>    9: 4c 8b 14 24          mov    (%rsp),%r10
>    d: 48 8d 04 49          lea    (%rcx,%rcx,2),%rax
>   11: 48 8d 14 81          lea    (%rcx,%rax,4),%rdx
>   15: 48                    rex.W
> [108431.821362] RSP: 0018:ffffac25000c7e98 EFLAGS: 00000202
> [108431.826787] RAX: ffff9ebfafbabb80 RBX: ffff9ebfafbb6600 RCX:
> 0000000000000000
> [108431.834135] RDX: 0000000000000006 RSI: fffffff19cf255d6 RDI:
> 0000000000000000
> [108431.841486] RBP: 0000000000000002 R08: 0000000000000000 R09:
> 0000000040000000
> [108431.848833] R10: 0000000000000018 R11: 00000000000000d4 R12:
> ffffffff8c015480
> [108431.856185] R13: 0000629e2a6170d9 R14: 0000000000000002 R15:
> 0000000000000000
> [108431.863539] ? cpuidle_enter_state (drivers/cpuidle/cpuidle.c:285)
> [108431.868104] cpuidle_enter (drivers/cpuidle/cpuidle.c:390)
> [108431.871879] do_idle (kernel/sched/idle.c:219 kernel/sched/idle.c:282)
> [108431.875305] cpu_startup_entry (kernel/sched/idle.c:378 (discriminator 1))
> [108431.879429] start_secondary (arch/x86/kernel/smpboot.c:288)
> [108431.883459] secondary_startup_64_no_verify (arch/x86/kernel/head_64.S:370)
> [108431.888714]  </TASK>
> [108431.891094] Modules linked in: chaoskey
> [108431.895132] CR2: 0000000000000008
> [108431.898647] ---[ end trace 0000000000000000 ]---
> [108431.898648] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [108431.910630] #PF: supervisor read access in kernel mode
> [108431.915969] #PF: error_code(0x0000) - not-present page
> [108431.916671] RIP: 0010:flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.921305] PGD 0
> [108431.921416] Code: 00 00 e9 96 fd ff ff 66 0f 1f 44 00 00 48 83 c7
> 08 be 32 00 00 00 e9 82 fd ff ff 66 90 48 8b 87 b0 00 00 00 48 05 81
> 00 00 00 <f0> 80 20 bf f0 80 8f b8 00 00 00 04 48 8b 97 b0 00 00 00 0f
> b6 42
> All code
> ========
>    0: 00 00                add    %al,(%rax)
>    2: e9 96 fd ff ff        jmp    0xfffffffffffffd9d
>    7: 66 0f 1f 44 00 00    nopw   0x0(%rax,%rax,1)
>    d: 48 83 c7 08          add    $0x8,%rdi
>   11: be 32 00 00 00        mov    $0x32,%esi
>   16: e9 82 fd ff ff        jmp    0xfffffffffffffd9d
>   1b: 66 90                xchg   %ax,%ax
>   1d: 48 8b 87 b0 00 00 00 mov    0xb0(%rdi),%rax
>   24: 48 05 81 00 00 00    add    $0x81,%rax
>   2a:* f0 80 20 bf          lock andb $0xbf,(%rax) <-- trapping instruction
>   2e: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>   35: 04
>   36: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   3d: 0f                    .byte 0xf
>   3e: b6 42                mov    $0x42,%dh
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f0 80 20 bf          lock andb $0xbf,(%rax)
>    4: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>    b: 04
>    c: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   13: 0f                    .byte 0xf
>   14: b6 42                mov    $0x42,%dh
> [108431.926468] P4D 0
> [108431.926568] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> [108431.926738]
> [108431.926839]
> [108431.926946] Oops: 0000 [#3] PREEMPT SMP NOPTI
> [108431.927044] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> 0000000000000001
> [108431.927145] CPU: 10 PID: 986 Comm: CPU 1/KVM Tainted: G      D
>        6.4.4-dirty #381
> [108431.927249] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> ffff9ebeda71ce58
> [108431.927377] Hardware name: Supermicro Super
> Server/A2SDi-12C-HLN4F, BIOS 1.7a 10/13/2022
> [108431.927508] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> ffff9ebe3d7fad58
> [108431.927635] RIP: 0010:memcmp (lib/string.c:681)
> [108431.927765] R10: 0000000000000000 R11: 0000000000000003 R12:
> ffff9ebfafab0000
> [108431.927893] Code: cc cc cc 48 85 c0 75 f3 0f b6 4f 01 48 83 c7 01
> 84 c9 75 bc eb e3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 eb 14
> 48 8b 06 <48> 39 07 75 17 48 83 c7 08 48 83 c6 08 48 83 ea 08 48 83 fa
> 07 77
> All code
> ========
>    0: cc                    int3
>    1: cc                    int3
>    2: cc                    int3
>    3: 48 85 c0              test   %rax,%rax
>    6: 75 f3                jne    0xfffffffffffffffb
>    8: 0f b6 4f 01          movzbl 0x1(%rdi),%ecx
>    c: 48 83 c7 01          add    $0x1,%rdi
>   10: 84 c9                test   %cl,%cl
>   12: 75 bc                jne    0xffffffffffffffd0
>   14: eb e3                jmp    0xfffffffffffffff9
>   16: 66 66 2e 0f 1f 84 00 data16 cs nopw 0x0(%rax,%rax,1)
>   1d: 00 00 00 00
>   21: 0f 1f 40 00          nopl   0x0(%rax)
>   25: eb 14                jmp    0x3b
>   27: 48 8b 06              mov    (%rsi),%rax
>   2a:* 48 39 07              cmp    %rax,(%rdi) <-- trapping instruction
>   2d: 75 17                jne    0x46
>   2f: 48 83 c7 08          add    $0x8,%rdi
>   33: 48 83 c6 08          add    $0x8,%rsi
>   37: 48 83 ea 08          sub    $0x8,%rdx
>   3b: 48 83 fa 07          cmp    $0x7,%rdx
>   3f: 77                    .byte 0x77
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 48 39 07              cmp    %rax,(%rdi)
>    3: 75 17                jne    0x1c
>    5: 48 83 c7 08          add    $0x8,%rdi
>    9: 48 83 c6 08          add    $0x8,%rsi
>    d: 48 83 ea 08          sub    $0x8,%rdx
>   11: 48 83 fa 07          cmp    $0x7,%rdx
>   15: 77                    .byte 0x77
> [108431.927997] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> ffff9ebd79a0f780
> 
> [108431.928294] FS:  0000000000000000(0000) GS:ffff9ebfafb80000(0000)
> knlGS:0000000000000000
> [108431.928421]
> [108431.928529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.928658] RAX: 00000000af00000a RBX: ffff9ebc413b4250 RCX:
> 0000000000000000
> [108431.928758] CR2: 0000000000000008 CR3: 0000000109310000 CR4:
> 00000000003526e0
> [108431.928866] RDX: 0000000000000032 RSI: ffffac25002b0ba0 RDI:
> 0000000000000008
> [108431.928996] Kernel panic - not syncing: Fatal exception in interrupt
> [108431.929123] RBP: ffff9ebd42b18058 R08: 000000000000000a R09:
> 000000000000001c
> [108431.929254] R10: 000000000000006b R11: 000000000000006b R12:
> 0000000000000000
> [108431.930351] R13: ffff9ebc413b4260 R14: ffff9ebd42b18000 R15:
> 0000000000000000
> [108431.930482] FS:  00007f50a75fe6c0(0000) GS:ffff9ebfafc80000(0000)
> knlGS:0000000000000000
> [108431.930615] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.930746] CR2: 0000000000000008 CR3: 0000000109310000 CR4:
> 00000000003526e0
> [108431.930879] Call Trace:
> [108431.930992]  <IRQ>
> [108431.931124] ? __die (arch/x86/kernel/dumpstack.c:421
> arch/x86/kernel/dumpstack.c:434)
> [108431.931236] ? page_fault_oops (arch/x86/mm/fault.c:707)
> [108431.931347] ? vhost_poll_wakeup (drivers/vhost/vhost.c:179)
> [108431.931456] ? __wake_up_common (kernel/sched/wait.c:108)
> [108431.931572] ? exc_page_fault (arch/x86/mm/fault.c:1279
> arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> [108431.931685] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
> [108431.931801] ? memcmp (lib/string.c:681)
> [108431.931912] flow_offload_hash_cmp (net/netfilter/nf_flow_table_core.c:253)
> [108431.932023] flow_offload_lookup (./include/linux/rhashtable.h:608
> ./include/linux/rhashtable.h:646
> net/netfilter/nf_flow_table_core.c:376)
> [108431.932133] nf_flow_offload_ip_hook (net/netfilter/nf_flow_table_ip.c:363)
> [108431.932245] ? netif_receive_skb (net/core/dev.c:5695 net/core/dev.c:5752)
> [108431.932358] ? reuseport_select_sock (net/core/sock_reuseport.c:609)
> [108431.932476] nf_hook_slow (./include/linux/netfilter.h:143
> net/netfilter/core.c:626)
> [108431.932591] __netif_receive_skb_core.constprop.0
> (./include/linux/netfilter_netdev.h:34 net/core/dev.c:5274
> net/core/dev.c:5361)
> [108431.932709] __netif_receive_skb_list_core (net/core/dev.c:5570)
> [108431.932822] netif_receive_skb_list_internal (net/core/dev.c:5638
> net/core/dev.c:5727)
> [108431.932938] ? napi_gro_flush (net/core/gro.c:342 net/core/gro.c:361)
> [108431.933052] napi_complete_done (./include/linux/list.h:37
> ./include/net/gro.h:434 ./include/net/gro.h:429 net/core/dev.c:6067)
> [108431.933166] ixgbe_poll (drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:3191)
> [108431.933281] ? timekeeping_advance (kernel/time/timekeeping.c:2223
> (discriminator 5))
> [108431.933395] __napi_poll (net/core/dev.c:6498)
> [108431.933506] net_rx_action (net/core/dev.c:6567 net/core/dev.c:6698)
> [108431.933621] __do_softirq (./arch/x86/include/asm/jump_label.h:27
> ./include/linux/jump_label.h:207 ./include/trace/events/irq.h:142
> kernel/softirq.c:572)
> [108431.933734] irq_exit_rcu (kernel/softirq.c:445
> kernel/softirq.c:650 kernel/softirq.c:662)
> [108431.933847] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> [108431.933958]  </IRQ>
> [108431.934063]  <TASK>
> [108431.934168] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:636)
> [108431.934277] RIP: 0010:vmx_set_hv_timer (arch/x86/kvm/vmx/vmx.c:7947)
> [108431.934389] Code: 5b c3 cc cc cc cc 31 f6 48 89 df e8 7a dd 01 00
> 85 c0 75 ec c6 83 da 1f 00 00 01 31 c0 c6 83 e9 21 00 00 00 eb da 0f
> 1f 40 00 <41> 56 41 55 41 54 49 89 fc 55 48 89 d5 53 48 89 f3 4c 8b b7
> 08 02
> All code
> ========
>    0: 5b                    pop    %rbx
>    1: c3                    ret
>    2: cc                    int3
>    3: cc                    int3
>    4: cc                    int3
>    5: cc                    int3
>    6: 31 f6                xor    %esi,%esi
>    8: 48 89 df              mov    %rbx,%rdi
>    b: e8 7a dd 01 00        call   0x1dd8a
>   10: 85 c0                test   %eax,%eax
>   12: 75 ec                jne    0x0
>   14: c6 83 da 1f 00 00 01 movb   $0x1,0x1fda(%rbx)
>   1b: 31 c0                xor    %eax,%eax
>   1d: c6 83 e9 21 00 00 00 movb   $0x0,0x21e9(%rbx)
>   24: eb da                jmp    0x0
>   26: 0f 1f 40 00          nopl   0x0(%rax)
>   2a:* 41 56                push   %r14 <-- trapping instruction
>   2c: 41 55                push   %r13
>   2e: 41 54                push   %r12
>   30: 49 89 fc              mov    %rdi,%r12
>   33: 55                    push   %rbp
>   34: 48 89 d5              mov    %rdx,%rbp
>   37: 53                    push   %rbx
>   38: 48 89 f3              mov    %rsi,%rbx
>   3b: 4c                    rex.WR
>   3c: 8b                    .byte 0x8b
>   3d: b7 08                mov    $0x8,%bh
>   3f: 02                    .byte 0x2
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 41 56                push   %r14
>    2: 41 55                push   %r13
>    4: 41 54                push   %r12
>    6: 49 89 fc              mov    %rdi,%r12
>    9: 55                    push   %rbp
>    a: 48 89 d5              mov    %rdx,%rbp
>    d: 53                    push   %rbx
>    e: 48 89 f3              mov    %rsi,%rbx
>   11: 4c                    rex.WR
>   12: 8b                    .byte 0x8b
>   13: b7 08                mov    $0x8,%bh
>   15: 02                    .byte 0x2
> [108431.934498] RSP: 0018:ffffac2503c7fdb0 EFLAGS: 00000206
> [108431.934776] RAX: 0000000000000000 RBX: ffff9ebc49303200 RCX:
> 0000000000000000
> [108431.934886] RDX: ffffac2503c7fdbf RSI: 0000c534e9ede5fa RDI:
> ffff9ebcf5bb23c0
> [108431.935017] RBP: ffff9ebcf5bb23c0 R08: 0000000000000000 R09:
> ffffac2503c7fd0c
> [108431.935148] R10: 0000000000000000 R11: 0000000000000022 R12:
> ffff9ebc4ca4d000
> [108431.935278] R13: ffff9ebcfaea5d00 R14: 0000000000000003 R15:
> ffff9ebcf5bb23c0
> [108431.935413] restart_apic_timer (arch/x86/kvm/lapic.c:2085
> arch/x86/kvm/lapic.c:2138)
> [108431.935552] kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:10887
> arch/x86/kvm/x86.c:10954 arch/x86/kvm/x86.c:11173)
> [108431.935666] ? kvm_vm_ioctl_irq_line (arch/x86/kvm/x86.c:6241)
> [108431.935778] kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4124)
> [108431.935891] ? net_rx_action (net/core/dev.c:6567 net/core/dev.c:6698)
> [108431.936003] ? __seccomp_filter (kernel/seccomp.c:1207)
> [108431.936120] __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:870
> fs/ioctl.c:856 fs/ioctl.c:856)
> [108431.936235] do_syscall_64 (arch/x86/entry/common.c:50
> arch/x86/entry/common.c:80)
> [108431.936346] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> [108431.936457] RIP: 0033:0x7f512ebfda3c
> [108431.936570] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 48 89 44
> 24 08 48 8d 44 24 20 48 89 44 24 10 c7 04 24 10 00 00 00 b8 10 00 00
> 00 0f 05 <3d> 00 f0 ff ff 89 c2 77 1b 48 8b 44 24 18 64 48 2b 04 25 28
> 00 00
> All code
> ========
>    0: 00 48 89              add    %cl,-0x77(%rax)
>    3: 44 24 18              rex.R and $0x18,%al
>    6: 31 c0                xor    %eax,%eax
>    8: 48 8d 44 24 60        lea    0x60(%rsp),%rax
>    d: 48 89 44 24 08        mov    %rax,0x8(%rsp)
>   12: 48 8d 44 24 20        lea    0x20(%rsp),%rax
>   17: 48 89 44 24 10        mov    %rax,0x10(%rsp)
>   1c: c7 04 24 10 00 00 00 movl   $0x10,(%rsp)
>   23: b8 10 00 00 00        mov    $0x10,%eax
>   28: 0f 05                syscall
>   2a:* 3d 00 f0 ff ff        cmp    $0xfffff000,%eax <-- trapping instruction
>   2f: 89 c2                mov    %eax,%edx
>   31: 77 1b                ja     0x4e
>   33: 48 8b 44 24 18        mov    0x18(%rsp),%rax
>   38: 64                    fs
>   39: 48                    rex.W
>   3a: 2b                    .byte 0x2b
>   3b: 04 25                add    $0x25,%al
>   3d: 28 00                sub    %al,(%rax)
> ...
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 3d 00 f0 ff ff        cmp    $0xfffff000,%eax
>    5: 89 c2                mov    %eax,%edx
>    7: 77 1b                ja     0x24
>    9: 48 8b 44 24 18        mov    0x18(%rsp),%rax
>    e: 64                    fs
>    f: 48                    rex.W
>   10: 2b                    .byte 0x2b
>   11: 04 25                add    $0x25,%al
>   13: 28 00                sub    %al,(%rax)
> ...
> [108431.936678] RSP: 002b:00007f50a75fd5a0 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [108431.936979] RAX: ffffffffffffffda RBX: 0000556810191420 RCX:
> 00007f512ebfda3c
> [108431.937110] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
> 000000000000001c
> [108431.937240] RBP: 000000000000ae80 R08: 000055680eb3bdf0 R09:
> 00000000000000ff
> [108431.937371] R10: 0000000000000002 R11: 0000000000000246 R12:
> 0000000000000000
> [108431.937501] R13: 0000000000000001 R14: 0000000000000001 R15:
> 0000000000000000
> [108431.937634]  </TASK>
> [108431.937736] Modules linked in: chaoskey
> [108431.937851] CR2: 0000000000000008
> [108431.937959] ---[ end trace 0000000000000000 ]---
> [108431.937962] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [108431.937972] #PF: supervisor read access in kernel mode
> [108431.937977] #PF: error_code(0x0000) - not-present page
> [108431.937982] PGD 0 P4D 0
> [108431.937989] Oops: 0000 [#4] PREEMPT SMP NOPTI
> [108431.937997] CPU: 3 PID: 74552 Comm: kworker/3:1 Tainted: G      D
>           6.4.4-dirty #381
> [108431.938006] Hardware name: Supermicro Super
> Server/A2SDi-12C-HLN4F, BIOS 1.7a 10/13/2022
> [108431.938009] Workqueue: events rht_deferred_worker
> [108431.938026] RIP: 0010:rht_deferred_worker (lib/rhashtable.c:244
> lib/rhashtable.c:288 lib/rhashtable.c:328 lib/rhashtable.c:432)
> [108431.938038] Code: 00 48 83 e2 fe 48 0f 44 14 24 48 89 d0 f6 c2 01
> 0f 85 af 01 00 00 48 8b 2a 40 f6 c5 01 74 0b e9 87 02 00 00 48 89 e8
> 4c 89 e5 <4c> 8b 65 00 41 f6 c4 01 74 f0 48 89 c3 41 0f b7 56 d6 49 8b
> 46 e8
> All code
> ========
>    0: 00 48 83              add    %cl,-0x7d(%rax)
>    3: e2 fe                loop   0x3
>    5: 48 0f 44 14 24        cmove  (%rsp),%rdx
>    a: 48 89 d0              mov    %rdx,%rax
>    d: f6 c2 01              test   $0x1,%dl
>   10: 0f 85 af 01 00 00    jne    0x1c5
>   16: 48 8b 2a              mov    (%rdx),%rbp
>   19: 40 f6 c5 01          test   $0x1,%bpl
>   1d: 74 0b                je     0x2a
>   1f: e9 87 02 00 00        jmp    0x2ab
>   24: 48 89 e8              mov    %rbp,%rax
>   27: 4c 89 e5              mov    %r12,%rbp
>   2a:* 4c 8b 65 00          mov    0x0(%rbp),%r12 <-- trapping instruction
>   2e: 41 f6 c4 01          test   $0x1,%r12b
>   32: 74 f0                je     0x24
>   34: 48 89 c3              mov    %rax,%rbx
>   37: 41 0f b7 56 d6        movzwl -0x2a(%r14),%edx
>   3c: 49 8b 46 e8          mov    -0x18(%r14),%rax
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 4c 8b 65 00          mov    0x0(%rbp),%r12
>    4: 41 f6 c4 01          test   $0x1,%r12b
>    8: 74 f0                je     0xfffffffffffffffa
>    a: 48 89 c3              mov    %rax,%rbx
>    d: 41 0f b7 56 d6        movzwl -0x2a(%r14),%edx
>   12: 49 8b 46 e8          mov    -0x18(%r14),%rax
> [108431.938044] RSP: 0018:ffffac2509a83e30 EFLAGS: 00010046
> [108431.938050] RAX: ffff9ebeda71ce58 RBX: 0000000000000000 RCX:
> ffff9ebd42b18000
> [108431.938055] RDX: ffff9ebeda71ce58 RSI: 0000000000000006 RDI:
> ffff9ebd42b18000
> [108431.938059] RBP: 0000000000000000 R08: 00000000de58e2a2 R09:
> 0000000000000000
> [108431.938063] R10: ffffffff8b1dd610 R11: 0000000000000000 R12:
> ffff9ebd42b18049
> [108431.938066] R13: ffff9ebd42b18058 R14: ffff9ebc413b42a0 R15:
> ffff9ebc985cc800
> [108431.938191] FS:  0000000000000000(0000) GS:ffff9ebfafac0000(0000)
> knlGS:0000000000000000
> [108431.938304] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.938415] CR2: 0000000000000000 CR3: 000000044b69a000 CR4:
> 00000000003526e0
> [108431.938520] Call Trace:
> [108431.938630]  <TASK>
> [108431.938766] ? __die (arch/x86/kernel/dumpstack.c:421
> arch/x86/kernel/dumpstack.c:434)
> [108431.938906] ? page_fault_oops (arch/x86/mm/fault.c:707)
> [108431.939025] ? exc_page_fault (arch/x86/mm/fault.c:1279
> arch/x86/mm/fault.c:1486 arch/x86/mm/fault.c:1542)
> [108431.939143] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:570)
> [108431.939320] ? flow_offload_fill_dir (net/netfilter/nf_flow_table_core.c:237)
> [108431.939440] ? rht_deferred_worker (lib/rhashtable.c:244
> lib/rhashtable.c:288 lib/rhashtable.c:328 lib/rhashtable.c:432)
> [108431.939580] process_one_work (kernel/workqueue.c:2413)
> [108431.939720] worker_thread (./include/linux/list.h:292
> kernel/workqueue.c:2556)
> [108431.939857] ? rescuer_thread (kernel/workqueue.c:2498)
> [108431.939993] kthread (kernel/kthread.c:379)
> [108431.940128] ? kthread_complete_and_exit (kernel/kthread.c:332)
> [108431.940267] ret_from_fork (arch/x86/entry/entry_64.S:314)
> [108431.940385]  </TASK>
> [108431.940514] Modules linked in: chaoskey
> [108431.940823] CR2: 0000000000000000
> [108431.941035] ---[ end trace 0000000000000000 ]---
> [108431.957494] RIP: 0010:flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.957615] Code: 00 00 e9 96 fd ff ff 66 0f 1f 44 00 00 48 83 c7
> 08 be 32 00 00 00 e9 82 fd ff ff 66 90 48 8b 87 b0 00 00 00 48 05 81
> 00 00 00 <f0> 80 20 bf f0 80 8f b8 00 00 00 04 48 8b 97 b0 00 00 00 0f
> b6 42
> All code
> ========
>    0: 00 00                add    %al,(%rax)
>    2: e9 96 fd ff ff        jmp    0xfffffffffffffd9d
>    7: 66 0f 1f 44 00 00    nopw   0x0(%rax,%rax,1)
>    d: 48 83 c7 08          add    $0x8,%rdi
>   11: be 32 00 00 00        mov    $0x32,%esi
>   16: e9 82 fd ff ff        jmp    0xfffffffffffffd9d
>   1b: 66 90                xchg   %ax,%ax
>   1d: 48 8b 87 b0 00 00 00 mov    0xb0(%rdi),%rax
>   24: 48 05 81 00 00 00    add    $0x81,%rax
>   2a:* f0 80 20 bf          lock andb $0xbf,(%rax) <-- trapping instruction
>   2e: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>   35: 04
>   36: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   3d: 0f                    .byte 0xf
>   3e: b6 42                mov    $0x42,%dh
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f0 80 20 bf          lock andb $0xbf,(%rax)
>    4: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>    b: 04
>    c: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   13: 0f                    .byte 0xf
>   14: b6 42                mov    $0x42,%dh
> [108431.957727] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> [108431.957940] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> 0000000000000001
> [108431.958048] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> ffff9ebeda71ce58
> [108431.958155] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> ffff9ebe3d7fad58
> [108431.958265] R10: 0000000000000000 R11: 0000000000000003 R12:
> ffff9ebfafab0000
> [108431.958372] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> ffff9ebd79a0f780
> [108431.958477] FS:  00007f50a75fe6c0(0000) GS:ffff9ebfafc80000(0000)
> knlGS:0000000000000000
> [108431.958587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.958694] CR2: 0000000000000008 CR3: 0000000109310000 CR4:
> 00000000003526e0
> [108431.977125] RIP: 0010:flow_offload_teardown
> (./arch/x86/include/asm/bitops.h:75
> ./include/asm-generic/bitops/instrumented-atomic.h:42
> net/netfilter/nf_flow_table_core.c:362)
> [108431.977247] Code: 00 00 e9 96 fd ff ff 66 0f 1f 44 00 00 48 83 c7
> 08 be 32 00 00 00 e9 82 fd ff ff 66 90 48 8b 87 b0 00 00 00 48 05 81
> 00 00 00 <f0> 80 20 bf f0 80 8f b8 00 00 00 04 48 8b 97 b0 00 00 00 0f
> b6 42
> All code
> ========
>    0: 00 00                add    %al,(%rax)
>    2: e9 96 fd ff ff        jmp    0xfffffffffffffd9d
>    7: 66 0f 1f 44 00 00    nopw   0x0(%rax,%rax,1)
>    d: 48 83 c7 08          add    $0x8,%rdi
>   11: be 32 00 00 00        mov    $0x32,%esi
>   16: e9 82 fd ff ff        jmp    0xfffffffffffffd9d
>   1b: 66 90                xchg   %ax,%ax
>   1d: 48 8b 87 b0 00 00 00 mov    0xb0(%rdi),%rax
>   24: 48 05 81 00 00 00    add    $0x81,%rax
>   2a:* f0 80 20 bf          lock andb $0xbf,(%rax) <-- trapping instruction
>   2e: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>   35: 04
>   36: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   3d: 0f                    .byte 0xf
>   3e: b6 42                mov    $0x42,%dh
> 
> Code starting with the faulting instruction
> ===========================================
>    0: f0 80 20 bf          lock andb $0xbf,(%rax)
>    4: f0 80 8f b8 00 00 00 lock orb $0x4,0xb8(%rdi)
>    b: 04
>    c: 48 8b 97 b0 00 00 00 mov    0xb0(%rdi),%rdx
>   13: 0f                    .byte 0xf
>   14: b6 42                mov    $0x42,%dh
> [108431.977421] RSP: 0018:ffffac250ade7e28 EFLAGS: 00010206
> [108431.977661] RAX: 0000000000000081 RBX: ffff9ebc413b42f8 RCX:
> 0000000000000001
> [108431.977792] RDX: 00000001067200c0 RSI: ffff9ebeda71ce58 RDI:
> ffff9ebeda71ce58
> [108431.977923] RBP: ffff9ebc413b4250 R08: ffff9ebc413b4250 R09:
> ffff9ebe3d7fad58
> [108431.978054] R10: 0000000000000000 R11: 0000000000000003 R12:
> ffff9ebfafab0000
> [108431.978184] R13: 0000000000000000 R14: ffff9ebfafab0005 R15:
> ffff9ebd79a0f780
> [108431.978317] FS:  0000000000000000(0000) GS:ffff9ebfafac0000(0000)
> knlGS:0000000000000000
> [108431.978430] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [108431.978561] CR2: 0000000000000000 CR3: 000000044b69a000 CR4:
> 00000000003526e0
> [108431.978671] note: kworker/3:1[74552] exited with irqs disabled
> [108433.230657] Shutting down cpus with NMI
> [108434.330988] Kernel Offset: 0x9200000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [108434.361885] ---[ end Kernel panic - not syncing: Fatal exception
> in interrupt ]---
> 

