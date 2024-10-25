Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C761CACE8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729843355; cv=none; b=JXGGVtTa1cxLfIhYUeQ+M1z6PvD7pk63BLTlfx2f1S2w3WAYHCkodx07JSBaGu4hxoWv9OEOLhmq0KOPb5r2FxJ7jdQVvFfUOzyeVszJsiuWQWFwugQ/thqB45Pje+HH2ELMd4EfeXkFcQAC7GF9voYHV+yZJZEjS0JFi0LIZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729843355; c=relaxed/simple;
	bh=hYUCKWI7qURBfI46qL5QO8ldpOYRmVFg+1vqdBL3WlU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NtmhJmuBIe1qusyv/opGmM/AHtd2OKXRGOOI66xy71h8us6ja6E94gCPN83yLnqgsUkzz+5+wnKzG2CqeIJJQnrZqLodoDmcE+VjqXzdSWWBniCSCK2LZIuNsegBsuFbXApFSOZqtC8n385kvO3UK6F1m2NN3HIlms+A7fH94D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gm+WULye; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gm+WULye"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e376aa4586so34310067b3.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 01:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729843351; x=1730448151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Dl/naZSHZOHu+i8dRY7E5rtnHdEcbtG/n8v3s5W581w=;
        b=gm+WULye0Er/w/pU9YoM0277JGG/ApGoF2MSwWT0oZY3YSjRELxHxave3CVM5hMMJ+
         MsT2NKv8t1l2zd2NEGvG1FX3aNcNuN++C0tNHNTpS3Bz2d8HJ2vXWZKqkCzkQmAAP4mS
         TjjsORIjguRCukJis9JVjIe8SFqr9DYGmdZqktFAP5z/0iPNp6q2RQJRZZfajcZu3Kxu
         QOwUKfDPwyHXJOawCVqG58VUHZlU3UhFynwLhJ3P2ye9zarw+LDaA+21T4tcipAtEjAc
         mvsCLv3CtDmQDpn1nmJmee83m1Xd9ooq79LMrZlNJ6UOleuwD+wk+vNMn31d4tL54aLb
         JlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729843351; x=1730448151;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dl/naZSHZOHu+i8dRY7E5rtnHdEcbtG/n8v3s5W581w=;
        b=n8NpvLogtf1Xht2CeYCljZSLem9MwWFjZZ2jmEl3AbUVFYS65/ppZAslGxFXeiCJDT
         y34wgTQKVZ2F2eqqfon6ht6Gt6TOXeli3k0CXtd5/ExpYVCYgB7mXZpLY1uviYcswfJh
         S2EptaZ22SWByUrWxlU8tv8HffpmEEyWNID45et2AFenkwo6SICtCpbINlTMQ6WqKtPQ
         sAdV/dMF0eX+f1HF/SoZ/+4avwY0dY5KpQD9nwannsc9S8Naw/nHijPKxkRT28W8Uzof
         4A7soSvoiQtIdmxg8G3VSNh7YALYdlWBVGImairSfEwFHrW2iBpawjWchv14/KJkQdaJ
         xxvw==
X-Forwarded-Encrypted: i=1; AJvYcCU3D4OodYfBERkD3twmT/7hphfdBs1unpB4TZuaOG2PK6oxyM7lYubMFNasdkt3k0iwAfdmqJAVkjke9d9yhOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YycoOVq+W2DtgDlp2I8exsVXxYe6rU4r07K2y5Ljpy5SwWbjAgA
	Bz67GR9a/vdIgUPgm0y/2IJmf2AQ1nGr6/f/pOY59XxdG+MFWfVj3au+bNbUi+G+5DgT9mjBrfO
	Z14wTo0+gYg==
X-Google-Smtp-Source: AGHT+IHDRKjcFE1E8WE4N+cBddKPWcrMbtV+vtV3f0rf7xM259C4zJu+M2fpsXm22gpi7NfozKEcWAvz2Rox5A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:f7:ea0b:ac12:11d6])
 (user=edumazet job=sendgmr) by 2002:a05:6902:f12:b0:e28:fdfc:b788 with SMTP
 id 3f1490d57ef6-e2f2fc49f82mr2548276.9.1729843351141; Fri, 25 Oct 2024
 01:02:31 -0700 (PDT)
Date: Fri, 25 Oct 2024 08:02:29 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241025080229.184676-1-edumazet@google.com>
Subject: [PATCH nf] netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

I got a syzbot report without a repro [1] crashing in nf_send_reset6()

I think the issue is that dev->hard_header_len is zero, and we attempt
later to push an Ethernet header.

Use LL_MAX_HEADER, as other functions in net/ipv6/netfilter/nf_reject_ipv6.c.

[1]

skbuff: skb_under_panic: text:ffffffff89b1d008 len:74 put:14 head:ffff88803123aa00 data:ffff88803123a9f2 tail:0x3c end:0x140 dev:syz_tun
 kernel BUG at net/core/skbuff.c:206 !
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 7373 Comm: syz.1.568 Not tainted 6.12.0-rc2-syzkaller-00631-g6d858708d465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:skb_panic net/core/skbuff.c:206 [inline]
 RIP: 0010:skb_under_panic+0x14b/0x150 net/core/skbuff.c:216
