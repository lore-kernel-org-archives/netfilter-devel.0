Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F0B197A72
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2024 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215143; cv=none; b=hk/RI+QEcN3OKgL9lwvDSdNmQ6KUdvskcyLldZfV8CY1rMH49/rJ9E4bu5pec9TdjbC2VkL3C8faod5SeIoWxl0zHLzJ3KABxUYVBaDf+hsICnT0TFilQb+IMizRbI8vwRJMqHdBfUVLub/S3BBcR1SnzJ1OLGIDClB/zp0nYjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215143; c=relaxed/simple;
	bh=8RQzucyBtXDListz71niPYywyYwQMq3VJ0QNsHWkUZg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DAZviotH2AcO8KOXbmhnIXBsm3/Z3mhxyjOmjixRcrKELCdab+0q9ATivCaUaFmV74F/6NDWRhEMidLke4tj7JW8OcXJgWFcnwvPOLm9D4wkET/Y16Q+kwkghNtZ5NW31AYwicn3QlMYlGBkcGlzRX4z51ebK7EimQGzh7M5EWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39a1ba36524so26893405ab.2
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2024 07:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723215141; x=1723819941;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WS4wUdMu05PmjoIYmryXhPmZERIqmmPmzD6LTmQl2oo=;
        b=EJL3hdcadqzeYYllciJ2bOLo2yG3s1FnKUUTWYxVjoKjCKOAbo/FEN+gfB9meaw58P
         J/Iujk+vgId47B/2ftnCsVv8rZrnXXEBuuDoabflSTVfj8SoFJLptPH5xf71HFkrREm9
         nDjEifOGY+g/95MRbbG0BMIOAIY2Wo2ja+aeXHLaiQhSgp+p8ukwpnyM9A+hqaOUXVqv
         ezUIbyHvya6ZeJMV/808dhsUv+ezgkD2r2h0QHuUNfQBctmpcpESd+7D6WEdsXZ/YXlN
         sXc/iEXBfsnH5nFsVF8Ne2ESLLVMX3Tltvn/mwm1ofk05FAtci8AKVLsLR35NCe+70ob
         6wdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3OWSqusH/aP7Lq5RsoQG+YJ1A6Tn6i70tB1SZL2NrbIaPjtkfwPUVH8TTZUGZ5TksJMaIaRKYWNB4y6R1Q+O62v/t2PqlSR/hYUgmltV+
X-Gm-Message-State: AOJu0YxS3u6N5XLlaMTsi8DSsqCV2qVNv0uDsXwuvn0rXURs+f1zGYFQ
	k7kYDNOLi9lC6azincn+xaQqvF9wSugnQgOvmb1igHYyCC6EPxY1cO3N/8NdYZCr1oz96l89gPr
	woFUa5bfxHOpMquTp6harpN4JJCTQtyPmwhLb+ZSUnm0F302FDM55QFc=
X-Google-Smtp-Source: AGHT+IG2sLm+75dZfXZVL08OlLUbAPAT1G+F5FE4fmFYw73Y7klQmlGy2LiIizPVLc2gjsEP8ZRq/hbtunz9NcZfH4l1YOgBGg33
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cd:b0:39a:ea21:1202 with SMTP id
 e9e14a558f8ab-39b81324a16mr1847285ab.5.1723215141558; Fri, 09 Aug 2024
 07:52:21 -0700 (PDT)
Date: Fri, 09 Aug 2024 07:52:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000626bb6061f414a6a@google.com>
Subject: [syzbot] [netfilter?] KMSAN: uninit-value in nf_flow_offload_inet_hook
From: syzbot <syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    21b136cc63d2 minmax: fix up min3() and max3() too
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1722af45980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a7cf62669c9536b
dashboard link: https://syzkaller.appspot.com/bug?extid=8407d9bb88cd4c6bf61a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7bab3af28a0e/disk-21b136cc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b237f0093184/vmlinux-21b136cc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4f9706b6c9e0/bzImage-21b136cc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8407d9bb88cd4c6bf61a@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_flow_offload_inet_hook+0x45a/0x5f0 net/netfilter/nf_flow_table_inet.c:32
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5440 [inline]
 __netif_receive_skb_core+0x47b1/0x6c90 net/core/dev.c:5528
 __netif_receive_skb_one_core net/core/dev.c:5658 [inline]
 __netif_receive_skb+0xca/0xa00 net/core/dev.c:5774
 process_backlog+0x4ad/0xa50 net/core/dev.c:6107
 __napi_poll+0xe7/0x980 net/core/dev.c:6771
 napi_poll net/core/dev.c:6840 [inline]
 net_rx_action+0xa5a/0x19b0 net/core/dev.c:6962
 handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
 __do_softirq+0x14/0x1a kernel/softirq.c:588
 do_softirq+0x9a/0x100 kernel/softirq.c:455
 __local_bh_enable_ip+0x9f/0xb0 kernel/softirq.c:382
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:908 [inline]
 __dev_queue_xmit+0x2692/0x5610 net/core/dev.c:4450
 dev_queue_xmit include/linux/netdevice.h:3105 [inline]
 packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3145 [inline]
 packet_sendmsg+0x90e3/0xa3a0 net/packet/af_packet.c:3177
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:745
 __sys_sendto+0x685/0x830 net/socket.c:2204
 __do_sys_sendto net/socket.c:2216 [inline]
 __se_sys_sendto net/socket.c:2212 [inline]
 __ia32_sys_sendto+0x123/0x1c0 net/socket.c:2212
 ia32_sys_call+0xb2/0x40d0 arch/x86/include/generated/asm/syscalls_32.h:370
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3994 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_node_noprof+0x6bf/0xb80 mm/slub.c:4080
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:583
 __alloc_skb+0x363/0x7b0 net/core/skbuff.c:674
 alloc_skb include/linux/skbuff.h:1320 [inline]
 alloc_skb_with_frags+0xc8/0xbf0 net/core/skbuff.c:6526
 sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2815
 packet_alloc_skb net/packet/af_packet.c:2994 [inline]
 packet_snd net/packet/af_packet.c:3088 [inline]
 packet_sendmsg+0x749c/0xa3a0 net/packet/af_packet.c:3177
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:745
 __sys_sendto+0x685/0x830 net/socket.c:2204
 __do_sys_sendto net/socket.c:2216 [inline]
 __se_sys_sendto net/socket.c:2212 [inline]
 __ia32_sys_sendto+0x123/0x1c0 net/socket.c:2212
 ia32_sys_call+0xb2/0x40d0 arch/x86/include/generated/asm/syscalls_32.h:370
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 7077 Comm: syz.0.484 Not tainted 6.11.0-rc1-syzkaller-00063-g21b136cc63d2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
=====================================================


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
