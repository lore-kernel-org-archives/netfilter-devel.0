From: Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr>
Subject: OOPS NULL pointer dereference in nf_nat_setup_info+0x471 (reproductible, 3.14.4)
Date: Mon, 26 May 2014 18:59:59 +0200
Message-ID: <4667198.VVkvcgzEe7@luna>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51338 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaEZRAK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 May 2014 13:00:10 -0400
Received: from gaia.dosisoft.fr (unknown [82.233.153.244])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 23C66A6209
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2014 18:58:18 +0200 (CEST)
Received: from luna.dosisoft.fr (luna.dosisoft.fr [IPv6:2a01:e35:2e99:9f40:1:0:65:39])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tondellier)
	by gaia.dosisoft.fr (Postfix) with ESMTPSA id 3gcl0f4Pjdz57
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2014 19:00:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I got the following OOPS with kernel 3.14.4 (debian backport for wheezy) on our 
internet gateway while trying to establish a new PPTP tunnel from a NAT-ed host.
Seems it's 100% reproductible (reproduced 2 times, and probably a 3rd, but 
without backtrace. I didn't try more, since it's a production system).

It seems that nat can sometimes be NULL here :
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/net/
netfilter/nf_nat_core.c#n419

It looks a lot like this one : https://bugs.debian.org/741667 (2nd backtrace at 
the end)

I have kdumps and kernel debug symbols for the second and third crashs, so let 
me known if you need more info (but please CC me).


More info on the setup :
- dual wan (multiple routing tables) with one tg3 and one e100 card
- lan is a bridge between 2 vlans with another tg3 card (tg3 and br* in 
backtrace)
- old hardware, but ECC memory, no known problems
- lightly loaded
- the last known good kernel was 3.11-0.bpo.2-amd64 (debian backport for wheezy)
- using static conntrack helpers for PPTP and FTP only, as described by 
https://home.regit.org/netfilter-en/secure-use-of-helpers/
- known ctnetlink users running : ulogd2, collectd
- some ipsec tunnels (xfrm in backtrace)

I can try to reproduce it on a more lightweight configuration if needed.

Thanks




crash 7.0.6
...
      KERNEL: /var/crash/201405261359/kernel_link
    DUMPFILE: /var/crash/201405261359/dump.201405261359  [PARTIAL DUMP]
        CPUS: 2
        DATE: Mon May 26 13:59:14 2014
      UPTIME: 00:49:24
LOAD AVERAGE: 0.03, 0.04, 0.05
       TASKS: 141
    NODENAME: XXXXXXXXXX
     RELEASE: 3.14-0.bpo.1-amd64
     VERSION: #1 SMP Debian 3.14.4-1~bpo70+1 (2014-05-14)
     MACHINE: x86_64  (2659 Mhz)
      MEMORY: 3 GB
       PANIC: "Oops: 0002 [#1] SMP " (check log for details)
         PID: 0
     COMMAND: "swapper/0"
        TASK: ffffffff81813480  (1 of 2)  [THREAD_INFO: ffffffff81800000]
         CPU: 0
       STATE: TASK_RUNNING (PANIC)

