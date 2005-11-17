From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Thu, 17 Nov 2005 23:04:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1767635589-1132265040=:9911"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437BD093.3010905@eurodev.net>
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

---187430788-1767635589-1132265040=:9911
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

y

On Thu, 17 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> On Mon, 14 Nov 2005, Pablo Neira wrote:
>>
>>> Krzysztof Oledzki wrote:
>>>
>>>> EIP is at sub_preempt_count+0x35/0x40
>>>>
>>>> AFAIK there were some small fixes that went into 2.6.15-rc1 which were
>>>> supposed to fix such problems with conntrack -L. Shuldn't we send them
>>>> to -stable to make 2.6.14.x also usable?
>>>
>>> I think so, at the least Yasuyuki's:
>>> [NETFILTER] refcount leak of proto when ctnetlink dumping tuple
>>>
>>> That fixes the problem that you're reporting.
>>
>> What about this one?
>
> I realised that Yasuyuki's patch is incomplete. Could you give a try to
> the patch attached. Thanks.

Didn't help:

  ------------[ cut here ]------------
kernel BUG at kernel/sched.c:2833!
invalid operand: 0000 [#55]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[<c01166a5>]    Not tainted VLI
EFLAGS: 00010206   (2.6.14.2)
EIP is at sub_preempt_count+0x35/0x40
eax: dc4a1000   ebx: de57d82c   ecx: 00000000   edx: 000000ff
esi: de57d770   edi: 000006ff   ebp: dc4a1c9c   esp: dc4a1c9c
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 2601, threadinfo=3Ddc4a1000 task=3Ddddf35c0)
Stack: ded58fb8 c011f1f9 de57d82c de57d770 000006ff ded58fb8 c0356565 dc480=
8e0
        00000a29 437cfdd2 00000000 00000001 de57d770 dc4808e0 dc4808e0 ded5=
8fa0
        dcae7c00 c03119a8 dc4808e0 ded58fa0 00000000 000000d0 dcae7c00 dc4a=
1d48
Call Trace:
  [<c011f1f9>] local_bh_enable+0x19/0x90
  [<c0356565>] ctnetlink_dump_table+0x95/0x110
  [<c03119a8>] netlink_dump+0x58/0x200
  [<c031172e>] netlink_recvmsg+0x22e/0x240
  [<c02e04fe>] sock_recvmsg+0xfe/0x120
  [<c0177e78>] update_atime+0x58/0xb0
  [<c013c1f5>] do_generic_mapping_read+0x315/0x5f0
  [<c012f620>] autoremove_wake_function+0x0/0x60
  [<c02e1f93>] sys_recvmsg+0x143/0x200
  [<c011eff1>] current_fs_time+0x51/0x70
  [<c0177f22>] inode_update_time+0x52/0xe0
  [<c0168cd6>] pipe_writev+0x2e6/0x4e0
  [<c0101469>] __switch_to+0x19/0x1f0
  [<c0216836>] copy_from_user+0x46/0x90
  [<c02e229f>] sys_socketcall+0x24f/0x260
  [<c0102be1>] syscall_call+0x7/0xb
Code: 89 e5 3b 50 14 7f 24 81 fa fe 00 00 00 76 0c b8 00 f0 ff ff 21 e0 29 =
50 14 c9 c3 80 78 14 00 75 ee 0f 0b 15 0b 17 8f 3b c0 eb e4 <0f> 0b 11 0b 1=
7 8f 3b c0 eb d2 90 55 89 e5 8b 45 08 8b 50 04 89

It seems it is even worse. :(

Need about 3 seconds to trigger this bug with:

# while true; do conntrack -L|wc -l; done

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1767635589-1132265040=:9911--
