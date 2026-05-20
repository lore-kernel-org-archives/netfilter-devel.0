Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97A83242AB
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 06:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779258240; cv=none; b=lRY5GhQTKtG83vBlbNisDW83L4YbvYGyZ2yEQghXVSksG7PkDirs5T/hSxS7c3b3rdWqJ/uCOgsjlP0wQg25SA7R46qP81sOABQEOOVu2sA699Sq099H0/5TkikAgLc+kpIGLTDBnHJjHsB9fCxV58rtb3Euyuz23EpbYdW2MMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779258240; c=relaxed/simple;
	bh=uyBKFyUrE1l76t2fcs8Mt+PN9hBLdb1uJgoy70DmMjI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EQBKnsEF41SRi2JSXcRItIKwhOzwGF3vN8Wgt2acR5DL8yU+AyR0WbWYjHUgkTj/a6tM3J6sCnCHo9zAl0G73zR511dLvxnLmZKd8NbYZ8bkDVBYru4q4mUacZ873OJfdZubtS6IKwLJEFJX2771CmhRvCQkA7j0HNvzYLyWBqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-696307c7f2eso10386866eaf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779258237; x=1779863037;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9LDCa34YdUZJw8O0LeNNzPHhjPn/bOCsB3XLuXMIaA=;
        b=XNAEZQK2qAT/TRc8Q3D8dIcFN0suRLLymGZq32KDUlXfB7F3nZ826Wh9SKoycoE7va
         /yadXhLCPFGey/asj73FcwleX9gl7pjZTmiVQd0sBnqzWc7R4fKBc25laCMEB3fIUbT8
         1wOBmYdW6TBIaPC+Mt3q1/sPHWuY1cXxYGTzMzVAe+UAMEzoGGHcNiwHvT2XnCEXhPrs
         RAe8bkQ5ghlFHFNXZw57TU5pwSYP//J9HY7rb9CJ/ynjHetBXQ0x0y8gsSoJVljrfR3G
         rWeW4omWWTzwCBbhXUONQZDMy+7+sWnobbhbVNWvdMYhSb9VVMA9LXwJwcKoV/IvUA27
         8KkQ==
X-Gm-Message-State: AOJu0Yz8eNhuIUSzOR1lLpHADQSuvAtqA/6+UiBUHeEBM/ROWMVE/Taj
	iIhZ+dwkN03LFS6rjZUwCGvMgHLBlE0Bajt/f4oZo22G7/tOPyIWkij2m5YscZpLpSUmGKwiPNb
	aq90hDx2+veoxulOhnIHD1g++Q1gkKD/xS/SNjzULpicFkFPtXFJqOoXuwp4=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:151f:b0:694:a339:43af with SMTP id
 006d021491bc7-69c9436974amr14921997eaf.28.1779258237681; Tue, 19 May 2026
 23:23:57 -0700 (PDT)
Date: Tue, 19 May 2026 23:23:57 -0700
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0d537d.a70a0220.1a69d3.001e.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE
 for accessing helper flags
From: syzbot ci <syzbot+cic0fb7b2de24b33ab@syzkaller.appspotmail.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
https://lore.kernel.org/all/20260519213826.1181661-1-pablo@netfilter.org
* [PATCH nf 1/7] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
* [PATCH nf 2/7] netfilter: conntrack: add dead flag to helpers
* [PATCH nf 3/7] netfilter: nf_conntrack_helper: add null check in nfct_help_data() calls
* [PATCH nf 4/7] netfilter: conntrack: add null check in nfct_help() calls
* [PATCH nf 5/7] netfilter: conntrack: add nf_ct_iterate_destroy_net()
* [PATCH nf 6/7] netfilter: nf_conntrack_timeout: use nf_ct_iterate_destroy() to cleanup timeout going away
* [PATCH nf 7/7] netfilter: xt_CT: fix race with rule removal and nfnetlink_queue

and found the following issue:
WARNING in xt_ct_tg_check

Full report is available here:
https://ci.syzbot.org/series/c356956d-b1f6-4d7e-be26-6cf68d49814e

***

WARNING in xt_ct_tg_check

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      2beba18b0160446463bf1dbd749324846db98493
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/45c49e4e-439a-4d11-bc9a-3c3a5077f679/config
syz repro: https://ci.syzbot.org/findings/9cfb9381-576b-4a17-a156-68641410fec2/syz_repro

No such timeout policy "syz1"
------------[ cut here ]------------
help
WARNING: net/netfilter/xt_CT.c:226 at xt_ct_tg_check+0x814/0xa90 net/netfilter/xt_CT.c:226, CPU#1: syz.0.17/5870
Modules linked in:
CPU: 1 UID: 0 PID: 5870 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:xt_ct_tg_check+0x814/0xa90 net/netfilter/xt_CT.c:226
Code: c7 c7 c0 a7 e6 8c e8 eb 33 3e f7 e9 12 ff ff ff e8 01 4b dc f7 48 c7 c7 40 a8 e6 8c 4c 89 ee e8 d2 33 3e f7 e9 f9 fe ff ff 90 <0f> 0b 90 4c 89 e0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 e7 e8 73
RSP: 0018:ffffc900036ef6e0 EFLAGS: 00010282
RAX: ffff88812063bd10 RBX: 1ffff920006ddee4 RCX: 0000000000000010
RDX: ffff88812063bd00 RSI: 0000000000000002 RDI: 0000000000000002
RBP: ffffc900036ef7b0 R08: ffffffff90316c23 R09: 1ffffffff2062d84
R10: dffffc0000000000 R11: fffffbfff2062d85 R12: ffff88812063bd10
R13: 00000000fffffffe R14: ffff888113ee1800 R15: dffffc0000000000
FS:  00007fd41ea436c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd41da72780 CR3: 0000000175cc8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xt_checkentry_target net/netfilter/x_tables.c:1115 [inline]
 xt_check_target+0x61a/0xca0 net/netfilter/x_tables.c:1138
 check_target net/ipv4/netfilter/ip_tables.c:510 [inline]
 find_check_entry net/ipv4/netfilter/ip_tables.c:552 [inline]
 translate_table+0x1881/0x2110 net/ipv4/netfilter/ip_tables.c:716
 do_replace net/ipv4/netfilter/ip_tables.c:1137 [inline]
 do_ipt_set_ctl+0x9f5/0xe00 net/ipv4/netfilter/ip_tables.c:1635
 nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
 __sys_setsockopt net/socket.c:2406 [inline]
 __do_sys_setsockopt net/socket.c:2412 [inline]
 __se_sys_setsockopt net/socket.c:2409 [inline]
 __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd41db9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd41ea43028 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fd41de15fa0 RCX: 00007fd41db9ce59
RDX: 0000000000000040 RSI: 8001000000000000 RDI: 0000000000000003
RBP: 00007fd41dc32d6f R08: 00000000000002a8 R09: 0000000000000000
R10: 0000200000001500 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd41de16038 R14: 00007fd41de15fa0 R15: 00007ffdb7f510f8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
