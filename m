From: "Jacky Luk" <jacky.luk@primecreation.com>
Subject: About the kernel panic using the ip_queue!
Date: Sat, 20 Sep 2008 18:30:38 +0800
Message-ID: <web-4539790@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n218103092061.netvigator.com ([218.103.92.61]:51289 "EHLO
	mail.primecreation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYITLdi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:33:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using the ip_queue to copy the packets to the 
userspace to perform some modification in the system which 
is installed the Red Hat Enterprise Linux ES release 4 
Nahant Update 6 (Kernel: 2.6.9-67.ELsmp). This system has 
six NIC ports and forms three bondings (Two ports to form 
one bonding). Therefore, two of the bondings would be used 
to handle the packet modification. They are belonged to 
different network and subnets. One of the bonding is 
belonged to 192.168.0.x and the other one is belonged to 
192.168.1.x.

I have discovered that the system would be freezed under 
the high traffic loading in certain time. The following is 
the error message which is captured from the 
/var/log/message:

Sep 19 02:25:28 NEIPPROXY02 kernel: Unable to handle 
kernel NULL pointer dereference at virtual address 
00000008
Sep 19 02:25:28 NEIPPROXY02 kernel:  printing eip:
Sep 19 02:25:28 NEIPPROXY02 kernel: c0164e31
Sep 19 02:25:28 NEIPPROXY02 kernel: *pde = 0fc07001
Sep 19 02:25:28 NEIPPROXY02 kernel: Oops: 0000 [#1]
Sep 19 02:25:28 NEIPPROXY02 kernel: SMP
Sep 19 02:25:28 NEIPPROXY02 kernel: Modules linked in: 
ip_queue iptable_mangle iptable_nat ip_conntrack 
iptable_filter ip_tables ip_vs_wrr ipmi_devintf ipmi_si 
ipmi_msghandler ip_vs autofs4 i2c_dev i2c_core
sunrpc arpt_mangle arptable_filter arp_tables md5 ipv6 
dm_mirror dm_mod joydev button battery ac ehci_hcd 
uhci_hcd e1000 bnx2 bonding(U) ata_piix libata ext3 jbd 
cciss sd_mod scsi_mod
Sep 19 02:25:28 NEIPPROXY02 kernel: CPU:    1
Sep 19 02:25:28 NEIPPROXY02 kernel: EIP: 
   0060:[<c0164e31>]    Not tainted VLI
Sep 19 02:25:28 NEIPPROXY02 kernel: EFLAGS: 00010246 
  (2.6.9-67.ELsmp)
Sep 19 02:25:28 NEIPPROXY02 kernel: EIP is at 
flush_old_exec+0x178/0x24c
Sep 19 02:25:28 NEIPPROXY02 kernel: eax: 00000000   ebx: 
c423f000   ecx: 00000000   edx: 00000004
Sep 19 02:25:28 NEIPPROXY02 kernel: esi: c423f000   edi: 
f729e200   ebp: f7d13800   esp: c423fec8
Sep 19 02:25:28 NEIPPROXY02 kernel: ds: 007b   es: 007b 
  ss: 0068
Sep 19 02:25:28 NEIPPROXY02 kernel: Process cmdline (pid: 
22943, threadinfo=c423f000 task=d82394b0)
Sep 19 02:25:28 NEIPPROXY02 kernel: Stack: 6c646d63 
00656e69 00000080 f7fdd780 00000000 00000001 ffffffb0 
00000001
Sep 19 02:25:28 NEIPPROXY02 kernel:        c0180cfa 
c032f580 c38672c0 f7fdd780 00000000 00000000 00000000 
00000000
Sep 19 02:25:28 NEIPPROXY02 kernel:        00000000 
ffffffff 000000d2 00000006 00000003 00000000 00000000 
00000002
Sep 19 02:25:28 NEIPPROXY02 kernel: Call Trace:
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c0180cfa>] 
load_elf_binary+0x56f/0xc5b
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c016466d>] 
copy_strings+0x22b/0x235
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c018078b>] 
load_elf_binary+0x0/0xc5b
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c01657cf>] 
search_binary_handler+0xb7/0x22a
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c0165aaf>] 
do_execve+0x16d/0x1fd
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c01049d5>] 
sys_execve+0x2b/0x8a
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c02d8607>] 
syscall_call+0x7/0xb
Sep 19 02:25:28 NEIPPROXY02 kernel:  [<c02d007b>] 
xfrm_policy_netlink+0x20/0x93
Sep 19 02:25:28 NEIPPROXY02 kernel: Code: b6 81 4c 01 00 
00 24 fc 08 d0 88 81 4c 01 00 00 8b 03 c7 80 88 00 00 00 
00 00 00 00 eb 4c 8b 85 0c 01 00 00 31 c9 ba 04 00 00 00 
<8b> 40 08 8b 40 10 e8 39 25 00 00 8
5 c0 75 09 f6 85 38 01 00 00
Sep 19 02:25:28 NEIPPROXY02 kernel:  <0>Fatal exception: 
panic in 5 seconds
Sep 19 23:47:50 NEIPPROXY02 syslogd 1.4.1: restart.
Sep 19 23:47:50 NEIPPROXY02 syslog: syslogd startup 
succeeded
Sep 19 23:47:50 NEIPPROXY02 kernel: klogd 1.4.1, log 
source = /proc/kmsg started.
Sep 19 23:47:50 NEIPPROXY02 kernel: Linux version 
2.6.9-67.ELsmp (brewbuilder@ls20-bc1-14.build.redhat.com) 
(gcc version 3.4.6 20060404 (Red Hat 3.4.6-8)) #1 SMP Wed 
Nov 7 13:58:04 EST 2007
Sep 19 23:47:50 NEIPPROXY02 kernel: BIOS-provided physical 
RAM map:
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
0000000000000000 - 000000000009f400 (usable)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
000000000009f400 - 00000000000a0000 (reserved)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000000f0000 - 0000000000100000 (reserved)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
0000000000100000 - 00000000cfe56000 (usable)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000cfe56000 - 00000000cfe5e000 (ACPI data)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000cfe5e000 - 00000000cfe5f000 (usable)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000cfe5f000 - 00000000d0000000 (reserved)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000e0000000 - 00000000f0000000 (reserved)
Sep 19 23:47:50 NEIPPROXY02 kernel:  BIOS-e820: 
00000000fec00000 - 00000000fed00000 (reserved)

In addition, the following is the iptables configuration 
to make the wanted packets to jump to the QUEUE target to 
perform the packet modification:
1. iptables -t mangle -A FORWARD -j QUEUE -i bond2 -s 
192.168.0.0/24 -p udp
2. iptables -t mangle -A PREROUTING -j QUEUE -i bond1 -d 
192.168.1.0/24 -p udp

What is the reason to cause the system to be freezed in 
such case? Also, could you suggest the solution to solve 
this freezing problem?

Thank you very much!

Regards,

Jacky Luk
