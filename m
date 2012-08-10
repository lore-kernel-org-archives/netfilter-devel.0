From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: nf_ct_expect: fix re-insertion in
 expect list if timer refresh fails
Date: Fri, 10 Aug 2012 11:18:30 +0200
Message-ID: <20120810091830.GA6682@1984>
References: <1344553332-8536-1-git-send-email-pablo@netfilter.org>
 <1344553332-8536-2-git-send-email-pablo@netfilter.org>
 <Pine.GSO.4.63.1208100135090.26308@stinky-local.trash.net>
 <20120810090412.GA1729@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35381 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2HJJSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:18:35 -0400
Content-Disposition: inline
In-Reply-To: <20120810090412.GA1729@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Forgot attachment, sorry. Here it is.

On Fri, Aug 10, 2012 at 11:04:12AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 10, 2012 at 02:00:31AM +0200, Patrick McHardy wrote:
> > On Fri, 10 Aug 2012, pablo@netfilter.org wrote:
> > 
> > >From: Pablo Neira Ayuso <pablo@netfilter.org>
> > >
> > >This patch fixes __nf_ct_expect_check to return 0 in case that the
> > >expectation timer refresh fails. If the expectation is dying, we have
> > >to make sure that we don't re-insert it again in the list.
> > >
> > >This problem becomes more noticeable with permanent expectations, used
> > >by the conntrack SIP helper.
> > >
> > >RIP: 0010:[<ffffffffa00b6ce2>]  [<ffffffffa00b6ce2>] flush_expectations.clone.15+0x72/0x9b
> > >[nf_conntrack_sip]
> > >RSP: 0018:ffff88013fc03970  EFLAGS: 00010246
> > >RAX: 0000000000000000 RBX: dead000000100100 RCX: ffff88011aaced68
> > >RDX: 0000000000000000 RSI: ffff88013fc03950 RDI: ffff88009a411f78
> > >RBP: ffff88013fc03990 R08: dead000000200200 R09: dead000000100100
> > >R10: dead000000200200 R11: ffff88013fc03950 R12: ffff88013fc03a01
> > >R13: 0000000000000001 R14: dead000000100100 R15: 0000000000000157
> > >[...]
> > >[<ffffffffa00b6e6a>] process_invite_response+0x66/0x6b [nf_conntrack_sip]
> > >[<ffffffffa00b65a1>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntrack_sip]
> > >[<ffffffffa00b6e04>] ? process_update_response+0x6b/0x6b [nf_conntrack_sip]
> > >[<ffffffffa00b68a6>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
> > >[<ffffffffa007aa15>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
> > >[<ffffffff812e54bc>] nf_iterate+0x43/0x78
> > >
> > >Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
> > >Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > >---
> > >net/netfilter/nf_conntrack_expect.c |    2 +-
> > >1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > >diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> > >index 45cf602..ec8bb0d 100644
> > >--- a/net/netfilter/nf_conntrack_expect.c
> > >+++ b/net/netfilter/nf_conntrack_expect.c
> > >@@ -398,7 +398,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
> > >	hlist_for_each_entry(i, n, &net->ct.expect_hash[h], hnode) {
> > >		if (expect_matches(i, expect)) {
> > >			/* Refresh timer: if it's dying, ignore.. */
> > >-			if (refresh_timer(i)) {
> > >+			if (!refresh_timer(i)) {
> > >				ret = 0;
> > >				goto out;
> > >			}
> > 
> > Actually that also doesn't look correct. If we managed to refresh
> > the timer (indicated by return value 1), there's nothing left to do
> > and we exit without an error. If the expectation is indeed dying
> > (indicated by return value 0), we continue looking for an alive
> > expectation and if none is found, we try to insert the new one. This
> > basically covers the rare condition that an expectation is dying at
> > the exact moment where a matching one is reinstated.
> 
> You're right.
> 
> > This can't be the problem though, the dying expectation won't vanish
> > while the SIP helper is walking the list since its using RCU for
> > destruction, and the SIP helper will ignore it since the timer can't
> > be deleted twice.
> 
> Yes, I had the same impression by looking at the code, still the dump
> (attached to this email) shows a list corruption while iterating.
> 
> > Is this problem reproducable and are there dumps showing what exactly
> > is happening?
> 
> It's not reproducible (or at least, we don't manage to reproduce it).

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x

general protection fault: 0000 [#1] SMP
CPU 0
Modules linked in: nf_nat_h323 nf_conntrack_h323 ipmi_si ipmi_devintf ipmi_msghandler xt_mac xt_NOTRACK iptable_raw xt_tcpudp xt_TCPMSS xt_string xt_state xt_owner xt_NFQUEUE xt_multiport xt_mark xt_length xt_iprange xt_hl xt_hashlimit xt_DSCP xt_dscp xt_conntrack xt_connmark nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_ftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ftp ipt_REJECT ipt_REDIRECT ipt_LOG xt_addrtype iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables ip6t_rt ip6t_REJECT ip6t_LOG ip6table_mangle ip6table_filter ip6_tables x_tables sit tunnel4 ehci_hcd
Pid: 0, comm: swapper/0 Not tainted 3.3.8 #6 Dell Inc. PowerEdge T110/0V52N7
RIP: 0010:[<ffffffffa00b6ce2>]  [<ffffffffa00b6ce2>] flush_expectations.clone.15+0x72/0x9b [nf_conntrack_sip]
RSP: 0018:ffff88013fc03970  EFLAGS: 00010246
RAX: 0000000000000000 RBX: dead000000100100 RCX: ffff88011aaced68
RDX: 0000000000000000 RSI: ffff88013fc03950 RDI: ffff88009a411f78
RBP: ffff88013fc03990 R08: dead000000200200 R09: dead000000100100
R10: dead000000200200 R11: ffff88013fc03950 R12: ffff88013fc03a01
R13: 0000000000000001 R14: dead000000100100 R15: 0000000000000157
FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f4d2c829230 CR3: 0000000001605000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81600000, task ffffffff8160d020)
Stack:
ffff88013fc03a50 ffff88013fc03a5c ffff88009a7ffa00 0000000000000000
ffff88013fc039b0 ffffffffa00b6e6a ffff88013fc039b0 ffffffff00000001
ffff88013fc03a40 ffffffffa00b65a1 ffff88013fc03a08 ffff88009a7ffa00
Call Trace:
<IRQ>
[<ffffffffa00b6e6a>] process_invite_response+0x66/0x6b [nf_conntrack_sip]
[<ffffffffa00b65a1>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntrack_sip]
[<ffffffffa00b6e04>] ? process_update_response+0x6b/0x6b [nf_conntrack_sip]
[<ffffffffa00b68a6>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
[<ffffffffa007aa15>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
[<ffffffff812e54bc>] nf_iterate+0x43/0x78
[<ffffffff812eedb9>] ? ip_finish_output2+0x1fc/0x1fc
[<ffffffff812e5558>] nf_hook_slow+0x67/0xff
[<ffffffff812eedb9>] ? ip_finish_output2+0x1fc/0x1fc
[<ffffffff812f0182>] ip_output+0x83/0x97
[<ffffffff812eb6d8>] ? inet_del_protocol+0x37/0x37
[<ffffffff812ed018>] ip_forward_finish+0x44/0x48
[<ffffffff812ed2ee>] ip_forward+0x2d2/0x340
[<ffffffff812eb9ca>] ip_rcv_finish+0x2f2/0x316
[<ffffffff812ebfc9>] ip_rcv+0x263/0x292
[<ffffffff812c6fba>] __netif_receive_skb+0x3b9/0x3fb
[<ffffffff812c71e3>] netif_receive_skb+0x71/0x78
[<ffffffff812c72cc>] napi_skb_finish+0x24/0x3c
[<ffffffff812c7814>] napi_gro_receive+0x105/0x112
[<ffffffff812413da>] igb_poll+0x7ca/0xa87
[<ffffffff8107537e>] ? handle_edge_irq+0xc6/0xea
[<ffffffff813758eb>] ? common_interrupt+0x6b/0x6b
[<ffffffff812c7918>] net_rx_action+0x6a/0x126
[<ffffffff8103ef5e>] __do_softirq+0x85/0x10f
[<ffffffff8137714c>] call_softirq+0x1c/0x30
[<ffffffff81003496>] do_softirq+0x33/0x69
[<ffffffff8103f195>] irq_exit+0x44/0x9c
[<ffffffff810033c3>] do_IRQ+0x98/0xaf
[<ffffffff813758eb>] common_interrupt+0x6b/0x6b
<EOI>
  [<ffffffff811a200d>] ? intel_idle+0xdf/0x105
[<ffffffff811a1fec>] ? intel_idle+0xbe/0x105
[<ffffffff812a44c2>] cpuidle_idle_call+0x8d/0xcd
[<ffffffff810008c4>] cpu_idle+0x5a/0x83
[<ffffffff816975f0>] ? firmware_map_add_hotplug+0x9f/0x9f
[<ffffffff81366064>] rest_init+0x68/0x6a
[<ffffffff816649ec>] start_kernel+0x290/0x29b
[<ffffffff81664274>] x86_64_start_reservations+0x84/0x89
[<ffffffff8166436b>] x86_64_start_kernel+0xf2/0xf9
Code: 06 cc f8 e0 85 c0 74 19 31 d2 31 f6 48 89 df e8 e2 22 fb ff 48 89 df e8 b3 22 fb ff 45 84 e4 74 1e 4c 89 f3 48 85 db 74 16 31 c0 <4c> 8b 33 83 bb d0 00 00 00 00 0f 95 c0 44 39 e8 75 e4 eb bc 48
RIP  [<ffffffffa00b6ce2>] flush_expectations.clone.15+0x72/0x9b [nf_conntrack_sip]
RSP <ffff88013fc03970>
---[ end trace 8ace9d28d6287483 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 15 seconds..Linux version 3.3.8 (root@cerber) (gcc version 4.5.3 (Gentoo Hardened 4.5.3-r2 p1.1, pie-0.4.7) ) #6 SMP Thu Jun 28 13:06:41 CEST 2012
Command line: ro md=1,/dev/sda1,/dev/sdb1 root=/dev/md1 panic=15 rootflags=data=journal,barrier=1 console=ttyS0,115200 console=tty0
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
BIOS-e820: 0000000000100000 - 00000000bf699000 (usable)
BIOS-e820: 00000000bf699000 - 00000000bf6af000 (reserved)
BIOS-e820: 00000000bf6af000 - 00000000bf6ce000 (ACPI data)
BIOS-e820: 00000000bf6ce000 - 00000000c0000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
NX (Execute Disable) protection: active
DMI 2.6 present.
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbf699 max_arch_pfn = 0x400000000
init_memory_mapping: 0000000000000000-00000000bf699000
init_memory_mapping: 0000000100000000-0000000140000000
ACPI: RSDP 00000000000f1220 00024 (v02 DELL  )
ACPI: XSDT 00000000000f1320 00094 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: FACP 00000000bf6c3bb4 000F4 (v03 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DSDT 00000000bf6af000 039A4 (v01 DELL   PE_SC3   00000001 INTL 20050624)
ACPI: FACS 00000000bf6c6000 00040
ACPI: APIC 00000000bf6c3478 00152 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SPCR 00000000bf6c35cc 00050 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HPET 00000000bf6c3620 00038 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: DM__ 00000000bf6c365c 000A8 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: MCFG 00000000bf6c3850 0003C (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: WD__ 00000000bf6c3890 00134 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SLIC 00000000bf6c39c8 00024 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: ERST 00000000bf6b2b24 00270 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: HEST 00000000bf6b2d94 003A8 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: BERT 00000000bf6b29a4 00030 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: EINJ 00000000bf6b29d4 00150 (v01 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: TCPA 00000000bf6c3b4c 00064 (v02 DELL   PE_SC3   00000001 DELL 00000001)
ACPI: SSDT 00000000bf6c7000 011C4 (v01  INTEL PPM RCM  80000001 INTL 20061109)
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
   Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
Early memory PFN ranges
     0: 0x00000010 -> 0x0000009d
     0: 0x00000100 -> 0x000bf699
     0: 0x00100000 -> 0x00140000
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x24] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x25] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x26] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x27] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x28] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x29] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x2a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x2b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x2f] disabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x30] disabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x31] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x32] disabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x33] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x34] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x35] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x36] disabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x37] disabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x38] disabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x39] disabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x3a] disabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x3b] disabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3c] disabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3d] disabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] disabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x3f] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s70528 r8192 d23680 u524288
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1025572
Kernel command line: ro md=1,/dev/sda1,/dev/sdb1 root=/dev/md1 panic=15 rootflags=data=journal,barrier=1 console=ttyS0,115200 console=tty0
md: Will configure md1 (super-block) from /dev/sda1,/dev/sdb1, below.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 4038332k/5242880k available (3557k kernel code, 1058664k absent, 145884k reserved, 2910k data, 464k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:712 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 2394.017 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.03 BogoMIPS (lpj=23940170)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20120111
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz stepping 05
Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
CPU erratum AAJ80 worked around
CPUID marked event: 'bus cycles' unavailable
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
NMI watchdog enabled, takes one hw-pmu counter.
#2
NMI watchdog enabled, takes one hw-pmu counter.
#3 Ok.
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 4 CPUs
Total of 4 processors activated (19152.13 BogoMIPS).
xor: automatically using best checksumming function: generic_sse
    generic_sse:  8963.200 MB/sec
xor: using function: generic_sse (8963.200 MB/sec

--FL5UXtIhxfXey3p5--
