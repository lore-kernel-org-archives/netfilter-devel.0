Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9523EC4
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 00:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732233745; cv=none; b=DQalG1vTDu6RyWqPURUz9eNgt6jsZvyKXsQBFVnfXwFHkG1twX1BZY/R0PmYUAGbWCGBnRfQmvb8PvBbOx/8VtFIjC28lKWUeYYfVzVlpALhwNPAmYj+fhtdlEGf1X8UsD0DqROhRpnRNiJayk+iW24G+dE/2TjYvAvgdxi6zqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732233745; c=relaxed/simple;
	bh=zPNsngUrW8SuQCUC+d9uvaCWxxOh0Robx3W3qXyId9Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dvz6s6bOMwRwbwv6suT5CPdEMMhTKAtlY5pzpBf+GvrLgG3rFUDw27tNANx4hDKyYDdnqeoAw1K9C8ew90UyCiaM3rRMho0NzhInZFQAKHp2bksNEdSHTzDp21L/q/2Kwuojs1TD5e47pcX4BhmUmQEAZNBEy36hDmEMjef6CgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a77fad574cso13535765ab.2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 16:02:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732233742; x=1732838542;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ELCqlXYQXHWugF/K5LLj7RS+1lCa8OMBZmX+A9KMV0Q=;
        b=cNcH3DXuzPZcm2e79Idj75oQoCsuU0o90zxE22UsGUPt1y4Ic+Rh9jhIqpRsb940gG
         cgBsXibah9OzwuS1wyrJycgBcU1jZwMuDOd0T/dfgdZ79qeugfxYf4Ppgs7Jlu3tRePH
         oAMzfqJtvYFIoep2NZ8XtZXyudvFe98C5D6IWtd8qXvev6FxLwqbW94IxUbghUwFtPuZ
         p00IDXNZsxzFzSk5N1gmj4lFU7nWTjFSTrdjThZbUbKgmQOcXGFJPKvn6Pu458VxbWQ3
         CG8MWuQTcSFF6tjlzBAZTYotVO71st5HeFLb6Nc25/wYtPKjtFsU41amCr7brvu0JbE7
         SONA==
X-Forwarded-Encrypted: i=1; AJvYcCX/JI0jPFtOoxwmtQuOioxKX13R5v+spBbrGv0OX+sDYGJqccpm/kOdynq6JE2SDnL54TgSpD6TXBkmltB+pVk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Ua+XRhmyNvX1ImvSXYVbD6G8BHvALHDy2n+RlC2+cdJIn6Sc
	A5vp6OlLWKHWG1mJLvQaZ6MkYwI02roJB1q3IWXwAAtH2BHxqvuvp7j0KbxACodVFa6JG/ZPIp/
	LD7i6hEu9ovz0slqXwpWZ6U6thy+TQ53fghe/XZDN0xoB33+oAHZArnI=
X-Google-Smtp-Source: AGHT+IFrhkvwA9BDIyJ3ZtLI5uSkjICy1EnXOW6/o/asoQTVP8NlKGJL/8tASg0d4q4IrL5YW74eVVxtObX1THmvLRrZxr8angNo
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c56a:0:b0:3a7:6825:409d with SMTP id
 e9e14a558f8ab-3a79ab8d47dmr10712425ab.0.1732233742100; Thu, 21 Nov 2024
 16:02:22 -0800 (PST)
Date: Thu, 21 Nov 2024 16:02:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673fca0e.050a0220.363a1b.012a.GAE@google.com>
Subject: [syzbot] [netfilter?] BUG: using smp_processor_id() in preemptible
 code in nft_inner_eval
From: syzbot <syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17da1b78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e796b1bf154f93a7
dashboard link: https://syzkaller.appspot.com/bug?extid=84d0441b9860f0d63285
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cdcbc016316b/disk-43fb83c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f82505daa7c2/vmlinux-43fb83c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/74b0b41d70c6/bzImage-43fb83c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+84d0441b9860f0d63285@syzkaller.appspotmail.com

check_preemption_disabled: 3425 callbacks suppressed
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 1 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 0 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
 </TASK>
BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1627/12102
caller is nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
CPU: 1 UID: 0 PID: 12102 Comm: syz.3.1627 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
 nft_inner_eval+0xda/0x18e0 net/netfilter/nft_inner.c:251
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
 NF_HOOK_COND include/linux/netfilter.h:302 [inline]
 ip_output+0x185/0x230 net/ipv4/ip_output.c:434
 ip_local_out net/ipv4/ip_output.c:130 [inline]
 ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1496
 udp_send_skb+0xab6/0x1630 net/ipv4/udp.c:984
 udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1272
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:726
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2581
 ___sys_sendmsg net/socket.c:2635 [inline]
 __sys_sendmmsg+0x36a/0x720 net/socket.c:2724
 __do_sys_sendmmsg net/socket.c:2751 [inline]
 __se_sys_sendmmsg net/socket.c:2748 [inline]
 __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2748
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1c1ff7e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c20db5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f1c20135fa0 RCX: 00007f1c1ff7e819
RDX: 000000000000002d RSI: 0000000020007fc0 RDI: 0000000000000007
RBP: 00007f1c1fff175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1c20135fa0 R15: 00007ffef663cd18
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