Code: 0d 8d 48 c7 c6 60 a6 29 8e 48 8b 54 24 08 8b 0c 24 44 8b 44 24 04 4d 89 e9 50 41 54 41 57 41 56 e8 ba 30 38 02 48 83 c4 20 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc900045269b0 EFLAGS: 00010282
RAX: 0000000000000088 RBX: dffffc0000000000 RCX: cd66dacdc5d8e800
RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000000000
RBP: ffff88802d39a3d0 R08: ffffffff8174afec R09: 1ffff920008a4ccc
R10: dffffc0000000000 R11: fffff520008a4ccd R12: 0000000000000140
R13: ffff88803123aa00 R14: ffff88803123a9f2 R15: 000000000000003c
FS:  00007fdbee5ff6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005d322000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  skb_push+0xe5/0x100 net/core/skbuff.c:2636
  eth_header+0x38/0x1f0 net/ethernet/eth.c:83
  dev_hard_header include/linux/netdevice.h:3208 [inline]
  nf_send_reset6+0xce6/0x1270 net/ipv6/netfilter/nf_reject_ipv6.c:358
  nft_reject_inet_eval+0x3b9/0x690 net/netfilter/nft_reject_inet.c:48
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_inet+0x418/0x6b0 net/netfilter/nft_chain_filter.c:161
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  NF_HOOK include/linux/netfilter.h:312 [inline]
  br_nf_pre_routing_ipv6+0x63e/0x770 net/bridge/br_netfilter_ipv6.c:184
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_bridge_pre net/bridge/br_input.c:277 [inline]
  br_handle_frame+0x9fd/0x1530 net/bridge/br_input.c:424
  __netif_receive_skb_core+0x13e8/0x4570 net/core/dev.c:5562
  __netif_receive_skb_one_core net/core/dev.c:5666 [inline]
  __netif_receive_skb+0x12f/0x650 net/core/dev.c:5781
  netif_receive_skb_internal net/core/dev.c:5867 [inline]
  netif_receive_skb+0x1e8/0x890 net/core/dev.c:5926
  tun_rx_batched+0x1b7/0x8f0 drivers/net/tun.c:1550
  tun_get_user+0x3056/0x47e0 drivers/net/tun.c:2007
  tun_chr_write_iter+0x10d/0x1f0 drivers/net/tun.c:2053
  new_sync_write fs/read_write.c:590 [inline]
  vfs_write+0xa6d/0xc90 fs/read_write.c:683
  ksys_write+0x183/0x2b0 fs/read_write.c:736
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdbeeb7d1ff
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 c9 8d 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 1c 8e 02 00 48
RSP: 002b:00007fdbee5ff000 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fdbeed36058 RCX: 00007fdbeeb7d1ff
RDX: 000000000000008e RSI: 0000000020000040 RDI: 00000000000000c8
RBP: 00007fdbeebf12be R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000008e R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fdbeed36058 R15: 00007ffc38de06e8
 </TASK>

Fixes: c8d7b98bec43 ("netfilter: move nf_send_resetX() code to nf_reject_ipvX modules")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 7db0437140bf22390e2f40f3b892978379e08a15..9ae2b2725bf99ab0c6057032996b7f249fb6f45c 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -268,12 +268,12 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		    int hook)
 {
-	struct sk_buff *nskb;
-	struct tcphdr _otcph;
-	const struct tcphdr *otcph;
-	unsigned int otcplen, hh_len;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
 	struct dst_entry *dst = NULL;
+	const struct tcphdr *otcph;
+	struct sk_buff *nskb;
+	struct tcphdr _otcph;
+	unsigned int otcplen;
 	struct flowi6 fl6;
 
 	if ((!(ipv6_addr_type(&oip6h->saddr) & IPV6_ADDR_UNICAST)) ||
@@ -312,9 +312,8 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (IS_ERR(dst))
 		return;
 
-	hh_len = (dst->dev->hard_header_len + 15)&~15;
-	nskb = alloc_skb(hh_len + 15 + dst->header_len + sizeof(struct ipv6hdr)
-			 + sizeof(struct tcphdr) + dst->trailer_len,
+	nskb = alloc_skb(LL_MAX_HEADER + sizeof(struct ipv6hdr) +
+			 sizeof(struct tcphdr) + dst->trailer_len,
 			 GFP_ATOMIC);
 
 	if (!nskb) {
@@ -327,7 +326,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 
 	nskb->mark = fl6.flowi6_mark;
 
-	skb_reserve(nskb, hh_len + dst->header_len);
+	skb_reserve(nskb, LL_MAX_HEADER);
 	nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP, ip6_dst_hoplimit(dst));
 	nf_reject_ip6_tcphdr_put(nskb, oldskb, otcph, otcplen);
 
-- 
2.47.0.163.g1226f6d8fa-goog

