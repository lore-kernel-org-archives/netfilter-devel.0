Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793913452;
	b=BsuWK6EgjDA8UH8WH8bYpWHvQJYzxkwcE+UoKobeWZhHF2n3441VoODGAjwvDiSEnO3Z
	 +4hdbmGfXiTU5LEbuz/EzAgPYXes41FHrL8B0vo56/o+iZR2FNDYNOcVnjGcxMdFn3zv4
	 bLZuYTqfHjTldeYYh/qKAOjMN/08fRJ3O4dxjPqtNva691rTWpdYMU5KZfExVszZLdOe+
	 hk/YtFJM1eGs/mEA3ka33dETx5q4xNv3owZjdj8DWq+30oCDXSHUWxvvwg8ons5YrgA4b
	 PwkgQAa9HbcGg0V6DTFoSU4XVfOaWERnBwbiiG/GF+z2NkdkHKBiQ6zezccHOAXTHBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913452;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=kKvT1WZP63DDiif92MikpmY+JmPHkMKG8ncW+5LMjTE=;
	b=lxq/73Hp52OXvtBdqWhH3RrP+C00U5hvVnoAW13n3F9XXivNvz82qQOBCJQwuY+qTpC5
	 ui+Iw1zdQzkuVWlvDTLOe8clXyAnOxAszW2yK5cGgyuiJRHtKXB8hNlRdfYijjtRS9HhO
	 gkx9uhKNIs0q/zX3xyEGsy878wzR5o1w1k1ES326yt7r+CJqHm8iQgPmlLQ/s0o4M4bKP
	 Iadhxd1cXfS7CCNek6PErTeNkfb4t9FtjNTjQ8/Hm2lKLDeDKsLx6EFHJIwvK5lpLrV4l
	 OVMViLRfqUagu0N3vutEX9rwA2w0xwaHV4E/PbklLknMC1FxtcY3+nXF8sGm496E3KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A242606A32F
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 21:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A242606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4f9b643ae53so1796254b6e.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 13:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793913451; x=1794518251;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kKvT1WZP63DDiif92MikpmY+JmPHkMKG8ncW+5LMjTE=;
        b=NvOwDiQ4ULj0CFGMGx5op5ofbwbK3vRb6yTYbjvi1tv2oxUGZBxJINYRfNVPni4Wgh
         QqCJ6UN4rcBzKm7MLNml7mAnBvk2P9ESef0ZhUEoFT5Wy852gSEpoCmzzS/11QaCveTg
         kGVRYiSW3C6X/Ba+GF67dXlXDkrB0vp+RynrnRsA1s28np/CjTkY4JSr4bqXPSeZbwnu
         xgiEiWFWEnX8wGAnj/ZLY902e6q1ilKMNPqoSWJCaBfNz4MafyoW0TnjhISRZmWLwHmw
         MDLjpL+919SYz+oTUcH+uvzhe8GknosPM87Z23z/aCx5uPH5z4qJQvX3Eg/CVRUsZHpI
         nAEw==
X-Forwarded-Encrypted: i=1; AKwUvBzZoeqztpzWQBsSdoXD6R2niCq/dLI5z0WyF0h6cZKzNoUjHwBf5n0vC7h/v20hi6YFVhHHeSb1SfUD0dyc084=@vger.kernel.org
X-Gm-Message-State: APuU4Z9CcS1MqpMcz4q/tf+9DiEHD2LFKD7X2RVhIIKxLIcWXafJYWi4
	iDI6fYQ3tjuxULl+qpjB7sJsBt+P0XQTNLtCACsZ+Pq3Gp6AUbkM+tNCbxwInaJ/oKAZoGd9y1X
	PFUtvlwslPhPBIkrZHtZa8QYEXofoP/7j/Rk1Lt80MNC1QOobo0HIGe0yEdk=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1985:b0:55c:8ee:a9c4 with SMTP id
 5614622812f47-567e115e036mr383926b6e.43.1793913451254; Thu, 05 Nov 2026
 13:17:31 -0800 (PST)
Date: Thu, 05 Nov 2026 13:17:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aecf26b.382bd2ce.33e041.0002.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in xt_dnat_target_v2
From: syzbot <syzbot+2e819f6641708bb6ab9d@syzkaller.appspotmail.com>
To: fw@strlen.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    787268686c64 ipmr, ip6mr: queue netlink route queries out ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
console output: https://syzkaller.appspot.com/x/log.txt?x=170b444e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d30e1495ee3ac817
dashboard link: https://syzkaller.appspot.com/bug?extid=2e819f6641708bb6ab9d
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=108b444e580000

AI-generated root cause summary:
When an incoming TCP packet is rejected by an nftables reject rule
(nft_reject_ipv4_eval), nf_send_reset() creates a TCP RST reply and attaches the
original packet's conntrack entry via nf_ct_attach(), marking its ctinfo as
IP_CT_RELATED_REPLY. As the RST packet traverses the NF_INET_LOCAL_OUT hook,
nf_nat_ipv4_fn() passes it to nf_nat_inet_fn() because it is not an ICMP packet.
In nf_nat_inet_fn(), IP_CT_RELATED_REPLY falls through to evaluation of
uninitialized NAT mappings, executing rules in the LOCAL_OUT NAT chain. If the
chain includes an xtables DNAT target (evaluated via nft_compat),
xt_dnat_target_v2() triggers WARN_ON because its assertion checks only for
IP_CT_NEW or IP_CT_RELATED, omitting IP_CT_RELATED_REPLY.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=2e819f6641708bb6ab9d

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e819f6641708bb6ab9d@syzkaller.appspotmail.com

