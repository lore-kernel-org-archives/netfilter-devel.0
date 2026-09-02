Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8C374187;
	Wed,  2 Sep 2026 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788375141; cv=none; b=UaXwLQs2mviAj7lkrUSF8OTOrTKFwjMQuayrDW30Xjnzvp4wfeBdArnPLPmYInUjZ1dG7cEdFPr+hBzudi73JZWleCEYJ7RTHjDQBTB3eKUHMtjbZf+ft6/kHzgrHHllGMYiof8PHcSB30FWP6Ay7+2suV5cGLY54MG3MEgs8ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788375141; c=relaxed/simple;
	bh=+dB8QRffgR6eYaoWZ0dZUjdKapPSbpOHQIRfxloj+Zc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=l9oDljyCIYRfzmNFaoupdtXwqT6v/OQGE8BbAMUfOKud9WQd+H2kePWj/DR3sGJihQ54IU+zaA3fd05qP4qyuPsboY+7yDVaJxYKbzn2MLMh639GVW/31JjeAlx+PF4FCefDS9DBEuRUP/9p69FlCKm8vJq/Nmv1NielSStAl6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=EIMZTpic; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="EIMZTpic"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1x1pB3-00ApxN-KB; Wed, 02 Sep 2026 19:55:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=fSlfqnwEvLaNr4akvlf7I2sHJLIFmr8QwBFYs0VFHBs=
	; b=EIMZTpicfh8iRbwp6VmW/QD90Q4sYZYV1LtQDQWascH+g0H9KwrRsOx4zOHeBhK02KM7ShO/b
	ZwEuH1jukjT/6g9Hq2tFSCOrZCiGcc2fEAdgCSrh5iJ2EZkXhQ2a+M+K+bXAnJOmRgkSjxqt9I7/K
	cTDBKMhcP5iafiq0TrPkhBdMP9daCL6GuflWwrZ58uQJ+wKSuu/bw1KfVmLojVHXpyB1ZlflBHxqz
	JVjeME8bpcFqhSrmyvRVOLiX+jkbFmW9Y2+xjZmxUta7A+YF1L25G4Apvgtg4hgfU8jzLo2SwO9CK
	2P+UmKjB/I5mMgwl56jKpTqy55c1lqtmmKoptQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1x1pAy-00072V-0N; Wed, 02 Sep 2026 19:55:08 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1x1pAi-0020Qt-Gs;
	Wed, 02 Sep 2026 19:54:52 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH bpf v3 0/2] bpf: Fix socket leaks around
 connect(AF_UNSPEC)+listen()
Date: Wed, 02 Sep 2026 19:52:13 +0200
Message-Id: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ7CIBBFr2JYi6EgSFx5D+MC6NRitRBoSU3Tu
 0tx0ZXu5k/+f29GEYKFiM67GQVINlrX58D2O2Ra1d8B2zpnRAkVRFCJozPdS3n8dK4bPR5MPkF
 1WNdKKwZEMsNRXvsAjZ0K+Yq0b9Dt+4yjfoAZVuZaa20cXHgXf6pKuahOlP1UpQoTXGldGy4N8
 Op4CdpNB+OKI9GNIskfCs0URgQQynUDQmyUZVk+iXGFbhkBAAA=
X-Change-ID: 20260628-sockmap-lookup-tcp-leak-bdaba3e083c5
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Jakub Sitnicki <jakub@cloudflare.com>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>
Cc: Michal Luczaj <mhal@rbox.co>, bpf@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2

This is a follow-up to Sashiko's report[1].

Several BPF socket helpers acquire a socket reference only when
sk_is_refcounted() == true, and release it, independently, by
re-evaluating sk_is_refcounted() again at the time the release runs. TCP
connect(AF_UNSPEC)+listen() sets SOCK_RCU_FREE on an established socket.
If that happens while a reference is outstanding, the release side sees
sk_is_refcounted() == false and skips the put; the socket is leaked.

unreferenced object 0xffff88811617ce00 (size 3200):
  comm "softirq", pid 0, jiffies 4294848512
  hex dump (first 32 bytes):
    7f 00 00 01 7f 00 00 01 4d 43 02 f6 00 00 00 00  ........MC......
    02 00 07 41 00 00 00 00 00 00 00 00 00 00 00 00  ...A............
  backtrace (crc fb5bd4c8):
    kmem_cache_alloc_noprof+0x53e/0x640
    sk_prot_alloc+0x69/0x240
    sk_clone+0x79/0x1230
    inet_csk_clone_lock+0x30/0x760
    tcp_create_openreq_child+0x34/0x2750
    tcp_v4_syn_recv_sock+0x12e/0x1080
    tcp_check_req+0x447/0x2310
    tcp_v4_rcv+0x1026/0x3c90
    ip_protocol_deliver_rcu+0x93/0x340
    ip_local_deliver_finish+0x356/0x5c0
    ip_local_deliver+0x184/0x4a0
    ip_rcv+0x4f4/0x5b0
    __netif_receive_skb_one_core+0x153/0x1b0
    process_backlog+0x28d/0x1190
    __napi_poll+0xab/0x520
    net_rx_action+0x3f0/0xca0

[1]: https://lore.kernel.org/bpf/20260701235552.2B0AA1F00A3F@smtp.kernel.org/

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Changes in v3:
- Add a fix for TC bpf_sk_assign() (patch #2)
- Clean up commit messages
- Non-fixes went to bpf-next: https://lore.kernel.org/bpf/20260813-sockmap-lookup-get-ref-v1-0-31f5d55f44ac@rbox.co/
- Link to v2: https://patch.msgid.link/20260803-sockmap-lookup-tcp-leak-v2-0-306e025bfe66@rbox.co

Changes in v2:
- Defer "Use sock_hold() instead of refcount_inc_not_zero() in lookup" to
  bpf-next [John]
- Fix comment style [Sashiko]
- Link to v1: https://patch.msgid.link/20260723-sockmap-lookup-tcp-leak-v1-0-1bbdc58ce514@rbox.co

To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: Andrii Nakryiko <andrii@kernel.org>
To: Eduard Zingerman <eddyz87@gmail.com>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
To: Martin KaFai Lau <martin.lau@linux.dev>
To: Song Liu <song@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
To: Jiri Olsa <jolsa@kernel.org>
To: Emil Tsalapatis <emil@etsalapatis.com>
To: John Fastabend <john.fastabend@gmail.com>
To: Stanislav Fomichev <sdf@fomichev.me>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
To: Willem de Bruijn <willemb@google.com>
To: Jakub Sitnicki <jakub@cloudflare.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
To: Joe Stringer <joe@wand.net.nz>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org

---
Michal Luczaj (2):
      bpf: Unconditionally take socket references in lookup helpers
      bpf: Fix reference leak in bpf_sk_assign()

 include/net/inet6_hashtables.h |  9 ++++----
 include/net/inet_hashtables.h  |  9 ++++----
 include/net/request_sock.h     |  2 +-
 include/net/sock.h             | 11 ++++++++++
 net/core/filter.c              | 49 +++++++++++++++++++++++++++++-------------
 net/core/sock_map.c            |  8 ++-----
 net/netfilter/nf_queue.c       | 18 ++++++++--------
 7 files changed, 67 insertions(+), 39 deletions(-)
---
base-commit: ce6b9e5dd873de532cd924e2abc928220cdc2738
change-id: 20260628-sockmap-lookup-tcp-leak-bdaba3e083c5

Best regards,
--  
Michal Luczaj <mhal@rbox.co>

