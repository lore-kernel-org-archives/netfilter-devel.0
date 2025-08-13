Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE012E5411
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 07:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071870; cv=none; b=eqgDSJQYgXHsL3uXTk7pz53EexQzcFPexHQ5+UKXBTsL2p1JYqUZGwk4xhaszw7gdsEmNleZnj9pi0ZzQXprFuagaQwC8dbyeRiabWgv86XwKf8ukc3jN7dzRjcfurkBDpbtBkhd/d560KcSJO5xMhqIW5LMwKrR/hSQQmnyr6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071870; c=relaxed/simple;
	bh=JP3JU9DeiGsROJxfLJcR/pj+/8+ah7HYe4Sxa3Bz/AI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=cElmRSVdyv+wUx+1ZQeBap7Kt1nGysH8xfL1zZq2ioRjCme2P1It2byRHVYv3gzAyyGvGA/3x3VFs8hfH2l8Za/7EjpAM4wBEuTtWaRFGE0XGGVE9YJUdm+DFJKQReZWCgIkVaOY6HbOtEZ93Dv6yRiS1BwXm1ELrftQRIRp7fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8817ecc1b33so1463645939f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 00:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755071868; x=1755676668;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8kNKWjQfVGgObiakLKUOpl9vALlhUvsvnWSAVGV+hA=;
        b=Q0fVyockqZzfD1IUy6TU+JQe2aD2XZUeaThIi4XvbzCTJXmexS7zshvT46Opx4RxBz
         iBy7jrmAI+Ex5QpHRp4DTiU5c+oZ5YwxCbExa6s6ed7F9le9uXgfPtgG3C46tp8bsCji
         c1c380RbmodEl2IkcaGHBGpAyiS7JMsqSkvtfqeAX+4LIdj2VqumU7ba2I0dJSr2wnzh
         hIfmRwNlCl1jsaebdt8leOhMa0kxxQWWF6HOrKYmSIPIG+WvxCeLJJg7tAZWYMmlLpsz
         LTztB3dKX9Dzu7PDHYm8LC1tqThWxM7pfKtqIe/BhY5NGlNQ9/AWgwpL1hjDCYDsI6F9
         /w8A==
X-Forwarded-Encrypted: i=1; AJvYcCVJZPnZoKH2/0qxzXsusP3GofMPgoW4Q8VHCZrHvrCn8wO8V5O9sk/kQ+Nvn7KRZmlJSLJT8rzolkwkS7rV2no=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+FDmVTgACPdMSQRZ2JLywVpcnduO4/6qTlVuty5/EIhrM9cZ+
	TH1gnJ8N6I7igIF7H5a4FPn81MsvTAyeew6xok+BK6qNp92byNzcHmCv4FN0rekbkBvvTU+4f0L
	pIfGKJoXOofeeU2RwijZgLrNrUlVEIzSFIcE6ujXWsG4QehXJW1JJAoq5/Gk=
X-Google-Smtp-Source: AGHT+IEz0TPsz1KmcJLOVcoGmgl6ivHtpmt3ABdiAZsXXtlUPUoPi0TiH/VXcplKlEfNOByudgT+xTYQ7LySxAvl4q0nNONtBLXh
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c05:b0:881:82bb:94b2 with SMTP id
 ca18e2360f4ac-884296a2e80mr445984139f.13.1755071867828; Wed, 13 Aug 2025
 00:57:47 -0700 (PDT)
Date: Wed, 13 Aug 2025 00:57:47 -0700
In-Reply-To: <20250812155245.507012-1-sdf@fomichev.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689c457b.a70a0220.7865.0049.GAE@google.com>
Subject: [syzbot ci] Re: net: Convert to skb_dst_reset and skb_dst_restore
From: syzbot ci <syzbot+ci1b726090b21fedf1@syzkaller.appspotmail.com>
To: abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com, 
	coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, mhal@rbox.co, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: Convert to skb_dst_reset and skb_dst_restore
https://lore.kernel.org/all/20250812155245.507012-1-sdf@fomichev.me
* [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
* [PATCH net-next 2/7] xfrm: Switch to skb_dst_reset to clear dst_entry
* [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear dst_entry
* [PATCH net-next 4/7] net: Switch to skb_dst_reset/skb_dst_restore for ip_route_input callers
* [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
* [PATCH net-next 6/7] chtls: Convert to skb_dst_reset
* [PATCH net-next 7/7] net: Add skb_dst_check_unset

and found the following issue:
WARNING in nf_reject_fill_skb_dst

Full report is available here:
https://ci.syzbot.org/series/dcc132bc-db4e-4a0b-a95c-9960b8a48d10

***

WARNING in nf_reject_fill_skb_dst

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/2aac43d4-6d95-49c6-8e28-28941fdb3117/config
C repro:   https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54ca186/c_repro
syz repro: https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54ca186/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Modules linked in:
CPU: 1 UID: 0 PID: 5901 Comm: kworker/u8:3 Not tainted 6.16.0-syzkaller-12063-g37816488247d-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
RIP: 0010:skb_dst_set include/linux/skbuff.h:1210 [inline]
RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Code: 8b 0d 60 b1 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 03 8d 67 01 cc e8 cd 6c ab f7 90 <0f> 0b 90 e9 38 ff ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
RAX: ffffffff8a143ee3 RBX: ffff888110b91200 RCX: ffff88810a3d8000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900001e0490 R08: ffffffff8fa34737 R09: 1ffffffff1f468e6
R10: dffffc0000000000 R11: fffffbfff1f468e7 R12: ffff888011c5c101
R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c21000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c003cc5000 CR3: 000000010fc16000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x40c/0x1920 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
 __netif_receive_skb_one_core net/core/dev.c:5979 [inline]
 __netif_receive_skb+0x143/0x380 net/core/dev.c:6092
 process_backlog+0x60e/0x14f0 net/core/dev.c:6444
 __napi_poll+0xc7/0x360 net/core/dev.c:7489
 napi_poll net/core/dev.c:7552 [inline]
 net_rx_action+0x707/0xe30 net/core/dev.c:7679
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
 __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4740
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0x11fe/0x16a0 net/ipv6/ip6_output.c:141
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xb96/0x1470 net/ipv6/ndisc.c:512
 ndisc_send_ns+0xcb/0x150 net/ipv6/ndisc.c:670
 addrconf_dad_work+0xaae/0x14b0 net/ipv6/addrconf.c:4282
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
