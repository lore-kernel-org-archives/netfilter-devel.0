From: Serge Leschinsky <serge.leschinsky@gmail.com>
Subject: a possible bug in netfilter
Date: Thu, 05 Apr 2012 21:12:34 -0700
Message-ID: <4F7E6D32.9060109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34535 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2DFEMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:12:37 -0400
Received: by dake40 with SMTP id e40so2343285dak.11
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Apr 2012 21:12:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Sometimes my system panics and below you can find the information I was able to 
catch via netconsole.

LFS-based system, kernel 3.3.1, xtables-addons 1.41

If I can do something to help you with debug/troubleshooting please let me know.

Thank you in advance,
Serge

BUG: unable to handle kernel
paging request
paging request
at 0000380000000000
at 0000380000000000
IP:
IP:
[<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
[<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
PGD 0

PGD 0

Oops: 0000 [#1]
Oops: 0000 [#1]
SMP

SMP

CPU 0

CPU 0

Modules linked in:
Modules linked in:
nf_conntrack_netlink
nf_conntrack_netlink
xt_recent
xt_recent
xt_psd(O)
xt_psd(O)
xt_TARPIT(O)
xt_TARPIT(O)
compat_xtables(O)
compat_xtables(O)
xt_NOTRACK
xt_NOTRACK
iptable_raw
iptable_raw
ip_set_bitmap_port
ip_set_bitmap_port
xt_set
xt_set
ip_set_hash_ip
ip_set_hash_ip
ip_set
ip_set
nfnetlink
nfnetlink
xt_mac
xt_mac
xt_tcpudp
xt_tcpudp
iptable_nat
iptable_nat
xt_multiport
xt_multiport
xt_limit
xt_limit
xt_conntrack
xt_conntrack
iptable_filter
iptable_filter
ip_tables
ip_tables
ipt_LOG
ipt_LOG
xt_state
xt_state
x_tables
x_tables
nf_nat_ftp
nf_nat_ftp
nf_nat
nf_nat
nf_conntrack_ipv4
nf_conntrack_ipv4
nf_defrag_ipv4
nf_defrag_ipv4
nf_conntrack_ftp
nf_conntrack_ftp
nf_conntrack
nf_conntrack
8021q
8021q
garp
garp
stp
stp
llc
llc
dm_mod
dm_mod
md_mod
md_mod
netconsole
netconsole
microcode
microcode
tun
tun
fam15h_power
fam15h_power
k10temp
k10temp
hwmon
hwmon
amd64_edac_mod
amd64_edac_mod
edac_core
edac_core
i2c_piix4
i2c_piix4
i2c_core
i2c_core
e1000e(O)
e1000e(O)
button
button
aufs
aufs
pata_atiixp
pata_atiixp
ahci
ahci
libahci
libahci
libata
libata
virtio_blk
virtio_blk
virtio_pci
virtio_pci
virtio_ring
virtio_ring
virtio
virtio
loop(O)


loop(O)


Pid: 0, comm: swapper/0 Tainted: G           O 3.3.1 #1
Pid: 0, comm: swapper/0 Tainted: G           O 3.3.1 #1
Supermicro H8SCM
Supermicro H8SCM
/H8SCM

/H8SCM

RIP: 0010:[<ffffffffa02001bd>]
RIP: 0010:[<ffffffffa02001bd>]
[<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
[<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
RSP: 0018:ffff88021ec03930  EFLAGS: 00010213
RSP: 0018:ffff88021ec03930  EFLAGS: 00010213
RAX: 0000380000000000 RBX: ffff88020f1f684e RCX: 0000000000000073
RAX: 0000380000000000 RBX: ffff88020f1f684e RCX: 0000000000000073
RDX: 0000000000000073 RSI: 000000010192f4e0 RDI: ffffffffa0205108
RDX: 0000000000000073 RSI: 000000010192f4e0 RDI: ffffffffa0205108
RBP: ffff88021ec039a0 R08: ffffffffa020b210 R09: 0000000000001544
RBP: ffff88021ec039a0 R08: ffffffffa020b210 R09: 0000000000001544
R10: 0000000000000000 R11: ffff88020f275a00 R12: 000000001e7036c0
R10: 0000000000000000 R11: ffff88020f275a00 R12: 000000001e7036c0
R13: 0000000000000011 R14: 0000000000000011 R15: ffffc900127e1210
R13: 0000000000000011 R14: 0000000000000011 R15: ffffc900127e1210
FS:  00007f8fb08a9700(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
FS:  00007f8fb08a9700(0000) GS:ffff88021ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000380000000000 CR3: 00000002105ef000 CR4: 00000000000406f0
CR2: 0000380000000000 CR3: 00000002105ef000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81800000, task ffffffff8180d020)
Process swapper/0 (pid: 0, threadinfo ffffffff81800000, task ffffffff8180d020)
Stack:
Stack:
000000010192f4e0
000000010192f4e0
ffffffff00000000
ffffffff00000000
0000000000000000
0000000000000000
3500000000000000
3500000000000000


ffff88020f1f684e
ffff88020f1f684e
ffff88020fcf54c0
ffff88020fcf54c0
ffffc900127e1070
ffffc900127e1070
0000380000000000
0000380000000000


ffff88021ec039a0
ffff88021ec039a0
ffffc900127e1180
ffffc900127e1180
ffff88020f1f684e
ffff88020f1f684e
ffff88020fcf54c0
ffff88020fcf54c0


Call Trace:
Call Trace:
<IRQ>
<IRQ>


[<ffffffffa01ab691>] ipt_do_table+0x2c1/0x630 [ip_tables]
[<ffffffffa01ab691>] ipt_do_table+0x2c1/0x630 [ip_tables]
[<ffffffff81493f92>] ? fib4_rule_action+0x72/0x90
[<ffffffff81493f92>] ? fib4_rule_action+0x72/0x90
[<ffffffff81436ee5>] ? fib_rules_lookup+0xc5/0x130
[<ffffffff81436ee5>] ? fib_rules_lookup+0xc5/0x130
[<ffffffffa01b20d3>] iptable_filter_hook+0x33/0x64 [iptable_filter]
[<ffffffffa01b20d3>] iptable_filter_hook+0x33/0x64 [iptable_filter]
[<ffffffff814498e5>] nf_iterate+0x85/0xc0
[<ffffffff814498e5>] nf_iterate+0x85/0xc0
[<ffffffff814515f0>] ? ip_rcv_finish+0x3a0/0x3a0
[<ffffffff814515f0>] ? ip_rcv_finish+0x3a0/0x3a0
[<ffffffff81449995>] nf_hook_slow+0x75/0x150
[<ffffffff81449995>] nf_hook_slow+0x75/0x150
[<ffffffff814515f0>] ? ip_rcv_finish+0x3a0/0x3a0
[<ffffffff814515f0>] ? ip_rcv_finish+0x3a0/0x3a0
[<ffffffff81451a3d>] ip_local_deliver+0x5d/0xa0
[<ffffffff81451a3d>] ip_local_deliver+0x5d/0xa0
[<ffffffff81451385>] ip_rcv_finish+0x135/0x3a0
[<ffffffff81451385>] ip_rcv_finish+0x135/0x3a0
[<ffffffff81451cb8>] ip_rcv+0x238/0x300
[<ffffffff81451cb8>] ip_rcv+0x238/0x300
[<ffffffff8141f9d5>] __netif_receive_skb+0x4e5/0x5f0
[<ffffffff8141f9d5>] __netif_receive_skb+0x4e5/0x5f0
[<ffffffff8141fcad>] netif_receive_skb+0x2d/0x90
[<ffffffff8141fcad>] netif_receive_skb+0x2d/0x90
[<ffffffff81420123>] ? dev_gro_receive+0x1d3/0x2e0
[<ffffffff8141fe50>] napi_skb_finish+0x50/0x70
[<ffffffff8141fe50>] napi_skb_finish+0x50/0x70
[<ffffffff8142046d>] napi_gro_receive+0xfd/0x130
[<ffffffff8142046d>] napi_gro_receive+0xfd/0x130
[<ffffffffa00d71be>] e1000_receive_skb+0x5e/0x80 [e1000e]
[<ffffffffa00d71be>] e1000_receive_skb+0x5e/0x80 [e1000e]
[<ffffffffa00d7546>] e1000_clean_rx_irq+0x366/0x460 [e1000e]
[<ffffffffa00d7546>] e1000_clean_rx_irq+0x366/0x460 [e1000e]
[<ffffffffa00d95bd>] e1000_poll+0x9d/0x3a0 [e1000e]
[<ffffffffa00d95bd>] e1000_poll+0x9d/0x3a0 [e1000e]
[<ffffffff81420692>] net_rx_action+0x122/0x280
[<ffffffff81420692>] net_rx_action+0x122/0x280
[<ffffffff8106e1b9>] ? run_rebalance_domains+0xb9/0x1a0
[<ffffffff8106e1b9>] ? run_rebalance_domains+0xb9/0x1a0
[<ffffffff8103ccdd>] __do_softirq+0xad/0x1d0
[<ffffffff8103ccdd>] __do_softirq+0xad/0x1d0
[<ffffffff81500d2e>] ? _raw_spin_lock+0xe/0x20
[<ffffffff81500d2e>] ? _raw_spin_lock+0xe/0x20
[<ffffffff81502e9c>] call_softirq+0x1c/0x26
[<ffffffff81502e9c>] call_softirq+0x1c/0x26
[<ffffffff810041d5>] do_softirq+0x65/0xa0
[<ffffffff810041d5>] do_softirq+0x65/0xa0
[<ffffffff8103d05d>] irq_exit+0x6d/0x80
[<ffffffff8103d05d>] irq_exit+0x6d/0x80
[<ffffffff81003dd6>] do_IRQ+0x66/0xe0
[<ffffffff81003dd6>] do_IRQ+0x66/0xe0
[<ffffffff815011ae>] common_interrupt+0x6e/0x6e
[<ffffffff815011ae>] common_interrupt+0x6e/0x6e
<EOI>
<EOI>


[<ffffffff8102639b>] ? native_safe_halt+0xb/0x10
[<ffffffff8102639b>] ? native_safe_halt+0xb/0x10
[<ffffffff81074e36>] ? ktime_get_real+0x16/0x50
[<ffffffff81074e36>] ? ktime_get_real+0x16/0x50
[<ffffffff812eb09e>] acpi_safe_halt+0x2c/0x47
[<ffffffff812eb09e>] acpi_safe_halt+0x2c/0x47
[<ffffffff812eb516>] acpi_idle_enter_c1+0x7a/0xe8
[<ffffffff812eb516>] acpi_idle_enter_c1+0x7a/0xe8
[<ffffffff813e3b3e>] cpuidle_idle_call+0xde/0x210
[<ffffffff813e3b3e>] cpuidle_idle_call+0xde/0x210
[<ffffffff81000a5f>] cpu_idle+0xbf/0xf0
[<ffffffff81000a5f>] cpu_idle+0xbf/0xf0
[<ffffffff814e51e5>] rest_init+0x75/0x80
[<ffffffff814e51e5>] rest_init+0x75/0x80
[<ffffffff818d3bf7>] start_kernel+0x3c3/0x3ce
[<ffffffff818d3bf7>] start_kernel+0x3c3/0x3ce
[<ffffffff818d332b>] x86_64_start_reservations+0x132/0x137
[<ffffffff818d332b>] x86_64_start_reservations+0x132/0x137
[<ffffffff818d3431>] x86_64_start_kernel+0x101/0x110
[<ffffffff818d3431>] x86_64_start_kernel+0x101/0x110
Code:
Code:
48
48
89
89
fa
fa
48
48
85
85
c0
c0
74
74
2b
2b
48
48
8d
8d
3c
3c
bf
bf
48
48
c1
c1
e7
e7
05
05
48
48
81
81
c7
c7
28
28
09
09
20
20
a0
a0
0f
0f
1f
1f
80 00 00 00 00 48 39 f8 0f 84 57 03 00 00 48 89 45 c8 <48> 8b 00 48 85 c0 75 eb 
48 8d 04 92 83 c1 01 89 0d 56 b7 00 00
80 00 00 00 00 48 39 f8 0f 84 57 03 00 00 48 89 45 c8 <48> 8b 00 48 85 c0 75 eb 
48 8d 04 92 83 c1 01 89 0d 56 b7 00 00