crash> log
...
[ 2963.801763] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 2963.802147] IP: [<ffffffffa0411c41>] nf_nat_setup_info+0x471/0x890 [nf_nat]
[ 2963.802475] PGD bb417067 PUD b9e94067 PMD 0 
[ 2963.802720] Oops: 0002 [#1] SMP 
[ 2963.802892] Modules linked in: tun seqiv xfrm6_mode_tunnel xfrm4_mode_tunnel ghash_generic gcm tcp_diag inet_diag cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 xts serpent_generic lrw gf128mul glue_helper blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common ablk_helper cryptd des_generic cbc cmac xcbc rmd160 sha512_ssse3 sha512_generic sha256_ssse3 sha256_generic hmac crypto_null af_key xfrm_algo ip6table_raw ip6t_REJECT ip6t_rt ip6table_filter nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_mangle ip6_tables ipt_rpfilter xt_CT iptable_raw xt_LOG xt_helper xt_
 nfacct ipt_REJECT
[ 2963.805701]  xt_NFLOG nfnetlink_log xt_pkttype xt_addrtype sch_htb iptable_filter xt_REDIRECT xt_nat xt_state xt_policy iptable_nat nf_nat_ipv4 xt_CLASSIFY xt_limit xt_length xt_comment xt_HL xt_hl xt_statistic xt_physdev xt_TCPMSS xt_tcpudp ipt_ECN nf_conntrack_ipv4 nf_defrag_ipv4 xt_dscp xt_hashlimit xt_DSCP xt_multiport xt_mark xt_conntrack xt_connmark iptable_mangle ip_tables x_tables nfnetlink_acct nfnetlink pppoe pppox ppp_generic slhc bridge sch_fq_codel speedstep_lib 8021q garp stp mrp llc nf_nat_ftp nf_nat_pptp nf_nat_proto_gre nf_nat nf_conntrack_ftp nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack ohci_hcd iTCO_wdt acpi_cpufreq iTCO_vendor_support ttm parport_pc drm_kms_helper coretemp parport i3000_edac edac_core processor button drm lpc_ich dcdbas mfd_core psmouse seri
 o_raw i2c_algo_bit
[ 2963.805701]  pcspkr thermal_sys i2c_i801 i2c_core rng_core kvm evdev ext4 crc16 mbcache jbd2 dm_mod raid1 md_mod hid_generic usbhid hid sd_mod crc_t10dif crct10dif_common sg sr_mod cdrom ata_generic ehci_pci uhci_hcd ehci_hcd ata_piix libata tg3 e1000e e100 mii scsi_mod usbcore ptp usb_common pps_core libphy
[ 2963.805701] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14-0.bpo.1-amd64 #1 Debian 3.14.4-1~bpo70+1
[ 2963.805701] Hardware name: Dell Inc.                 PowerEdge SC440              /0YH299, BIOS 1.5.0  09/04/2007
[ 2963.805701] task: ffffffff81813480 ti: ffffffff81800000 task.ti: ffffffff81800000
[ 2963.805701] RIP: 0010:[<ffffffffa0411c41>]  [<ffffffffa0411c41>] nf_nat_setup_info+0x471/0x890 [nf_nat]
[ 2963.805701] RSP: 0018:ffff8800bfa03658  EFLAGS: 00010246
[ 2963.805701] RAX: 0000000000000000 RBX: ffff880036eff758 RCX: 0000000000000000
[ 2963.805701] RDX: ffff88003689d040 RSI: 00000000de183e04 RDI: ffffffffa0414430
[ 2963.805701] RBP: 00000000000013bc R08: ffffffff81886f80 R09: ffff88003689d040
[ 2963.805701] R10: ffff8800bfa03638 R11: ffff8800b9b80000 R12: 0000000000000000
[ 2963.805701] R13: ffff8800bfa036b8 R14: 0000000000000000 R15: 0000000000000000
[ 2963.805701] FS:  0000000000000000(0000) GS:ffff8800bfa00000(0000) knlGS:0000000000000000
[ 2963.805701] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2963.805701] CR2: 0000000000000010 CR3: 00000000bb41b000 CR4: 00000000000007f0
[ 2963.805701] Stack:
[ 2963.805701]  000000000000ffff ffffffffa0413280 ffffffff81886f80 ffffffffa0512060
[ 2963.805701]  ffffffffa0512068 ffffffffa0413290 ffffffff81886f80 00000000f040100a
[ 2963.805701]  0000000000000000 968fa7c2000209d2 0000000000000000 0006bb0600000000
[ 2963.805701] Call Trace:
[ 2963.805701]  <IRQ> 
[ 2963.805701] 
[ 2963.805701]  [<ffffffffa05250fd>] ? xt_snat_target_v0+0x2d/0x40 [xt_nat]
[ 2963.805701]  [<ffffffffa04a5260>] ? ipt_do_table+0x350/0x610 [ip_tables]
[ 2963.805701]  [<ffffffff81489a05>] ? xfrm_bundle_lookup+0x595/0x680
[ 2963.805701]  [<ffffffffa0516214>] ? nf_nat_ipv4_fn+0x194/0x290 [iptable_nat]
[ 2963.805701]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[ 2963.805701]  [<ffffffffa0516488>] ? nf_nat_ipv4_out+0x58/0x100 [iptable_nat]
[ 2963.805701]  [<ffffffff8142ebf6>] ? nf_iterate+0x86/0xc0
[ 2963.805701]  [<ffffffff81436e40>] ? ip_frag_mem+0x40/0x40
[ 2963.805701]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[ 2963.805701]  [<ffffffff8142eca7>] ? nf_hook_slow+0x77/0x150
[ 2963.805701]  [<ffffffff8143a1f0>] ? ip_fragment+0x830/0x830
[ 2963.805701]  [<ffffffff8143af2a>] ? ip_output+0x7a/0x90
[ 2963.805701]  [<ffffffff813fe293>] ? __netif_receive_skb_core+0x643/0x7c0
[ 2963.805701]  [<ffffffff813fe510>] ? netif_receive_skb_internal+0x80/0x80
[ 2963.805701]  [<ffffffff813fe4aa>] ? netif_receive_skb_internal+0x1a/0x80
[ 2963.805701]  [<ffffffffa045d760>] ? br_handle_frame_finish+0x1d0/0x3f0 [bridge]
[ 2963.805701]  [<ffffffffa0464060>] ? br_nf_post_routing+0x310/0x310 [bridge]
[ 2963.805701]  [<ffffffffa045d590>] ? br_handle_local_finish+0x60/0x60 [bridge]
[ 2963.805701]  [<ffffffffa04641a6>] ? br_nf_pre_routing_finish+0x146/0x380 [bridge]
[ 2963.805701]  [<ffffffffa045d590>] ? br_handle_local_finish+0x60/0x60 [bridge]
[ 2963.805701]  [<ffffffffa04649df>] ? br_nf_pre_routing+0x3ff/0x650 [bridge]
[ 2963.805701]  [<ffffffffa045d590>] ? br_handle_local_finish+0x60/0x60 [bridge]
[ 2963.805701]  [<ffffffff8142ebf6>] ? nf_iterate+0x86/0xc0
[ 2963.805701]  [<ffffffffa045d590>] ? br_handle_local_finish+0x60/0x60 [bridge]
[ 2963.805701]  [<ffffffff8142eca7>] ? nf_hook_slow+0x77/0x150
[ 2963.805701]  [<ffffffffa045d590>] ? br_handle_local_finish+0x60/0x60 [bridge]
[ 2963.805701]  [<ffffffffa045db18>] ? br_handle_frame+0x198/0x240 [bridge]
[ 2963.805701]  [<ffffffffa045d980>] ? br_handle_frame_finish+0x3f0/0x3f0 [bridge]
[ 2963.805701]  [<ffffffff813fdfbd>] ? __netif_receive_skb_core+0x36d/0x7c0
[ 2963.805701]  [<ffffffff8101d2a5>] ? read_tsc+0x5/0x20
[ 2963.805701]  [<ffffffff813fe4aa>] ? netif_receive_skb_internal+0x1a/0x80
[ 2963.805701]  [<ffffffff813fecb5>] ? napi_gro_receive+0xb5/0x120
[ 2963.805701]  [<ffffffffa021349f>] ? tg3_poll_work+0xc8f/0xea0 [tg3]
[ 2963.805701]  [<ffffffff810a605f>] ? __wake_up_common+0x4f/0x80
[ 2963.805701]  [<ffffffffa021c124>] ? tg3_poll+0x84/0x3c0 [tg3]
[ 2963.805701]  [<ffffffff813ff9a9>] ? net_rx_action+0x119/0x230
[ 2963.805701]  [<ffffffff814f0f49>] ? _raw_spin_unlock_irqrestore+0x9/0x10
[ 2963.805701]  [<ffffffff81069a9e>] ? __do_softirq+0xee/0x2f0
[ 2963.805701]  [<ffffffff81069ebe>] ? irq_exit+0x7e/0xa0
[ 2963.805701]  [<ffffffff81017211>] ? do_IRQ+0x61/0x110
[ 2963.805701]  [<ffffffff814f162d>] ? common_interrupt+0x6d/0x6d
[ 2963.805701]  <EOI> 
[ 2963.805701] 
[ 2963.805701]  [<ffffffff8101e7f0>] ? idle_notifier_register+0x10/0x10
[ 2963.805701]  [<ffffffff810512c2>] ? native_safe_halt+0x2/0x10
[ 2963.805701]  [<ffffffff8101e80d>] ? default_idle+0x1d/0xf0
[ 2963.805701]  [<ffffffff810b7dc3>] ? cpu_startup_entry+0x93/0x270
[ 2963.805701]  [<ffffffff818c6f11>] ? start_kernel+0x419/0x424
[ 2963.805701]  [<ffffffff818c6911>] ? repair_env_string+0x58/0x58
[ 2963.805701]  [<ffffffff818c6120>] ? early_idt_handlers+0x120/0x120
[ 2963.805701]  [<ffffffff818c6120>] ? early_idt_handlers+0x120/0x120
[ 2963.805701]  [<ffffffff818c672b>] ? x86_64_start_kernel+0x150/0x15f
[ 2963.805701] Code: 66 f4 0d e1 48 8b 93 e0 00 00 00 31 c0 48 c1 ed 20 48 85 d2 74 0e 0f b6 4a 11 84 c9 74 06 0f b6 c1 48 01 d0 4c 8b 44 24 10 89 ed <48> 89 58 10 48 c1 e5 03 49 03 a8 88 0b 00 00 48 8b 55 00 48 89 
[ 2963.805701] RIP  [<ffffffffa0411c41>] nf_nat_setup_info+0x471/0x890 [nf_nat]
[ 2963.805701]  RSP <ffff8800bfa03658>
[ 2963.805701] CR2: 0000000000000010



