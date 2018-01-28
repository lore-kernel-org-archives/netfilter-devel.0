From: Florian Westphal <fw@strlen.de>
Subject: Re: general protection fault in ip6t_do_table
Date: Sun, 28 Jan 2018 22:55:41 +0100
Message-ID: <20180128215541.GC5906@breakpoint.cc>
References: <001a1134eab4b849a50563c844fd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
To: syzbot <syzbot+e783f671527912cd9403@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1134eab4b849a50563c844fd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

syzbot <syzbot+e783f671527912cd9403@syzkaller.appspotmail.com> wrote:
> CPU: 0 PID: 3675 Comm: syzkaller168273 Not tainted 4.15.0-rc9+ #283
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:ip6t_do_table+0x12de/0x19d0 net/ipv6/netfilter/ip6_tables.c:360
> RSP: 0018:ffff8801db206c58 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8801d9aafb80 RCX: ffffffff84d30352
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff8801d9aafcde
> RBP: ffff8801db206e60 R08: 1ffff1003b640d54 R09: 0000000000000000
> R10: 00000000000000d0 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8801d9aafc50
> FS:  0000000000a5d880(0000) GS:ffff8801db200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000209f1000 CR3: 00000001bc9f8001 CR4: 00000000001606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  ip6table_security_hook+0x65/0x80 net/ipv6/netfilter/ip6table_security.c:45

In case noone else can look at this I'll investigate this next friday
(currently travelling).
