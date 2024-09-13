Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8D081720
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726247180; cv=none; b=eNDTsOetHgYNSkzqCfrRF0yWQh5TyvDcnCBRPF0FIBDFxShGMquohvA1sP/C8PTER40PoSkSXCFojLNnOQIO1D1bwsd70xnstU049oUb3hGmhN+iAH6Z89yShk8a4fWYUXHq4IG0wPncH8ZwjZTJ7r+h+nMpck8OrZufPXeg3nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726247180; c=relaxed/simple;
	bh=CRsmI6gxOMpsuLo45bPY23hXw9zGyGQD78sbCV3nJ6s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZVPdfb6ClmQHxlJ0WAg2gfzIOmZ0s+/au4r6J/LvJcqWrqe2c7Hj6LNktAo5SgURe1a/n48tFV7ncR2t6VLYueUlOBaYVyq05B8i7IyryKB5+JymnqSSh+LfyIAKmuSKyuC5WrtrUiv5TEXquOtzA8ApYcBNgOJeTfkY10dL16Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hx792GEJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hx792GEJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1da40c6daaso3251705276.0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726247177; x=1726851977; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VMQEfmmM5zZqs/FvdexqNs9m62IGW0F3qftdOVgtTgw=;
        b=Hx792GEJVOmRzXEEq3MqP4mQXmyA2+uEplfDBq+NBZgWIizz3GAWS+sleKPwf0ZUuW
         iF2HxuIVAiWVwez2vNZtu0m56q3aeHDV90CtpKFHf+CaE5V33bZI+Q4bXBnNFvFk65yN
         ATZ6ldMMZqmrsEPo0o8+zT9BthwuVBlxECejqyc0gDR5WLDb76kqA0PLH9TjYGsPLX+X
         JgNGHLC52i69eHMoGQ9zRCTMSuxNLWlovR2AiJjBCsvQAXqSC754zHshb/EbOP05gNpi
         6P6o/o64zab7ldxYuTEVG3RtedDY1uo7HFzjEfXA1daSJw3OdpVBYqCHo7o07v+Vuont
         BtsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726247177; x=1726851977;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VMQEfmmM5zZqs/FvdexqNs9m62IGW0F3qftdOVgtTgw=;
        b=bTxBfMHPRr1KTuPPnoHyDuhHFK18+WejDFhxi/FxAt6k08HoQtRxZo9UygYfFjPHvl
         PR28A6OF83duFb0wq7fu/RyIkGtMOpkqfVhHJjSO+qh2tN/C0oMDtzew/B20YVXgdKcp
         CMGUvIcDNymLw9oXZ83paO8CfyMAo8Y8BM+DYFSMEtKTWjDSnYWIMwwaHiYszZFjmb2m
         sjNp/ib8VGFxsiPjDs0YRur6F+lel7ppzN2xQ4ET3OP5eeCYERR/1AJF0sQBcggZEVco
         nKIK6rvZd4530snTDd1ozmVedxdRtHVyptUYxN66Z4sJS0XRFtYeELShMi/nZlEUrLAH
         nz9g==
X-Forwarded-Encrypted: i=1; AJvYcCWqjfQONw0H3khX1DZVmh+xfK3ahhOm/UwUr1npC4dr0+pXtoGgKkTYORRKIbosEgBgoh3NZt8VTzRmOH/Ucq4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9/7/mSboyfEOZkIWC+Y7p22gI0D2SgprpcTE9wQ+yVMfnWwbA
	GVT2b5Z9gXzCpC7aAhyhD21G6XifHEbI43i4gzxeNPt7SiR0URnjppzHpKRjRwslDFFvf12rbLS
	YQTGtzVCrqw==
X-Google-Smtp-Source: AGHT+IH+hEOPIFUf35hL64NfJSvMuo2gRulrcjdy2bDnXXGH16YTKcVNMgOaDNBj/LFwj+LiFKKVQhGYnm2XVg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:f7:ea0b:ac12:11d6])
 (user=edumazet job=sendgmr) by 2002:a25:e446:0:b0:e11:6a73:b0d with SMTP id
 3f1490d57ef6-e1d9dc3b6c9mr8174276.6.1726247177281; Fri, 13 Sep 2024 10:06:17
 -0700 (PDT)
Date: Fri, 13 Sep 2024 17:06:15 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240913170615.3670897-1-edumazet@google.com>
Subject: [PATCH net] netfilter: nf_reject_ipv6: fix nf_reject_ip6_tcphdr_put()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