Note : 0x471 = 1137


crash> bt
PID: 0      TASK: ffffffff81813480  CPU: 0   COMMAND: "swapper/0"
 #0 [ffff8800bfa032f0] machine_kexec at ffffffff8104d1e7
 #1 [ffff8800bfa03350] crash_kexec at ffffffff810dc815
 #2 [ffff8800bfa03420] oops_end at ffffffff814f2538
 #3 [ffff8800bfa03440] no_context at ffffffff814e7e94
 #4 [ffff8800bfa03490] __do_page_fault at ffffffff814f4f16
 #5 [ffff8800bfa035a0] page_fault at ffffffff814f1948
    [exception RIP: nf_nat_setup_info+1137]
    RIP: ffffffffa0411c41  RSP: ffff8800bfa03658  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff880036eff758  RCX: 0000000000000000
    RDX: ffff88003689d040  RSI: 00000000de183e04  RDI: ffffffffa0414430
    RBP: 00000000000013bc   R8: ffffffff81886f80   R9: ffff88003689d040
    R10: ffff8800bfa03638  R11: ffff8800b9b80000  R12: 0000000000000000
    R13: ffff8800bfa036b8  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffff8800bfa03740] xt_snat_target_v0 at ffffffffa05250fd [xt_nat]
 #7 [ffff8800bfa03780] ipt_do_table at ffffffffa04a5260 [ip_tables]
 #8 [ffff8800bfa038b0] nf_nat_ipv4_fn at ffffffffa0516214 [iptable_nat]
 #9 [ffff8800bfa03930] nf_nat_ipv4_out at ffffffffa0516488 [iptable_nat]
