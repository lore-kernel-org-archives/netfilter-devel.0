From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000000 after conntrack -I
Date: Sun, 6 Nov 2005 01:05:27 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511060103230.27498@bizon.gios.gov.pl>
References: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
	<436A6B39.3080508@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-969150861-1131235527=:27498"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <436A6B39.3080508@eurodev.net>
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

---187430788-969150861-1131235527=:27498
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 3 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> # conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src 2.3.4.5
>> --reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst 2
>> --reply-port-src 3 --reply-port-dst 4 -t 32323 -u ASSURED
>
> --state option is missing: Unfortunately conntrack forgot to check it
> that such parameter was missing and ctnetlink didn't do that check
> either. That's why it resulted in an oops :(
>
> I've just applied a patch for conntrack, refresh your working copy. So
> you won't be able to reproduce that oops anymore.
>
> Anyway I'll send a patch for ctnetlink, that checking must be done in
> kernel space as well.

Simmilar problem, this time ICMP related:

# conntrack -I -s=3D192.168.0.88 -d=3D192.168.31.255 -r=3D192.168.31.255 -q=
=3D192.168.0.88 -p icmp -t 4 -u ASSURED --icmp-type 1  --icmp-code 3

Unable to handle kernel NULL pointer dereference at virtual address 0000000=
4
  printing eip:
c042b7a4
*pde =3D 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c042b7a4>]    Not tainted VLI
EFLAGS: 00010282   (2.6.14)
EIP is at icmp_nfattr_to_tuple+0x34/0x40
eax: 00000000   ebx: c41fac34   ecx: c41fac34   edx: c41fabf4
esi: c41fac70   edi: c0594ae0   ebp: dfadd000   esp: c41fab94
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 1922, threadinfo=3Dc41fa000 task=3Dc5b0c030)
Stack: c042e584 c41fabf4 c41fac34 dfadd030 00000018 00000000 00000400 00000=
000
        c01bad7d c473f3ec dfadd018 dfadd02c c01c1dfc c41fac3c 00000000 0000=
0282
        00000001 00000046 c011a963 c15e8b3c 00000003 00000001 c41fa000 0000=
0282
Call Trace:
  [<c042e584>] ctnetlink_new_conntrack+0x494/0x4e0
  [<c01bad7d>] journal_dirty_metadata+0xfd/0x250
  [<c01c1dfc>] journal_add_journal_head+0x7c/0x120
  [<c011a963>] __wake_up+0x53/0x80
  [<c01bb2ee>] journal_stop+0x18e/0x280
  [<c014014d>] find_get_page+0x3d/0x60
  [<c0454121>] nfnetlink_rcv+0x271/0x2c7
  [<c03e2c8b>] netlink_data_ready+0x6b/0x70
  [<c03e1da2>] netlink_sendskb+0x32/0x60
  [<c03e28db>] netlink_sendmsg+0x20b/0x310
  [<c01ac708>] ext3_mark_iloc_dirty+0x28/0x40
  [<c01b1094>] __ext3_journal_stop+0x24/0x50
  [<c03b073a>] sock_sendmsg+0xda/0x100
  [<c01865ca>] __mark_inode_dirty+0xda/0x1b0
  [<c017d7a6>] update_atime+0x96/0xb0
  [<c02777a6>] copy_from_user+0x46/0x80
  [<c01339f0>] autoremove_wake_function+0x0/0x60
  [<c03b21bf>] sys_sendmsg+0x18f/0x1f0
  [<c014522e>] __alloc_pages+0x2fe/0x480
  [<c014a909>] lru_cache_add_active+0x39/0x70
  [<c0150910>] do_anonymous_page+0x100/0x160
  [<c0150ea0>] __handle_mm_fault+0xf0/0x1a0
  [<c02777a6>] copy_from_user+0x46/0x80
  [<c03b2662>] sys_socketcall+0x242/0x260
  [<c04b56f0>] do_page_fault+0x0/0x623
  [<c0103215>] syscall_call+0x7/0xb
Code: 42 10 85 c0 74 06 83 7a 14 00 75 0b b8 ff ff ff ff c3 90 8d 74 26 00 =
0f b6 40 04 88 41 0c 8b 42 14 0f b6 40 04 88 41 0d 8b 42 0c <66> 0f b6 40 0=
4 66 89 41 04 31 c0 c3 55 31 c0 57 56 53 83 ec 40


Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-969150861-1131235527=:27498--
