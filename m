From: Deti Fliegl <deti@fliegl.de>
Subject: Re: again oops: conntrack & 2.6.14-git14
Date: Wed, 23 Nov 2005 18:38:12 +0100
Message-ID: <4384A904.4080700@fliegl.de>
References: <43760B97.9010603@fliegl.de> <4380B5B1.9040506@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060601050600040109010405"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4380B5B1.9040506@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060601050600040109010405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Deti Fliegl wrote:
> 
>> This time it seems that I cought the oops in the right place. It's 
>> still happening somewhere in the conntrack code:
> 
> 
> I can't see how this can happen, but I'm looking at 2.6.15-rc2.
> Can you please test again with 2.6.15-rc2 and without ipt_ipp2p
> and other external patches?
Well it does (now on 2.6.15-rc2-git2, without ipt_ipp2p), see log attached.

Deti

--------------060601050600040109010405
Content-Type: text/plain;
 name="bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bug.txt"

Linux version 2.6.15-rc2-git2-smp (root@natomat2) (gcc version 3.3.5 20050117 (prerelease) (SUSE Linux)) #1 SMP Wed Nov 23 08:57:03 CET 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e2000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dffe0000 (usable)
 BIOS-e820: 00000000dffe0000 - 00000000dffef000 (ACPI data)
 BIOS-e820: 00000000dffef000 - 00000000dfffdc00 (ACPI NVS)
 BIOS-e820: 00000000dfffdc00 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec86000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec80400, GSI 48-71
ACPI: IOAPIC (id[0x0b] address[0xfec84000] gsi_base[72])
IOAPIC[3]: apic_id 11, version 32, address 0xfec84000, GSI 72-95
ACPI: IOAPIC (id[0x0c] address[0xfec84400] gsi_base[96])
IOAPIC[4]: apic_id 12, version 32, address 0xfec84400, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
Checking aperture...
Built 1 zonelists
Kernel command line: root=/dev/sda2 selinux=0  splash=silent console=tty0 resume=/dev/sda1  showopts vga=2 console=ttyS0,115200 console=tty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
time.c: Using 3.579545 MHz PM timer.
time.c: Detected 3192.151 MHz processor.
Console: colour VGA+ 80x43
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Placing software IO TLB between 0x5560000 - 0x9560000
Memory: 4048112k/4718592k available (1953k kernel code, 145244k reserved, 1163k data, 192k init)
Calibrating delay using timer specific routine.. 6393.14 BogoMIPS (lpj=12786294)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU0: Thermal monitoring enabled (TM1)
mtrr: v2.0 (20020519)
Using local APIC timer interrupts.
Detected 12.469 MHz APIC timer.
Booting processor 1/4 APIC 0x6
Initializing CPU#1
Calibrating delay using timer specific routine.. 6384.56 BogoMIPS (lpj=12769136)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU1: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 48 cycles, maxerr 1200 cycles)
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 6384.55 BogoMIPS (lpj=12769112)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU2: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
CPU 2: Syncing TSC to CPU 0.
CPU 2: synchronized TSC with CPU 0 (last diff -124 cycles, maxerr 944 cycles)
Booting processor 3/4 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 6384.56 BogoMIPS (lpj=12769136)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU3: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 3.20GHz stepping 01
CPU 3: Syncing TSC to CPU 0.
CPU 3: synchronized TSC with CPU 0 (last diff -9 cycles, maxerr 1136 cycles)
Brought up 4 CPUs
time.c: Using PIT/TSC based timekeeping.
testing NMI watchdog ... OK.
checking if image is initramfs... it is
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
PCI: Using MMCONFIG at e0000000
ACPI: Subsystem revision 20050902
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *5)
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
TC classifier action (bugs to netdev@vger.kernel.org cc hadi@cyberus.ca)
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
PCI: Bridge: 0000:01:00.0
  IO window: disabled.
  MEM window: fcc00000-fccfffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:01:00.2
  IO window: c000-cfff
  MEM window: fcd00000-fcdfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: c000-cfff
  MEM window: fcb00000-fcdfffff
  PREFETCH window: f0000000-fbffffff
