From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 7 Jun 2008 16:58:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806071656190.10202@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl> <484A788C.3000205@trash.net>
 <484A798C.6000608@trash.net> <Pine.LNX.4.64.0806071540490.14796@bizon.gios.gov.pl>
 <484A9303.5030407@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1412121972-1212850710=:10202"
Cc: netfilter-devel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:33082 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYFGO7U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:59:20 -0400
In-Reply-To: <484A9303.5030407@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1412121972-1212850710=:10202
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 7 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> On Sat, 7 Jun 2008, Patrick McHardy wrote:
>>> In case its not, does that kernel include commit 86577c661?
>>=20
>> No, it does not but unfortunately this fix does not solve the crash.=20
>> However, before you spend too much time on this I'll check 2.6.25.6 and=
=20
>> 2.6.26-rc to make sure this problem has not been solved already.
>
> Thanks, please let me know how it turns out.

Clean 2.6.26-rc5 kernel, no additional patches at all.

BUG: unable to handle kernel NULL pointer dereference at 00000032
IP: [<c03d930e>] nf_nat_setup_info+0x219/0x57f
*pde =3D 00000000=20
Oops: 0000 [#1] PREEMPT SMP

Pid: 1414, comm: conntrackd Not tainted (2.6.26-rc5 #1)
EIP: 0060:[<c03d930e>] EFLAGS: 00010282 CPU: 1
EIP is at nf_nat_setup_info+0x219/0x57f
EAX: c05bd47c EBX: f754bcc4 ECX: 0000000c EDX: 00000000
ESI: 0000019e EDI: f1c49bb4 EBP: f1c49bc8 ESP: f1c49b78
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process conntrackd (pid: 1414, ti=3Df1c48000 task=3Df7d31030 task.ti=3Df1c4=
8000)
Stack: 00000000 f1c49c2c f322b7fc 00000008 0005caaa f1c49bac 0005caaa c0138=
e70
        0552215c 00000000 117334e0 00005102 c2012108 3aaf4108 0000002c 0000=
0000
        c0139bdc 3aa00780 f50b3474 f1c49c04 00000008 c038e728 0000000a f50b=
3474=20
Call Trace:
  [<c0138e70>] clockevents_program_event+0xca/0xd9
  [<c0139bdc>] tick_program_event+0x30/0x4f
  [<c038e728>] nla_parse+0x5c/0xb0
  [<c039801f>] ctnetlink_change_status+0x190/0x1c6
  [<c03982f0>] ctnetlink_new_conntrack+0x189/0x61f
  [<c0108346>] read_tsc+0x6/0x22
  [<c01367c4>] getnstimeofday+0x32/0xad
  [<c03902d1>] nfnetlink_rcv_msg+0xc1/0xd8
  [<c0390228>] nfnetlink_rcv_msg+0x18/0xd8
  [<c0390210>] nfnetlink_rcv_msg+0x0/0xd8
  [<c038d2ce>] netlink_rcv_skb+0x2d/0x71
  [<c0390205>] nfnetlink_rcv+0x19/0x24
  [<c038d0f5>] netlink_unicast+0x1b3/0x216
  [<c038d892>] netlink_sendmsg+0x237/0x244
  [<c035cf39>] sock_sendmsg+0xb8/0xd1
  [<c013223c>] autoremove_wake_function+0x0/0x2b
  [<c013223c>] autoremove_wake_function+0x0/0x2b
  [<c035d7a0>] sys_sendto+0xfc/0x127
  [<c014f90e>] __pagevec_lru_add_active+0x99/0xa4
  [<c0152909>] __inc_zone_state+0x10/0x61
  [<c045c854>] _spin_unlock+0xc/0x1f
  [<c015421a>] do_wp_page+0x3e7/0x440
  [<c035e02d>] sys_socketcall+0x106/0x196
  [<c0103946>] syscall_call+0x7/0xb
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: e8 25 4e d4 ff 89 e0 25 00 e0 ff ff f6 40 08 04 74 48 e8 2f 1c 08 00 =
eb 41 8b 1b 85 db 74 1d 8b 03 0f 18 00 90 8b 53 18 8d 4a 0c <8a> 41 26 3a 8=
4 24 8a 00 00 00 75 e2 e9 09 ff ff ff b8 01 00 00=20
EIP: [<c03d930e>] nf_nat_setup_info+0x219/0x57f SS:ESP 0068:f1c49b78
---[ end trace 5de3919242e64ed5 ]---
note: conntrackd[1414] exited with preempt_count 1
BUG: scheduling while atomic: conntrackd/1414/0x10000002
Pid: 1414, comm: conntrackd Tainted: G      D   2.6.26-rc5 #1
  [<c045a96f>] schedule+0x9b/0x60b
  [<c015ba07>] free_pages_and_swap_cache+0x6a/0x7e
  [<c011ed44>] __cond_resched+0xf/0x27
  [<c045b00e>] _cond_resched+0x21/0x2a
  [<c0154845>] unmap_vmas+0x47e/0x551
  [<c01573c7>] exit_mmap+0x70/0xf8
  [<c012162a>] mmput+0x1c/0x7e
  [<c0125b4c>] do_exit+0x1dc/0x572
  [<c0104ccb>] die+0x11f/0x124
  [<c01143bf>] do_page_fault+0x4ae/0x567
  [<c01367c4>] getnstimeofday+0x32/0xad
  [<c0113f11>] do_page_fault+0x0/0x567
  [<c045cb3a>] error_code+0x72/0x78
  [<c03d930e>] nf_nat_setup_info+0x219/0x57f
  [<c0138e70>] clockevents_program_event+0xca/0xd9
  [<c0139bdc>] tick_program_event+0x30/0x4f
  [<c038e728>] nla_parse+0x5c/0xb0
  [<c039801f>] ctnetlink_change_status+0x190/0x1c6
  [<c03982f0>] ctnetlink_new_conntrack+0x189/0x61f
  [<c0108346>] read_tsc+0x6/0x22
  [<c01367c4>] getnstimeofday+0x32/0xad
  [<c03902d1>] nfnetlink_rcv_msg+0xc1/0xd8
  [<c0390228>] nfnetlink_rcv_msg+0x18/0xd8
  [<c0390210>] nfnetlink_rcv_msg+0x0/0xd8
  [<c038d2ce>] netlink_rcv_skb+0x2d/0x71
  [<c0390205>] nfnetlink_rcv+0x19/0x24
  [<c038d0f5>] netlink_unicast+0x1b3/0x216
  [<c038d892>] netlink_sendmsg+0x237/0x244
  [<c035cf39>] sock_sendmsg+0xb8/0xd1
  [<c013223c>] autoremove_wake_function+0x0/0x2b
  [<c013223c>] autoremove_wake_function+0x0/0x2b
  [<c035d7a0>] sys_sendto+0xfc/0x127
  [<c014f90e>] __pagevec_lru_add_active+0x99/0xa4
  [<c0152909>] __inc_zone_state+0x10/0x61
  [<c045c854>] _spin_unlock+0xc/0x1f
  [<c015421a>] do_wp_page+0x3e7/0x440
  [<c035e02d>] sys_socketcall+0x106/0x196
  [<c0103946>] syscall_call+0x7/0xb
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1412121972-1212850710=:10202--