syzbot reported that nf_reject_ip6_tcphdr_put() was possibly sending
garbage on the four reserved tcp bits (th->res1)

Use skb_put_zero() to clear the whole TCP header,
as done in nf_reject_ip_tcphdr_put()

BUG: KMSAN: uninit-value in nf_reject_ip6_tcphdr_put+0x688/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:255
  nf_reject_ip6_tcphdr_put+0x688/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:255
  nf_send_reset6+0xd84/0x15b0 net/ipv6/netfilter/nf_reject_ipv6.c:344
  nft_reject_inet_eval+0x3c1/0x880 net/netfilter/nft_reject_inet.c:48
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x438/0x22a0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_inet+0x41a/0x4f0 net/netfilter/nft_chain_filter.c:161
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  NF_HOOK include/linux/netfilter.h:312 [inline]
  ipv6_rcv+0x29b/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5661 [inline]
  __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5775
  process_backlog+0x4ad/0xa50 net/core/dev.c:6108
  __napi_poll+0xe7/0x980 net/core/dev.c:6772
  napi_poll net/core/dev.c:6841 [inline]
  net_rx_action+0xa5a/0x19b0 net/core/dev.c:6963
  handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
  __do_softirq+0x14/0x1a kernel/softirq.c:588
  do_softirq+0x9a/0x100 kernel/softirq.c:455
  __local_bh_enable_ip+0x9f/0xb0 kernel/softirq.c:382
  local_bh_enable include/linux/bottom_half.h:33 [inline]
  rcu_read_unlock_bh include/linux/rcupdate.h:908 [inline]
  __dev_queue_xmit+0x2692/0x5610 net/core/dev.c:4450
  dev_queue_xmit include/linux/netdevice.h:3105 [inline]
  neigh_resolve_output+0x9ca/0xae0 net/core/neighbour.c:1565
  neigh_output include/net/neighbour.h:542 [inline]
  ip6_finish_output2+0x2347/0x2ba0 net/ipv6/ip6_output.c:141
  __ip6_finish_output net/ipv6/ip6_output.c:215 [inline]
  ip6_finish_output+0xbb8/0x14b0 net/ipv6/ip6_output.c:226
  NF_HOOK_COND include/linux/netfilter.h:303 [inline]
  ip6_output+0x356/0x620 net/ipv6/ip6_output.c:247
  dst_output include/net/dst.h:450 [inline]
  NF_HOOK include/linux/netfilter.h:314 [inline]
  ip6_xmit+0x1ba6/0x25d0 net/ipv6/ip6_output.c:366
  inet6_csk_xmit+0x442/0x530 net/ipv6/inet6_connection_sock.c:135
  __tcp_transmit_skb+0x3b07/0x4880 net/ipv4/tcp_output.c:1466
  tcp_transmit_skb net/ipv4/tcp_output.c:1484 [inline]
  tcp_connect+0x35b6/0x7130 net/ipv4/tcp_output.c:4143
  tcp_v6_connect+0x1bcc/0x1e40 net/ipv6/tcp_ipv6.c:333
  __inet_stream_connect+0x2ef/0x1730 net/ipv4/af_inet.c:679
  inet_stream_connect+0x6a/0xd0 net/ipv4/af_inet.c:750
  __sys_connect_file net/socket.c:2061 [inline]
  __sys_connect+0x606/0x690 net/socket.c:2078
  __do_sys_connect net/socket.c:2088 [inline]
  __se_sys_connect net/socket.c:2085 [inline]
  __x64_sys_connect+0x91/0xe0 net/socket.c:2085
  x64_sys_call+0x27a5/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:43
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
  nf_reject_ip6_tcphdr_put+0x60c/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:249
  nf_send_reset6+0xd84/0x15b0 net/ipv6/netfilter/nf_reject_ipv6.c:344
  nft_reject_inet_eval+0x3c1/0x880 net/netfilter/nft_reject_inet.c:48
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x438/0x22a0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_inet+0x41a/0x4f0 net/netfilter/nft_chain_filter.c:161
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  NF_HOOK include/linux/netfilter.h:312 [inline]
  ipv6_rcv+0x29b/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5661 [inline]
  __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5775
  process_backlog+0x4ad/0xa50 net/core/dev.c:6108
  __napi_poll+0xe7/0x980 net/core/dev.c:6772
  napi_poll net/core/dev.c:6841 [inline]
  net_rx_action+0xa5a/0x19b0 net/core/dev.c:6963
  handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
  __do_softirq+0x14/0x1a kernel/softirq.c:588

