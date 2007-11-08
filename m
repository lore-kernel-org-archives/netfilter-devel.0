From: Andrei Popa <andrei.popa@i-neo.ro>
Subject: Re: [oops] in text matching
Date: Thu, 08 Nov 2007 21:06:56 +0200
Message-ID: <1194548816.3467.0.camel@ierdnac>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>
	 <1194547827.3298.5.camel@ierdnac>  <1194547991.3298.7.camel@ierdnac>
Reply-To: andrei.popa@i-neo.ro
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [85.204.20.254] ([85.204.20.254]:41137 "EHLO megainternet.ro"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318AbXKHTHS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:07:18 -0500
In-Reply-To: <1194547991.3298.7.camel@ierdnac>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thu, 2007-11-08 at 20:53 +0200, Andrei Popa wrote:
> On Thu, 2007-11-08 at 20:50 +0200, Andrei Popa wrote:
> > On Thu, 2007-11-08 at 14:32 +0100, Patrick McHardy wrote:
> > > Andrei Popa wrote:
> > > > Please CC as i am not subscribed to the list.
> > > > I-m using 2.6.22.9 and when I tried to insert this line it gave
> > the
> > > > oops:

Another oops if it helps...

BUG: unable to handle kernel paging request at virtual address e0000000
 printing eip:
c01e2707
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c01e2707>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22.9-iteyeb11 #8)
EIP is at bm_init+0xd7/0x210
eax: 0412d3e8   ebx: ffffffff   ecx: 0412d3e8   edx: 00000000
esi: dbed2c18   edi: 00000000   ebp: 00000000   esp: d999cbcc
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process iptables (pid: 5079, ti=d999c000 task=d98e30d0 task.ti=d999c000)
Stack: 00000000 dbed2800 dbed2810 00000000 00000010 c0448040 c0133130
a2281b4f
       00000010 d98ab0c0 d98ab0c3 c03a4e1a c03eae00 c01e2308 d98ab0d0
d98ab0bc
       d98ab09c c02f3ce0 0000009c c02f3d1e 000000d0 00000001 c03ffee0
c032f50f
Call Trace:
 [<c0133130>] tick_program_event+0x40/0x60
 [<c01e2308>] textsearch_prepare+0x68/0x90
 [<c02f3ce0>] checkentry+0x0/0x60
 [<c02f3d1e>] checkentry+0x3e/0x60
 [<c032f50f>] translate_table+0x37f/0x740
 [<c032fa56>] do_ipt_set_ctl+0x186/0x470
 [<c02ef5cd>] nf_sockopt+0xad/0x100
 [<c02ef670>] nf_setsockopt+0x20/0x30
 [<c0300559>] ip_setsockopt+0x109/0xc40
 [<c02ef5f2>] nf_sockopt+0xd2/0x100
 [<c02cb0dc>] release_sock+0xc/0x80
 [<c02ff824>] ip_getsockopt+0x114/0x670
 [<c01d6c54>] prio_tree_insert+0x74/0x240
 [<c01da278>] mmx_clear_page+0x18/0x64
 [<c013e30c>] get_page_from_freelist+0x21c/0x2f0
 [<c013e436>] __alloc_pages+0x56/0x2f0
 [<c013c313>] filemap_nopage+0x143/0x2e0
 [<c0145952>] __handle_mm_fault+0x722/0x7c0
 [<c02caa23>] sock_common_setsockopt+0x23/0x30
 [<c02c89df>] sys_setsockopt+0x5f/0xb0
 [<c02ca459>] sys_socketcall+0x209/0x280
 [<c0114be0>] do_page_fault+0x0/0x5f0
 [<c0103d92>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 00 8b 7f 04 89 3c 24 8b 0c 24 8b 54 24 08 89 4c 82 04 40 3d 01 01
00 00 75 ed 49 74 26 8b 1c 24 8b 32 31 c9 66 31 c0 4b 8b 3c 24 <0f> b6
14 06 41 29 c7 89 f8 8b 7c 24 08 48 39 cb 89 44 97 08 89
EIP: [<c01e2707>] bm_init+0xd7/0x210 SS:ESP 0068:d999cbcc


