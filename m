From: Linke <linkerpro@mail.ru>
Subject: BUG: Kernel panic at masquerade
Date: Fri, 09 Jan 2015 23:32:01 +0200
Message-ID: <54B048D1.6040009@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp13.mail.ru ([94.100.181.94]:32900 "EHLO smtp13.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbbAIVcL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:32:11 -0500
Received: from [109.87.127.30] (port=55829 helo=[192.168.7.100])
	by smtp13.mail.ru with esmtpa (envelope-from <linkerpro@mail.ru>)
	id 1Y9hA3-0004M0-CE
	for netfilter-devel@vger.kernel.org; Sat, 10 Jan 2015 00:32:09 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm stable receive a kernel panic in this ruleset:

nft add table firewall
nft add chain firewall prerouting {type nat hook prerouting priority 0\;}
nft add rule firewall prerouting masquerade


trying at Archlinux

official latest 3.18-grsec kernel
and AUR 3.19.0-rc3-gbdec419 (builded from git.kernel.org)



Arch Linux 3.19.0-rc3-gbdec419 (ttyS0)

archbox login: [   28.840829] BUG: unable to handle kernel NULL pointer 
dereference at 00000000000000a8
[   28.843935] IP: [<ffffffffa035c0cc>] 
nf_nat_masquerade_ipv4+0x7c/0x130 [nf_nat_masquerade_ipv4]
[   28.843935] PGD 0
[   28.843935] Oops: 0000 [#1] PREEMPT SMP
[   28.843935] Modules linked in: nft_masq_ipv4 nf_nat_masquerade_ipv4 
nft_masq nft_chain_nat_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack nf_tables_ipv4 nf_tables nfnetlink ppdev 
snd_intel8x0 iosf_mbi joydev snd_ac97_codec ac97_bus snd_pcm mousedev 
pcspkr snd_timer psmouse evdev mac_hid snd serio_raw battery parport_pc 
parport ac intel_agp intel_gtt soundcore i2c_piix4 button i2c_core 
processor e1000 sch_fq_codel ext4 crc16 mbcache jbd2 hid_generic usbhid 
hid sr_mod cdrom sd_mod ata_generic pata_acpi atkbd libps2 ohci_pci 
ohci_hcd usbcore ahci ata_piix libahci usb_common libata scsi_mod i8042 
serio
[   28.843935] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 
3.19.0-rc3-gbdec419 #2
[   28.843935] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[   28.843935] task: ffffffff81818540 ti: ffffffff81800000 task.ti: 
ffffffff81800000
[   28.843935] RIP: 0010:[<ffffffffa035c0cc>] [<ffffffffa035c0cc>] 
nf_nat_masquerade_ipv4+0x7c/0x130 [nf_nat_masquerade_ipv4]
[   28.843935] RSP: 0018:ffff88007fc036c8  EFLAGS: 00010246
[   28.843935] RAX: 0000000000000000 RBX: ffff880037adf640 RCX: 
ffff88007c367380
[   28.843935] RDX: 000000000000004e RSI: 0000000000000000 RDI: 
0000000000000000
[   28.843935] RBP: ffff88007fc03718 R08: ffff880037ba4000 R09: 
0000000000000040
[   28.843935] R10: 0000000000000000 R11: 0000000000000002 R12: 
ffff880037ba4000
[   28.843935] R13: ffff88007fc03728 R14: 0000000000000000 R15: 
ffff88007b8e9598
[   28.843935] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000) 
knlGS:0000000000000000
[   28.843935] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   28.843935] CR2: 00000000000000a8 CR3: 0000000001811000 CR4: 
00000000000006f0
[   28.843935] Stack:
[   28.843935]  ffff88007ffedb08 0000000000000000 ffffffff81818540 
ffff88007ffedb00
[   28.843935]  ffff88007fc03828 171e81be3eb286e2 ffff88007fc037a8 
ffff88007fc039c8
[   28.843935]  ffff88007b8e9580 00000000ffffffff ffff88007fc03768 
ffffffffa0361068
[   28.843935] Call Trace:
[   28.843935]  <IRQ>
[   28.843935]  [<ffffffffa0361068>] nft_masq_ipv4_eval+0x68/0x85 
[nft_masq_ipv4]
[   28.843935]  [<ffffffffa0219193>] nft_do_chain+0x103/0x540 [nf_tables]
[   28.843935]  [<ffffffff811b4d3b>] ? new_slab+0x13b/0x380
[   28.843935]  [<ffffffffa022b5c7>] ? __nf_conntrack_alloc+0x67/0x250 
[nf_conntrack]
[   28.843935]  [<ffffffff812c0aee>] ? memzero_explicit+0xe/0x10
[   28.843935]  [<ffffffff813b20e1>] ? extract_entropy+0xe1/0x220
[   28.843935]  [<ffffffff81457c84>] ? __skb_checksum_complete+0x24/0xd0
[   28.843935]  [<ffffffffa022b5c7>] ? __nf_conntrack_alloc+0x67/0x250 
[nf_conntrack]
[   28.843935]  [<ffffffff811b7e2e>] ? __kmalloc+0x18e/0x1e0
[   28.843935]  [<ffffffffa029309e>] nft_nat_do_chain+0x7e/0xa0 
[nft_chain_nat_ipv4]
[   28.843935]  [<ffffffffa028881b>] nf_nat_ipv4_fn+0x18b/0x230 
[nf_nat_ipv4]
[   28.843935]  [<ffffffffa0293020>] ? nft_nat_ipv4_out+0x20/0x20 
[nft_chain_nat_ipv4]
[   28.843935]  [<ffffffffa02888ee>] nf_nat_ipv4_in+0x2e/0x90 [nf_nat_ipv4]
[   28.843935]  [<ffffffff8149deb0>] ? ip_local_deliver_finish+0x210/0x210
[   28.843935]  [<ffffffff8149deb0>] ? ip_local_deliver_finish+0x210/0x210
[   28.843935]  [<ffffffffa0293115>] nft_nat_ipv4_in+0x15/0x17 
[nft_chain_nat_ipv4]
[   28.843935]  [<ffffffff81496e1a>] nf_iterate+0xaa/0xc0
[   28.843935]  [<ffffffff8149deb0>] ? ip_local_deliver_finish+0x210/0x210
[   28.843935]  [<ffffffff81496eb4>] nf_hook_slow+0x84/0x150
[   28.843935]  [<ffffffff8149deb0>] ? ip_local_deliver_finish+0x210/0x210
[   28.843935]  [<ffffffff8149e70c>] ip_rcv+0x2fc/0x3a0
[   28.843935]  [<ffffffff814606d2>] __netif_receive_skb_core+0x5c2/0x870
[   28.843935]  [<ffffffff81462b7a>] __netif_receive_skb+0x1a/0x80
[   28.843935]  [<ffffffff81462c20>] netif_receive_skb_internal+0x40/0xd0
[   28.843935]  [<ffffffff814635f8>] napi_gro_receive+0xc8/0x120
[   28.843935]  [<ffffffffa01f241d>] e1000_clean_rx_irq+0x16d/0x590 [e1000]
[   28.843935]  [<ffffffffa01f1be5>] e1000_clean+0x2b5/0x980 [e1000]
[   28.843935]  [<ffffffff810b5718>] ? __wake_up+0x48/0x60
[   28.843935]  [<ffffffff813b0f3a>] ? __mix_pool_bytes+0x3a/0xb0
[   28.843935]  [<ffffffff8146437a>] net_rx_action+0x21a/0x360
[   28.843935]  [<ffffffff81078b71>] __do_softirq+0xe1/0x2c0
[   28.843935]  [<ffffffff81078e8e>] irq_exit+0x7e/0xa0
[   28.843935]  [<ffffffff81564188>] do_IRQ+0x58/0xf0
[   28.843935]  [<ffffffff8156212d>] common_interrupt+0x6d/0x6d
[   28.843935]  <EOI>
[   28.843935]  [<ffffffff8105b856>] ? native_safe_halt+0x6/0x10
[   28.843935]  [<ffffffff81020bae>] default_idle+0x1e/0xf0
[   28.843935]  [<ffffffff8102164f>] arch_cpu_idle+0xf/0x20
[   28.843935]  [<ffffffff810b628b>] cpu_startup_entry+0x34b/0x460
[   28.843935]  [<ffffffff81552195>] rest_init+0x85/0x90
[   28.843935]  [<ffffffff818fe020>] start_kernel+0x48e/0x4af
[   28.843935]  [<ffffffff818fd120>] ? early_idt_handlers+0x120/0x120
[   28.843935]  [<ffffffff818fd4d7>] x86_64_start_reservations+0x2a/0x2c
[   28.843935]  [<ffffffff818fd62b>] x86_64_start_kernel+0x152/0x175
[   28.843935] Code: 41 8b 54 24 18 b8 01 00 00 00 85 d2 0f 84 8f 00 00 
00 48 8b 47 58 0f b7 97 c4 00 00 00 48 8b 8f d0 00 00 00 4c 89 f7 48 83 
e0 fe <8b> b0 a8 00 00 00 85 f6 0f 44 74 11 10 31 d2 e8 d0 84 17 e1 85
[   28.843935] RIP  [<ffffffffa035c0cc>] 
nf_nat_masquerade_ipv4+0x7c/0x130 [nf_nat_masquerade_ipv4]
[   28.843935]  RSP <ffff88007fc036c8>
[   28.843935] CR2: 00000000000000a8
[   28.843935] ---[ end trace 806dc8e8ef489763 ]---
[   28.843935] Kernel panic - not syncing: Fatal exception in interrupt
[   28.843935] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation 
range: 0xffffffff80000000-0xffffffff9fffffff)
[   28.843935] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt


Please let me know if I'm doing something wrong.
Thank you!
