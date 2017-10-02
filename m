From: Shankara Pailoor <sp3485@columbia.edu>
Subject: Memory Leak in nf_conntrack_in
Date: Mon, 2 Oct 2017 08:59:25 -0400
Message-ID: <CAASgV=vpJBSNR7YxKD33F7EcUZUp7hMLXhTAww2H4RH5Kha+cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andrew Zhu Aday <andrew.aday@columbia.edu>,
        syzkaller <syzkaller@googlegroups.com>
To: LKML <linux-kernel@vger.kernel.org>, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de,
        David Miller <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I am fuzzing linux 4.13-rc7 and I got a report about a memory leak.
Here is the alloc stack:

2017/10/01 02:08:59 BUG: memory leak:
unreferenced object 0xffff880069cf0300 (size 312):
  comm "syz-executor0", pid 3032, jiffies 4294722144 (age 10.773s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 6d 01 80 f2 ff ff ff ff ff ff ff ff  ....m...........
  backtrace:
    [<ffffffff98b28ba3>] kmemleak_alloc+0x23/0x40
    [<ffffffff968db017>] kmem_cache_alloc+0x127/0x2d0
    [<ffffffff98286371>] __nf_conntrack_alloc.isra.51+0x141/0x5a0
    [<ffffffff982868e7>] init_conntrack+0xd7/0x920
    [<ffffffff9828d3b0>] nf_conntrack_in+0xb20/0xf00
    [<ffffffff984b612c>] ipv4_conntrack_local+0x18c/0x1e0
    [<ffffffff9826f4c3>] nf_hook_slow+0xc3/0x290
    [<ffffffff98316321>] __ip_local_out+0x421/0x7a0
    [<ffffffff983166cd>] ip_local_out+0x2d/0x160
    [<ffffffff98317cf6>] ip_queue_xmit+0x8c6/0x1810
    [<ffffffff9838e6a3>] tcp_transmit_skb+0x1963/0x3320
    [<ffffffff983973e8>] tcp_connect+0x26e8/0x35e0
    [<ffffffff983afb45>] tcp_v4_connect+0x15f5/0x1e80
    [<ffffffff984202f4>] __inet_stream_connect+0x2d4/0xf00
    [<ffffffff98420f78>] inet_stream_connect+0x58/0xa0
    [<ffffffff980f0d54>] SYSC_connect+0x204/0x470
unreferenced object 0xffff880069cf0480 (size 312):
  comm "syz-executor0", pid 3038, jiffies 4294722168 (age 10.749s)
  hex dump (first 32 bytes):
    01 00 00 00 ff ff ff ff 00 00 00 00 ad 4e ad de  .............N..
    ff ff ff ff 00 00 00 00 ff ff ff ff ff ff ff ff  ................

My configs are the following:

https://pastebin.com/srCGHknL

Regards,
Shankara
