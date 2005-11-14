From: Krzysztof Oledzki <olenf@ans.pl>
Subject: kernel BUG at kernel/sched.c:2833!
Date: Mon, 14 Nov 2005 10:50:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1895894468-1131961823=:8729"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1895894468-1131961823=:8729
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

------------[ cut here ]------------
kernel BUG at kernel/sched.c:2833!
invalid operand: 0000 [#1]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[sub_preempt_count+53/64]    Not tainted VLI
EFLAGS: 00010206   (2.6.14.2)
EIP is at sub_preempt_count+0x35/0x40
eax: dccff000   ebx: dcf502a4   ecx: 00000000   edx: 000000ff
esi: dcf501e8   edi: 00000100   ebp: dccffc9c   esp: dccffc9c
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 373, threadinfo=3Ddccff000 task=3Ddccaa5c0)
Stack: dd284278 c011f1f9 dcf502a4 dcf501e8 00000100 dd284278 c03564f5 df2ef=
b60
        00000175 4378576a 00000000 00000001 dcf501e8 df2efb60 df2efb60 dd28=
4260
        dd56a600 c0311968 df2efb60 dd284260 00000000 000000d0 dd56a600 dccf=
fd48
Call Trace:
  [local_bh_enable+25/144] local_bh_enable+0x19/0x90
  [ctnetlink_dump_table+149/272] ctnetlink_dump_table+0x95/0x110
  [netlink_dump+88/512] netlink_dump+0x58/0x200
  [netlink_recvmsg+558/576] netlink_recvmsg+0x22e/0x240
  [netlink_sendskb+50/96] netlink_sendskb+0x32/0x60
  [sock_recvmsg+254/288] sock_recvmsg+0xfe/0x120
  [update_atime+149/176] update_atime+0x95/0xb0
  [sock_sendmsg+229/256] sock_sendmsg+0xe5/0x100
  [autoremove_wake_function+0/96] autoremove_wake_function+0x0/0x60
  [sys_recvmsg+323/512] sys_recvmsg+0x143/0x200
  [lru_cache_add_active+57/112] lru_cache_add_active+0x39/0x70
  [do_anonymous_page+250/352] do_anonymous_page+0xfa/0x160
  [do_no_page+105/816] do_no_page+0x69/0x330
  [copy_from_user+70/144] copy_from_user+0x46/0x90
  [sys_socketcall+591/608] sys_socketcall+0x24f/0x260
  [do_page_fault+0/1501] do_page_fault+0x0/0x5dd
  [syscall_call+7/11] syscall_call+0x7/0xb
Code: 89 e5 3b 50 14 7f 24 81 fa fe 00 00 00 76 0c b8 00 f0 ff ff 21 e0 29 =
50 14 c9 c3 80 78 14 00 75 ee 0f 0b 15 0b 37 8e 3b c0 eb e4 <0f> 0b 11 0b 3=
7 8e 3b c0 eb d2 90 55 89 e5 8b 45 08 8b 50 04 89


AFAIK there were some small fixes that went into 2.6.15-rc1 which were=20
supposed to fix such problems with conntrack -L. Shuldn't we send them to=
=20
-stable to make 2.6.14.x also usable?


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki

---187430788-1895894468-1131961823=:8729--