------------[ cut here ]------------
!(ct != NULL && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED))
WARNING: net/netfilter/xt_nat.c:154 at xt_dnat_target_v2+0x97/0xc0 net/netfilter/xt_nat.c:153, CPU#0: syz-executor145/6031
Modules linked in:
CPU: 0 UID: 0 PID: 6031 Comm: syz-executor145 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
RIP: 0010:xt_dnat_target_v2+0x97/0xc0 net/netfilter/xt_nat.c:153
Code: 74 22 41 83 e7 07 41 83 c7 fd bf fe ff ff ff 44 89 fe e8 ac 1e 90 f7 41 83 ff fe 72 25 e8 91 19 90 f7 eb 09 e8 8a 19 90 f7 90 <0f> 0b 90 4c 89 f7 48 89 de ba 01 00 00 00 5b 41 5e 41 5f e9 21 17
RSP: 0018:ffffc90000006de0 EFLAGS: 00010246
RAX: ffffffff8a38fc64 RBX: ffff8880614cd418 RCX: ffff88807c979f40
RDX: 0000000000000100 RSI: 0000000000000100 RDI: 00000000fffffffe
RBP: ffffc90000006ed0 R08: 0000000000000100 R09: 0000000000000000
R10: ffffc900000070b0 R11: ffffffff8a38fbb0 R12: ffffffff919e5438
R13: 1ffff92000000dc4 R14: ffff8880247c8900 R15: 0000000000000001
FS:  0000555563505400(0000) GS:ffff88812361d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe16ab8280 CR3: 0000000034dea000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 nft_target_eval_xt+0x1ad/0x2b0 net/netfilter/nft_compat.c:100
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x48d/0x1b10 net/netfilter/nf_tables_core.c:285
 nft_nat_do_chain+0x360/0x4b0 net/netfilter/nft_chain_nat.c:32
 nf_nat_inet_fn+0x5de/0xb50 net/netfilter/nf_nat_core.c:931
 nf_nat_ipv4_fn net/netfilter/nf_nat_proto.c:583 [inline]
 nf_nat_ipv4_local_fn+0x18c/0x570 net/netfilter/nf_nat_proto.c:738
 nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:633
 nf_hook+0x22a/0x3a0 include/linux/netfilter.h:280
 __ip_local_out+0x558/0x6a0 net/ipv4/ip_output.c:120
 ip_local_out+0x2a/0x190 net/ipv4/ip_output.c:129
 nf_send_reset+0xd8d/0x1530 net/ipv4/netfilter/nf_reject_ipv4.c:339
 nft_reject_ipv4_eval+0xf6/0x230 net/ipv4/netfilter/nft_reject_ipv4.c:30
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x48d/0x1b10 net/netfilter/nf_tables_core.c:285
 nft_do_chain_ipv4+0x195/0x290 net/netfilter/nft_chain_filter.c:24
 nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:633
 nf_hook include/linux/netfilter.h:280 [inline]
 NF_HOOK+0x21f/0x3c0 include/linux/netfilter.h:323
 __netif_receive_skb_one_core net/core/dev.c:6433 [inline]
 __netif_receive_skb net/core/dev.c:6546 [inline]
 process_backlog+0xa6b/0x18b0 net/core/dev.c:6897
 __napi_poll+0xaa/0x330 net/core/dev.c:7977
 napi_poll net/core/dev.c:8040 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:8197
 handle_softirqs+0x265/0x8d0 kernel/softirq.c:669
 do_softirq+0x77/0xd0 kernel/softirq.c:569
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x140 kernel/softirq.c:473
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 __dev_queue_xmit+0x1efb/0x3920 net/core/dev.c:5121
 neigh_output include/net/neighbour.h:554 [inline]
 ip_finish_output2+0xc4b/0x10b0 net/ipv4/ip_output.c:236
 NF_HOOK_COND include/linux/netfilter.h:314 [inline]
 ip_output+0x29f/0x450 net/ipv4/ip_output.c:437
 __ip_queue_xmit+0x10df/0x1b10 net/ipv4/ip_output.c:533
 __tcp_transmit_skb+0x2d06/0x47b0 net/ipv4/tcp_output.c:1773
 tcp_transmit_skb net/ipv4/tcp_output.c:1790 [inline]
 tcp_connect+0x1a7e/0x4990 net/ipv4/tcp_output.c:4451
 tcp_v4_connect+0x1264/0x1b20 net/ipv4/tcp_ipv4.c:348
 __inet_stream_connect+0x28c/0xf50 net/ipv4/af_inet.c:684
 inet_stream_connect+0x66/0xa0 net/ipv4/af_inet.c:755
 connect_socket net/socket.c:2143 [inline]
 __sys_connect_file net/socket.c:2168 [inline]
 __sys_connect+0x316/0x450 net/socket.c:2185
 __do_sys_connect net/socket.c:2191 [inline]
 __se_sys_connect net/socket.c:2188 [inline]
 __x64_sys_connect+0x7a/0x90 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f81c24b2ff7
Code: 48 89 fa 4c 89 df e8 98 1d 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffe16aca280 EFLAGS: 00000202 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000555563505400 RCX: 00007f81c24b2ff7
RDX: 0000000000000010 RSI: 00007ffe16aca300 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00000000d2040002
R13: 00007f81c24eed50 R14: 00007ffe16aca300 R15: 00007f81c24ec06c
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
