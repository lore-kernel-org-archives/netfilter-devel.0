Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126A638735E
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909924; cv=none; b=OmUFGC9Bklu+mUrS+gvN7s4JUlvoDDmucd1CSOX8zbEofum9Iet0HcL0lolylGLeDPYjkLXCpVgZtj8ar7DE7WiFxTKNVlhWzncTEcKqSrPWeMqsy7xWMb01cmlD+it/bbE9vBQYGXISzDqVr7dSDTg3hISLEPlxHkppfasIvd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909924; c=relaxed/simple;
	bh=gNExzrK/DJLtPB7fHgtqJHeoVg6E5WUuHnFBXHsAobc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EYMYcpZZVojFA68TuKoFuutoKw/B8txPY44xm35YNRg2sBXZ5ZQtL+3bCbBcPtC7+5EVYiuPGe1CYQazL/sEF+JVmB/Hhxuo54OGRBB4dG1mSFFV0m0Oaax9S/TaLNf4Kdzq92cvtPqkoI7ouNj4XE6zA/SsTcBfZWca8jf/HyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40948b7e832so54300246fac.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Mar 2026 10:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909922; x=1773514722;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFKlKppWZ1atXG5g/mzZfeIw97mKXkqXOimB2H6XWUU=;
        b=fN5yoOdOXU0eK03GfJrkfTmGx+GJELxTMd4uXLY0A9XRgspYgSy+NTzQl4beI6sv18
         uABEUSLB+qwZsDMo2xHJ7/PpjvwFk0H3BqxEtNW5+O6OV8GOAujb/TrckSjmTAfHLsuX
         TPgMpk7IJiWak9xiAtarQCK6+r11XChBzYXm7ZHQqO7guB6mPQXYSeQ6+sG9QXFx6Mqg
         lY24bK5a5aCzaWDFNlX1GqMGCvny3voAM26jrpZ0sXwghSpb4kOEt0f7/wJO1cgcNF0Y
         W5rH3qgi2t0+v0DAIBtJkDOF+VB0/ssZxzKdtMFiISF9mdJjPLFtBXB7/riNlMBqiSFZ
         cK1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpOTUxfqEbYsoSThnn5i5syMpHimQ+ipnnx97Ithv+56FBIykcTuefNERzyA4ohHot395K8e0QNH2vfoIrsGY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz6ckvwRAD6cj4NfD2QjbSYxnlGUBIVyqbS/byT+0aKFSJddn8
	8nVBM71lHOItikyMlmhuXvLL1fjjYzqx72qQ+eka+wt1MS9vitTWiH7gcgTPq8UeFgL2sDgM53Y
	6qYYQsuCbN5lD8/gBXDTqtz4uMDFKiXCKdYRbbGKNKhttAkm1lhecQHoBu6Q=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:228e:b0:679:c3e3:c360 with SMTP id
 006d021491bc7-67b9bccacdfmr3962418eaf.32.1772909922088; Sat, 07 Mar 2026
 10:58:42 -0800 (PST)
Date: Sat, 07 Mar 2026 10:58:42 -0800
In-Reply-To: <20260306123649.2878676-1-pablo@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ac7562.050a0220.13f275.005a.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: nft_set_rbtree: allocate same array size
 on updates
From: syzbot ci <syzbot+ci49735e77812b876d@syzkaller.appspotmail.com>
To: fw@strlen.de, netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: nft_set_rbtree: allocate same array size on updates
https://lore.kernel.org/all/20260306123649.2878676-1-pablo@netfilter.org
* [PATCH nf] netfilter: nft_set_rbtree: allocate same array size on updates

and found the following issue:
general protection fault in nft_array_may_resize

Full report is available here:
https://ci.syzbot.org/series/63a7af7e-7e81-40b3-ac44-4a537af34cdf

***

general protection fault in nft_array_may_resize

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      488f6400e447d446ff4d5daef6988f3403dd948d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7f67fa0a-1740-40ec-b191-899f77dd02ce/config
C repro:   https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c3aace/c_repro
syz repro: https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c3aace/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c:649
Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 nft_rbtree_insert+0x161/0x2c00 net/netfilter/nft_set_rbtree.c:678
 nft_add_set_elem net/netfilter/nf_tables_api.c:7486 [inline]
 nf_tables_newsetelem+0x2a17/0x4450 net/netfilter/nf_tables_api.c:7618
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x1240/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdff099c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff596fb518 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fdff0c15fa0 RCX: 00007fdff099c799
RDX: 0000000000000040 RSI: 0000200000009b40 RDI: 0000000000000003
RBP: 00007fdff0a32bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdff0c15fac R14: 00007fdff0c15fa0 R15: 00007fdff0c15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c:649
Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	49 81 c7 38 01 00 00 	add    $0x138,%r15
   9:	4c 89 f8             	mov    %r15,%rax
   c:	48 c1 e8 03          	shr    $0x3,%rax
  10:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  15:	74 08                	je     0x1f
  17:	4c 89 ff             	mov    %r15,%rdi
  1a:	e8 1b de 4f f8       	call   0xf84fde3a
  1f:	4d 8b 3f             	mov    (%r15),%r15
  22:	4c 89 f8             	mov    %r15,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 e3 01 00 00    	jne    0x219
  36:	41 8b 2f             	mov    (%r15),%ebp
  39:	48                   	rex.W
  3a:	c7                   	.byte 0xc7
  3b:	c0                   	.byte 0xc0
  3c:	a8 c2                	test   $0xc2,%al
  3e:	1a                   	.byte 0x1a


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
