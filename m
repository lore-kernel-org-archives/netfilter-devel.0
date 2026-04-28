Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D4C3E1CE4
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 09:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777367387; cv=none; b=IaUH5nnMhOVdlQAmWAM8XTrSGw9xOAb0/125H/p1ePqXrbT4d1hWv+9tEqDFMxLlJJ+HkI4nNJjjV4JFXB2RdtFn9hsAlPq4mNPPf0FLlGVZOoKuFM/cSGCgeCnrtzA23U0KnCyA3W5EhCo9EPXXVlKLAqUN0UEeIjS3A01Hvzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777367387; c=relaxed/simple;
	bh=ndV9HO4TrB7UH4OQaqRqhxadXpb2M84IgFY4mR7mxMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rInrTjTRTN/BFvfrD8/SKsusNcIoqLMlKTlobSWVJsi2YTwh5MW9FePA3nBlvjEaxINuH2Q1hySMboN5YzTQJeqbXSZ5LCa524/2VYiCXk1xxFko98pCkCDeNEAM8sO+SvIJvLtcZ/K011j9Sw71CAuRRAipaQIRst8ZLb7FCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=oxd16e8J; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="oxd16e8J"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so80329795e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 02:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1777367384; x=1777972184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uv+T7Qd810LVMbQvEtvpybibnpScTbWBpv7OZ6oXHZE=;
        b=oxd16e8JM587DpH50wb73izUKuxGy6KNMTHCm0SnzHK9useMwvOq913/8vzpeiZUNH
         s6q1s/yrWI/C3elj1lF+DrvrgMnSeURx5pIi9SyTXsn2k3OjEXTBkfKXabQNDBel8CGS
         g9+4rWSTOYN1sDRr45Y6pWnAYmDUYtKx47v1JElDdv1yQXg2oAtBgsGt9rfRNtxrjOmk
         rr1WO2LfqavyJPvrOoukwdnx4S04P3jhK4+vHZerVIgPIABYM2uCgNaTbCjct3UBACeq
         AbaugpzsOAQe1eGu4XddPK+bT7iwZu7GQF6gZtJ+V3pqilFk5zIqexJT5Q7kA+QeFPo4
         0oVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777367384; x=1777972184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uv+T7Qd810LVMbQvEtvpybibnpScTbWBpv7OZ6oXHZE=;
        b=czo3KoFFQqpufeWfawiGHxvUyyZCVOmyP1Xa96Fr2bXrfmCKG+5RCosJX3yc86Ht5/
         GSDOdWWHlTFtLeLKVUTOATatoVWoE/EPe1Re+JRNFosshEJsTUtoL/aZfE3eoNKsIBMG
         pQIxAf/Xt4OEK0Zv4zrq6ZFhSxplfaWw4lgAndVE+S9JchjgDZkqXLZsBhcxQOFdbfWR
         uRf641INlIXTPI1f6BSvNGgcuoMszCcqZBStVX/sIMkE3kYXq11vScuf6q2Lju3xk0B9
         EiKCCSgTGJ9wdPwFytOLYatnfxsRNGjCI0cQCo+XO7AUGpoY3mbQfJexfnIyi/ruHO2z
         z68w==
X-Gm-Message-State: AOJu0YyRUnQyacts/VguEEkyR89EDCByd9lkh0cgYd1oxkYTreVhXVXt
	XpwbITGjxY2LK8xAibFvuVF8nFixoFFG8BpB7JDOyxNxcchUGUvlzb77PZ7IaYwABhYdbfKl7LZ
	pUPcT
X-Gm-Gg: AeBDieulwot7gdoW5S8CpR6uHqcM6YR8WtPi8NzfE1ER2U1yRT8xDFBUxEVI3SNJ2Bm
	TlOTfx6hsOVHxnTN59Ut5v/hzcVpUAyZARjCVgdBxFrNPh1lvQ9MnDmF8syCc83uETSh7u44Jla
	Jqojku1zuU9X/JH3FnUIUDSd+lSMYRLioRU+leZpEC02pEBh/PwAM6XEjFKWEygOZ837ORI+z3L
	gAG+W1SAB5jdAArRwN67vTfnh7jCM5a5UWt1SyEFBcCYKUW6bzS16QgQCgaHqXZ25YmqkKi0FRZ
	Sa07TQUEkBRXrrd8zbJZH+irbQxALZJNmdw+hyY8azx1IvCbg40+F4dy112LI3dPYRowYlNtLh9
	d9QHeR6Y8RiRNzQYoKw/ZGpaaE/EWJpeilMF7F50RCeiV7uT0gHaWzEYdzUzwKtfHrRg4nUjIeT
	72BhPYRTmYcSM3eFgUntmgm+ACwjmBA0pFH8wl1rkhVPy5GS3KrV5zdcsFca/t6uThE68i3dwQf
	vZtn1uigRmCcGpMPV0losxK+QcXtw==
