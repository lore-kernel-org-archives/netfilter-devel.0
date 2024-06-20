Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49C1B3740
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903609; cv=none; b=PqTVSRWcQG6u+qYAEvSJNfrsbv5SzuIazgfFHk76wAyn9nErg81Y1NErvhAAXjtgdFYeqL2Z2Ye2PL5ohGYUipn87e2SLIHreAie5hDCWjN3EfN+BXjidOw2Tz8xV8hHNaYGxKDjpufAE8i+hCPpLiF1+oLnZFTLvnCRAgWh3qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903609; c=relaxed/simple;
	bh=scgHkruoEAkle9q6sx/K7pawaw3JGtStnANhAJE+Mrs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cXtYhFjfc14w2mQ3+8AjC1dcViBWc+ppa0PHtVn/Rwlwl9I1hRwpfUQcZP8yL028zgot7WWfcNI0ysHSlRARsL52RnEpVVZpF8kTyLrjxqbVj2FX47e4Y5Oj8Tykifs1ixgdmLCCm+67/14ItdmKJGbOEiIpRk+19gY6XvtrkZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e8e2ea7b4bso148891439f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 10:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718903605; x=1719508405;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dloohfvNqwLpkgq3WIx9Wy5br5yUFL1AXkVltV350hg=;
        b=gcMRxiG2pvLkSxyfiR0Qw+pSnAoVs5LywZN1OZXbaERkbGG28qKa9De1nMytzK5lxq
         GJD5gZwcSMbKpAAqN/aNn88YojUq56gl79o+34vwkH3HoggnTMFjwdX0uwWqWv77fQZX
         bRHOXzmFKJimL90DfQodNFRafJd2Nshrog2yaOpOCCye4WpOmRlgcJV1OkM/Dt/fQwiY
         K6vLn8FzSqZQ2WEjuH7xPfcX06oG/yTiKnM+YV8kqFqCUZIgICJ3tDT2fM8jRB7R3pdb
         jwOzYZpPgB165zwjzOWXI/10O6UIdPzGrcvaLYoo3CB+MwCQT9HGD9MKtZfJDXvv89UY
         5fmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH/jQlS6ymB4F4gCO3bbrwAp1FbyIwcFXIqchjhUYRGI00fhSy3p5AqnzJOb0N6W3v7M7HtIMhlNOvWmq6j9w2O65egwilfqnvKHUUmoL1
X-Gm-Message-State: AOJu0Yz6QRAcORrjf96FIhVKWSOb4h35U37yRWbqyFSBok0aanMg/WwC
	DZt87GR6ceqtoK71nbApxTchRRGSPjbZNqLuU/UQCdWUSlhp1NDq0Y5YnIL25k6E7WqeXb93h6B
	mgLDap2GS2G4I7VV6f6wrm19ufaEECUVqHQJXzPe+T7TDt7BhVwdZgf4=
X-Google-Smtp-Source: AGHT+IFSG4BQt1tRkgp1nG4acJ9PEY8VfVecGiMDljTzb9OTfi5GQnQ0zB6p/EDX5Ag/rbZ75LTcQFwSL2Xcj6/ufpbRF9G6yVIB
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3492:b0:4b9:b122:d07d with SMTP id
 8926c6da1cb9f-4b9b122d669mr147548173.4.1718903604911; Thu, 20 Jun 2024
 10:13:24 -0700 (PDT)
Date: Thu, 20 Jun 2024 10:13:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c63a8e061b556ea6@google.com>
Subject: [syzbot] [netfilter?] [usb?] INFO: rcu detected stall in NF_HOOK
From: syzbot <syzbot+696cffe71c444e4a2dd8@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10341146980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0ce06dcc735711
dashboard link: https://syzkaller.appspot.com/bug?extid=696cffe71c444e4a2dd8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e8bfee980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d3d851980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/93525a95fe83/disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b9b895227ea2/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e825248a8e73/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+696cffe71c444e4a2dd8@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P45
 1-....
 } 2688 jiffies s: 1349 root: 0x2/T
rcu: blocking rcu_node structures (internal RCU debug):

