Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525737;
	b=Ab/XjeW86CRkFlUkAHDTGN1Rloi29kHgxoIUhVhk1eHc0YNskj1mDyqE2Qv7Uln2iiU6
	 bfUQZC+nmcuZ442Cd440I2LPZvEjqyZeTuC1Cv+MvI0jBmavwABH03eOyNn8RT1K/uCtK
	 xLvjOjKSR6mLfHfyBbwW83UXaLzdp1zFY/QMsZvoMqJCfTEDU+wVEbsXuLVeqtA85q591
	 nAGM+IoaxogDg6T1KJTHfPaRzGecI08fyHSRKLzHFurveVBP0OR4/Ea+HNSzA331/ztdM
	 Ms+NYy20rg6ZuZfUhOjDn1Z5fAuyW9RohKEw18DLiuigJSw/07KDscbu+uZcCrB+sJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525737;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZAJFkeBY0BZ1OPlmDSlGAxEEUMWDR+RmAqL5xjV6gRU=;
	b=GStBzGlBdhYKTt98QQs4yg9g2+SqMYP4Zm0yyKvpWip9XbWw08JlpfrHWwYNPl4Q1L4U
	 G1h14nKEIzxb8684cbt5rdbr4qgEi6ZhZXl3G+vU5hqNuiWvLjkS+ZO7IWNmF1XHqVwtb
	 3YXgiye+I4p15mMmJVDuldIQMvM9iRBxZNTG0GX4+9dXKc/ofPSQSCdmiR7/q7dH53Ox7
	 bADSULDUZcGVHo7Qh6Ztf/sY2vrMofwOxXRy0nP8DIKwUGA2jWGX6OmzhjBbrDZizhFeK
	 UCJoOlBWdpclXLQ/p2iY8dzg41Y0jLx4iFweqR3PBjq2M4NEzMJ41gKLOb9pyPRxNtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SpadUEwm;
	arc=none smtp.remote-ip=91.218.175.169
Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57367606A322
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57367606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SpadUEwm
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fuZhFuYOPr0oewf5ZwksCl2L3uxSF9dVzjuhFkRLtXE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525734; v=1; x=1796130534;
 b=SpadUEwmyDkvAYAqWTSsZ1ceMQuk7K736e1kJy1PX5kon8+rApg8y6Ob4/PyThZ6Mju8oWOG
 8eevL9j8QwBDFVel88hNg9vRragCQMY2s42vkRTkx3FefIS7iN5Fp+yXom+AcR17DZfuHjIWUrB
 HDZRfmws4Ed+enLHd9ufQXWg=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5aa0fa67673d0461;
	Tue, 24 Nov 2026 13:08:54 +0000
X-Mizu-Trace-ID: 5aa0fa67673d0461
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v1 6/6] tcp: do not call bpf_skops_write_hdr_opt() unless needed
Date: Tue, 24 Nov 2026 22:06:31 +0900
Message-ID: <20261124130631.1886963-7-xuanqiang.luo@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

__tcp_transmit_skb() calls bpf_skops_write_hdr_opt() for every skb. The
function returns at once if no BPF program reserved room for TCP options
(opts->bpf_opt_len == 0), which is the common case.

It has a struct bpf_sock_ops_kern on its stack. With
CONFIG_STACKPROTECTOR_STRONG=y, its stack canary is set up and checked
even when it has nothing to do.

Test opts.bpf_opt_len in its callers instead.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 2/2 up/down: 28/-196 (-168)
Function                                     old     new   delta
tcp_make_synack                             2006    2020     +14
__tcp_transmit_skb                          4114    4128     +14
tcp_options_write.isra                      1699    1651     -48
bpf_skops_write_hdr_opt.isra                1206    1058    -148
Total: Before=24067405, After=24067237, chg -0.00%

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 net/ipv4/tcp_output.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c2022fc9ad52..3c0be5a675ea 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -538,9 +538,6 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
 {
 	u8 first_opt_off, nr_written = 0, max_opt_len = opts->bpf_opt_len;
 
-	if (likely(!max_opt_len))
-		return;
-
 	first_opt_off = tcp_hdrlen(skb) - max_opt_len;
 
 	if (cgroup_bpf_enabled(CGROUP_SOCK_OPS) &&
@@ -1731,7 +1728,8 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	}
 
 	/* BPF prog is the last one writing header option */
-	bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
+	if (unlikely(opts.bpf_opt_len))
+		bpf_skops_write_hdr_opt(sk, skb, NULL, NULL, 0, &opts);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (likely(icsk->icsk_af_ops->net_header_len == sizeof(struct ipv6hdr)))
@@ -4146,8 +4144,9 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	rcu_read_unlock();
 #endif
 
-	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
-				synack_type, &opts);
+	if (unlikely(opts.bpf_opt_len))
+		bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
+					synack_type, &opts);
 
 	skb_set_delivery_time(skb, now, SKB_CLOCK_MONOTONIC);
 	tcp_add_tx_delay(skb, tp);
-- 
2.43.0

