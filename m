Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B5C128368
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 12:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712233255; cv=none; b=hURUJSt0toxL2lNo+bn4GE5l5AX1dK2bKR1O+EjgLBFAIWesAuxwxN1oIoeHQJKEaZ6/B99EVftXZ4x7MqYFdnP5efEtqcw2z3enjVxd1/MzQjuxuyyJQhpLKNz7fhWnMygHQqfaCZrzkriiNdy9ykJ1Qt2gGaRakiuCedlMLg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712233255; c=relaxed/simple;
	bh=REMktHm+FgsBlVxWcUnKMoKuAz8bxajqkfWFiry5Gao=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tznSq7UVk+H0fCeSJCY7PRD3AI18U6apettPnTeM5HibatRUclcVkbRDX/QvEcYvOlitICLqZ7WJzjm2yQ7diKt/NL6m+bZGAjisq3eL6DZcsGvEp7OG/FC+3j2Pu51sidkGw2ndSboYDdQgRuFqE+tOB/xKXw88BkYk7uWGEX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ru31sPeu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ru31sPeu"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615365a5ecfso15298337b3.3
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Apr 2024 05:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712233253; x=1712838053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z1/n+j8eXXMQvld3HNZDBdZPz3kRpN0A4qvNXNbcDlQ=;
        b=ru31sPeuc5JQD+msylTDogEQGe0bMwVOgQHURw8dK3TEaxXtK2T5op9xg8I+XAriZC
         txmKucrtNzwYN8mtYYRZFAsaCs8cZjHajAUV9+Kz7yLjiOiI/3k/TP5eJji8uN0A3+4M
         wfuHD+psUcvqiiex2wgd9E6ArI7okwfdroLcv4sBToCG6fD5e/u1K+zfCUbTEq+sFr0Y
         Zc9DzlK9EBvBByd5mgVSoRJZ3utkxsNh7/bFGUfnnoqX7fOHo0saMLzwiHvoef/RWgBY
         6uNsthmTWY2mnFhaoG2XHdC47hKzW0WT0akJuvXZVcdz1hnewBrZUhgbAc8JZqzLxYef
         h36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712233253; x=1712838053;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z1/n+j8eXXMQvld3HNZDBdZPz3kRpN0A4qvNXNbcDlQ=;
        b=LtWZxr1lVVOFKYxrwuNqTvBFuMLOoXF+xZBy9I8B6ZVpO8wHf1aFHzSYxeP+mplCfm
         s6WTh60U8prmFhqhA+cz5oQUd+k1vz9kMpzpZmLTlS2Jh9biSdkaeAERuYPEDwSxcg/3
         WGPuTMsoxvozrYVZd7JKqUSX4i0LYloQgv9G/xubaYDNLLSOMvphdQXq2qWpk8b0GSZd
         3/FMxmK8q+ooXcKleTk/0w9it8CXT1dgUIduUDbS1Of5H9YnGXdn4Zr4C+9s6ahsTjzE
         /PCJj9wVYCar6bOgwVXNcvLWsnk0liFkncnWfzWbnHYA8N5tEc7+P3WLZ6z/d6cAfyQm
         i6vg==
X-Forwarded-Encrypted: i=1; AJvYcCVb4O7DNQljUKTUJwrzBuN33AWp6z24nD4VZf1IPZn21CqPqABgpdjwy/zEPTUqU8t5sv29RwFKq5oGi9adLpWQ/uiHhNJb7+ZNZorc6NdH
X-Gm-Message-State: AOJu0YxRxMNMv2vWpGirTJWOSQwBgNUZ2LbkxgmiOthEr6sw5Vhlytzn
	kLvVAKvr6+QKGWw0S/0/8rhpHCnVojaTjbblP+Y0I7v1ePosPuvuohQFuayHJ29xRQKSy65hBNW
	pSncNgzrFiQ==
X-Google-Smtp-Source: AGHT+IG3atDXWHSI6gSFYPwti52AhtGvlDYdzQKq0dexwBQhd8pnPjnTO0eGQTnY44srL142e5wIgkRWA6Fr/w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:4e89:0:b0:615:737c:2864 with SMTP id
 c131-20020a814e89000000b00615737c2864mr534480ywb.2.1712233252873; Thu, 04 Apr
 2024 05:20:52 -0700 (PDT)
Date: Thu,  4 Apr 2024 12:20:51 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240404122051.2303764-1-edumazet@google.com>
Subject: [PATCH net] netfilter: validate user input for expected length
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

