From: jp@skylan.sk
Subject: xtables-addons: pknock extension crashes the kernel
Date: Sat, 29 Jan 2011 20:12:12 +0100 (CET)
Message-ID: <59618.87.244.225.21.1296328332.squirrel@mail.atlantis.sk>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50230 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752634Ab1A2TSv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:18:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am using gentoo, hardened build, kernel version 2.6.34-r6. The pknock
module does not load, instead, it crashes. GCC version is 4.4.4-r2,
iptables version 1.4.10. Tried all xtables-addons versions from 1.28 to
newest 1.32, same result for all builds.

BUG: unable to handle kernel NULL pointer dereference at 000000000000002e
IP: [<ffffffffa002c0a3>]
PGD 7cae4066
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/0000:03:04.0/net/eth0/broadcast
CPU 1
Modules linked in: xt_pknock(+) compat_xtables nf_conntrack_ftp [last
unloaded: compat_xtables]

Pid: 8772, comm: modprobe Not tainted 2.6.34-hardened-r6 #3 /ProLiant
DL320 G5p
RIP: 0010:[<ffffffffa002c0a3>]  [<ffffffffa002c0a3>]
RSP: 0018:ffff880072d4ff18  EFLAGS: 00010282
RAX: fffffffffffffffe RBX: ffffffffa002c000 RCX: 0000000000000000
RDX: 0000000000000014 RSI: 0000000000000282 RDI: ffff88007ced7c00
RBP: ffff880072d4ff18 R08: 0000000000000000 R09: 00000000ffffff02
R10: ffff88000197f230 R11: 00000000ffffff02 R12: 0000000000000000
R13: 000000607b319b90 R14: 0000000000000003 R15: 0000000000000000
FS:  000002ea04114700(0000) GS:ffff880001a40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000002e CR3: 0000000001655000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 8772, threadinfo ffff880072d4e000, task
ffff88007f04a190)
Stack:
 ffff880072d4ff48 ffffffff810001d7 0000000000000003 ffffffffa00240c0
<0> 0000000000005833 000000607b319b90 ffff880072d4ff78 ffffffff8106e716
<0> 0000000000004010 000000607b319c00 000000607b319b90 000000607b328110
Call Trace:
 [<ffffffff810001d7>]
 [<ffffffff8106e716>]
 [<ffffffff81002c80>]
Code: e8 83 63 13 e1 48 89 05 a4 7f ff ff 48 85 c0 75 1a 48 8b 35 90 7f ff
ff 48 c7 c7 60 90 02 a0 e8 22 31 39 e1 b8 fa ff ff ff eb 58 <8b> 50 30 48
8b 35 4b 00 95 e1 89 15 7d 7f ff ff 48 89 05 7e 7f
RIP  [<ffffffffa002c0a3>]
 RSP <ffff880072d4ff18>
CR2: 000000000000002e
---[ end trace b6967d742232c755 ]---

