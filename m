Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6419DFAB
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765496664; cv=none; b=J7v+IhuTToRfpmjRbUCaOBYxpOlNtwHq09lpo4pAC0BMTT3reAC6+DG8lCx+F2zvPJ8u/XtC/U05+uYEOuCzIPBGvULCqisz5jDBd2QdECNJeBbRgyM4sSJHpCJ3F/nS840AgD6kvsF9/mIOyHD8V4bj5P6KXIn8AVM0WQxki4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765496664; c=relaxed/simple;
	bh=kweQCQmDUPReqCEtyfwyN6m6JtHkE2e7lzHFapG3kBw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=YgE0UFNdgHEjEB/Ib3sjqVipAzA7uTTi7UNCb4JAE+Oyef447iZ5MwRtpghRhoV1eTb+7y+SBStkPfop2rogaSjGbdyTgIDSU2NHMTlkKE6HMcZNRxEcDcWJM3OAHgLS9qhviHgWDKOGdMKBR51eE5KIL1v7r7HDHD9Ld2dW6Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-44fe73611fdso831175b6e.0
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Dec 2025 15:44:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765496662; x=1766101462;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=upZQ1mqW5QIiRRJS5+UQR46TtfDCfKkqFD2u5VQHzQ0=;
        b=lrx9JRLV9Vi/wk1q/igK/majXHh6hjk0exgTuvH87kUvi/6n44lhKh5XA7eakjyj/a
         KbycvtZKL+09JGEmJw/0aflaT78jNJljSz5+RCcze6nSxUTlbhXyO1WOYq9UxaJiP6G2
         FRi2pTBVurYIM3E3lmre+xtU9PR8abdGqR3eaxVzxtE7GMbur+mvkGQZr9z1dMgnRlS0
         p6QTAD7DwNRxnzWKrBw4nkIs1hwgQ+2VP8ZiJX41+HG/7czV60L3SPpeNWLgFketDc9r
         fw3q7TsrafXoWpeBE1xcAhIeIS60rMkRB/Z7RXjHZYgaPNplxwrSFpwbNOsuVWe18BEb
         tv1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX/ZDEmB4VFl8OFRl2HTIAFT4uE5MCNmzXzONj3Ckowa5OIMRLvqXPVdGfS9JBPDjBZuW8EyASFipHib1LYTNg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3S6KYJLcTHH0nBP5KsNK/dBHxqFkZ+I38o36ifRbNUuamtpey
	muZ2ag3ZVgpjbFgSdEDzVuSLgQNPROxHe6wuviamgDcNqzqRmoIEIERIb9pQjz0siRRj6B2qMTS
	S2ZxI3YqIMvO0aKPVGSN17G/obxdx9fAnsADvh4Xb0b7aMrcUpnlPvdmlVfk=
X-Google-Smtp-Source: AGHT+IHTm26FE9oFJaO1FZZ7RAIHr1Pol94DU+3+bTFh/xKqbOhLaFzntA73leQHpobGNakOQSy9CwB+dVrgou1zyhoiLCRmj25/
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e912:0:b0:659:9a49:9000 with SMTP id
 006d021491bc7-65b452597b2mr114498eaf.45.1765496662268; Thu, 11 Dec 2025
 15:44:22 -0800 (PST)
Date: Thu, 11 Dec 2025 15:44:22 -0800
In-Reply-To: <20251211123038.1175-1-fw@strlen.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693b5756.050a0220.1ff09b.0012.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: nf_tables: avoid chain re-validation if possible
From: syzbot ci <syzbot+ci135094d4d47126eb@syzkaller.appspotmail.com>
To: fw@strlen.de, hamzamahfooz@linux.microsoft.com, 
	netfilter-devel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] netfilter: nf_tables: avoid chain re-validation if possible
https://lore.kernel.org/all/20251211123038.1175-1-fw@strlen.de
* [PATCH nf v3] netfilter: nf_tables: avoid chain re-validation if possible

and found the following issue:
WARNING in nft_chain_validate

Full report is available here:
https://ci.syzbot.org/series/498345c4-bb9b-4e13-9cd1-42a483844f55

***

WARNING in nft_chain_validate

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      6a107cfe9c99a079e578a4c5eb70038101a3599f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e56f0271-a9ee-403c-ad73-fe3d0fb22785/config
C repro:   https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a99b6c/c_repro
syz repro: https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a99b6c/syz_repro

------------[ cut here ]------------
WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline], CPU#1: syz.0.17/5982
WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176, CPU#1: syz.0.17/5982
Modules linked in:
CPU: 1 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline]
RIP: 0010:nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176
Code: 31 db 89 d8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 2d 32 42 f8 bb fc ff ff ff eb de e8 21 32 42 f8 90 <0f> 0b 90 49 83 c5 78 ba 04 00 00 00 4c 89 ef 31 f6 e8 ea 18 a8 f8
RSP: 0018:ffffc90003df6fe0 EFLAGS: 00010293
RAX: ffffffff897f183f RBX: 0000000000000000 RCX: ffff888102f93a80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000040 R08: ffff888102f93a80 R09: 0000000000000002
R10: 0000000000000010 R11: 0000000000000000 R12: ffff88816a79c510
R13: ffff88816a79c500 R14: ffff88816a79c500 R15: dffffc0000000000
FS:  000055555e417500(0000) GS:ffff8882a9eb1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000005000 CR3: 000000017531c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 nft_validate_register_store+0xf6/0x1d0 net/netfilter/nf_tables_api.c:11750
 nft_parse_register_store+0x225/0x2c0 net/netfilter/nf_tables_api.c:11787
 nft_immediate_init+0x1cf/0x390 net/netfilter/nft_immediate.c:67
 nf_tables_newexpr net/netfilter/nf_tables_api.c:3550 [inline]
 nf_tables_newrule+0x1794/0x28a0 net/netfilter/nf_tables_api.c:4419
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x11d9/0x2590 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:733
 ____sys_sendmsg+0x505/0x820 net/socket.c:2608
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2662
 __sys_sendmsg net/socket.c:2694 [inline]
 __do_sys_sendmsg net/socket.c:2699 [inline]
 __se_sys_sendmsg net/socket.c:2697 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2697
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f577a58f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe377887c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f577a7e5fa0 RCX: 00007f577a58f7c9
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f577a5f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f577a7e5fa0 R14: 00007f577a7e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
