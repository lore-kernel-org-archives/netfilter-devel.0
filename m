Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189035B657
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790447015; cv=none; b=osIToQimxYuTKMn59ZnIzdLv4EL2FbPJAMpJu1hoDxCcTvoLg0w3n0nLDkqxY30OTdnWI8tYrT/GTEX5T4uXKAFObW+0MDjScjpZX98Je7T+xLtwzggrcKH7yRIBGvDBGKjYti7NQZZ/nNxO28/jyHPeXVyaC57CpUiejjkZpMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790447015; c=relaxed/simple;
	bh=qfALQe90TeUnY37aQVtdHFc4lNsDWUqSJvSQILWWHpo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r6ME0MxzPgFMeQPnWP13jLlSATET0gerlhIiwJHwXFVQqNoDYVpx4iw38rluNVhf2IHZM8xwh/edqyPinEKDvjuiSQ7ghrKtB+ypnqsn9SPpgbF2Z90t5GFhZZ5+tt67FmOhP0+p7wTTtksbF0dodhXOlCJjgteo817QRcMk0FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b597558c4cso3427486b6e.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 11:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790447012; x=1791051812;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InOuP8c6dtBIwm2Fjbz4yA5MQ5gnJ6A4TGBGUZFZG+w=;
        b=P5wnbeoa8eLCWWccy36aHTk+yOzbba2sQdXtB2taijwxqkWhF/pvB32ow1jO68tUp0
         r1im9ty44Btj5OlvMyfT9B2oW6x/bKW0xPaAv1p68sm6DtzmRKxgszHB/vEYjxl+ugGK
         b0E9K2bm7bdi3O2mB1KG3QI8r6s9fStnOqXLDAGd50FxttgtfvP3Qpi76QyAGD/LlsCt
         DhyLJ/3k+kcaCwgTr8bJnK6KYprIh1xyYJ+CYsZtDTZVXIyYpI8O1u5cBn18X6SwGYV/
         hwdY21CXJ7kdXt85e2DKUKo0Eej/Owg+Tsncl3NNVh/hByttJeGHkMTUltBFecKdnMD9
         StZQ==
X-Forwarded-Encrypted: i=1; AKwUvBxVV3Xos9uxkAWww1qsPFKj7W95gIYjfGvbsSG8QNGPAKKf2avFNqXAKAEUjtA6wTVzmkn34WjUYbRL9Mc4ufk=@vger.kernel.org
X-Gm-Message-State: AFuF++ngGOdMTK1KUgQzUWONoSxdVDlBlryJ2VGAGOVC66fmhUoD3n/l
	8h85Z0tsWQdIfytlxDk+exDvjSvHU29JPM0A7hijOHeTxEv+HUJl3v5vvdpZIFdLnm/LA7OIY7Q
	mKJ/3z7x755z8uQRiPGJPEiVbITkr5CxTAOHMhJZQLupPBBErJq31wp5F6ug=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:190d:b0:4c1:e6f4:f2c5 with SMTP id
 5614622812f47-4d728c29dadmr10660539b6e.2.1790447012256; Sat, 26 Sep 2026
 11:23:32 -0700 (PDT)
Date: Sat, 26 Sep 2026 11:23:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab80da4.e548f532.1ca396.0032.GAE@google.com>
Subject: [syzbot] [netfilter?] kernel BUG in nf_ip6_checksum
From: syzbot <syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eabc76156e86 Merge branch 'net-dsa-mv88e6xxx-ethtool-n-tup..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=102d1405580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a013aa2165022bf
dashboard link: https://syzkaller.appspot.com/bug?extid=5a8667f002726fc59f88
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122d1405580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c58c5e580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1d4c5734556a/disk-eabc7615.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5c68f2f68d0d/vmlinux-eabc7615.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f4fc253f3897/bzImage-eabc7615.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com

ip6_tables: ip6tables: counters copy to user failed while replacing table
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:3606!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5631 Comm: syz-executor206 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:skb_checksum+0x8b2/0x8c0 net/core/skbuff.c:3606
Code: c4 3d 8c f8 e9 43 f9 ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 59 f9 ff ff 4c 89 ff e8 49 3d 8c f8 e9 4c f9 ff ff e8 ef 35 1c f8 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003a3f000 EFLAGS: 00010293
RAX: ffffffff89ab9c91 RBX: 000000000000053c RCX: ffff88807f8abe80
RDX: 0000000000000000 RSI: 000000000000053c RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffff88807f8abe80 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000003c R14: 000000000000003c R15: 0000000000000578
FS:  0000555590f26400(0000) GS:ffff888124cca000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556b4bcc5000 CR3: 000000006f904000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_ip6_checksum+0x1bd/0x320 net/netfilter/utils.c:89
 synproxy_tg6+0x1a4/0x6e0 net/ipv6/netfilter/ip6t_SYNPROXY.c:21
 ip6t_do_table+0xd37/0x15b0 net/ipv6/netfilter/ip6_tables.c:366
 nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:280 [inline]
 NF_HOOK+0x21f/0x3c0 include/linux/netfilter.h:323
 ip6_input+0x16a/0x270 net/ipv6/ip6_input.c:545
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 __netif_receive_skb net/core/dev.c:6377 [inline]
 netif_receive_skb_internal net/core/dev.c:6463 [inline]
 netif_receive_skb+0x278/0xbf0 net/core/dev.c:6522
 tun_rx_batched+0x1de/0x790 drivers/net/tun.c:1571
 tun_get_user+0x2be0/0x44d0 drivers/net/tun.c:2045
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:2091
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f993fdff367
Code: 48 89 fa 4c 89 df e8 78 1e 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffcd131e8b0 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000555590f26400 RCX: 00007f993fdff367
RDX: 000000000000004a RSI: 0000200000000500 RDI: 00000000000000c8
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f993fe6ebe0 R15: 0000000000000002
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_checksum+0x8b2/0x8c0 net/core/skbuff.c:3606
Code: c4 3d 8c f8 e9 43 f9 ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 59 f9 ff ff 4c 89 ff e8 49 3d 8c f8 e9 4c f9 ff ff e8 ef 35 1c f8 90 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003a3f000 EFLAGS: 00010293
RAX: ffffffff89ab9c91 RBX: 000000000000053c RCX: ffff88807f8abe80
RDX: 0000000000000000 RSI: 000000000000053c RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffff88807f8abe80 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
R13: 000000000000003c R14: 000000000000003c R15: 0000000000000578
FS:  0000555590f26400(0000) GS:ffff888124cca000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556b4bcc5000 CR3: 000000006f904000 CR4: 00000000003526f0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
