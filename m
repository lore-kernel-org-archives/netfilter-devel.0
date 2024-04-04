Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBE535AC
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712234974; cv=none; b=Jm8lYmF366vJW+knb+tlnA6MoS8XsRmRoELhl4H8Ds85+FtEJmhHqvosC3zJbca20mrbOeZBmAPVpWw58KlkqR7gGSjHI600duzZWpODG5BxagmKEhLYIXEmnDFYOOX4Asq6OxwcaDXYgGpviDWxMPT/uOo9yreklRsTRkSUGow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712234974; c=relaxed/simple;
	bh=sb4KZ5DnjkABLmFvWPyLD59JcXtsgt27QvqxFSn2aiQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FQ1/D8jcbIqiHL+Z5TIFd364OucIreH1okhc6QbrVA+wcONcuT3160JiViUxLaGfqGs8VEK22++qGKO+EiJ4NsHniqFr+CZLNM9d1PRv9/GaXVWPx6R02zOFAr4pT+9gCmsiEtgFaXIg/e1CnKEgwIkJQX2dOnE8FE/maOAcmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-368cb71dfbeso7700515ab.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Apr 2024 05:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712234971; x=1712839771;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VpwTCb/N6+jyMk/fXZkM5PIZRZLMUvuOzVXItB/Y9yk=;
        b=qmzOaHd6KeBU7EVYE2p7YWKfSjBmOsYDMIptIRLxppAPle3U6uF8M4E0dET0klvvz+
         +7615dUKjgPicl81lG/4evyZZp2ddExEUak3hyG2VM1LeKSS71IEm6alMfiJnJITTKv8
         h29v30VcRI8eqrxpx4OAmI6iSss8HhqpSBmsD1HU3B3DAn3tABdhLJYcF8YMoHHyxbmQ
         s7WIEYJYmQdddufjpPGIwnJquYihw6gB9Ul6McMkwmhcUuAYr7k1TWDabbRkQFj2KoUI
         1HkNw4ZbCLxUy4qFOeeDX4xDjW/PKiTKKd1/VOOQ6GQm1skedkMG+DXiZLzCgs93sxNw
         RTJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU2/Z4FCKssZo22/M6yHMC6J3z7lO6fqNAae9Kek+depgQ/oJoHyiPVpT6i5Xf2Ydt2xywI7aC++eYf+oZVlThOT+vPgn0bkL51Z2RHp/F
X-Gm-Message-State: AOJu0YyXdUqXh5Hn4D0SJXCEQ5t5h8AHdz3sGk1XYfxuiqFss7w4UN4t
	YfnS884jf4vl/tn2cbt9hHsLZv9Rjzy147bs0zDRun/cAKurigzkfyGj45n4CXxRy1kJWL+5ROn
	sJo72T/PG13o1qT8FmFFLuZRjP4nmdw6w9agZlCMRw/lTQMPFtxzsMn0=
X-Google-Smtp-Source: AGHT+IH5QdcGAKBpOAUvYhYjJZA7iLPcQe6gVhzzRDOvzFZBwg5fhfy0nQdFWfh3kP9KcxfgcHug0BFvTfDaA6pzO9iSeJAvBBE2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:369:f4bd:2df4 with SMTP id
 h5-20020a92c265000000b00369f4bd2df4mr161162ild.1.1712234971567; Thu, 04 Apr
 2024 05:49:31 -0700 (PDT)
Date: Thu, 04 Apr 2024 05:49:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000040a883061544c59f@google.com>
Subject: [syzbot] [netfilter?] KMSAN: uninit-value in nf_flow_offload_ip_hook
From: syzbot <syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3e92c1e6cd87 Merge tag 'selinux-pr-20240402' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135dbd3d180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5112b3f484393436
dashboard link: https://syzkaller.appspot.com/bug?extid=b6f07e1c07ef40199081
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ac287f716705/disk-3e92c1e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f04f8cb0bdc6/vmlinux-3e92c1e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a8eb9003da40/bzImage-3e92c1e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in nf_flow_skb_encap_protocol net/netfilter/nf_flow_table_ip.c:290 [inline]
BUG: KMSAN: uninit-value in nf_flow_offload_lookup net/netfilter/nf_flow_table_ip.c:352 [inline]
BUG: KMSAN: uninit-value in nf_flow_offload_ip_hook+0x79a/0x3e40 net/netfilter/nf_flow_table_ip.c:424
 nf_flow_skb_encap_protocol net/netfilter/nf_flow_table_ip.c:290 [inline]
 nf_flow_offload_lookup net/netfilter/nf_flow_table_ip.c:352 [inline]
 nf_flow_offload_ip_hook+0x79a/0x3e40 net/netfilter/nf_flow_table_ip.c:424
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf2/0x3f0 net/netfilter/core.c:626
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5318 [inline]
 __netif_receive_skb_core+0x430b/0x6190 net/core/dev.c:5406
 __netif_receive_skb_one_core net/core/dev.c:5536 [inline]
 __netif_receive_skb+0xca/0xa00 net/core/dev.c:5652
 netif_receive_skb_internal net/core/dev.c:5738 [inline]
 netif_receive_skb+0x58/0x660 net/core/dev.c:5798
 tun_rx_batched+0x3ee/0x980 drivers/net/tun.c:1549
 tun_get_user+0x5566/0x69e0 drivers/net/tun.c:2002
 tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
 call_write_iter include/linux/fs.h:2108 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb63/0x1520 fs/read_write.c:590
 ksys_write+0x20f/0x4c0 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x72/0x7a

Uninit was created at:
 __alloc_pages+0x9d6/0xe70 mm/page_alloc.c:4598
 alloc_pages_mpol+0x299/0x990 mm/mempolicy.c:2264
 alloc_pages+0x1bf/0x1e0 mm/mempolicy.c:2335
 skb_page_frag_refill+0x2bf/0x7c0 net/core/sock.c:2921
 tun_build_skb drivers/net/tun.c:1679 [inline]
 tun_get_user+0x1258/0x69e0 drivers/net/tun.c:1819
 tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
 call_write_iter include/linux/fs.h:2108 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xb63/0x1520 fs/read_write.c:590
 ksys_write+0x20f/0x4c0 fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __x64_sys_write+0x93/0xe0 fs/read_write.c:652
 do_syscall_64+0xd5/0x1f0
 entry_SYSCALL_64_after_hwframe+0x72/0x7a

CPU: 0 PID: 5636 Comm: syz-executor.0 Not tainted 6.9.0-rc2-syzkaller-00042-g3e92c1e6cd87 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
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
