From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Unable to handle kernel NULL pointer dereference at virtual address
 00000000 after conntrack -I
Date: Thu, 3 Nov 2005 14:14:39 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-207821379-1131023679=:32626"
Cc: netfilter-devel@lists.netfilter.org
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

---187430788-207821379-1131023679=:32626
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

# conntrack -I --orig-src 1.2.3.4 --orig-dst 1.2.3.5 --reply-src 2.3.4.5 --=
reply-dst 2.3.4.5 -p tcp --orig-port-src 1 --orig-port-dst 2 --reply-port-s=
rc 3 --reply-port-dst 4 -t 32323 -u ASSURED


Unable to handle kernel NULL pointer dereference at virtual address 0000000=
0
  printing eip:
c0429a29
*pde =3D 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c0429a29>]    Not tainted VLI
EFLAGS: 00010282   (2.6.14)
EIP is at nfattr_to_tcp+0x9/0x90
eax: c2dcbb60   ebx: dbcc0320   ecx: 00000001   edx: 00000000
esi: 00000006   edi: c0594a00   ebp: c2dcbb60   esp: c2dcbb34
ds: 007b   es: 007b   ss: 0068
Process conntrack (pid: 13870, threadinfo=3Dc2dcb000 task=3Dd97415a0)
Stack: c042816e 00000006 dbcc0320 00000006 00000000 c042dfbc c2dcbb60 dbcc0=
320
        d9b074a0 00000004 00000000 00000000 d692e920 00000000 00000007 c642=
9ea4
        c6429ea4 d9b07414 d9b07400 c01233d3 d9b07414 c2dcbc70 c0594a00 d9b0=
7400
Call Trace:
  [<c042816e>] ip_conntrack_proto_find_get+0x7e/0xb0
  [<c042dfbc>] ctnetlink_create_conntrack+0x18c/0x2c0
  [<c01233d3>] local_bh_enable+0x33/0xa0
  [<c042e1ee>] ctnetlink_new_conntrack+0xfe/0x4e0
  [<c011a963>] __wake_up+0x53/0x80
  [<c01bb2ee>] journal_stop+0x18e/0x280
  [<c0454131>] nfnetlink_rcv+0x271/0x2c7
  [<c03e2c8b>] netlink_data_ready+0x6b/0x70
  [<c03e1da2>] netlink_sendskb+0x32/0x60
  [<c03e28db>] netlink_sendmsg+0x20b/0x310
  [<c01ac708>] ext3_mark_iloc_dirty+0x28/0x40
  [<c01b1094>] __ext3_journal_stop+0x24/0x50
  [<c03b073a>] sock_sendmsg+0xda/0x100
  [<c0186696>] __mark_inode_dirty+0x1a6/0x1b0
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
  [<c04b5700>] do_page_fault+0x0/0x623
  [<c0103215>] syscall_call+0x7/0xb
Code: ff b8 ff ff ff ff eb e2 31 c0 eb 97 8d b6 00 00 00 00 31 c0 e9 3b ff =
ff ff 89 f6 8d bc 27 00 00 00 00 83 ec 14 8b 44 24 18 8b 10 <0f> b7 02 83 c=
2 04 89 54 24 08 83 e8 04 89 44 24 0c b8 01 00 00


# uname -r
2.6.14



Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-207821379-1131023679=:32626--