#10 [ffff8800bfa03950] nf_iterate at ffffffff8142ebf6
#11 [ffff8800bfa039a0] nf_hook_slow at ffffffff8142eca7
#12 [ffff8800bfa03a10] ip_output at ffffffff8143af2a
#13 [ffff8800bfa03a30] __netif_receive_skb_core at ffffffff813fe293
#14 [ffff8800bfa03ab0] br_handle_frame_finish at ffffffffa045d760 [bridge]
#15 [ffff8800bfa03b00] br_nf_pre_routing_finish at ffffffffa04641a6 [bridge]
#16 [ffff8800bfa03b60] br_nf_pre_routing at ffffffffa04649df [bridge]
#17 [ffff8800bfa03bb0] nf_iterate at ffffffff8142ebf6
#18 [ffff8800bfa03c00] nf_hook_slow at ffffffff8142eca7
#19 [ffff8800bfa03c70] br_handle_frame at ffffffffa045db18 [bridge]
#20 [ffff8800bfa03cb0] __netif_receive_skb_core at ffffffff813fdfbd
#21 [ffff8800bfa03d30] napi_gro_receive at ffffffff813fecb5
#22 [ffff8800bfa03d60] tg3_poll_work at ffffffffa021349f [tg3]
#23 [ffff8800bfa03e30] tg3_poll at ffffffffa021c124 [tg3]
#24 [ffff8800bfa03e90] net_rx_action at ffffffff813ff9a9
#25 [ffff8800bfa03e98] _raw_spin_unlock_irqrestore at ffffffff814f0f49
#26 [ffff8800bfa03f00] __do_softirq at ffffffff81069a9e
#27 [ffff8800bfa03f70] irq_exit at ffffffff81069ebe
#28 [ffff8800bfa03f80] do_IRQ at ffffffff81017211
--- <IRQ stack> ---
#29 [ffffffff81801df8] ret_from_intr at ffffffff814f162d
    [exception RIP: native_safe_halt+2]
    RIP: ffffffff810512c2  RSP: ffffffff81801ea0  RFLAGS: 00000292
    RAX: ffffffff8101e7f0  RBX: ffff8800bfa0ec80  RCX: ffffffff81840d60
    RDX: ffff8800bfa00000  RSI: 0000000000000000  RDI: 0000000000000096
    RBP: ffffffff818a6980   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 00000001000a295f  R12: 0000000000000082
    R13: ffffffff8101d8c5  R14: 000000018101d86d  R15: ffff8800bfa143b8
    ORIG_RAX: ffffffffffffffad  CS: 0010  SS: 0018
