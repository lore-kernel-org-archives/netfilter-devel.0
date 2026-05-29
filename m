Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD111421F0E
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084946; cv=none; b=DJGgT3ISxPZ45FVQXwgvGZwl0BX38we8eGrS+nVHb5ry4xErsAGu9zfikBU5iHLBrfoLEJtqq8502nb/oBYjOVZfclMWhARCuSHOWgW47jt8nx1AeqgKcuq46GiECC0WAqYnyx3Z3R/J0x4Ljrt0J4tOTvPHifk7sjpUWg75bNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084946; c=relaxed/simple;
	bh=pcTnwe/KVI85n95UPLkXuabPEJyxyegVKL/hCCAxPaM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mjDqQD2yjbOZu60kxk7SdJE5K8/2wFIr3CDM0JLadGhhJojEfah+BXGrPpX1ckXDR4EKEQObm3xxcrkiF8+aOg2OR1nnk+uC3ypv/aEVch1wRBD1sXIdBvzPsQ84YohDbkMsxPXauaXFvG4bPz5cdN9RXuI5qzSgUfbzGpEWPf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-69d932fb253so7815429eaf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 13:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084942; x=1780689742;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HfkZqZPb1eH2CVhAL5pZp6RKk2Z5O4JrS5f/56nRwpw=;
        b=JtcQG7Wfe1R7FdqRdBULF4NHejRhGMlCKUhoJQ3136500UCcALJ+qrOI74J1UUlREl
         abRG6cquboRId5naAIaxCcrlzPBOsjS6k+3zA29XhVwH9g5BPfkuSJwZcJXhOyqnyFAp
         jCORtiGpFp3lJ8Ia/4mKfWzq8bkwfFM++QNyjmi+wme2mNyikqv64Em3ulwmZJhUHI+h
         gdNKJ8FdfcVSAdOtuqbN0Afhj4DHoGWHIZfikZb6PV0rq7ST5GxmD2mccrdOvbQlkgkP
         v2Hrp5pg34+jOpfhOkkyQoVnOBikhBTXzG4cUNlDkixG+h07Q/RxiuuESK5TijQqqObM
         62gg==
X-Forwarded-Encrypted: i=1; AFNElJ/7KDsjiRMMc7g8/+OWodrEQ7Ip1bQsprgU7MSny9y2y+kSMDAvB4Z7leb0jMxagKac9a/QTpI6GyNwASFGaHM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3vvpfd4nAT3SHiC/54i9OVMXfWTE8VcyV9au7YnCH+W9K62pB
	qQopAzFtgVEYyBHL7b/6toD05tMTgHjzOFX2f8nc2kyl28vMwu+/MJmtFYt3SsiDmxk/+RhqOdJ
	+9a0VnUs2NmNzOQa1ri5NEsgp4fn4FWoNjWpBXb8naujk5ZlrYsSPhTkCtVg=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1908:b0:69e:14a:f307 with SMTP id
 006d021491bc7-69e10403fa4mr410206eaf.45.1780084941817; Fri, 29 May 2026
 13:02:21 -0700 (PDT)
Date: Fri, 29 May 2026 13:02:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a19f0cd.5099cdd9.8e407.0003.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list (2)
From: syzbot <syzbot+122256c3e2bf6ec9f928@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d60ec36cab33 Merge tag 'mm-hotfixes-stable-2026-05-25-16-2..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f1712e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e327ee9a867dd6b9
dashboard link: https://syzkaller.appspot.com/bug?extid=122256c3e2bf6ec9f928
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d60ec36c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8c1a87b3686/vmlinux-d60ec36c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/731575988634/bzImage-d60ec36c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+122256c3e2bf6ec9f928@syzkaller.appspotmail.com

------------[ cut here ]------------
conntrack cleanup blocked for 60s
WARNING: net/netfilter/nf_conntrack_core.c:2506 at nf_conntrack_cleanup_net_list+0x4f7/0x690 net/netfilter/nf_conntrack_core.c:2506, CPU#2: kworker/u32:12/10858
Modules linked in:
CPU: 2 UID: 0 PID: 10858 Comm: kworker/u32:12 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nf_conntrack_cleanup_net_list+0x4f7/0x690 net/netfilter/nf_conntrack_core.c:2506
Code: 29 c3 48 89 de e8 a9 84 58 f8 48 85 db 78 0f e8 bf 89 58 f8 e8 ea 64 dc 01 e9 0e fc ff ff e8 b0 89 58 f8 48 8d 3d 39 7f 36 07 <67> 48 0f b9 3a eb de 4c 8b 6c 24 40 e8 98 89 58 f8 48 b8 00 00 00
RSP: 0018:ffffc90004057968 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffffffffffff RCX: ffffffff89b02597
RDX: ffff888042c5ca00 RSI: ffffffff89b025b0 RDI: ffffffff90e6a4f0
RBP: 0000000000000001 R08: 0000000000000007 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffc90004057b20 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880d656a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c360d0b CR3: 000000004064f000 CR4: 0000000000352ef0
DR0: 0000000000000009 DR1: 00000000000000c9 DR2: 00000000000000f3
DR3: 00000000000000c0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ops_exit_list net/core/net_namespace.c:205 [inline]
 ops_undo_list+0x363/0xab0 net/core/net_namespace.c:252
 cleanup_net+0x499/0x920 net/core/net_namespace.c:702
 process_one_work+0xa0e/0x1980 kernel/workqueue.c:3314
 process_scheduled_works kernel/workqueue.c:3397 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3478
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	29 c3                	sub    %eax,%ebx
   2:	48 89 de             	mov    %rbx,%rsi
   5:	e8 a9 84 58 f8       	call   0xf85884b3
   a:	48 85 db             	test   %rbx,%rbx
   d:	78 0f                	js     0x1e
   f:	e8 bf 89 58 f8       	call   0xf85889d3
  14:	e8 ea 64 dc 01       	call   0x1dc6503
  19:	e9 0e fc ff ff       	jmp    0xfffffc2c
  1e:	e8 b0 89 58 f8       	call   0xf85889d3
  23:	48 8d 3d 39 7f 36 07 	lea    0x7367f39(%rip),%rdi        # 0x7367f63
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb de                	jmp    0xf
  31:	4c 8b 6c 24 40       	mov    0x40(%rsp),%r13
  36:	e8 98 89 58 f8       	call   0xf85889d3
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8
  3d:	00 00                	add    %al,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
