Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC8D1A7073
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Oct 2024 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727972069; cv=none; b=r0pmvJsOFdWnBQ/6hTlAMBDUwDtipil14QbjizqnG++pp2sX8PGTFxiY6AJrbUr4JrjPRiR4Lw50sFhx9ozDcWS36+zIJ9STIHjfE19w4D0CcdGzLkbYTvoPO8yPy7MC8nKBuKu1wdlzchabKep1yT1jrV2oSI075YuLek5UbGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727972069; c=relaxed/simple;
	bh=Q43Nn+nRDdSbLdmoFxzYjL6331eikpFp9tPn2TbBuiE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=U156K4dXVSJV2kzJSEsrDi0QaictwcqqGQ+DhXux0lMf1pJsrl1o0E4TfXx0baZsco3HLy/WC0PdpGpEdZU2MKg22ac+KkbTWU2wSf1S6LyUxBKFLkwmpJ9VnqpMi1pr7nc8MW63i8+UFV4MjZxIEGXxgcOeoZA1+gGRAkFFhps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82ce3316d51so101768239f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2024 09:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727972067; x=1728576867;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qTPs2W9AuhEyIZxezQD0f+MtBNpMI6U9HXy5kw/im2I=;
        b=PY4XECDg1DWdSoyQZnC3k1qAOfKlMY6RQ14HNY4RBDPl6RbdGfiQ5+sJNm4WDbWe8H
         oGARlYVB3FjVY0wLqgdAQT5ZcR2fuxntHfBkr5IH/9lkBR3iZy3WnsFtd3XLVMsQxHAL
         V5wmkSaRPz0rbZNyoLdiWuxuKsZs+kdhu2t5cRF7D1vTRZhxuvs1x3Oqwet05Re/e01O
         qkwVkOH1AoTXk5V4yjQmEZL/QFmvqeBzNjXfq08iizqipC38uh0DYdMy8HgL3x5qXJbo
         j4Pz0E7MwF2LdFkMycTEPBnuAfg1OrHWNjuH8sCpYAgOMMKlm76Blj3FOEK6mqI9t99N
         RzGg==
X-Forwarded-Encrypted: i=1; AJvYcCWK1AFYsa8bVI4b3TMsmhFvypX0r/0sRuwsDZW3xG0Ej+I5fxCWNKO9aYW+o0fH+DKdHiUy9WysE7vAyE1Achg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmp/AOrId+Ea+W+BPlsN0wCLkgpmwPJZBTrWYD1zybcFjjERd3
	PCsiGW2Yyf5EwTZ/X8hxEqxain2N7a5qqJgDN6ePjmsqdcudbog5norPSPAJzzalwhlYvmUPc/2
	s1UXIAd1axj5whb/vO6cXylGBg9mDkgzkbEln3y/WrRliYeuOzpHCDBo=
X-Google-Smtp-Source: AGHT+IGqxnJc4MF9EmIwdRctewFC6Fc6ArE6osuDIWG7YfiOTD0mRcrVfe8kJ86Jsy4VOJybW/Gdvar+IxAHI3CwcMMcKFy9k/d+
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdaf:0:b0:3a0:8d2f:2914 with SMTP id
 e9e14a558f8ab-3a36594abadmr70909295ab.23.1727972067026; Thu, 03 Oct 2024
 09:14:27 -0700 (PDT)
Date: Thu, 03 Oct 2024 09:14:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fec2e2.050a0220.9ec68.0047.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in xt_cluster_mt (2)
From: syzbot <syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    da3ea35007d0 Linux 6.11-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10462807980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=256c348558aa5cf611a9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14462807980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b21bc7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/46118740ac64/disk-da3ea350.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/435bba6270f6/vmlinux-da3ea350.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e93b731ca115/bzImage-da3ea350.xz

Bisection is inconclusive: the first bad commit could be any of:

40fc165304f0 usb: host: xhci-rcar: Add XHCI_TRUST_TX_LENGTH quirk
e82adc1074a7 usb: typec: Fix unchecked return value
976daf9d1199 usb: typec: tcpm: Try PD-2.0 if sink does not respond to 3.0 source-caps

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1209449f980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_is_multicast_addr net/netfilter/xt_cluster.c:72 [inline]
WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780 net/netfilter/xt_cluster.c:104
Modules linked in:
CPU: 0 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:xt_cluster_is_multicast_addr net/netfilter/xt_cluster.c:72 [inline]
RIP: 0010:xt_cluster_mt+0x196/0x780 net/netfilter/xt_cluster.c:104
Code: f0 00 00 00 23 2b bf e0 00 00 00 89 ee e8 32 ee a1 f7 81 fd e0 00 00 00 75 1c e8 e5 e9 a1 f7 e9 83 00 00 00 e8 db e9 a1 f7 90 <0f> 0b 90 eb 0c e8 d0 e9 a1 f7 eb 05 e8 c9 e9 a1 f7 4d 8d af 80 00
RSP: 0018:ffffc90000006c88 EFLAGS: 00010246
RAX: ffffffff89f1a2d5 RBX: 0000000000000007 RCX: ffff88801ced3c00
RDX: 0000000000000100 RSI: ffffffff8fd2a440 RDI: 0000000000000007
RBP: ffffc90000006e68 R08: 0000000000000001 R09: ffffffff89f1a1c4
R10: 0000000000000002 R11: ffff88801ced3c00 R12: dffffc0000000000
R13: 1ffff92000159c18 R14: ffffc90000ace140 R15: ffff8880251bf280
FS:  0000000000000000(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efc6d6b6440 CR3: 000000000e734000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ebt_do_match net/bridge/netfilter/ebtables.c:109 [inline]
 ebt_do_table+0x174b/0x2a40 net/bridge/netfilter/ebtables.c:230
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 NF_HOOK+0x2a7/0x460 include/linux/netfilter.h:312
 __br_forward+0x489/0x660 net/bridge/br_forward.c:115
 br_handle_frame_finish+0x18ba/0x1fe0 net/bridge/br_input.c:215
 br_nf_hook_thresh+0x472/0x590
 br_nf_pre_routing_finish_ipv6+0xaa0/0xdd0
 NF_HOOK include/linux/netfilter.h:314 [inline]
 br_nf_pre_routing_ipv6+0x379/0x770 net/bridge/br_netfilter_ipv6.c:184
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:277 [inline]
 br_handle_frame+0x9fd/0x1530 net/bridge/br_input.c:424
 __netif_receive_skb_core+0x13e8/0x4570 net/core/dev.c:5555
 __netif_receive_skb_one_core net/core/dev.c:5659 [inline]
 __netif_receive_skb+0x12f/0x650 net/core/dev.c:5775
 process_backlog+0x662/0x15b0 net/core/dev.c:6108
 __napi_poll+0xcb/0x490 net/core/dev.c:6772
 napi_poll net/core/dev.c:6841 [inline]
 net_rx_action+0x89b/0x1240 net/core/dev.c:6963
 handle_softirqs+0x2c4/0x970 kernel/softirq.c:554
 do_softirq+0x11b/0x1e0 kernel/softirq.c:455
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:382
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:908 [inline]
 __dev_queue_xmit+0x1763/0x3e90 net/core/dev.c:4450
 neigh_output include/net/neighbour.h:542 [inline]
 ip6_finish_output2+0x1001/0x1730 net/ipv6/ip6_output.c:141
 ip6_finish_output+0x41e/0x810 net/ipv6/ip6_output.c:226
 NF_HOOK include/linux/netfilter.h:314 [inline]
 ndisc_send_skb+0xab2/0x1380 net/ipv6/ndisc.c:511
 ndisc_send_ns+0xcc/0x160 net/ipv6/ndisc.c:669
 addrconf_dad_work+0xb45/0x16f0 net/ipv6/addrconf.c:4282
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd10 kernel/workqueue.c:3389
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