#30 [ffffffff81801ea0] default_idle at ffffffff8101e80d
#31 [ffffffff81801ed0] cpu_startup_entry at ffffffff810b7dc3
#32 [ffffffff81801f30] start_kernel at ffffffff818c6f11
#33 [ffffffff81801f80] x86_64_start_kernel at ffffffff818c672b


crash> bt -f
...
 #5 [ffff8800bfa035a0] page_fault at ffffffff814f1948
    [exception RIP: nf_nat_setup_info+1137]
    RIP: ffffffffa0411c41  RSP: ffff8800bfa03658  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff880036eff758  RCX: 0000000000000000
    RDX: ffff88003689d040  RSI: 00000000de183e04  RDI: ffffffffa0414430
    RBP: 00000000000013bc   R8: ffffffff81886f80   R9: ffff88003689d040
    R10: ffff8800bfa03638  R11: ffff8800b9b80000  R12: 0000000000000000
    R13: ffff8800bfa036b8  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    ffff8800bfa035a8: 0000000000000000 0000000000000000 
    ffff8800bfa035b8: ffff8800bfa036b8 0000000000000000 
    ffff8800bfa035c8: 00000000000013bc ffff880036eff758 
    ffff8800bfa035d8: ffff8800b9b80000 ffff8800bfa03638 
    ffff8800bfa035e8: ffff88003689d040 ffffffff81886f80 
    ffff8800bfa035f8: 0000000000000000 0000000000000000 
    ffff8800bfa03608: ffff88003689d040 00000000de183e04 
    ffff8800bfa03618: ffffffffa0414430 ffffffffffffffff 
    ffff8800bfa03628: ffffffffa0411c41 0000000000000010 
    ffff8800bfa03638: 0000000000010246 ffff8800bfa03658 
    ffff8800bfa03648: 0000000000000018 ffffffffa0411c1a 
    ffff8800bfa03658: 000000000000ffff ffffffffa0413280 
    ffff8800bfa03668: ffffffff81886f80 ffffffffa0512060 
    ffff8800bfa03678: ffffffffa0512068 ffffffffa0413290 
    ffff8800bfa03688: ffffffff81886f80 00000000f040100a 
    ffff8800bfa03698: 0000000000000000 968fa7c2000209d2 
    ffff8800bfa036a8: 0000000000000000 0006bb0600000000 
    ffff8800bfa036b8: 00000000f499e952 0000000000000000 
    ffff8800bfa036c8: 968fa7c2000209d2 0000000000000000 
    ffff8800bfa036d8: 0006bb0600000000 00000000968fa7c2 
    ffff8800bfa036e8: 0000000000000000 f499e9520002bb06 
    ffff8800bfa036f8: 0000000000000000 010609d200000000 
    ffff8800bfa03708: 000000000000ffff ffff880036eff758 
    ffff8800bfa03718: ffff8800ba75fd50 ffff8800b928d640 
    ffff8800bfa03728: ffffc900049f1ef0 ffffffffa04a94a0 
    ffff8800bfa03738: ffffe8ffffc01b04 ffffffffa05250fd 
 #6 [ffff8800bfa03740] xt_snat_target_v0 at ffffffffa05250fd [xt_nat]
...

crash> dis -l nf_nat_setup_info

