Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7491662F1
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 18:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727376975; cv=none; b=jSgSvVEaiZw0oZq6GZ0RiLP5T4ip9H/iOaCdWX/OQvaiAhDY4LVdvmZ38d/IHzkcGkQ5RGfCR1/Ff7QDqkOXgCibnTs830wF+LJktWMarKfozipjmTw9bHOBcOxQmsgzje8P8gmHKex/8yEEetb9lvgP78hVhSxEtqEJbNdnvoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727376975; c=relaxed/simple;
	bh=SYAzZf7fL7yIxfos7iOx2bw7k6KMuMFEtuuPb2VGYsk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MUWnAL5NsyI/UbvyCXs/MCf1rZURwX9aCeXJCnTIzhUZI7mLw8B44bkR/gE8Y87LZSQcR2Ia2WIqRx4ScV8Re/CTvaS1bXUqTzBqvicrb7tFcYAZATCswbHwO1sB2N/L8n84jNtuvnE/YuRGnXqRMqApTCaTuoWJWzylEOGAbLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MAlq+Kev; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MAlq+Kev"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035949cc4eso2039618276.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 11:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727376973; x=1727981773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GYZcEJhsOftnMMZystmGPE1lb8+vlI2F7UUy9IdVj58=;
        b=MAlq+KevMm7kdq+bz9f3If/wHNUfofV4tpCDBkRBPpZRa7nPfkY9/vI+91lK+gv9lr
         TxRfm4JQkFdhrP6ywMQUacv14RVxzpVnL6CN8QFo1mgNB4Q77lGCwpKC+Jy2OpAB3x80
         npg+1aLx6+Kt2ATt9Ul2rEYalwx/hfutendCSOgrsAMPYygyL9UIuOHdVp5edoZs1o9F
         c1PD8KhJr+jQoLsvwjhfB/4dCpu/fros2cJttCQh3/C0bcu0ipCb2FATU5+uNIjhhzfv
         MdNJL7wAE9NKg7XuOybsZEdhCZGZPiuQYXzfOoKp8dXFMd5hIinEtdPFJ5pIIhWtiQ6t
         ZvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727376973; x=1727981773;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GYZcEJhsOftnMMZystmGPE1lb8+vlI2F7UUy9IdVj58=;
        b=OmowQvphJ743vUWA7m9FGzZyc6TKPcfgHngwFVqL1IsjZsJevsFGyU2Z57z81+MRW/
         CBVPqPSIhwQQuPMZcyn0OS+fbp8Iav6MmWAtMFbYB640ObkcZfuCkJ2Z2/IYvNptsR5w
         Zd32ctVN2QDHFVYslhVw6OOiUozyQd+tLmj2K9VKXOgDOOwAzXPzBM5h8FghgRDZunyg
         hvFicu4goJz+JoslKKUbdUsQ+WckngchlRWnxav+WN1/Bx6/kbCdFdmYC8zEQRyqyW6J
         XDlzIrR8pnZHKIlcwMTLj7lLhgXeIGFQj2AUmR60PrlWE9C/PEIdPDLLuMJ2WrAAtSSU
         QJEA==
X-Forwarded-Encrypted: i=1; AJvYcCVLbuVkaqQR+L9VQh3mDbKaTEDA8CA6MTFubiJFvHS3oLnctGJQdGzwyWI/STlOYfDiCj8I1UT46nzS5I2CWLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqA7tdLx0KhDNMrRwdLtwCUZGCdOzFbTU7rOp64pdiaicoOrxf
	3fhY785n+IKs8otyTCVe8zlHByAQZ9qbnnZarwDBXJUqluTDpQX2ZcWuNCAeelGoz6N5GPuRj75
	1ZMSiZstp1Q==
X-Google-Smtp-Source: AGHT+IG5p84FxDmTnqT3GKqUxH9flLKG8nSbZhQBrmsIghNSRqD/dCAwTrHidbSLrN8NSbU16qETxI42Lbpj8A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:f7:ea0b:ac12:11d6])
 (user=edumazet job=sendgmr) by 2002:a25:ef52:0:b0:dfa:8ed1:8f1b with SMTP id
 3f1490d57ef6-e2604b1a436mr512276.1.1727376972889; Thu, 26 Sep 2024 11:56:12
 -0700 (PDT)