Uninit was stored to memory at:
  nf_reject_ip6_tcphdr_put+0x2ca/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:231
  nf_send_reset6+0xd84/0x15b0 net/ipv6/netfilter/nf_reject_ipv6.c:344
  nft_reject_inet_eval+0x3c1/0x880 net/netfilter/nft_reject_inet.c:48
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x438/0x22a0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_inet+0x41a/0x4f0 net/netfilter/nft_chain_filter.c:161
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  NF_HOOK include/linux/netfilter.h:312 [inline]
  ipv6_rcv+0x29b/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5661 [inline]
  __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5775
  process_backlog+0x4ad/0xa50 net/core/dev.c:6108
  __napi_poll+0xe7/0x980 net/core/dev.c:6772
  napi_poll net/core/dev.c:6841 [inline]
  net_rx_action+0xa5a/0x19b0 net/core/dev.c:6963
  handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
  __do_softirq+0x14/0x1a kernel/softirq.c:588

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:3998 [inline]
  slab_alloc_node mm/slub.c:4041 [inline]
  kmem_cache_alloc_node_noprof+0x6bf/0xb80 mm/slub.c:4084
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:583
  __alloc_skb+0x363/0x7b0 net/core/skbuff.c:674
  alloc_skb include/linux/skbuff.h:1320 [inline]
  nf_send_reset6+0x98d/0x15b0 net/ipv6/netfilter/nf_reject_ipv6.c:327
  nft_reject_inet_eval+0x3c1/0x880 net/netfilter/nft_reject_inet.c:48
  expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
  nft_do_chain+0x438/0x22a0 net/netfilter/nf_tables_core.c:288
  nft_do_chain_inet+0x41a/0x4f0 net/netfilter/nft_chain_filter.c:161
  nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
  nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
  nf_hook include/linux/netfilter.h:269 [inline]
  NF_HOOK include/linux/netfilter.h:312 [inline]
  ipv6_rcv+0x29b/0x390 net/ipv6/ip6_input.c:310
  __netif_receive_skb_one_core net/core/dev.c:5661 [inline]
  __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5775
  process_backlog+0x4ad/0xa50 net/core/dev.c:6108
  __napi_poll+0xe7/0x980 net/core/dev.c:6772
  napi_poll net/core/dev.c:6841 [inline]
  net_rx_action+0xa5a/0x19b0 net/core/dev.c:6963
  handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
  __do_softirq+0x14/0x1a kernel/softirq.c:588

Fixes: c8d7b98bec43 ("netfilter: move nf_send_resetX() code to nf_reject_ipvX modules")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dedee264b8f6c8e5155074c6788c53fdf228ca3c..b9457473c176df7a797ae9d4dabd36bcfffaa2fd 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -223,33 +223,23 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 			      const struct tcphdr *oth, unsigned int otcplen)
 {
 	struct tcphdr *tcph;
-	int needs_ack;
 
 	skb_reset_transport_header(nskb);
-	tcph = skb_put(nskb, sizeof(struct tcphdr));
+	tcph = skb_put_zero(nskb, sizeof(struct tcphdr));
 	/* Truncate to length (no data) */
 	tcph->doff = sizeof(struct tcphdr)/4;
 	tcph->source = oth->dest;
 	tcph->dest = oth->source;
 
 	if (oth->ack) {
-		needs_ack = 0;
 		tcph->seq = oth->ack_seq;
-		tcph->ack_seq = 0;
 	} else {
-		needs_ack = 1;
 		tcph->ack_seq = htonl(ntohl(oth->seq) + oth->syn + oth->fin +
 				      otcplen - (oth->doff<<2));
-		tcph->seq = 0;
+		tcph->ack = 1;
 	}
 
-	/* Reset flags */
-	((u_int8_t *)tcph)[13] = 0;
 	tcph->rst = 1;
-	tcph->ack = needs_ack;
-	tcph->window = 0;
-	tcph->urg_ptr = 0;
-	tcph->check = 0;
 
 	/* Adjust TCP checksum */
 	tcph->check = csum_ipv6_magic(&ipv6_hdr(nskb)->saddr,
-- 
2.46.0.662.g92d0881bb0-goog

