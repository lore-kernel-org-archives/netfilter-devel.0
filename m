From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: kernel crash in netlink_sock_destruct()
Date: Tue, 17 Nov 2015 13:49:18 +0100
Message-ID: <CAOkSjBgsSapxsCeFA6W-BfSZ3SUjr9mxQ3z6F-ABsrY8yb7veg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37117 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbbKQMtk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Nov 2015 07:49:40 -0500
Received: by wmww144 with SMTP id w144so24238589wmw.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2015 04:49:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've found this in a machine I'm using to play with nftables.

The kernel is 4.2, so not sure if already fixed.

[mar nov 17 13:39:07 2015] ------------[ cut here ]------------
[mar nov 17 13:39:07 2015] WARNING: CPU: 0 PID: 0 at
/home/zumbi/linux-4.2.5/net/netlink/af_netlink.c:946
netlink_sock_destruct+0x103/0x140()
[mar nov 17 13:39:07 2015] Modules linked in: nf_conntrack_netlink
hid_generic usbhid hid binfmt_misc nft_counter nft_meta
nf_conntrack_ipv6 nf_defrag_ipv6 nft_ct nft_hash nft_rbtree nft_nat
nft_chain_nat_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
nf_conntrack nf_tables_inet nf_tables_ipv6 nf_tables_ipv4 nf_tables
nfnetlink bonding coretemp kvm_intel amdkfd evdev kvm radeon iTCO_wdt
iTCO_vendor_support ppdev ttm drm_kms_helper psmouse serio_raw pcspkr
drm i2c_i801 i2c_algo_bit ipmi_si lpc_ich i3000_edac mfd_core
ipmi_msghandler parport_pc edac_core 8250_fintek parport rng_core
shpchp button acpi_cpufreq processor thermal_sys autofs4 ext4 crc16
mbcache jbd2 dm_mirror dm_region_hash dm_log dm_mod sg sd_mod
ata_generic ata_piix ahci libahci libata scsi_mod ehci_pci floppy
e1000e ptp pps_core uhci_hcd
[mar nov 17 13:39:07 2015]  ehci_hcd usbcore usb_common
[mar nov 17 13:39:07 2015] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G
    W       4.2.0-0.bpo.1-amd64 #1 Debian 4.2.5-1~bpo8+1
[mar nov 17 13:39:07 2015] Hardware name: MAXDATA PLATINUM 300 IR M7
/S3000AHV, BIOS S3000.86B.02.00.0044.071120071047 07/11/2007
[mar nov 17 13:39:07 2015]  0000000000000000 ffffffff81853cc8
ffffffff81552eb1 0000000000000000
[mar nov 17 13:39:07 2015]  ffffffff8106fa01 ffff8800d916e800
ffff88011fc165b0 000000000000000a
[mar nov 17 13:39:07 2015]  0000000000000001 ffff8800da8bfaa0
ffffffff8148f023 0000000000000000
[mar nov 17 13:39:07 2015] Call Trace:
[mar nov 17 13:39:07 2015]  <IRQ>  [<ffffffff81552eb1>] ? dump_stack+0x=
40/0x50
[mar nov 17 13:39:07 2015]  [<ffffffff8106fa01>] ?
warn_slowpath_common+0x81/0xb0
[mar nov 17 13:39:07 2015]  [<ffffffff8148f023>] ?
netlink_sock_destruct+0x103/0x140
[mar nov 17 13:39:07 2015]  [<ffffffff8144dc0a>] ? sk_destruct+0x1a/0x1=
20
[mar nov 17 13:39:07 2015]  [<ffffffff810ca05a>] ?
rcu_process_callbacks+0x20a/0x5a0
[mar nov 17 13:39:07 2015]  [<ffffffff8101c645>] ? read_tsc+0x5/0x10
[mar nov 17 13:39:07 2015]  [<ffffffff81073aa7>] ? __do_softirq+0x107/0=
x270
[mar nov 17 13:39:07 2015]  [<ffffffff81073d82>] ? irq_exit+0x92/0xa0
[mar nov 17 13:39:07 2015]  [<ffffffff8155b37e>] ?
smp_apic_timer_interrupt+0x3e/0x50
[mar nov 17 13:39:07 2015]  [<ffffffff8155955b>] ?
apic_timer_interrupt+0x6b/0x70
[mar nov 17 13:39:07 2015]  <EOI>  [<ffffffff8101dc86>] ? mwait_idle+0x=
b6/0x150
[mar nov 17 13:39:07 2015]  [<ffffffff810abf5b>] ? cpu_startup_entry+0x=
2eb/0x350
[mar nov 17 13:39:07 2015]  [<ffffffff81b2af5e>] ? start_kernel+0x480/0=
x48b
[mar nov 17 13:39:07 2015]  [<ffffffff81b2a120>] ?
early_idt_handler_array+0x120/0x120
[mar nov 17 13:39:07 2015]  [<ffffffff81b2a120>] ?
early_idt_handler_array+0x120/0x120
[mar nov 17 13:39:07 2015]  [<ffffffff81b2a605>] ?
x86_64_start_kernel+0x148/0x157
[mar nov 17 13:39:07 2015] ---[ end trace 9424a28950df2909 ]---


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