I got multiple syzbot reports showing old bugs exposed
by BPF after commit 20f2505fb436 ("bpf: Try to avoid kzalloc
in cgroup/{s,g}etsockopt")

setsockopt() @optlen argument should be taken into account
before copying data.

 BUG: KASAN: slab-out-of-bounds in copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
 BUG: KASAN: slab-out-of-bounds in copy_from_sockptr include/linux/sockptr.h:55 [inline]
 BUG: KASAN: slab-out-of-bounds in do_replace net/ipv4/netfilter/ip_tables.c:1111 [inline]
 BUG: KASAN: slab-out-of-bounds in do_ipt_set_ctl+0x902/0x3dd0 net/ipv4/netfilter/ip_tables.c:1627
Read of size 96 at addr ffff88802cd73da0 by task syz-executor.4/7238

CPU: 1 PID: 7238 Comm: syz-executor.4 Not tainted 6.9.0-rc2-next-20240403-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
  print_address_description mm/kasan/report.c:377 [inline]
  print_report+0x169/0x550 mm/kasan/report.c:488
  kasan_report+0x143/0x180 mm/kasan/report.c:601
  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
  __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
  copy_from_sockptr_offset include/linux/sockptr.h:49 [inline]
  copy_from_sockptr include/linux/sockptr.h:55 [inline]
  do_replace net/ipv4/netfilter/ip_tables.c:1111 [inline]
  do_ipt_set_ctl+0x902/0x3dd0 net/ipv4/netfilter/ip_tables.c:1627
  nf_setsockopt+0x295/0x2c0 net/netfilter/nf_sockopt.c:101
  do_sock_setsockopt+0x3af/0x720 net/socket.c:2311
  __sys_setsockopt+0x1ae/0x250 net/socket.c:2334
  __do_sys_setsockopt net/socket.c:2343 [inline]
  __se_sys_setsockopt net/socket.c:2340 [inline]
  __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2340
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a
RIP: 0033:0x7fd22067dde9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd21f9ff0c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fd2207abf80 RCX: 00007fd22067dde9
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fd2206ca47a R08: 0000000000000001 R09: 0000000000000000
R10: 0000000020000880 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007fd2207abf80 R15: 00007ffd2d0170d8
 </TASK>

Allocated by task 7238:
  kasan_save_stack mm/kasan/common.c:47 [inline]
  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
  poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
  __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
  kasan_kmalloc include/linux/kasan.h:211 [inline]
  __do_kmalloc_node mm/slub.c:4069 [inline]
  __kmalloc_noprof+0x200/0x410 mm/slub.c:4082
  kmalloc_noprof include/linux/slab.h:664 [inline]
  __cgroup_bpf_run_filter_setsockopt+0xd47/0x1050 kernel/bpf/cgroup.c:1869
  do_sock_setsockopt+0x6b4/0x720 net/socket.c:2293
  __sys_setsockopt+0x1ae/0x250 net/socket.c:2334
  __do_sys_setsockopt net/socket.c:2343 [inline]
  __se_sys_setsockopt net/socket.c:2340 [inline]
  __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2340
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a

The buggy address belongs to the object at ffff88802cd73da0
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes inside of
 allocated 1-byte region [ffff88802cd73da0, ffff88802cd73da1)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88802cd73020 pfn:0x2cd73
flags: 0xfff80000000000(node=0|zone=1|lastcpupid=0xfff)
page_type: 0xffffefff(slab)
raw: 00fff80000000000 ffff888015041280 dead000000000100 dead000000000122
raw: ffff88802cd73020 000000008080007f 00000001ffffefff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 5103, tgid 2119833701 (syz-executor.4), ts 5103, free_ts 70804600828
  set_page_owner include/linux/page_owner.h:32 [inline]
  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1490
  prep_new_page mm/page_alloc.c:1498 [inline]
  get_page_from_freelist+0x2e7e/0x2f40 mm/page_alloc.c:3454
  __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4712
  __alloc_pages_node_noprof include/linux/gfp.h:244 [inline]
  alloc_pages_node_noprof include/linux/gfp.h:271 [inline]
  alloc_slab_page+0x5f/0x120 mm/slub.c:2249
  allocate_slab+0x5a/0x2e0 mm/slub.c:2412
  new_slab mm/slub.c:2465 [inline]
  ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3615
  __slab_alloc+0x58/0xa0 mm/slub.c:3705
  __slab_alloc_node mm/slub.c:3758 [inline]
  slab_alloc_node mm/slub.c:3936 [inline]
  __do_kmalloc_node mm/slub.c:4068 [inline]
  kmalloc_node_track_caller_noprof+0x286/0x450 mm/slub.c:4089
  kstrdup+0x3a/0x80 mm/util.c:62
  device_rename+0xb5/0x1b0 drivers/base/core.c:4558
  dev_change_name+0x275/0x860 net/core/dev.c:1232
  do_setlink+0xa4b/0x41f0 net/core/rtnetlink.c:2864
  __rtnl_newlink net/core/rtnetlink.c:3680 [inline]
  rtnl_newlink+0x180b/0x20a0 net/core/rtnetlink.c:3727
  rtnetlink_rcv_msg+0x89b/0x10d0 net/core/rtnetlink.c:6594
  netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2559
  netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
  netlink_unicast+0x7ea/0x980 net/netlink/af_netlink.c:1361
page last free pid 5146 tgid 5146 stack trace:
  reset_page_owner include/linux/page_owner.h:25 [inline]
  free_pages_prepare mm/page_alloc.c:1110 [inline]
  free_unref_page+0xd3c/0xec0 mm/page_alloc.c:2617
  discard_slab mm/slub.c:2511 [inline]
  __put_partials+0xeb/0x130 mm/slub.c:2980
  put_cpu_partial+0x17c/0x250 mm/slub.c:3055
  __slab_free+0x2ea/0x3d0 mm/slub.c:4254
  qlink_free mm/kasan/quarantine.c:163 [inline]
  qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
  kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
  __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
  kasan_slab_alloc include/linux/kasan.h:201 [inline]
  slab_post_alloc_hook mm/slub.c:3888 [inline]
  slab_alloc_node mm/slub.c:3948 [inline]
  __do_kmalloc_node mm/slub.c:4068 [inline]
  __kmalloc_node_noprof+0x1d7/0x450 mm/slub.c:4076
  kmalloc_node_noprof include/linux/slab.h:681 [inline]
  kvmalloc_node_noprof+0x72/0x190 mm/util.c:634
  bucket_table_alloc lib/rhashtable.c:186 [inline]
  rhashtable_rehash_alloc+0x9e/0x290 lib/rhashtable.c:367
  rht_deferred_worker+0x4e1/0x2440 lib/rhashtable.c:427
  process_one_work kernel/workqueue.c:3218 [inline]
  process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3299
  worker_thread+0x86d/0xd70 kernel/workqueue.c:3380
  kthread+0x2f0/0x390 kernel/kthread.c:388
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243

Memory state around the buggy address:
 ffff88802cd73c80: 07 fc fc fc 05 fc fc fc 05 fc fc fc fa fc fc fc
 ffff88802cd73d00: fa fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>ffff88802cd73d80: fa fc fc fc 01 fc fc fc fa fc fc fc fa fc fc fc
                               ^
 ffff88802cd73e00: fa fc fc fc fa fc fc fc 05 fc fc fc 07 fc fc fc
 ffff88802cd73e80: 07 fc fc fc 07 fc fc fc 07 fc fc fc 07 fc fc fc

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/bridge/netfilter/ebtables.c | 6 ++++++
 net/ipv4/netfilter/arp_tables.c | 4 ++++
 net/ipv4/netfilter/ip_tables.c  | 4 ++++
 net/ipv6/netfilter/ip6_tables.c | 4 ++++
 4 files changed, 18 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 99d82676f780ac49d01151fa9c585f44f9ea8ccc..cbd0e3586c3f61904efb4db7d9101d7770c852e7 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1111,6 +1111,8 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	struct ebt_table_info *newinfo;
 	struct ebt_replace tmp;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
@@ -1423,6 +1425,8 @@ static int update_counters(struct net *net, sockptr_t arg, unsigned int len)
 {
 	struct ebt_replace hlp;
 
+	if (len < sizeof(hlp))
+		return -EINVAL;
 	if (copy_from_sockptr(&hlp, arg, sizeof(hlp)))
 		return -EFAULT;
 
@@ -2352,6 +2356,8 @@ static int compat_update_counters(struct net *net, sockptr_t arg,
 {
 	struct compat_ebt_replace hlp;
 
+	if (len < sizeof(hlp))
+		return -EINVAL;
 	if (copy_from_sockptr(&hlp, arg, sizeof(hlp)))
 		return -EFAULT;
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 2407066b0fec1121d71561ecbad6f4f87ecdebbc..b150c9929b12e86219a55c77da480e0c538b3449 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -956,6 +956,8 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct arpt_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
@@ -1254,6 +1256,8 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct arpt_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7da1df4997d057a4292927c2041687c2b39d4a01..487670759578168c5ff53bce6642898fc41936b3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1108,6 +1108,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct ipt_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
@@ -1492,6 +1494,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct ipt_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index fd9f049d6d41e77eacc10ce074a8a0d96b0d2e11..636b360311c5365fba2330f6ca2f7f1b6dd1363e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1125,6 +1125,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct ip6t_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
@@ -1501,6 +1503,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 	void *loc_cpu_entry;
 	struct ip6t_entry *iter;
 
+	if (len < sizeof(tmp))
+		return -EINVAL;
 	if (copy_from_sockptr(&tmp, arg, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-- 
2.44.0.478.gd926399ef9-goog