0xffffffffa0411c15 <nf_nat_setup_info+1093>:    callq  0xffffffff814f1080 <_raw_spin_lock_bh>
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 857
0xffffffffa0411c1a <nf_nat_setup_info+1098>:    mov    0xe0(%rbx),%rdx
/build/linux-v1L7fI/linux-3.14.4/include/net/netfilter/nf_conntrack_extend.h: 68
0xffffffffa0411c21 <nf_nat_setup_info+1105>:    xor    %eax,%eax
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 129
0xffffffffa0411c23 <nf_nat_setup_info+1107>:    shr    $0x20,%rbp
/build/linux-v1L7fI/linux-3.14.4/include/net/netfilter/nf_conntrack_extend.h: 62
0xffffffffa0411c27 <nf_nat_setup_info+1111>:    test   %rdx,%rdx
0xffffffffa0411c2a <nf_nat_setup_info+1114>:    je     0xffffffffa0411c3a <nf_nat_setup_info+1130>
/build/linux-v1L7fI/linux-3.14.4/include/net/netfilter/nf_conntrack_extend.h: 57
0xffffffffa0411c2c <nf_nat_setup_info+1116>:    movzbl 0x11(%rdx),%ecx
/build/linux-v1L7fI/linux-3.14.4/include/net/netfilter/nf_conntrack_extend.h: 62
0xffffffffa0411c30 <nf_nat_setup_info+1120>:    test   %cl,%cl
0xffffffffa0411c32 <nf_nat_setup_info+1122>:    je     0xffffffffa0411c3a <nf_nat_setup_info+1130>
/build/linux-v1L7fI/linux-3.14.4/include/net/netfilter/nf_conntrack_extend.h: 70
0xffffffffa0411c34 <nf_nat_setup_info+1124>:    movzbl %cl,%eax
0xffffffffa0411c37 <nf_nat_setup_info+1127>:    add    %rdx,%rax
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 420
0xffffffffa0411c3a <nf_nat_setup_info+1130>:    mov    0x10(%rsp),%r8
0xffffffffa0411c3f <nf_nat_setup_info+1135>:    mov    %ebp,%ebp
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 419
0xffffffffa0411c41 <nf_nat_setup_info+1137>:    mov    %rbx,0x10(%rax)
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 421
0xffffffffa0411c45 <nf_nat_setup_info+1141>:    shl    $0x3,%rbp
/build/linux-v1L7fI/linux-3.14.4/net/netfilter/nf_nat_core.c: 420
0xffffffffa0411c49 <nf_nat_setup_info+1145>:    add    0xb88(%r8),%rbp
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 397
0xffffffffa0411c50 <nf_nat_setup_info+1152>:    mov    0x0(%rbp),%rdx
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 400
0xffffffffa0411c54 <nf_nat_setup_info+1156>:    mov    %rbp,0x8(%rax)
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 399
0xffffffffa0411c58 <nf_nat_setup_info+1160>:    mov    %rdx,(%rax)
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 402
0xffffffffa0411c5b <nf_nat_setup_info+1163>:    test   %rdx,%rdx
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 401
0xffffffffa0411c5e <nf_nat_setup_info+1166>:    mov    %rax,0x0(%rbp)
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 402
0xffffffffa0411c62 <nf_nat_setup_info+1170>:    je     0xffffffffa0411c68 <nf_nat_setup_info+1176>
/build/linux-v1L7fI/linux-3.14.4/include/linux/rculist.h: 403
0xffffffffa0411c64 <nf_nat_setup_info+1172>:    mov    %rax,0x8(%rdx)
/build/linux-v1L7fI/linux-3.14.4/include/linux/spinlock.h: 348
0xffffffffa0411c68 <nf_nat_setup_info+1176>:    mov    $0xffffffffa0414430,%rdi
0xffffffffa0411c6f <nf_nat_setup_info+1183>:    callq  0xffffffff814f1060 <_raw_spin_unlock_bh>


Relevant gdb disassemble on module nf_nat.ko :

411             if (maniptype == NF_NAT_MANIP_SRC) {
   0x0000000000000b32 <+866>:   test   %r12d,%r12d
   0x0000000000000b35 <+869>:   jne    0x1000 <nf_nat_setup_info+2096>

412                     unsigned int srchash;
413
414                     srchash = hash_by_src(net, nf_ct_zone(ct),
415                                           &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
416                     spin_lock_bh(&nf_nat_lock);
417                     /* nf_conntrack_alter_reply might re-allocate extension aera */
418                     nat = nfct_nat(ct);
419                     nat->ct = ct;
   0x0000000000000c41 <+1137>:  mov    %rbx,0x10(%rax)

420                     hlist_add_head_rcu(&nat->bysource,
   0x0000000000000c3a <+1130>:  mov    0x10(%rsp),%r8
   0x0000000000000c3f <+1135>:  mov    %ebp,%ebp
   0x0000000000000c49 <+1145>:  add    0xb88(%r8),%rbp

421                                        &net->ct.nat_bysource[srchash]);
   0x0000000000000c45 <+1141>:  shl    $0x3,%rbp

422                     spin_unlock_bh(&nf_nat_lock);
423             }

