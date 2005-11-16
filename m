From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Wed, 16 Nov 2005 22:16:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1347514265-1132175818=:16387"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437882BE.6080705@eurodev.net>
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

---187430788-1347514265-1132175818=:16387
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 14 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> EIP is at sub_preempt_count+0x35/0x40
>>
>> AFAIK there were some small fixes that went into 2.6.15-rc1 which were
>> supposed to fix such problems with conntrack -L. Shuldn't we send them
>> to -stable to make 2.6.14.x also usable?
>
> I think so, at the least Yasuyuki's:
> [NETFILTER] refcount leak of proto when ctnetlink dumping tuple
>
> That fixes the problem that you're reporting.

What about this one?

------------[ cut here ]------------
kernel BUG at kernel/sched.c:2833!
invalid operand: 0000 [#2]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[sub_preempt_count+53/64]    Not tainted VLI
EFLAGS: 00010206   (2.6.14.2)
EIP is at sub_preempt_count+0x35/0x40
eax: daa35000   ebx: daecaec0   ecx: 00000000   edx: 000000ff
esi: daecae04   edi: 00000e5d   ebp: daa35c9c   esp: daa35c9c
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 1403, threadinfo=3Ddaa35000 task=3Ddc3ca0b0)
Stack: ded31fb8 c011f1f9 daecaec0 daecae04 00000e5d ded31fb8 c0356565 da1cd=
260
        0000057b 43790384 00000000 00000001 daecae04 da1cd260 da1cd260 ded3=
1fa0
        dbc5dc00 c03119a8 da1cd260 ded31fa0 00000000 000000d0 dbc5dc00 daa3=
5d48
Call Trace:
  [local_bh_enable+25/144] local_bh_enable+0x19/0x90
  [ctnetlink_dump_table+149/272] ctnetlink_dump_table+0x95/0x110
  [netlink_dump+88/512] netlink_dump+0x58/0x200
  [netlink_recvmsg+558/576] netlink_recvmsg+0x22e/0x240
  [sock_recvmsg+254/288] sock_recvmsg+0xfe/0x120
  [update_atime+149/176] update_atime+0x95/0xb0
  [do_generic_mapping_read+789/1520] do_generic_mapping_read+0x315/0x5f0
  [autoremove_wake_function+0/96] autoremove_wake_function+0x0/0x60
  [sys_recvmsg+323/512] sys_recvmsg+0x143/0x200
  [current_fs_time+81/112] current_fs_time+0x51/0x70
  [inode_update_time+82/224] inode_update_time+0x52/0xe0
  [pipe_writev+742/1248] pipe_writev+0x2e6/0x4e0
  [pipe_write+55/64] pipe_write+0x37/0x40
  [copy_from_user+70/144] copy_from_user+0x46/0x90
  [sys_socketcall+591/608] sys_socketcall+0x24f/0x260
  [sys_write+81/128] sys_write+0x51/0x80
  [syscall_call+7/11] syscall_call+0x7/0xb
Code: 89 e5 3b 50 14 7f 24 81 fa fe 00 00 00 76 0c b8 00 f0 ff ff 21 e0 29 =
50 14 c9 c3 80 78 14 0
15 0b 17 8f 3b c0 eb e4 <0f> 0b 11 0b 17 8f 3b c0 eb d2 90 55 89 e5 8b 45 0=
8 8b 50 04 89


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1347514265-1132175818=:16387--