X-Received: by 2002:a05:600c:c177:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48a77b12a49mr30418175e9.16.1777367383438;
        Tue, 28 Apr 2026 02:09:43 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf260200051aef03a698a1fc.dip0.t-ipconnect.de. [2003:fa:af26:200:51a:ef03:a698:a1fc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775defe4sm29070145e9.7.2026.04.28.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 02:09:42 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH net] netfilter: nf_nat: avoid invalid nat_net pointer use on failed nf_nat_init()
Date: Tue, 28 Apr 2026 11:09:17 +0200
Message-ID: <20260428090917.3851366-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We ran into below KASAN splat, which is mostly uninteresting, beside
for having nf_nat_register_fn() in the call chain as a cause for the
offending access:

==================================================================
BUG: KASAN: slab-out-of-bounds in nf_nat_register_fn+0x5f9/0x640
Read of size 8 at addr ffff890031e54c20 by task iptables/9510

CPU: 0 UID: 0 PID: 9510 Comm: iptables Not tainted 6.18.18-grsec-full-20260320181326 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 […] dump_stack_lvl+0xee/0x160 ffff88004117eeb8
 […] print_report+0x6e/0x640 ffff88004117eee0
 […] ? __phys_addr+0x8e/0x140 ffff88004117eef0
 […] ? kasan_addr_to_slab+0x51/0xe0 ffff88004117ef08
 […] ? complete_report_info+0xec/0x1c0 ffff88004117ef20
 […] ? nf_nat_register_fn+0x5f9/0x640 ffff88004117ef48
 […] kasan_report+0xbc/0x140 ffff88004117ef50
 […] ? nf_nat_register_fn+0x5f9/0x640 ffff88004117ef90
 […] nf_nat_register_fn+0x5f9/0x640 ffff88004117eff8
 […] ? nf_nat_icmp_reply_translation+0x6e0/0x6e0 ffff88004117f070
 […] nf_tables_register_hook.part.0+0xa0/0x220 ffff88004117f080
 […] nf_tables_addchain.constprop.0+0x1054/0x1fc0 ffff88004117f0b8
 […] ? nft_chain_lookup.part.0+0x4ce/0xac0 ffff88004117f130
 […] ? nf_tables_abort+0x3d80/0x3d80 ffff88004117f190
 […] ? nf_tables_dumpreset_obj+0x100/0x100 ffff88004117f1c8
 […] ? nft_table_lookup.part.0+0x255/0x300 ffff88004117f310
 […] ? nf_tables_newchain+0x21a4/0x2fa0 ffff88004117f358
 […] nf_tables_newchain+0x21a4/0x2fa0 ffff88004117f360
 […] ? nf_tables_addchain.constprop.0+0x1fc0/0x1fc0 ffff88004117f458
 […] ? nla_get_range_signed+0x4a0/0x4a0 ffff88004117f488
 […] ? lock_acquire+0x16f/0x320 ffff88004117f490
 […] ? find_held_lock+0x3b/0xe0 ffff88004117f4b0
 […] ? __nla_parse+0x45/0x80 ffff88004117f500
 […] nfnetlink_rcv_batch+0xbca/0x19a0 ffff88004117f550
 […] ? nfnetlink_net_exit_batch+0x120/0x120 ffff88004117f618
 […] ? __sanitizer_cov_trace_switch+0x63/0xe0 ffff88004117f720
 […] ? gr_acl_handle_mmap+0x1c4/0x320 ffff88004117f7c0
 […] ? nla_get_range_signed+0x4a0/0x4a0 ffff88004117f7e8
 […] ? gr_is_capable+0x6f/0xe0 ffff88004117f830
 […] ? __nla_parse+0x45/0x80 ffff88004117f860
 […] ? skb_pull+0x103/0x1a0 ffff88004117f880
 […] nfnetlink_rcv+0x3db/0x4a0 ffff88004117f8b0
 […] ? nfnetlink_rcv_batch+0x19a0/0x19a0 ffff88004117f8d8
 […] ? netlink_lookup+0xe2/0x240 ffff88004117f900
 […] netlink_unicast+0x74b/0xb00 ffff88004117f930
 […] ? netlink_attachskb+0xb20/0xb20 ffff88004117f980
 […] ? __check_object_size+0x3e/0xaa0 ffff88004117f998
 […] ? security_netlink_send+0x51/0x160 ffff88004117f9c8
 […] netlink_sendmsg+0xa03/0x1200 ffff88004117f9f8
 […] ? netlink_unicast+0xb00/0xb00 ffff88004117fa70
 […] ? netlink_unicast+0xb00/0xb00 ffff88004117fac8
 […] ? ____sys_sendmsg+0xe2a/0x1040 ffff88004117faf8
 […] ____sys_sendmsg+0xe2a/0x1040 ffff88004117fb00
 […] ? kernel_recvmsg+0x300/0x300 ffff88004117fb60
 […] ? reacquire_held_locks+0xe9/0x260 ffff88004117fbc8
 […] ___sys_sendmsg+0x138/0x200 ffff88004117fbf8
 […] ? do_recvmmsg+0x7e0/0x7e0 ffff88004117fc30
 […] ? lockdep_hardirqs_on_prepare+0x101/0x1e0 ffff88004117fc50
 […] ? lock_acquire+0x16f/0x320 ffff88004117fd20
 […] ? lock_acquire+0x16f/0x320 ffff88004117fd58
 […] ? find_held_lock+0x3b/0xe0 ffff88004117fd70
 […] __sys_sendmsg+0x17a/0x260 ffff88004117fdc8
 […] ? __sys_sendmsg_sock+0x80/0x80 ffff88004117fdf0
 […] ? syscall_trace_enter+0x15e/0x2c0 ffff88004117fe98
 […] do_syscall_64+0x7d/0x400 ffff88004117fec8
 […] entry_SYSCALL_64_safe_stack+0x4a/0x60 ffff88004117fef8
 </TASK>
