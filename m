Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC2F24503B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618099; cv=none; b=rxwCiB01t51j44Z0ZTab5JJcvolx/BtIUlkWscQlUf8N5nEaY9u9zjQMK/swYYl1+YYvUQsxICTtbLZ7hsnM7Ie5wHh2vJWlfVwtZV2JMSjNbrzpairD8pRl5uaUnLB1Q0oTRrPlpNrDevOTnyTTdgjC5mV7BwLhl0QWkM0BAiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618099; c=relaxed/simple;
	bh=6ny1+oLcix0Cm5LRZzNnGgVardq6Yu2NbGyuh2E9un0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XvQMs/3Yv/f44t+Mv7K+6+5dcCeZdo80DLaoUixPHRiA5KearBKiQr3jXxMTSIeIlPdo/KPJ5ZRfdEipJGjtFZDlt9niSdqIw3kAGXJKWy4lgBSmiYjtvfnTzbLtJQ3fnQ6wngwiMBDu1/Fd5ozziCxy8iWyD5SzC6sku+OO7e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e56ffe1aa2so59898905ab.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 08:41:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755618096; x=1756222896;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zGjRr1cYGEj54QjHL1/VNSj13OPwrMZdB0ipo2v3hKA=;
        b=Fgswb5JAmu5ZSKS23SykXOhWXeqdQLCMfGOsf9EsrBttz7lKhORrqSWwLsCvK2sWDa
         69rWY0a5YoG3sUcFTmJNPdpOMAmakSQNZXAPpjgD60ec/iUeIrGx7xrQGv7+3JN9GisX
         +W0mrQNN+j0B06oTbc6/lBRzBv+HaItyoulczktjcXLWs4cy2QXB66lz2CEhVITEpBpq
         ML84ZEkeiuNQXhnCcpwY1jLreIWnmWIxgCcQoagYAYXQSKlJc+vPSBF0AivSfM8ecJjY
         yTO1buPzJdhexPmjKUlKAWFzOdjEIzg4Zuz9jx7VkR8pMRgj17WDw9ZPgP8czyl1K8/k
         h1GQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtSfGbgM5A9tli2lIGFUzQHYf7IS/24b61EWOUdkqg2E4/9CnIBqUy4MBs42+WsRJDH5+/MHoVVrR7IRww5iM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe6Bv+lmjbcgihODakKFMEfW9jCMqR52DwmcxV3z8RArJh2JO+
	fUbtVf2WZbj9tUVAHYVAZMJstza0ta2ejqx0DFesW4wVA5upJ3y7NL7O1V26GNPLYVYZe4FHRRz
	EM8IW88AHA/Q9bk7b9IQxI/MQy8/gcy4KA27EUzSZqaEiTTIc5PHOTUBz5hw=
X-Google-Smtp-Source: AGHT+IHX9l3izd1NoI9wLCzZARGcN2wtOytN4Ai4R7nzgvLtL+HnR4xPZxIdSZiyC7eK7BYeAJE0oC3ZipCi3JK8uoiSQ5lu2Xik
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1947:b0:3e5:83c5:fe10 with SMTP id
 e9e14a558f8ab-3e6764f2d64mr41844415ab.0.1755618096385; Tue, 19 Aug 2025
 08:41:36 -0700 (PDT)
Date: Tue, 19 Aug 2025 08:41:36 -0700
In-Reply-To: <20250818154032.3173645-1-sdf@fomichev.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a49b30.050a0220.e29e5.00c8.GAE@google.com>
Subject: [syzbot ci] Re: net: Convert to skb_dstref_steal and skb_dstref_restore
From: syzbot ci <syzbot+ci77a5caa9fce14315@syzkaller.appspotmail.com>
To: abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com, 
	coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, fw@strlen.de, gregkh@linuxfoundation.org, 
	herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, 
	mhal@rbox.co, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	pabeni@redhat.com, pablo@netfilter.org, sdf@fomichev.me, 
	steffen.klassert@secunet.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net: Convert to skb_dstref_steal and skb_dstref_restore
https://lore.kernel.org/all/20250818154032.3173645-1-sdf@fomichev.me
* [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_restore
* [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst_entry
* [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clear dst_entry
* [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input callers
* [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
* [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
* [PATCH net-next v2 7/7] net: Add skb_dst_check_unset

and found the following issue:
WARNING in nf_reject_fill_skb_dst

Full report is available here:
https://ci.syzbot.org/series/74fec874-bca1-42a5-bb58-f3f49b95e348

***

WARNING in nf_reject_fill_skb_dst

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      8159572936392b514e404bab2d60e47cebd5acfe
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/10161afb-c9c1-4272-851c-1ded15995879/config
C repro:   https://ci.syzbot.org/findings/7f681f6a-9952-49a0-8533-0bc185291f81/c_repro
syz repro: https://ci.syzbot.org/findings/7f681f6a-9952-49a0-8533-0bc185291f81/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1211 [inline]
WARNING: CPU: 1 PID: 5862 at ./include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Modules linked in:
CPU: 1 UID: 0 PID: 5862 Comm: kworker/u8:2 Not tainted 6.17.0-rc1-syzkaller-00207-g815957293639-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
RIP: 0010:skb_dst_set include/linux/skbuff.h:1211 [inline]
RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Code: 8b 0d 60 75 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d e9 03 91 67 01 cc e8 ad d0 aa f7 90 <0f> 0b 90 e9 38 ff ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
RAX: ffffffff8a14dae3 RBX: ffff88810f943b00 RCX: ffff888109618000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900001e0490 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: fffffbfff1f46fc7 R12: ffff88810ec56101
R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002f6a520 CR3: 0000000027716000 CR4: 00000000000006f0
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
 __napi_poll+0xc7/0x360 net/core/dev.c:7494
 napi_poll net/core/dev.c:7557 [inline]
 net_rx_action+0x707/0xe30 net/core/dev.c:7684
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
