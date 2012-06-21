From: Sasikanth babu <sasikanth.v19@gmail.com>
Subject: 2.6.39.4: nf_ct_delete_from_lists & death_by_timeout kernel panic
Date: Thu, 21 Jun 2012 16:30:12 +0530
Message-ID: <CAOJFanXBB_sYuoJ5Nb=aztKNwaqmWQf=J4h1+2+gctuUWOBQhA@mail.gmail.com>
References: <CAOJFanVxBU5uxn2sFCdgZEJptf=nsSXtQV_n9uOLOT3mTi1CVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62018 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab2FULAN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:00:13 -0400
In-Reply-To: <CAOJFanVxBU5uxn2sFCdgZEJptf=nsSXtQV_n9uOLOT3mTi1CVg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

  I have been experiencing kernel panic in netfilters when sends
traffic to it . I had enabled RPS, RFS and XPS too and box has 24
core.

[11583.703375] general protection fault: 0000 [#1] SMP
[11583.708347] last sysfs file: /sys/devices/virtual/net/tunl0/uevent
[11583.714509] CPU 0
[11583.716338] Modules linked in: xt_u32 xt_NFQUEUE nfnetlink_queue
nfnetlink ipip tunnel4 boardctrl ipv6 iTCO_wdt ixgbe igb
iTCO_vendor_support pcspkr [last unloaded: scsi_wait_scan]
[11583.732708]
[11583.734193] Pid: 0, comm: swapper Tainted: G        W   2.6.39.4
[11583.749480] RIP: 0010:[<ffffffff814ba52e>]  [<ffffffff814ba52e>]
nf_ct_helper_destroy+0x3e/0x42
[11583.758168] RSP: 0018:ffff88063fc03df0  EFLAGS: 00010206
[11583.763463] RAX: 000179840fc084c0 RBX: ffff880617c229e8 RCX: 0000000000002b80
[11583.770579] RDX: 00000000000000c8 RSI: 0000000000000001 RDI: ffff880617c229e8
[11583.777695] RBP: ffff88063fc03df0 R08: ffffffff81ced010 R09: ffff88063fc03e08
[11583.784810] R10: 0000000000000000 R11: ffffffff81604ca5 R12: ffffffff81dffc00
[11583.791925] R13: 0000000000000100 R14: ffff88063fc03e90 R15: ffffffff81a01fd8
[11583.799040] FS:  0000000000000000(0000) GS:ffff88063fc00000(0000)
knlGS:0000000000000000
[11583.807108] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[11583.812836] CR2: 00007f95b195b000 CR3: 0000000001a03000 CR4: 00000000000006f0
[11583.819950] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[11583.827065] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[11583.834181] Process swapper (pid: 0, threadinfo ffffffff81a00000,
task ffffffff81a0b020)
[11583.842247] Stack:
[11583.844250]  ffff88063fc03e10 ffffffff814b7d0b ffff880617c229e8
ffff880617c22a60
[11583.851662]  ffff88063fc03e30 ffffffff814b7ef8 ffff880617c22a70
ffffffff81cebd40
[11583.859076]  ffff88063fc03ed0 ffffffff81057d94 ffff88063fc0fff0
ffffffff81cc8a08
[11583.866490] Call Trace:
[11583.868925]  <IRQ>
[11583.871026]  [<ffffffff814b7d0b>] nf_ct_delete_from_lists+0x1b/0xaf
[11583.877277]  [<ffffffff814b7ef8>] death_by_timeout+0x4a/0x57
[11583.882922]  [<ffffffff81057d94>] run_timer_softirq+0x1cb/0x29a
[11583.888827]  [<ffffffff814b7eae>] ? T.925+0x10f/0x10f
[11583.893866]  [<ffffffff81051710>] __do_softirq+0xda/0x1ad
[11583.899252]  [<ffffffff81073268>] ? tick_program_event+0x1f/0x21
[11583.905242]  [<ffffffff8156181c>] call_softirq+0x1c/0x30
[11583.910540]  [<ffffffff8100bbca>] do_softirq+0x46/0x83
[11583.915665]  [<ffffffff810514c6>] irq_exit+0x52/0x9b
[11583.920616]  [<ffffffff81562149>] smp_apic_timer_interrupt+0x85/0x93
[11583.926955]  [<ffffffff81560fd3>] apic_timer_interrupt+0x13/0x20
[11583.932944]  <EOI>
[11583.935046]  [<ffffffff812c84ae>] ? intel_idle+0xce/0xfa
[11583.940343]  [<ffffffff812c8491>] ? intel_idle+0xb1/0xfa
[11583.945642]  [<ffffffff8145fa8d>] cpuidle_idle_call+0xf4/0x173
[11583.951462]  [<ffffffff81009e18>] cpu_idle+0xb2/0xe8
[11583.956413]  [<ffffffff8153997e>] rest_init+0x72/0x74
[11583.961452]  [<ffffffff81b66cb2>] start_kernel+0x3e9/0x3f4
[11583.966922]  [<ffffffff81b662cd>] x86_64_start_reservations+0xb8/0xbc
[11583.973347]  [<ffffffff81b663d2>] x86_64_start_kernel+0x101/0x110
[11583.979421] Code: 85 c0 74 09 31 d2 80 78 10 00 0f 95 c2 85 d2 74
1c 0f b6 50 10 48 01 d0 74 13 48 8b 00 48 85 c0 74 0b 48 8b 40 58 48
85 c0 74 02 <ff> d0 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 c7 c7 d0 d4 b4
81 e8
[11583.998840] RIP  [<ffffffff814ba52e>] nf_ct_helper_destroy+0x3e/0x42
[11584.005185]  RSP <ffff88063fc03df0>
[11584.008681] ---[ end trace 12d25ef5ad62c0bb ]---
[11584.013289] Kernel panic - not syncing: Fatal exception in interrupt
[11584.019629] Pid: 0, comm: swapper Tainted: G      D W   2.6.39.4
[11584.027094] Call Trace:
[11584.029534]  <IRQ>  [<ffffffff8155794b>] panic+0x91/0x1a4
[11584.034941]  [<ffffffff8155ad70>] oops_end+0xb7/0xc7
[11584.039896]  [<ffffffff8100cc91>] die+0x5a/0x63
[11584.044418]  [<ffffffff8155a9b6>] do_general_protection+0x135/0x13d
[11584.050672]  [<ffffffff8155a1a5>] general_protection+0x25/0x30
[11584.056494]  [<ffffffff814ba52e>] ? nf_ct_helper_destroy+0x3e/0x42
[11584.062663]  [<ffffffff814b7d0b>] nf_ct_delete_from_lists+0x1b/0xaf
[11584.068917]  [<ffffffff814b7ef8>] death_by_timeout+0x4a/0x57
[11584.074565]  [<ffffffff81057d94>] run_timer_softirq+0x1cb/0x29a
[11584.080473]  [<ffffffff814b7eae>] ? T.925+0x10f/0x10f
[11584.085516]  [<ffffffff81051710>] __do_softirq+0xda/0x1ad
[11584.090904]  [<ffffffff81073268>] ? tick_program_event+0x1f/0x21
[11584.096900]  [<ffffffff8156181c>] call_softirq+0x1c/0x30
[11584.102200]  [<ffffffff8100bbca>] do_softirq+0x46/0x83
[11584.107329]  [<ffffffff810514c6>] irq_exit+0x52/0x9b
[11584.112284]  [<ffffffff81562149>] smp_apic_timer_interrupt+0x85/0x93
[11584.118624]  [<ffffffff81560fd3>] apic_timer_interrupt+0x13/0x20
[11584.124617]  <EOI>  [<ffffffff812c84ae>] ? intel_idle+0xce/0xfa
[11584.130545]  [<ffffffff812c8491>] ? intel_idle+0xb1/0xfa
[11584.135847]  [<ffffffff8145fa8d>] cpuidle_idle_call+0xf4/0x173
[11584.141669]  [<ffffffff81009e18>] cpu_idle+0xb2/0xe8
[11584.146624]  [<ffffffff8153997e>] rest_init+0x72/0x74
[11584.151666]  [<ffffffff81b66cb2>] start_kernel+0x3e9/0x3f4
[11584.157141]  [<ffffffff81b662cd>] x86_64_start_reservations+0xb8/0xbc
[11584.163567]  [<ffffffff81b663d2>] x86_64_start_kernel+0x101/0x110

thanks in advance
Sasi
