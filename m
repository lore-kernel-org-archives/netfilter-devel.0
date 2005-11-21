From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Mon, 21 Nov 2005 22:20:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511212208550.13610@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>
	<4381D8B3.1010100@eurodev.net>
	<Pine.LNX.4.64.0511211541020.30476@bizon.gios.gov.pl>
	<4381DDCF.7090609@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1628123042-1132608027=:13610"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4381DDCF.7090609@eurodev.net>
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

---187430788-1628123042-1132608027=:13610
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 21 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>>> I can't reproduce that problem that you're reporting. I don't see how
>>> the ctnetlink code can trigger that at the moment :(
>>
>> What information should I provide to help tracking this bug?
>
> Any extra patch applied to your vanilla kernel?

From=20pom-ng:
  ROUTE TARPIT TTL iprange ipv4options policy comment time set u32 random u=
nclean

From=20http://www.ipp2p.org: (pom-ng contains much older version):
  ipp2p-0.8.0

And my set of patches (patch-ole-2.6.14-o5.gz):
  + 0020: iptables-PreroutingFilter-2611
  + 0030: IPv6-OptionalSIT-26
  + 0050: VGACanDo64KB-Option-26
  + 0060: 3c59x-ShowEthID-26
  + 0061: tulip-8021q-2.6.13.2-szpajder
  + 0070: 2.6.14-libata-passthru
  + 0100: netfilter-ctnl-refcnt
  + 0101: proto_find
  + 0110: bonding-vlan
  + 0120: workaround-for-pnp-device-interrupt

You can find it here:
  ftp://ftp.ans.pl/pub/patches/patch-ole-2.6.14-broken-out/

AFAIK there is nothing special here.

> architecture?
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2400+
stepping        : 1
cpu MHz         : 1994.966
cache size      : 256 KB

It is:
Linux version 2.6.14.2 (root@gate) (gcc version 3.3.5) #1 PREEMPT Mon Nov 2=
1 22:02:40 CET 2005

Do you need my config?

> whatever that can give me a clue on what's wrong.
OK. Thank you for helping me.

>>> The only bugfix that was in my pending queue is:
>>> [PATCH] relax ip_conntrack_[nat_]proto_find_get checkings
>>
>> OK. I'll test this patch.
>
> Fine.

Tested. Still wrong:

------------[ cut here ]------------
kernel BUG at kernel/sched.c:2833!
invalid operand: 0000 [#1]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[sub_preempt_count+53/64]    Not tainted VLI
EFLAGS: 00010206   (2.6.14.2)
EIP is at sub_preempt_count+0x35/0x40
eax: dd3b2000   ebx: dd2c8f4c   ecx: 00000000   edx: 000000ff
esi: dd2c8e90   edi: 00000418   ebp: dd3b2c9c   esp: dd3b2c9c
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 372, threadinfo=3Ddd3b2000 task=3Ddd3b15c0)
Stack: dedac8b8 c011f1f9 dd2c8f4c dd2c8e90 00000418 dedac8b8 c0356565 c155e=
6c0
        00000174 438236f7 00000000 00000001 dd2c8e90 c155e6c0 c155e6c0 deda=
c8a0
        dd4e0000 c03119a8 c155e6c0 dedac8a0 00000000 000000d0 dd4e0000 dd3b=
2d48
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
  [do_IRQ+89/128] do_IRQ+0x59/0x80
  [syscall_call+7/11] syscall_call+0x7/0xb
Code: 89 e5 3b 50 14 7f 24 81 fa fe 00 00 00 76 0c b8 00 f0 ff ff 21 e0 29 =
50 14 c9 c3 80 78 14 00 75 ee 0f 0b 15 0b 97 8e 3b c0 eb e4 <0f> 0b 11 0b 9=
7 8e 3b c0 eb d2 90 55 89 e5 8b 45 08 8b 50 04 89


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1628123042-1132608027=:13610--
