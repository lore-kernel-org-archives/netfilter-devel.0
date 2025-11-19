Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AAF363C4F
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 13:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763558067; cv=none; b=WM0mNMPWK3iFgp7tduSuMggfyNefEnkyFrZE3uuoJnnmgcsEqIDlkoBTDpuZ7NMgLhjmUnyY2oF34SBs0yalswmKWC3V5G+A0NDR067i0S/X1Mv/ARqx+WG5hLWMbCfRgMW2cFgyExLoGvjze/+9p3+kyZkHWeXeN28p5jfiZjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763558067; c=relaxed/simple;
	bh=42RmOKiDA6GeexOCOMcU/ivBYtVakVLPOtwUodTLUOk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZbCBfVm74ODbV797CQvni33UI1dXlbYCtu4yub312oXI83elTHwTNACpfbSm6ESzNyzzcQsa/EThW8h9deNATQ+4IhUmif8zsMKOH9wHIHB5lEW9pJVUZ1CTXWhzYvAoEUOvwGL2+D0fkI2L7XRZX5lTpkt3n99EUE7aHKw77Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-435a04dace1so5608595ab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 05:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763558060; x=1764162860;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cWeS540O/DtVZO2hs++H8AN2oyKVmTS0zqyLwiaCVtg=;
        b=N5uWu/u63c1bFsob9p71MUUhG1qNp5pfEj9M8YBQ6C4wp5Lg2JGK+SujbZRW9GwYnW
         PfHJHSp23iLkUMVl2UvdYi42noFhG9vV1D3ZNI+4JqE53M8YEGJfa36rPLiNBuJLNV5p
         E+DugZJyo+R8OWmRplJHdoCtdyqlDDI0eGPzWp635fhX6hIuA5kTzo8zZ0/1hWKmwZzf
         FcDpa860fw1GviwcY7HzkxqsSUibKELRfxgiu/VESETx6dyDwaAgqlAa11oqoACYKWfy
         8cLoayYi++p9GdRzKBSmUH13nub26qiS/EAdy1DtSmytZIMlaH+JQL1FNvQRs1AuZrvi
         aQnw==
X-Forwarded-Encrypted: i=1; AJvYcCUN+vzhgqZe4l/MdS+vQMSy4k4xRxbrOggpRw6YD6pqir6GigmdRHnHgT6/141rkvr8bKUFeuHIsVn7MORkE2g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFaEvBm5Z0Q3Ojs3nFbA/AE0Gd3le54VKLtSi859asHlxv7V5Z
	GBDsuglzjTXHfqpF6sD3cqPr0fdEZ7bdicwkhno+M6u4etREMIp9XLCTHUDimcXBfR/aoCHJi3i
	vK8JieimSM1rt8iKUVRKvlQ5ANKAT8Rkt/20ngipV09UmcdhanxcZmBkDwvE=
X-Google-Smtp-Source: AGHT+IE0wN29h+b//Oy4kflZwkutKByXWn7e4G2F17+fGh7LzriH+pLrQE9E/GQMsNJDpkneW5Y33SPtXhIrBOd2RULh8XNfzAHd
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3810:b0:434:96ea:ff8b with SMTP id
 e9e14a558f8ab-43496eb0395mr195448995ab.35.1763558060468; Wed, 19 Nov 2025
 05:14:20 -0800 (PST)
Date: Wed, 19 Nov 2025 05:14:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691dc2ac.050a0220.2ffa18.0005.GAE@google.com>
Subject: [syzbot] [bridge?] [netfilter?] WARNING in nf_ct_bridge_post
From: syzbot <syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com>
To: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, fw@strlen.de, horms@kernel.org, idosch@nvidia.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5bebe8de1926 mm/huge_memory: Fix initialization of huge ze..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1526e97c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fca8b4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121b7332580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5bebe8de.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/45a180eaa13d/vmlinux-5bebe8de.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9ba2dcafae20/bzImage-5bebe8de.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com

bridge0: received packet on syz_tun with own address as source address (addr:aa:aa:aa:aa:aa:aa, vlan:1)
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5876 at net/bridge/netfilter/nf_conntrack_bridge.c:357 nf_ct_bridge_refrag net/bridge/netfilter/nf_conntrack_bridge.c:357 [inline]
WARNING: CPU: 0 PID: 5876 at net/bridge/netfilter/nf_conntrack_bridge.c:357 nf_ct_bridge_post+0x3ff/0x1060 net/bridge/netfilter/nf_conntrack_bridge.c:408
Modules linked in:
CPU: 0 UID: 0 PID: 5876 Comm: syz.3.94 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:nf_ct_bridge_refrag net/bridge/netfilter/nf_conntrack_bridge.c:357 [inline]
RIP: 0010:nf_ct_bridge_post+0x3ff/0x1060 net/bridge/netfilter/nf_conntrack_bridge.c:408
Code: 89 ff 48 89 da 48 8d 8c 24 40 01 00 00 49 c7 c0 40 0c 2a 8a e8 12 d6 e1 ff 41 bf 02 00 00 00 e9 9c 07 00 00 e8 d2 1a 96 f7 90 <0f> 0b 90 45 31 ff e9 8b 07 00 00 e8 c1 1a 96 f7 eb 05 e8 ba 1a 96
RSP: 0018:ffffc9000d996ae0 EFLAGS: 00010293
RAX: ffffffff8a29f88e RBX: ffff888050bc0140 RCX: ffff88803b2b0000
RDX: 0000000000000000 RSI: ffffffff8f40f220 RDI: 0000000000000081
RBP: ffffc9000d996cc0 R08: ffff88803b2b0000 R09: 0000000000000002
R10: 000000000000dd86 R11: 0000000000000000 R12: 1ffff1100a17802e
R13: dffffc0000000000 R14: ffffc9000d996d80 R15: 0000000000000081
FS:  00007f027c05e6c0(0000) GS:ffff88808d730000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 0000000059f5b000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x215/0x3c0 include/linux/netfilter.h:316
 br_forward_finish+0xd3/0x130 net/bridge/br_forward.c:66
 NF_HOOK+0x320/0x3c0 include/linux/netfilter.h:318
 __br_forward+0x41e/0x600 net/bridge/br_forward.c:115
 deliver_clone net/bridge/br_forward.c:131 [inline]
 maybe_deliver+0xb5/0x160 net/bridge/br_forward.c:191
 br_flood+0x31a/0x6a0 net/bridge/br_forward.c:238
 br_handle_frame_finish+0x15a3/0x1c90 net/bridge/br_input.c:229
 nf_hook_bridge_pre net/bridge/br_input.c:313 [inline]
 br_handle_frame+0xb75/0x14f0 net/bridge/br_input.c:442
 __netif_receive_skb_core+0x10b9/0x4380 net/core/dev.c:5966
 __netif_receive_skb_one_core net/core/dev.c:6077 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6192
 netif_receive_skb_internal net/core/dev.c:6278 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6337
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f027b18e17f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 92 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 4c 93 02 00 48
RSP: 002b:00007f027c05e000 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f027b3e6090 RCX: 00007f027b18e17f
RDX: 000000000000004e RSI: 0000200000000500 RDI: 00000000000000c8
RBP: 00007f027b211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000004e R11: 0000000000000293 R12: 0000000000000000
R13: 00007f027b3e6128 R14: 00007f027b3e6090 R15: 00007ffc84bca4a8
 </TASK>


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
