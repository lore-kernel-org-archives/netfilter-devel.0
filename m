From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in
 compat_copy_entries
Date: Sat, 21 Apr 2018 11:18:27 -0700
Message-ID: <20180421181827.GC1098@sol.localdomain>
References: <001a113f1b64a3c4ab0566a60182@google.com>
 <1520263080.5898.7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot <syzbot+5705ba91388d7bc30828@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520263080.5898.7.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 05, 2018 at 04:18:00PM +0100, Paolo Abeni wrote:
> On Mon, 2018-03-05 at 00:21 -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot hit the following crash on upstream commit
> > 5fbdefcf685defd8bc5a8f37b17538d25c58d77a (Fri Mar 2 21:05:20 2018 +0000)
> > Merge branch 'parisc-4.16-1' of  
> > git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
> > 
> > So far this crash happened 5 times on upstream.
> > syzkaller reproducer is attached.
> > Raw console output is attached.
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached.
> > user-space arch: i386
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+5705ba91388d7bc30828@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for  
> > details.
> > If you forward the report, please keep this part and the footer.
> > 
> > audit: type=1400 audit(1520098078.492:8): avc:  denied  { map } for   
> > pid=4239 comm="syz-execprog" path="/root/syzkaller-shm255959590" dev="sda1"  
> > ino=16482 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
> > tcontext=unconfined_u:object_r:file_t:s0 tclass=file permissive=1
> > IPVS: ftp: loaded support on port[0] = 21
> > BUG: unable to handle kernel paging request at ffffc90001819e4f
> > IP: ebt_size_mwt net/bridge/netfilter/ebtables.c:2037 [inline]
> > IP: size_entry_mwt net/bridge/netfilter/ebtables.c:2122 [inline]
> > IP: compat_copy_entries+0x49f/0x1050 net/bridge/netfilter/ebtables.c:2160
> > PGD 1dad2f067 P4D 1dad2f067 PUD 1dad30067 PMD 1b2408067 PTE 0
> > Oops: 0000 [#1] SMP KASAN
> > Dumping ftrace buffer:
> >     (ftrace buffer empty)
> > Modules linked in:
> > CPU: 1 PID: 4249 Comm: syz-executor0 Not tainted 4.16.0-rc3+ #248
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> > Google 01/01/2011
> > RIP: 0010:ebt_size_mwt net/bridge/netfilter/ebtables.c:2037 [inline]
> > RIP: 0010:size_entry_mwt net/bridge/netfilter/ebtables.c:2122 [inline]
> > RIP: 0010:compat_copy_entries+0x49f/0x1050  
> > net/bridge/netfilter/ebtables.c:2160
> > RSP: 0018:ffff8801b34bf7e8 EFLAGS: 00010246
> > RAX: 000000000000000a RBX: ffff8801b34bf9d4 RCX: ffffc90001819e4f
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801b34bf9d8
> > RBP: ffff8801b34bf968 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff88613340 R11: 0000000000000001 R12: 000000000000ee5f
> > R13: dffffc0000000000 R14: ffff8801b34bf9c8 R15: ffffc90001819e2f
> > FS:  0000000000000000(0000) GS:ffff8801db300000(0063) knlGS:00000000085b9900
> > CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> > CR2: ffffc90001819e4f CR3: 00000001b2bd7003 CR4: 00000000001606e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   compat_do_replace+0x398/0x7c0 net/bridge/netfilter/ebtables.c:2249
> >   compat_do_ebt_set_ctl+0x22a/0x2d0 net/bridge/netfilter/ebtables.c:2330
> >   compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
> >   compat_nf_setsockopt+0x88/0x130 net/netfilter/nf_sockopt.c:156
> >   compat_ip_setsockopt+0x8b/0xd0 net/ipv4/ip_sockglue.c:1285
> >   inet_csk_compat_setsockopt+0x95/0x120 net/ipv4/inet_connection_sock.c:1041
> >   compat_tcp_setsockopt+0x3d/0x70 net/ipv4/tcp.c:2916
> >   compat_sock_common_setsockopt+0xb2/0x140 net/core/sock.c:2986
> >   C_SYSC_setsockopt net/compat.c:403 [inline]
> >   compat_SyS_setsockopt+0x17c/0x410 net/compat.c:386
> >   do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
> >   do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
> >   entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> > RIP: 0023:0xf7fbbc99
> > RSP: 002b:00000000ffd5ab8c EFLAGS: 00000286 ORIG_RAX: 000000000000016e
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
> > RDX: 0000000000000080 RSI: 0000000020000280 RDI: 0000000000000208
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > Code: 8d 4f 20 48 89 c8 48 89 8d c8 fe ff ff 48 c1 e8 03 42 0f b6 14 28 48  
> > 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b2 0a 00 00 <45> 8b 67 20  
> > 44 39 a5 04 ff ff ff 0f 82 bd 08 00 00 e8 cb 52 56
> > RIP: ebt_size_mwt net/bridge/netfilter/ebtables.c:2037 [inline] RSP:  
> > ffff8801b34bf7e8
> > RIP: size_entry_mwt net/bridge/netfilter/ebtables.c:2122 [inline] RSP:  
> > ffff8801b34bf7e8
> > RIP: compat_copy_entries+0x49f/0x1050 net/bridge/netfilter/ebtables.c:2160  
> > RSP: ffff8801b34bf7e8
> > CR2: ffffc90001819e4f
> > ---[ end trace cf111332eb971f16 ]---
> > 
> > 
> > ---
> > This bug is generated by a dumb bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for details.
> > Direct all questions to syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report.
> > If you forgot to add the Reported-by tag, once the fix for this bug is  
> > merged
> > into any tree, please reply to this email with:
> > #syz fix: exact-commit-title
> > If you want to test a patch for this bug, please reply with:
> > #syz test: git://repo/address.git branch
> > and provide the patch inline or as an attachment.
> > To mark this as a duplicate of another syzbot report, please reply with:
> > #syz dup: exact-subject-of-another-report
> > If it's a one-off invalid bug report, please reply with:
> > #syz invalid
> > Note: if the crash happens again, it will cause creation of a new bug  
> > report.
> > Note: all commands must start from beginning of the line in the email body.
> 
> #syz fix: netfilter: ebtables: add CONFIG_COMPAT support
>

Wrong commit title.  The fix for this actually was:

#syz fix: netfilter: ebtables: CONFIG_COMPAT: don't trust userland offsets

- Eric