==================================================================

The out-of-bounds report, though, is a red herring as it is for an
access that shouldn't have happened in the first place.

When nf_nat_init() fails to register its BPF kfuncs, it'll unwind and,
among others, call unregister_pernet_subsys() to deregister its per-net
ops. This makes the previously allocated net id available for reuse by
the next caller of register_pernet_subsys(), in our case, synproxy.
However, 'nat_net_id' will still hold the previously allocated value.

If nf_nat.o gets build as a module, all this doesn't matter. A failed
initialization routine makes the module fail to load and any dependent
module won't be able to load either. However, if nf_nat.o is built-in,
a failing init won't /completely/ make its functionality unavailable to
dependent modules, namely the code and static data is still there, free
to be called by modules like nft_chain_nat.ko.

Case in point, nft_chain_nat registers hooks that'll call into nf_nat
which, in our case, failed to initialize and therefore won't have a
valid net id nor related net_nat object any more.

Code in nf_nat, namely nf_nat_register_fn() and nf_nat_unregister_fn(),
still making use of the reallocated net id, lead to a type confusion as
the call to net_generic() will no longer return memory belonging to an
object suited to fit 'struct nat_net' but 'struct synproxy_net' instead.
The latter is only 24 bytes on 64-bit systems, much smaller than struct
nat_net which is 176 bytes, perfectly explaining the OOB KASAN report.

Detect and handle a failed nf_nat_init() by testing the 'nf_nat_hook'
pointer which will be reset to NULL on initialization errors to prevent
the usage of an invalid nat_net pointer.

As this check is only needed when nf_nat.o is built-in, guard it by
'#ifndef MODULE...'.

Fixes: cbc1dd5b659f ("netfilter: nf_nat: Fix possible memory leak in nf_nat_init()")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 net/netfilter/nf_nat_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3b5434e4ec9c..76a150b9d418 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1187,6 +1187,16 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	struct nf_hook_ops *nat_ops;
 	int i, ret;
 
+#ifndef MODULE
+	/* If nf_nat_core is built-in and nf_nat_init() fails, dependent
+	 * modules like nft_chain_nat.ko may still call this function.
+	 * However, nat_net would be invalid, likely pointing to some other
+	 * per-net structure.
+	 */
+	if (WARN_ON_ONCE(!nf_nat_hook))
+		return -EOPNOTSUPP;
+#endif
+
 	if (WARN_ON_ONCE(pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
 		return -EINVAL;
 
-- 
2.47.3

