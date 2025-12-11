Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B121771C
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765478314; cv=none; b=AxIQOA7XhbfFsIC/WK5JXGyR+3j/rWWwGezO1Yq/9I+8pGrZHJ0CDw00sf6B+wU+9igLy6trcpbFFVXJmoPzHYhX0sPzsONIHQ92fX3m/0U6htygtES8eloLoEME8KnB051d34nUzZKhgOH3QcIDhzVmqF8v2ILZte3jCL4vPvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765478314; c=relaxed/simple;
	bh=KjN2TfuFunnBIIjIY5/NDtntkHTxpWh/AWfe8kSHgJ8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q4LtC0wGrZFQDSwxlqG6IKRiv4kRnZ/30+emGnoeYTqHPE1aa7ppP5WYp6n6HHGfQI6CJD1Aa0b4hy8cBNzzK70qCiZBnKsShZez7Y5pJN9EKrHHW4kVbfWbWsNaUx/Y17ezRv3fKixwk4L4s3Z0Y1EfLRZ5ysRwO5yMB4R63D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65b32d52186so546237eaf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 10:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765478311; x=1766083111;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmftX27Q/W7fyuelLAuPg2KIcheP2mgJj3RegfphCow=;
        b=NenCU+oZDpfd86o/rrt2DTzemN61dar2l0pl1jzR4r/HkPsOGUrfR072IbvyZZ7ito
         rcawKLESByqNt6dtq3+oGDHePnHNIxCYyst6rn+5R2564N/6b7+zzkPajJoct5NLqklD
         cfE/1tgEc9hu1fahHmcsdyvFV20GdyJxYXCXa3szpkTlclehl5wqYEA/inp3mWyR+hIw
         WZ6ewr1nXi5cQkgEM9Bi/PhiR2Mi/qoRe9C+vbrY7L89whqVgAW+GLdtD7cMXuJHqd+G
         gjjz1DXOfn5GtAHsl3pnIn5ffsMLCfn891f6B/Cl4dtVVZwaJxC33zGsNsT09BQ5x1x2
         OzDw==
X-Forwarded-Encrypted: i=1; AJvYcCWTSIvyiPfv2Bsi4LozxEaMiGaMAwN52tjK9ZQOp9ICePp9BkzUAehDqt2iZoT3MdGMh2Du8cqWt257T/omTm8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhgvB8s+nIL8eB/JBJwzWMug9T1FIYtZKyNJzT5jsnQildT1d2
	/iYkr1ZTBHZFfKLF8cXfccFMs5bpTeZZjjwqmf/4htVmGWEFgJbd/QEFMAqv3dIjxUI+fFSPBsd
	ysu2bYxYQ+dRRnqtBoDqcPenEwkxIIu8Ts1DMAZvX+ZrlyL2V8yjb1us38QY=
X-Google-Smtp-Source: AGHT+IEUZS5AFevvdPKWhnZ6WlvBNFsQ70+WT7EWv59zCjxEhfcLDn8Ymyg1BUg3wUcIiYnNXj08X8qEp6wSFad0/LEsPgoZ6dnq
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f033:b0:657:4f2:97b2 with SMTP id
 006d021491bc7-65b2aaeb8d3mr3768233eaf.0.1765478311480; Thu, 11 Dec 2025
 10:38:31 -0800 (PST)
Date: Thu, 11 Dec 2025 10:38:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list
From: syzbot <syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5ce74bc1b7cb Add linux-next specific files for 20251211
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11a241b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=4393c47753b7808dac7d
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e1660176a50f/disk-5ce74bc1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/616ede012bbd/vmlinux-5ce74bc1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7c0c5bc40fd8/bzImage-5ce74bc1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com

------------[ cut here ]------------
conntrack cleanup blocked for 60s
WARNING: net/netfilter/nf_conntrack_core.c:2512 at nf_conntrack_cleanup_net_list+0x234/0x340 net/netfilter/nf_conntrack_core.c:2511, CPU#1: kworker/u8:0/12
Modules linked in:
CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: netns cleanup_net
RIP: 0010:nf_conntrack_cleanup_net_list+0x234/0x340 net/netfilter/nf_conntrack_core.c:2511
Code: 08 48 89 df e8 fd 78 a3 f8 4c 8b 3b 49 39 df 74 69 e8 20 16 3d f8 45 31 e4 e9 8e fe ff ff e8 13 16 3d f8 48 8d 3d ec 2f 0c 06 <67> 48 0f b9 3a eb c0 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c cd fe ff
RSP: 0018:ffffc90000117870 EFLAGS: 00010293
RAX: ffffffff8984a13d RBX: ffffc90000117a00 RCX: ffff88801ce8db80
RDX: 0000000000000000 RSI: ffffffffffffffcb RDI: ffffffff8f90d130
RBP: 0000000000000001 R08: ffff88807ce6b003 R09: 1ffff1100f9cd600
R10: dffffc0000000000 R11: ffffed100f9cd601 R12: 0000000000000001
R13: dffffc0000000000 R14: 00000001000068e3 R15: 0000000100006918
FS:  0000000000000000(0000) GS:ffff888125f32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000020000 CR3: 00000000306ac000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 ops_exit_list net/core/net_namespace.c:205 [inline]
 ops_undo_list+0x525/0x990 net/core/net_namespace.c:252
 cleanup_net+0x4d8/0x7a0 net/core/net_namespace.c:696
 process_one_work+0x93a/0x15a0 kernel/workqueue.c:3279
 process_scheduled_works kernel/workqueue.c:3362 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3443
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
----------------
Code disassembly (best guess):
   0:	08 48 89             	or     %cl,-0x77(%rax)
   3:	df e8                	fucomip %st(0),%st
   5:	fd                   	std
   6:	78 a3                	js     0xffffffab
   8:	f8                   	clc
   9:	4c 8b 3b             	mov    (%rbx),%r15
   c:	49 39 df             	cmp    %rbx,%r15
   f:	74 69                	je     0x7a
  11:	e8 20 16 3d f8       	call   0xf83d1636
  16:	45 31 e4             	xor    %r12d,%r12d
  19:	e9 8e fe ff ff       	jmp    0xfffffeac
  1e:	e8 13 16 3d f8       	call   0xf83d1636
  23:	48 8d 3d ec 2f 0c 06 	lea    0x60c2fec(%rip),%rdi        # 0x60c3016
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb c0                	jmp    0xfffffff1
  31:	89 e9                	mov    %ebp,%ecx
  33:	80 e1 07             	and    $0x7,%cl
  36:	80 c1 03             	add    $0x3,%cl
  39:	38 c1                	cmp    %al,%cl
  3b:	0f                   	.byte 0xf
  3c:	8c cd                	mov    %cs,%ebp
  3e:	fe                   	(bad)
  3f:	ff                   	.byte 0xff


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