Date: Thu, 26 Sep 2024 18:56:11 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240926185611.3988042-1-edumazet@google.com>
Subject: [PATCH nf] netfilter: nf_tables: prevent nf_skb_duplicated corruption
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

syzbot found that nf_dup_ipv4() or nf_dup_ipv6() could write
per-cpu variable nf_skb_duplicated in an unsafe way [1].

Disabling preemption as hinted by the splat is not enough,
we have to disable soft interrupts as well.

[1]
BUG: using __this_cpu_write() in preemptible [00000000] code: syz.4.282/6316
 caller is nf_dup_ipv4+0x651/0x8f0 net/ipv4/netfilter/nf_dup_ipv4.c:87
CPU: 0 UID: 0 PID: 6316 Comm: syz.4.282 Not tainted 6.11.0-rc7-syzkaller-00104-g7052622fccb1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:93 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
  check_preemption_disabled+0x10e/0x120 lib/smp_processor_id.c:49
  nf_dup_ipv4+0x651/0x8f0 net/ipv4/netfilter/nf_dup_ipv4.c:87
  nft_dup_ipv4_eval+0x1db/0x300 net/ipv4/netfilter/nft_dup_ipv4.c:30
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_ipv4+0x202/0x320 net/netfilter/nft_chain_filter.c:23
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
  nf_hook+0x2c4/0x450 include/linux/netfilter.h:269
  NF_HOOK_COND include/linux/netfilter.h:302 [inline]
  ip_output+0x185/0x230 net/ipv4/ip_output.c:433
  ip_local_out net/ipv4/ip_output.c:129 [inline]
  ip_send_skb+0x74/0x100 net/ipv4/ip_output.c:1495
  udp_send_skb+0xacf/0x1650 net/ipv4/udp.c:981
  udp_sendmsg+0x1c21/0x2a60 net/ipv4/udp.c:1269
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x1a6/0x270 net/socket.c:745
  ____sys_sendmsg+0x525/0x7d0 net/socket.c:2597
  ___sys_sendmsg net/socket.c:2651 [inline]
  __sys_sendmmsg+0x3b2/0x740 net/socket.c:2737
  __do_sys_sendmmsg net/socket.c:2766 [inline]
  __se_sys_sendmmsg net/socket.c:2763 [inline]
  __x64_sys_sendmmsg+0xa0/0xb0 net/socket.c:2763
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4ce4f7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4ce5d4a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f4ce5135f80 RCX: 00007f4ce4f7def9
RDX: 0000000000000001 RSI: 0000000020005d40 RDI: 0000000000000006
RBP: 00007f4ce4ff0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f4ce5135f80 R15: 00007ffd4cbc6d68
 </TASK>

Fixes: d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 7 +++++--
 net/ipv6/netfilter/nf_dup_ipv6.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index f4aed0789d69dce64377446d7cfded9c5ecd5f51..ec94ee1051c77f9af8f13d0842978f8cee5d7da7 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -53,8 +53,9 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 {
 	struct iphdr *iph;
 
+	local_bh_disable();
 	if (this_cpu_read(nf_skb_duplicated))
-		return;
+		goto out;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
 	 * the original skb, which should continue on its way as if nothing has
@@ -62,7 +63,7 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	 */
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
-		return;
+		goto out;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Avoid counting cloned packets towards the original connection. */
@@ -91,6 +92,8 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	} else {
 		kfree_skb(skb);
 	}
+out:
+	local_bh_enable();
 }
 EXPORT_SYMBOL_GPL(nf_dup_ipv4);
 
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index a0a2de30be3e7b6fa9aa34dcc6a918e566713e07..0c39c77fe8a8a4c7589cdd9e6b7fb78e6f0ef88b 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -47,11 +47,12 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
+	local_bh_disable();
 	if (this_cpu_read(nf_skb_duplicated))
-		return;
+		goto out;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
-		return;
+		goto out;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	nf_reset_ct(skb);
@@ -69,6 +70,8 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	} else {
 		kfree_skb(skb);
 	}
+out:
+	local_bh_enable();
 }
 EXPORT_SYMBOL_GPL(nf_dup_ipv6);
 
-- 
2.46.1.824.gd892dcdcdd-goog