Sending NMI from CPU 0 to CPUs 1:
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
NMI backtrace for cpu 1
CPU: 1 PID: 5155 Comm: kworker/1:4 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:__asan_memcpy+0x4e/0x70 mm/kasan/shadow.c:109
Code: e8 17 e5 ff ff 84 c0 74 2c 4c 89 ff 4c 89 e6 ba 01 00 00 00 48 89 d9 e8 00 e5 ff ff 84 c0 74 15 4c 89 ff 4c 89 f6 4c 89 e2 5b <41> 5c 41 5e 41 5f e9 87 cd 8a 09 31 c0 5b 41 5c 41 5e 41 5f c3 cc
RSP: 0018:ffffc90000a163a0 EFLAGS: 00000002
RAX: 0000000000010101 RBX: 0000000000000001 RCX: ffffffff8b7fc5b8
RDX: 0000000000000001 RSI: ffffffff8bcb80c0 RDI: ffffc90000a1670e
RBP: ffffc90000a164b0 R08: ffffc90000a1670e R09: 1ffff92000142ce1
R10: dffffc0000000000 R11: fffff52000142ce2 R12: 0000000000000001
R13: dffffc0000000000 R14: ffffffff8bcb80c0 R15: ffffc90000a1670e
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055558ba82ca8 CR3: 0000000024054000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 vsnprintf+0x948/0x1da0 lib/vsprintf.c:2786
 sprintf+0xda/0x120 lib/vsprintf.c:3028
 print_caller kernel/printk/printk.c:1338 [inline]
 info_print_prefix+0x204/0x310 kernel/printk/printk.c:1355
 record_print_text kernel/printk/printk.c:1402 [inline]
 printk_get_next_message+0x6da/0xbe0 kernel/printk/printk.c:2855
 console_emit_next_record kernel/printk/printk.c:2895 [inline]
 console_flush_all+0x410/0xfd0 kernel/printk/printk.c:2994
 console_unlock+0x13b/0x4d0 kernel/printk/printk.c:3063
 vprintk_emit+0x5a6/0x770 kernel/printk/printk.c:2345
 dev_vprintk_emit+0x2ae/0x330 drivers/base/core.c:4951
 dev_printk_emit+0xdd/0x120 drivers/base/core.c:4962
 _dev_err+0x122/0x170 drivers/base/core.c:5017
 wdm_int_callback+0x41f/0xac0 drivers/usb/class/cdc-wdm.c:269
 __usb_hcd_giveback_urb+0x373/0x530 drivers/usb/core/hcd.c:1648
 dummy_timer+0x830/0x45d0 drivers/usb/gadget/udc/dummy_hcd.c:1987
 __run_hrtimer kernel/time/hrtimer.c:1687 [inline]
 __hrtimer_run_queues+0x59b/0xd50 kernel/time/hrtimer.c:1751
 hrtimer_interrupt+0x396/0x990 kernel/time/hrtimer.c:1813
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1032 [inline]
 __sysvec_apic_timer_interrupt+0x110/0x3f0 arch/x86/kernel/apic/apic.c:1049
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
 sysvec_apic_timer_interrupt+0x52/0xc0 arch/x86/kernel/apic/apic.c:1043
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__orc_find arch/x86/kernel/unwind_orc.c:99 [inline]
RIP: 0010:orc_find arch/x86/kernel/unwind_orc.c:227 [inline]
RIP: 0010:unwind_next_frame+0x527/0x2a00 arch/x86/kernel/unwind_orc.c:494
Code: 75 34 48 63 2b 48 01 dd 48 89 ef 4c 89 f6 e8 60 34 55 00 48 8d 43 04 4c 39 f5 4c 0f 46 e8 48 8d 43 fc 4c 0f 47 e0 4c 0f 46 fb <4d> 39 e5 77 1d e8 df 31 55 00 eb 96 89 d9 80 e1 07 80 c1 03 38 c1
RSP: 0018:ffffc90000a17708 EFLAGS: 00000293
RAX: ffffffff90113598 RBX: ffffffff9011359c RCX: ffff888056a0bc00
RDX: ffff888056a0bc00 RSI: ffffffff895aff5e RDI: ffffffff895afe38
RBP: ffffffff895afe38 R08: ffffffff8140f500 R09: ffffc90000a178d0
R10: 0000000000000003 R11: ffffffff8181e050 R12: ffffffff9011359c
R13: ffffffff901135a0 R14: ffffffff895aff5e R15: ffffffff9011359c
 arch_stack_walk+0x151/0x1b0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2196 [inline]
 slab_free mm/slub.c:4437 [inline]
 kmem_cache_free+0x145/0x350 mm/slub.c:4512
 skb_release_all net/core/skbuff.c:1171 [inline]
 __kfree_skb net/core/skbuff.c:1187 [inline]
 kfree_skb_reason+0x16d/0x3b0 net/core/skbuff.c:1223
 kfree_skb include/linux/skbuff.h:1257 [inline]
 ip6_mc_input+0xa1b/0xc30 net/ipv6/ip6_input.c:589
 ip_sabotage_in+0x203/0x290 net/bridge/br_netfilter_hooks.c:996
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 NF_HOOK+0x29e/0x450 include/linux/netfilter.h:312
 __netif_receive_skb_one_core net/core/dev.c:5625 [inline]
 __netif_receive_skb+0x1ea/0x650 net/core/dev.c:5739
 netif_receive_skb_internal net/core/dev.c:5825 [inline]
 netif_receive_skb+0x1e8/0x890 net/core/dev.c:5885
 NF_HOOK+0x9e/0x400 include/linux/netfilter.h:314
 br_handle_frame_finish+0x18eb/0x1fe0
 br_nf_hook_thresh+0x472/0x590
 br_nf_pre_routing_finish_ipv6+0xa9e/0xdd0
 NF_HOOK include/linux/netfilter.h:314 [inline]
 br_nf_pre_routing_ipv6+0x370/0x760 net/bridge/br_netfilter_ipv6.c:184
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:277 [inline]
 br_handle_frame+0x9f3/0x1520 net/bridge/br_input.c:424
 __netif_receive_skb_core+0x13d3/0x4420 net/core/dev.c:5519
 __netif_receive_skb_one_core net/core/dev.c:5623 [inline]
 __netif_receive_skb+0x12f/0x650 net/core/dev.c:5739
 process_backlog+0x391/0x7d0 net/core/dev.c:6068
 __napi_poll+0xcb/0x490 net/core/dev.c:6722
 napi_poll net/core/dev.c:6791 [inline]
 net_rx_action+0x7bb/0x10a0 net/core/dev.c:6907
 handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
 do_softirq+0x11b/0x1e0 kernel/softirq.c:455
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:382
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:820 [inline]
 nsim_dev_trap_report_work+0x75d/0xaa0 drivers/net/netdevsim/dev.c:850
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 5.575 msecs
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P45/1:b..l
rcu: 	(detected by 1, t=10502 jiffies, g=16325, q=901 ncpus=2)
task:kworker/1:1     state:R  running task     stack:21328 pid:45    tgid:45    ppid:2      flags:0x00004000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x17e8/0x4a20 kernel/sched/core.c:6745
 preempt_schedule_irq+0xfb/0x1c0 kernel/sched/core.c:7067
 irqentry_exit+0x5e/0x90 kernel/entry/common.c:354
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_acquire+0x264/0x550 kernel/locking/lockdep.c:5758
Code: 2b 00 74 08 4c 89 f7 e8 2a 84 89 00 f6 44 24 61 02 0f 85 85 01 00 00 41 f7 c7 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 25 00 00 00 00 00 43 c7 44 25 09 00 00 00 00 43 c7 44 25
RSP: 0018:ffffc90000b56f20 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff9200016adf0 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcacd00 RDI: ffffffff8c1ff840
RBP: ffffc90000b57068 R08: ffffffff92fab587 R09: 1ffffffff25f56b0
R10: dffffc0000000000 R11: fffffbfff25f56b1 R12: 1ffff9200016adec
R13: dffffc0000000000 R14: ffffc90000b56f80 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 rcu_read_lock include/linux/rcupdate.h:781 [inline]
 sk_filter_trim_cap+0x1d0/0xa80 net/core/filter.c:154
 sk_filter include/linux/filter.h:945 [inline]
 do_one_broadcast net/netlink/af_netlink.c:1491 [inline]
 netlink_broadcast_filtered+0x7c0/0x1290 net/netlink/af_netlink.c:1544
 netlink_broadcast+0x39/0x50 net/netlink/af_netlink.c:1568
 uevent_net_broadcast_untagged lib/kobject_uevent.c:331 [inline]
 kobject_uevent_net_broadcast+0x38f/0x580 lib/kobject_uevent.c:410
 kobject_uevent_env+0x57d/0x8e0 lib/kobject_uevent.c:593
 really_probe+0x7f4/0xad0 drivers/base/dd.c:706
 __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:798
 driver_probe_device+0x50/0x430 drivers/base/dd.c:828
 __device_attach_driver+0x2d6/0x530 drivers/base/dd.c:956
 bus_for_each_drv+0x24e/0x2e0 drivers/base/bus.c:457
 __device_attach+0x333/0x520 drivers/base/dd.c:1028
 bus_probe_device+0x189/0x260 drivers/base/bus.c:532
 device_add+0x856/0xbf0 drivers/base/core.c:3721
 usb_new_device+0x104a/0x19a0 drivers/usb/core/hub.c:2651
 hub_port_connect drivers/usb/core/hub.c:5521 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5661 [inline]
 port_event drivers/usb/core/hub.c:5821 [inline]
 hub_event+0x2d6a/0x5150 drivers/usb/core/hub.c:5903
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
cdc_wdm 3-1:1.0: nonzero urb status received: -71
cdc_wdm 3-1:1.0: wdm_int_callb

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
