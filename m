From: Ramesh M <rameshandram@gmail.com>
Subject: (unknown)
Date: Fri, 26 Oct 2012 10:29:16 +0530
Message-ID: <CABx-mUmVbY+6b2wcpP74eYCccoBg7VyyHGyUw5kMMy2S=PT-EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36108 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2JZE7R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:59:17 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so2275922obb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Oct 2012 21:59:16 -0700 (PDT)
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Team,

I am getting the below panic message when i enable NAT in linux kernel
2.6.31 running on mips based SOC board.

could you please let me know if you this issue already FIXED or root
caused  somewhere ??


Thanks for your help


Regards
Ramesh


Unhandled kernel unaligned access or invalid instruction[#1]:
Cpu 0
$ 0   : 00000000 00000000 804f3172 0000005c
$ 4   : 8797c8c0 0000001c 879a32e4 00000001
$ 8   : 00000028 800fdf48 00000014 37987883
$12   : 185a5616 80256a20 05491623 edf4c4c3
$16   : 00000006 0000001c 00000014 879a32e4
$20   : 8797c8c0 00000001 879a32d8 879cec00
$24   : 00000000 80193958
$28   : 87824000 87825a50 8797c8c0 801e5074
Hi    : 00000388
Lo    : 00000000
epc   : 801e6b60 tcp_manip_pkt+0x3c/0x11c
    Not tainted
ra    : 801e5074 manip_pkt+0x70/0x14c
Status: 1100ff03    KERNEL EXL IE
Cause : 00800010
BadVA : 804f318e
PrId  : 00019750 (MIPS 74Kc)
Modules linked in: athrs_gmac
Process ksoftirqd/0 (pid: 3, threadinfo=87824000, task=87817198, tls=00000000)
Stack : 185a5616 80256a20 05491623 edf4c4c3 804f3186 8797c8c0 804f3172 00000006
        8797c8c0 0000001c 879a32e4 00000001 00000001 801e5074 87825b10 8111ae50
        87824000 87825ab8 8797c8c0 801e527c 804f3186 8797c8c0 879a32e4 00000014
        00000000 801e52cc 8797c8c0 87825c08 8797c8c0 00000001 00000001 87825ad8
        802cb970 802c6aa0 c0a80115 00000000 00000000 00000000 052c0002 0a34f48c
        ...
Call Trace:
[<801e6b60>] tcp_manip_pkt+0x3c/0x11c
[<801e5074>] manip_pkt+0x70/0x14c
[<801e52cc>] nf_nat_icmp_reply_translation+0x17c/0x26c
[<801eb8bc>] nf_nat_fn+0x100/0x1d8
[<801ebae0>] nf_nat_out+0x48/0xe8
[<8018a174>] nf_iterate+0x84/0xf8
[<8018a378>] nf_hook_slow+0x94/0x130
[<801b4d94>] ip_output+0xac/0xd8
[<801b401c>] ip_push_pending_frames+0x2e8/0x378
[<801d6c98>] icmp_send+0x524/0x58c
[<801a9ff4>] ipv4_link_failure+0x20/0x60
[<801d41dc>] arp_error_report+0x38/0x4c
[<8017cf00>] neigh_invalidate+0x94/0xb8
[<8017e8e0>] neigh_timer_handler+0x1f8/0x448
[<8002d708>] run_timer_softirq+0x14c/0x1d8
[<80029248>] __do_softirq+0xb0/0x144
[<80029324>] do_softirq+0x48/0x6c
[<800293a8>] ksoftirqd+0x60/0xf0
[<80037c4c>] kthread+0x7c/0x88
[<800085ec>] kernel_thread_helper+0x10/0x18

Code: afbf0034  8c8200a8  8c830054 <7c45100a> 7c421e00  00021080
00458021  26020014  0062182b
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt
