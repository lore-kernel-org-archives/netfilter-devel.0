Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AD93986E3
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Jan 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767807270; cv=none; b=uH1DNrUbCAujzz7VYK2o0qVMuaU8YVLqiwEZPHLThjXPspVZijU/RA7TOen+CeiekveOhziJp1lWSxQISJ3XE/nRxIeRUSWlCNGCnQlPIKPJUZta8acOdGZectjBgUIVFuogfJgVmqVZd7JALmvGnTMHyifieBbLg2S80ZWDCv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767807270; c=relaxed/simple;
	bh=5U1R4ljm+W2Izg/oglsYWbCr8DPRgdEq+bghHYPYKOo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cdQhvDrUOp2197Oj2kQfftWAM4OQN3HJiv3K2jM4cn+cN2vMDItQXAJCUunz9IUsY4NTp2JNmlWGjBNW1h2DGmoeUIoFbbTSjEicr0NnhpKUku1sXCf3YxfG64HT055SnZlglHaHQQXUJwqbsvZFWdcY/Kzs89OrEPHhOxzSynk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-65d0318e02eso5542763eaf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Jan 2026 09:34:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767807268; x=1768412068;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B2PYel2T5pfRZieI9Ikpf9k9MeQfExr2YEBU6Ig4pDY=;
        b=GBxs3J29Adjw1hTOMjROaNfeCYK5+n75jxcr13alx9ATTdkImBDgT/BJG03QjLlv52
         X7rKwOFLvV5q5lG2t+xTm22qKEgLlSRviuEMIwlHdw8FcohyjX1LxB06XWYnvN9iGelE
         Yo/I7Pbplc2pnNG1GY8vmqLxFsgkqw+Ymp90UVw4jr+DeZxvy6Ya1P7wb6ih/8yJUY9N
         aHOujDJeY9rBs17ALCUjqK8XI4qZX2FnptYEzX259pBv/SoqAfDmAEMrbFzBuyjm1YU7
         BIkyzcQPBjRyqlrsE1Uogp5J5fkDTEjjwBEAJR2lycnVqA75b/Dlblp38dYC+v4swglX
         Fbfw==
X-Forwarded-Encrypted: i=1; AJvYcCWbw29vHmvrq8P7gky+D2LixjZhqGSDJ9wEKLF8Lf54wDMS8p+jPcSQbFlT5GWbl8KtkbLb85ndUV0rNAvH4pc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRTtnOCDffTRjT7fMdDJmynIImnqGh6UGTL6ZpQJGU35s8/SLX
	V3/r5J1yoqveZgCTeuirUgqciJTII31LkYtl+KPmmKg+WnorwkjMF2h2k8PEKOAmq9dJJTrxkLC
	0w/5/vTxzYfKmza+ct4sNyYifh+AMMlPKdVR3yOTTna3WviHnXqr6F/XD2jY=
X-Google-Smtp-Source: AGHT+IEvbirL/hcDClvaNWS9E2YR9mYvyih3qxygmz33zoYwgC4KNsxzOEs9f+P8oN9uGiWUy2XEHmVaENeSQdofantqDPgl4BZV
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f002:b0:65d:318:df67 with SMTP id
 006d021491bc7-65f55082728mr1367976eaf.70.1767807268209; Wed, 07 Jan 2026
 09:34:28 -0800 (PST)
Date: Wed, 07 Jan 2026 09:34:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695e9924.050a0220.1c677c.0371.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nf_hook_entry_head (2)
From: syzbot <syzbot+6f6a1d20567a8d6b2a58@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b69053dd3ffb wifi: mt76: Remove blank line after mt792x fi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134dca9a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a94030c847137a18
dashboard link: https://syzkaller.appspot.com/bug?extid=6f6a1d20567a8d6b2a58
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18036fd3b399/disk-b69053dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bcf4c5ec9d8e/vmlinux-b69053dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b4101a9d1eed/bzImage-b69053dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f6a1d20567a8d6b2a58@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: net/netfilter/core.c:329 at nf_hook_entry_head+0x23e/0x2c0 net/netfilter/core.c:329, CPU#0: kworker/u8:13/4537
Modules linked in:
CPU: 0 UID: 0 PID: 4537 Comm: kworker/u8:13 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: netns cleanup_net
RIP: 0010:nf_hook_entry_head+0x23e/0x2c0 net/netfilter/core.c:329
Code: 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 4c 89 ff e8 5d 76 a7 f8 4d 39 37 74 36 e8 23 56 41 f8 90 <0f> 0b 90 31 db 48 89 d8 5b 41 5e 41 5f 5d e9 5a 9f 90 f7 cc e8 09
RSP: 0018:ffffc9000d997788 EFLAGS: 00010293
RAX: ffffffff897fa15b RBX: ffff888024f18000 RCX: ffff888033515b80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888033515b80 R09: 0000000000000006
R10: 000000000000000a R11: 0000000000000000 R12: ffff8880555f8000
R13: 0000000000000005 R14: ffff8880555f8000 R15: ffff888024f18108
FS:  0000000000000000(0000) GS:ffff888125e1f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fa18ff8 CR3: 00000000ac7e4000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __nf_unregister_net_hook+0x74/0x6f0 net/netfilter/core.c:491
 nft_unregister_flowtable_ops net/netfilter/nf_tables_api.c:9038 [inline]
 __nft_unregister_flowtable_net_hooks net/netfilter/nf_tables_api.c:9053 [inline]
 __nft_release_hook+0x180/0x350 net/netfilter/nf_tables_api.c:12035
 __nft_release_hooks net/netfilter/nf_tables_api.c:12049 [inline]
 nf_tables_pre_exit_net+0xa7/0x110 net/netfilter/nf_tables_api.c:12200
 ops_pre_exit_list net/core/net_namespace.c:161 [inline]
 ops_undo_list+0x187/0x990 net/core/net_namespace.c:234
 cleanup_net+0x4d8/0x7a0 net/core/net_namespace.c:696
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x510/0xa50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


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
