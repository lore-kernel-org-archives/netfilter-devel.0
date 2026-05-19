Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B083F1AC9
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 11:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191794; cv=none; b=P57Y4jjbYDVOSquewzvGF91jzzdXdzFP/JlPJluXNQVPP8qYH5BlQU3WSkkbi0D206dYvslU/48BBj0keQC7clxkuNZeYpYuN8kuvpV4Ci4k0qS9y+Hkpv66J1FeWiTalCZr+k6Yk3tK6b3Oz35FlWLimQLb0zs/37jN/AygSAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191794; c=relaxed/simple;
	bh=6EHyX+t59JQk8qaGatmxGZ3pdkNuXcSnsYDgZnyNEp4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eYkP0mvf9xYFhAdU3moSRzh4u/okJDnlxvoQUHOZEdPGinLmmJ9qgI1Jicj6hVQQDuFw738FosG8hWDiNpc9aoDIiulu1EZYidX+Q7j0Bp87stA6zskBrD59XISVRyC0zM6hIBlQY5zNvGLmmg/yLIp01nds3O4+IiX8f7zeaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-68e924f632bso6754412eaf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 04:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191792; x=1779796592;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1p6VfNC57KjkmyCN/S20TDWRsKpJFRMJHYp7VVD08s=;
        b=LrL14E+DmQ3DhnWyOcxSprGd2r60dwzJXBTDgP2Rq5yPPXVLRmC+YVthdrx4OHFwEI
         Cn+vXrLimHBiz7CiA2siO8fPOcNQpnEsVMHa5A0j64PeucN+tDfaDZjZCZ81ZE39Wc/W
         FBVUASrWXYEoL1X1bglbG2jKdSexeYbVuLo+B6U6/2R88s38rSe6Zj5fVv7bwkkHoyhk
         vjFuQeWV9BLEItE36IQ1pjcoXDU6uJo7VSmnk0fBvQOGniSMb2U3D7lC3lVRJW58mLri
         lgWDtKAOtUNcfAS+ye76YLaRA9oG8eqH56ZGrarQr4JMhrvY68x0eYc+btPHINk7Zm63
         VLOQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vXVLAvWUtn316QClNTJAPhXBt/EeC2ckyja2q9vY5oqXBtJXkv+osyrTLAtU892xQCN3fGWRUT49Ga8p+t78=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyQMPVi4kFbhyFn4KLc400dBJ2/N81ou4M0SpZGMQTy++2cVR7
	/NuWDXb7KvkZWxnUUyG2FR/PVE/uMUjZaoJCoc7pUqsVtOSTv6xtQjsL2LZIFqVu1mfm5Zs/S3r
	s5oZ3tJ3IihBc3MFhe2im8XIGQ1ndQFJhtJCvym4oOGnooCBfSECbFRraCQc=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e916:0:b0:68a:116a:a5e5 with SMTP id
 006d021491bc7-69c9bfb0957mr12376940eaf.44.1779191791837; Tue, 19 May 2026
 04:56:31 -0700 (PDT)
Date: Tue, 19 May 2026 04:56:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0c4fef.170a0220.25463a.022e.GAE@google.com>
Subject: [syzbot] [netfilter?] BUG: using smp_processor_id() in preemptible
 code in cpu_mt
From: syzbot <syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    50d00ea66086 Merge branch 'bpf-follow-up-fixes-for-stack-a..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17f258c8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4caf64b1ee83dac0
dashboard link: https://syzkaller.appspot.com/bug?extid=690d3e3ffa7335ac10eb
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dbc6ccaf15bc/disk-50d00ea6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9160c9066e5c/vmlinux-50d00ea6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6f1c3abffde/bzImage-50d00ea6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com

BUG: using smp_processor_id() in preemptible [00000000] code: syz.3.1377/11941
caller is cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
CPU: 1 UID: 0 PID: 11941 Comm: syz.3.1377 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 cpu_mt+0x53/0xd0 net/netfilter/xt_cpu.c:37
 __nft_match_eval net/netfilter/nft_compat.c:412 [inline]
 nft_match_eval+0x1ad/0x2b0 net/netfilter/nft_compat.c:442
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x48d/0x1ae0 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x360/0x4b0 net/netfilter/nft_chain_filter.c:162
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:619
 nf_hook+0x22a/0x3a0 include/linux/netfilter.h:273
 NF_HOOK_COND include/linux/netfilter.h:306 [inline]
 ip_output+0x269/0x450 net/ipv4/ip_output.c:438
 __ip_queue_xmit+0x116a/0x1bb0 net/ipv4/ip_output.c:534
 sctp_packet_transmit+0x246f/0x2ac0 net/sctp/output.c:653
 sctp_packet_singleton+0x234/0x340 net/sctp/outqueue.c:783
 sctp_outq_flush_ctrl net/sctp/outqueue.c:914 [inline]
 sctp_outq_flush+0x50d/0x31b0 net/sctp/outqueue.c:1212
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:-1 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1204 [inline]
 sctp_do_sm+0x54c7/0x5cf0 net/sctp/sm_sideeffect.c:1175
 sctp_primitive_ASSOCIATE+0x95/0xc0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143d/0x1900 net/sctp/socket.c:1840
 sctp_sendmsg+0x1b3d/0x2c10 net/sctp/socket.c:2030
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x80a/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff6e519ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff6e33f6028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff6e5415fa0 RCX: 00007ff6e519ce59
RDX: 00000000000480d1 RSI: 0000200000000140 RDI: 0000000000000003
RBP: 00007ff6e5232d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff6e5416038 R14: 00007ff6e5415fa0 R15: 00007ffdfe9dd548
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
