From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: crash on >= 4.9.0 kernel seems nf related
Date: Wed, 3 May 2017 13:31:35 +0200
Message-ID: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:36016 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdECLbg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2017 07:31:36 -0400
Received: by mail-yb0-f178.google.com with SMTP id s22so41838526ybe.3
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2017 04:31:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After running on kernel 4.9 for quite some time, we suddenly experienced
hangs. Tried compiling 4.11.0, but the problem remains. The only think
that changed was a couple
more rules in nft, traffic is the same.

4.8.6 kernel works fine (but has other problems). Attached is the
debugging output, hope it can
help you track down the issue:

May  3 12:46:59 fw01 kernel: [  271.875363] ------------[ cut here ]------------
May  3 12:46:59 fw01 kernel: [  271.875369] WARNING: CPU: 0 PID: 3 at
net/sched/sch_generic.c:316 dev_watchdog+0x212/0x220
May  3 12:46:59 fw01 kernel: [  271.875370] NETDEV WATCHDOG: eth1
(igb): transmit queue 1 timed out
May  3 12:46:59 fw01 kernel: [  271.875370] Modules linked in:
May  3 12:46:59 fw01 kernel: [  271.875373] CPU: 0 PID: 3 Comm:
kworker/0:0 Not tainted 4.11.0 #1
May  3 12:46:59 fw01 kernel: [  271.875374] Hardware name: Dell Inc.
PowerEdge R210/05KX61, BIOS 1.3.4 05/24/2010
May  3 12:46:59 fw01 kernel: [  271.875377] Workqueue: events_long gc_worker
May  3 12:46:59 fw01 kernel: [  271.875378] Call Trace:
May  3 12:46:59 fw01 kernel: [  271.875380]  <IRQ>
May  3 12:46:59 fw01 kernel: [  271.875383]  dump_stack+0x4d/0x6e
May  3 12:46:59 fw01 kernel: [  271.875386]  __warn+0xcc/0xf0
May  3 12:46:59 fw01 kernel: [  271.875387]  warn_slowpath_fmt+0x4a/0x50
May  3 12:46:59 fw01 kernel: [  271.875390]  ? tick_program_event+0x3f/0x70
May  3 12:46:59 fw01 kernel: [  271.875391]  dev_watchdog+0x212/0x220
May  3 12:46:59 fw01 kernel: [  271.875392]  ?
dev_deactivate_queue.constprop.31+0x60/0x60
May  3 12:46:59 fw01 kernel: [  271.875395]  call_timer_fn+0x30/0x140
May  3 12:46:59 fw01 kernel: [  271.875397]  run_timer_softirq+0x1be/0x3f0
May  3 12:46:59 fw01 kernel: [  271.875399]  ? handle_irq_event_percpu+0x40/0x50
May  3 12:46:59 fw01 kernel: [  271.875401]  __do_softirq+0xbe/0x280
May  3 12:46:59 fw01 kernel: [  271.875404]  do_softirq_own_stack+0x1c/0x30
May  3 12:46:59 fw01 kernel: [  271.875404]  </IRQ>
May  3 12:46:59 fw01 kernel: [  271.875406]  do_softirq+0x42/0x50
May  3 12:46:59 fw01 kernel: [  271.875407]  __local_bh_enable_ip+0x75/0x80
May  3 12:46:59 fw01 kernel: [  271.875410]  _raw_spin_unlock_bh+0x15/0x20
May  3 12:46:59 fw01 kernel: [  271.875412]
nf_nat_cleanup_conntrack+0x1bd/0x230
May  3 12:46:59 fw01 kernel: [  271.875413]  ? nf_nat_l3proto_register+0x70/0x70
May  3 12:46:59 fw01 kernel: [  271.875415]  __nf_ct_ext_destroy+0x38/0x50
May  3 12:46:59 fw01 kernel: [  271.875417]  nf_conntrack_free+0x17/0x50
May  3 12:46:59 fw01 kernel: [  271.875418]  destroy_conntrack+0x74/0x90
May  3 12:46:59 fw01 kernel: [  271.875421]  nf_conntrack_destroy+0x12/0x20
May  3 12:46:59 fw01 kernel: [  271.875422]  nf_ct_gc_expired+0x45/0x90
May  3 12:46:59 fw01 kernel: [  271.875423]  gc_worker+0xb3/0x180
May  3 12:46:59 fw01 kernel: [  271.875425]  process_one_work+0x143/0x3e0
May  3 12:46:59 fw01 kernel: [  271.875426]  worker_thread+0x126/0x480
May  3 12:46:59 fw01 kernel: [  271.875429]  kthread+0x104/0x140
May  3 12:46:59 fw01 kernel: [  271.875430]  ? process_one_work+0x3e0/0x3e0
May  3 12:46:59 fw01 kernel: [  271.875431]  ? kthread_park+0x90/0x90
May  3 12:46:59 fw01 kernel: [  271.875432]  ret_from_fork+0x29/0x40
May  3 12:46:59 fw01 kernel: [  271.875434] ---[ end trace 3da51f3ef83370a7 ]---
May  3 12:47:03 fw01 kernel: [  275.629072] igb 0000:01:00.0 eth0:
igb: eth0 NIC Link is Down
May  3 12:47:03 fw01 kernel: [  275.629135] igb 0000:01:00.1 eth1: Reset adapter
May  3 12:47:03 fw01 kernel: [  275.629316] igb 0000:01:00.0 eth0: Reset adapter
May  3 12:47:12 fw01 kernel: [  285.159798] igb 0000:01:00.1 eth1:
igb: eth1 NIC Link is Up 1000 Mbps Half Duplex, Flow Control: RX/TX
May  3 12:47:12 fw01 kernel: [  285.159801] igb 0000:01:00.1: EEE
Disabled: unsupported at half duplex. Re-enable using ethtool when at
full duplex.
May  3 12:47:15 fw01 kernel: [  287.842412] igb 0000:01:00.1: exceed
max 2 second
May  3 12:48:21 fw01 kernel: [  353.875946] igb 0000:01:00.0 eth0: Reset adapter

-- 
Bj(/)rnar
