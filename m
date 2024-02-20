Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F97F17554
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708439483; cv=none; b=NVT9xwoedE7Y53XqYdzbALf1U3pCdkke1WgylV4bdN4eIKUvxex+fECflhDvS+tNPQSJghY7sd2uGKf/Ollr0FhfqFuFJcLK3MQ/UrCugH5j/lFKSlw3K0WAe/TlX26ww1KuPx1eewMOe92GjC+dRcYEc34buQ97U1bIkmdcGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708439483; c=relaxed/simple;
	bh=1Ku617Ug3TIkXzoKRdJUDcauPiB6tB464nbm+/XGfiI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Cs7fdsHF55LYnjdmUOvzDxH7o7NXOKFz01a4jMnp1SC8VywTjAjEuRclf8NqD4coUWqkiuqcqmSVmEKRwgzks48KVAHSoGt6XzzlfHzXS+JmZIrIRmN53jf4vrUf//OSQtBgpkFlIDrvWvSVUp+PyOJJ8kpTUI8A257qarQ+f/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c751a35e4dso150649239f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 06:31:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708439481; x=1709044281;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rK+JD4sM6GkbtXUauvK2wy7q/mG6x0dPYQMJQoe+q9A=;
        b=pZbZ0mZrC0zTOz3gS9ZTlOcxUCEbRqqV9V0XcmnldTwEXuwlt11vA3YYhbJo9rWhiB
         2+uHXT+WRLtdoEwPCoOZRo44gQMSIMajsruuhSAj0i3BJG2r4Gn1lD72aQp86GWyXOnS
         pQkserOErJr/X23eItvKvWCgxwi3wLpSc1JnwbvU8uKLnyNFuH9uFvYT5VZLhQ09qSoH
         zrQsINfRFVCpxBQKxsfgUsxtDs85NYTDdy5mBgKL35B8JevNC/nhRodGjSjdK+cx7/iY
         +TsgvD+Tv9/yFwfCNogrk8S8iQGnZIeLb5wti9Q+DrtEguCuWhYt78CpMcKyXFvP8dst
         ybbA==
X-Forwarded-Encrypted: i=1; AJvYcCUZOiKuDHqMxN7iDjtpu4GNFKdrmZTmcv4anp0coon9M41YT4CByn+WnXQSrWQYk1jUiKguAZb8DSEzZyjMYqHL3PNMQbdRlcS+TVMfTTga
X-Gm-Message-State: AOJu0YwMk5D932yqJLCtTi/BoZAiybZZ0D/4NjlRjA+qVio8NSgE6aq+
	THa8TlKwKeB4Xfe9HmH0sevd17ht+wTf2IS9KERId0L8eAaFjg8VzEaXKhbN9rEbdJFaC2/Rwiz
	V0cgjxhnRIG3+Kdwpl/iwMwpeftJIQ0GswABOCBLomN2WiM7Kqi6zhO0=
X-Google-Smtp-Source: AGHT+IF78DcUKnNEHE/PHVeiSh2vVF1cahGnv8yWxefMMlQtm0HPEhjwGlPPR/jtz2ThXvoCK8+95NwASrmw1mlSaPprqr8t94Fd
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4708:b0:473:dcbe:bb58 with SMTP id
 cs8-20020a056638470800b00473dcbebb58mr302126jab.4.1708439481496; Tue, 20 Feb
 2024 06:31:21 -0800 (PST)
Date: Tue, 20 Feb 2024 06:31:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a393d0611d11073@google.com>
Subject: [syzbot] [netfilter?] KMSAN: uninit-value in __nla_validate_parse (3)
From: syzbot <syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c1ca10ceffbb Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1120c23c180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e3dd779fba027968
dashboard link: https://syzkaller.appspot.com/bug?extid=3f497b07aa3baf2fb4d0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/83d019f0ac47/disk-c1ca10ce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/49e05dd7a23d/vmlinux-c1ca10ce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/68ec9fa2d33d/bzImage-c1ca10ce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in nla_validate_range_unsigned lib/nlattr.c:222 [inline]
BUG: KMSAN: uninit-value in nla_validate_int_range lib/nlattr.c:336 [inline]
BUG: KMSAN: uninit-value in validate_nla lib/nlattr.c:575 [inline]
BUG: KMSAN: uninit-value in __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 nla_validate_range_unsigned lib/nlattr.c:222 [inline]
 nla_validate_int_range lib/nlattr.c:336 [inline]
 validate_nla lib/nlattr.c:575 [inline]
 __nla_validate_parse+0x2e20/0x45c0 lib/nlattr.c:631
 __nla_parse+0x5f/0x70 lib/nlattr.c:728
 nla_parse_deprecated include/net/netlink.h:703 [inline]
 nfnetlink_rcv_msg+0x723/0xde0 net/netfilter/nfnetlink.c:275
 netlink_rcv_skb+0x371/0x650 net/netlink/af_netlink.c:2543
 nfnetlink_rcv+0x372/0x4950 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1341 [inline]
 netlink_unicast+0xf49/0x1250 net/netlink/af_netlink.c:1367
 netlink_sendmsg+0x1238/0x13d0 net/netlink/af_netlink.c:1908
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3819 [inline]
 slab_alloc_node mm/slub.c:3860 [inline]
 kmem_cache_alloc_node+0x5cb/0xbc0 mm/slub.c:3903
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:560
 __alloc_skb+0x352/0x790 net/core/skbuff.c:651
 alloc_skb include/linux/skbuff.h:1296 [inline]
 netlink_alloc_large_skb net/netlink/af_netlink.c:1213 [inline]
 netlink_sendmsg+0xb34/0x13d0 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x9c2/0xd60 net/socket.c:2584
 ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2638
 __sys_sendmsg net/socket.c:2667 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x307/0x490 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

CPU: 1 PID: 6771 Comm: syz-executor.0 Not tainted 6.8.0-rc4-syzkaller-00331-gc1ca10ceffbb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024
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
