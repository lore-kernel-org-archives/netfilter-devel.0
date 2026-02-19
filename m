Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD2F2E6CAB
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Feb 2026 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771495415; cv=none; b=RA38cqzl08xe2zbcStCZSEvZM3ilV0vJRghyddRjj47AFccRqJGJvhXu2MZvIl3h0Ivdn4iW+1E8gjxFwFIITopvibJAa0YRFmsALveoXgnAEBdGt+BeGW7Sf5VS+AuFR3nNshsXFcvbRxEela7hn8cFjtCFvccM0G+Q8tfO2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771495415; c=relaxed/simple;
	bh=sEIJOIuiR0o6vuxNRuKsbIrhMaxf4GimZjRON6NHACk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pvMrXT9zBZdK6+oTvB13lBjpQITWeqqvYTy83zDv7V1mt4/OtXYvOiiEFg4El4yULvp0pKFj6a+JAqGQH+xQ3XOUZnGRmsFPs9aNn9rgb/xoN8YErGp6+LToY0AS8ugz/7z92n70zMUmTgYfYNY22DxGHfaT+eHLrnNga5IT04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-66b612efb4aso8765756eaf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Feb 2026 02:03:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771495413; x=1772100213;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mnyxSwG0f43opxwhR2Uh0mu4WQh6AUfN8L7kli8tKR0=;
        b=UTmDXKaCER0rcM+EFEb4hAx9v6usZv4GXWIKECNteIjpQg6f1PrN8X11A1bGy6g/vB
         irt+nHlwpm0vytkyRpOsh7Vq16eB7QA1N4fXXqApPTAiYo5Fg8ysqRMFlEILl/s9rXvD
         60BxnTryQpSPa1lzGrfH66IHgZgHsCcev/r+/jg6ZtK+rPwcyLGUEQQbcC4arTcu9zV+
         T6y32Jxh0RFJxP+danufe0muDYCasOcPCDEbGZKmpT8SE7d2Ga75xgeSmZLhB/DoLroA
         grP7ZGdLu6OU0/pn02NLgQuEHW/turatYuE12Pl8M5mPeZ8BB2sPUc8VxQRflSyn+7eC
         d8ow==
X-Forwarded-Encrypted: i=1; AJvYcCUYjqEL/TtGtbw+sNto3PoHa9ODii7fYgc2NZLiIPX7Vzkft4qCKK2dHyZTyK52dxk4bLU3Gg1dittJjPhkHfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKBWTSc47kb06CtE2wvOjipMtU8tDY72IkiPIjcGVlZbaE1ILw
	eFg/cmaxN2v96I/NryaT5lxEtNkjBn0Lh9AjAvLu8KWzKwtVD75pNdB2I4ju8IXEiWHYbsjL1sb
	yx/WDCa4+yMYm7vvyQld2BrxqtOHYnxkG8XkfwEMHmvd3VHVWJloJAZJH2mE=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2188:b0:676:7a1d:2c57 with SMTP id
 006d021491bc7-679b1036992mr638024eaf.19.1771495413173; Thu, 19 Feb 2026
 02:03:33 -0800 (PST)
Date: Thu, 19 Feb 2026 02:03:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6996dff5.a70a0220.2c38d7.0123.GAE@google.com>
Subject: [syzbot] [netfilter?] KASAN: use-after-free Read in nf_hook_entry_head
From: syzbot <syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4c51f90d45dc selftests/bpf: Add powerpc support for get_pr..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1736f652580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d9e410399043c26
dashboard link: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11213b3a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/173ab67d0a10/disk-4c51f90d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c8787b7cc0e/vmlinux-4c51f90d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf9799a7764a/bzImage-4c51f90d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in read_pnet include/net/net_namespace.h:419 [inline]
BUG: KASAN: use-after-free in dev_net include/linux/netdevice.h:2741 [inline]
BUG: KASAN: use-after-free in nf_hook_entry_head+0x1f1/0x2c0 net/netfilter/core.c:319
Read of size 8 at addr ffff88807c16c108 by task syz.3.29/6113

CPU: 0 UID: 0 PID: 6113 Comm: syz.3.29 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 read_pnet include/net/net_namespace.h:419 [inline]
 dev_net include/linux/netdevice.h:2741 [inline]
 nf_hook_entry_head+0x1f1/0x2c0 net/netfilter/core.c:319
 __nf_unregister_net_hook+0x74/0x6f0 net/netfilter/core.c:491
 nft_unregister_flowtable_ops net/netfilter/nf_tables_api.c:9059 [inline]
 __nft_unregister_flowtable_net_hooks net/netfilter/nf_tables_api.c:9074 [inline]
 __nft_release_hook net/netfilter/nf_tables_api.c:12063 [inline]
 nft_rcv_nl_event+0x7b8/0xdb0 net/netfilter/nf_tables_api.c:12176
 notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9f86f9c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc01263e28 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f9f87217da0 RCX: 00007f9f86f9c629
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f9f87217da0 R08: 00007f9f87216038 R09: 0000000000000000
R10: 000000000003fd84 R11: 0000000000000246 R12: 000000000001a119
R13: 00007f9f8721636c R14: 0000000000019ef5 R15: 00007ffc01263f30
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88807c16e700 pfn:0x7c16c
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea000176ec08 ffff8880b8640a40 0000000000000000
raw: ffff88807c16e700 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x446dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), pid 6130, tgid 6113 (syz.3.29), ts 106243960748, free_ts 106536545080
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1888
 prep_new_page mm/page_alloc.c:1896 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3961
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5249
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2485
 ___kmalloc_large_node+0x4e/0x150 mm/slub.c:5118
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5149
 __do_kmalloc_node mm/slub.c:5165 [inline]
 __kvmalloc_node_noprof+0x7b/0x8a0 mm/slub.c:6668
 alloc_netdev_mqs+0xa6/0x11b0 net/core/dev.c:12012
 tun_set_iff+0x532/0xf00 drivers/net/tun.c:2778
 __tun_chr_ioctl+0x7bb/0x1e10 drivers/net/tun.c:3088
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 6113 tgid 6113 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1432 [inline]
 __free_frozen_pages+0xc00/0xd90 mm/page_alloc.c:2977
 device_release+0x9e/0x1d0 drivers/base/core.c:-1
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x228/0x560 lib/kobject.c:737
 netdev_run_todo+0xc75/0xde0 net/core/dev.c:11713
 tun_detach drivers/net/tun.c:640 [inline]
 tun_chr_close+0x13c/0x1c0 drivers/net/tun.c:3436
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88807c16c000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88807c16c080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88807c16c100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff88807c16c180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88807c16c200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