PCI: Bridge: 0000:04:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:04:00.2
  IO window: d000-dfff
  MEM window: fcf00000-fcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: d000-dfff
  MEM window: fce00000-fcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: e000-efff
  MEM window: fd000000-febfffff
  PREFETCH window: e2000000-e20fffff
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 169
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 169
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
audit: initializing netlink socket (disabled)
audit(1132741882.880:1): initialized
Total HugeTLB memory allocated, 0
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Real Time Clock Driver v1.12
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
loop: loaded (max 8 devices)
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
Freeing unused kernel memory: 192k freed
SCSI subsystem initialized
megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.6 (Release Date: Mon Mar 07 12:27:22 EST 2005)
megaraid: probe new device 0x1000:0x0407:0x8086:0x0530: bus 2:slot 3:func 0
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 24 (level, low) -> IRQ 177
megaraid: fw version:[413Y] bios version:[H420]
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
  Vendor: ESG-SHV   Model: SCA HSBP M29      Rev: 1.06
  Type:   Processor                          ANSI SCSI revision: 02
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[0]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID1  140G  Rev: 413Y
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 287109120 512-byte hdwr sectors (147000 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 287109120 512-byte hdwr sectors (147000 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2
sd 0:2:0:0: Attached scsi disk sda
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH5: IDE controller at PCI slot 0000:00:1f.1
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 185
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, hdd:DMA
hdd: TOSHIBA CD/DVDW SD-R6472, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Intel(R) PRO/1000 Network Driver - version 6.1.16-k2-NAPI
Copyright (c) 1999-2005 Intel Corporation.
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 54 (level, low) -> IRQ 193
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 20 sharing vector 0xC9 and IRQ 20
ACPI: PCI Interrupt 0000:03:04.1[B] -> GSI 55 (level, low) -> IRQ 201
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
GSI 21 sharing vector 0xD1 and IRQ 21
ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 96 (level, low) -> IRQ 209
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
hdd: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Capability LSM initialized
hw_random hardware driver 1.0.0 loaded
Adding 979924k swap on /dev/sda1.  Priority:42 extents:1 across:979924k
 0:0:6:0: Attached scsi generic sg0 type 3
sd 0:2:0:0: Attached scsi generic sg1 type 0
e1000: extern: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
e1000: mgmt: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
e1000: intern: e1000_watchdog_task: NIC Link is Up 1000 Mbps Full Duplex
ip_tables: (C) 2000-2002 Netfilter core team
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Netfilter messages via NETLINK v0.30.
ip_conntrack version 2.4 (8192 buckets, 65536 max) - 312 bytes per conntrack
i8xx TCO timer: initialized (0x0460). heartbeat=30 sec (nowayout=1)
send_arp uses obsolete (PF_INET,SOCK_PACKET)
NET: Registered protocol family 17


Welcome to SuSE Linux 9.3 (x86-64) - Kernel 2.6.15-rc2-git2-smp (ttyS0).


natomat2 login: <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [1] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcefd40  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 ffff81011fceff00 000000001fcefe68 0000000000000002 
       ffff81011fcefe68 0000000000000000 ffff81011fcefe68 0000000000000000 
       ffff81011fcefe68 ffffffff8015161e 
Call Trace: <IRQ> <ffffffff8015161e>{softlockup_tick+132} <ffffffff80111c3e>{timer_interrupt+503}
       <ffffffff80151687>{handle_IRQ_event+41} <ffffffff80151758>{__do_IRQ+158}
       <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [2] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcefaa8  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcefd90 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fcefc98 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff801302f4>{printk+141} <ffffffff8010e90d>{error_exit+0}
       <ffffffff8010f42d>{show_trace+489} <ffffffff8015161e>{softlockup_tick+132}
       <ffffffff80111c3e>{timer_interrupt+503} <ffffffff80151687>{handle_IRQ_event+41}
       <ffffffff80151758>{__do_IRQ+158} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [3] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcef808  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcefaf8 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fcef9f8 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff801302f4>{printk+141} <ffffffff8010e90d>{error_exit+0}
       <ffffffff8010f42d>{show_trace+489} <ffffffff8015161e>{softlockup_tick+132}
       <ffffffff80111c3e>{timer_interrupt+503} <ffffffff80151687>{handle_IRQ_event+41}
       <ffffffff80151758>{__do_IRQ+158} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [4] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcef568  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcef858 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fcef758 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff801302f4>{printk+141} <ffffffff8010e90d>{error_exit+0}
       <ffffffff8010f42d>{show_trace+489} <ffffffff8015161e>{softlockup_tick+132}
       <ffffffff80111c3e>{timer_interrupt+503} <ffffffff80151687>{handle_IRQ_event+41}
       <ffffffff80151758>{__do_IRQ+158} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [5] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcef2c8  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcef5b8 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fcef4b8 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff801302f4>{printk+141} <ffffffff8010e90d>{error_exit+0}
       <ffffffff8010f42d>{show_trace+489} <ffffffff8015161e>{softlockup_tick+132}
       <ffffffff80111c3e>{timer_interrupt+503} <ffffffff80151687>{handle_IRQ_event+41}
       <ffffffff80151758>{__do_IRQ+158} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [6] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fcef028  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcef318 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fcef218 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff801302f4>{printk+141} <ffffffff8010e90d>{error_exit+0}
       <ffffffff8010f42d>{show_trace+489} <ffffffff8015161e>{softlockup_tick+132}
       <ffffffff80111c3e>{timer_interrupt+503} <ffffffff80151687>{handle_IRQ_event+41}
       <ffffffff80151758>{__do_IRQ+158} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff80110242>{do_IRQ+47} <ffffffff8012acc1>{activate_task+142}
       <ffffffff8010df52>{ret_from_intr+0} <ffffffff8812d09a>{:ip_conntrack:death_by_timeout+0}
       <ffffffff8020effd>{__write_lock_failed+9} <ffffffff802e5270>{.text.lock.spinlock+111}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff80138332>{run_timer_softirq+348} <ffffffff8012b90d>{scheduler_tick+646}
       <ffffffff80134dda>{__do_softirq+102} <ffffffff8010ef53>{call_softirq+31}
        <EOI> <1>Unable to handle kernel paging request at ffffffff82800000 RIP: 
<ffffffff8010f42d>{show_trace+489}
PGD 103027 PUD 105027 PMD 0 
Oops: 0000 [7] SMP 
CPU 2 
Modules linked in: ip_conntrack_netlink ipt_CLASSIFY sch_htb ipt_mark ipt_CONNMARK af_packet ipt_SAME i8xx_tco ipt_state ipt_pkttype ipt_NOTRACK iptable_raw ipt_LOG ipt_limit ipt_hashlimit ip_nat_ftp ip_conntrack_ftp iptable_nat ip_nat ip_conntrack nfnetlink ipt_MARK edd iptable_mangle iptable_filter evdev ip_tables sg sr_mod i2c_i801 i2c_core hw_random capability commoncap ext3 jbd ide_cd cdrom ide_disk e1000 piix ide_core megaraid_mbox megaraid_mm sd_mod scsi_mod
Pid: 8085, comm: conntrack Not tainted 2.6.15-rc2-git2-smp #1
RIP: 0010:[<ffffffff8010f42d>] <ffffffff8010f42d>{show_trace+489}
RSP: 0018:ffff81011fceed88  EFLAGS: 00010002
RAX: 0000000000000000 RBX: bb81be0000000000 RCX: ffffffff803afdf8
RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff803afe40
RBP: ffffffff827ffffb R08: 0000000000000005 R09: 0000000000000001
R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff804be100
FS:  00002aaaab0f6b00(0000) GS:ffffffff80488900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff82800000 CR3: 000000004c83e000 CR4: 00000000000006e0
Process conntrack (pid: 8085, threadinfo ffff810046b60000, task ffff81011d7b37b0)
Stack: 0000000000000100 00ffffff8012f6d1 0000000000000005 ffff81011fcef078 
       000000000000000a ffff81011fceffc0 ffff81011fcebfc0 0000000000000000 
       ffff81011fceef78 ffffffff8010f57f 
Call Trace: <IRQ> <ffffffff8010f57f>{show_stack+210} <ffffffff8010f618>{show_registers+142}
       <ffffffff8010f905>{__die+142} <ffffffff802e5e42>{do_page_fault+1682}
       <ffffffff8012fb98>{release_console_sem+391} <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}
       <ffffffff8010e90d>{error_exit+0} <ffffffff8010f42d>{show_trace+489}
       <ffffffff8010f43d>{show_trace+505} <ffffffff8010f57f>{show_stack+210}
       <ffffffff8010f618>{show_registers+142} <ffffffff8010f905>{__die+142}
       <ffffffff802e5e42>{do_page_fault+1682} <ffffffff8012fb98>{release_console_sem+391}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8812d0aa>{:ip_conntrack:death_by_timeout+16}
       <ffffffff8010ef53>{call_softirq+31} <ffffffff8010ef53>{call_softirq+31}

--------------060601050600040109010405--
