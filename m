Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2F710F0
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 00:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780877498; cv=none; b=VYXAzkrDchVYCxYSqX04oJF0OPX6ug3TSw2nSWWuorsjQ6InnBh3Id7w+OwhjRqN46SruK5D3dXrEm8Nc7EJBFYbAohjYM2z9ioojcgyh6MCSZkV1p5P0CX4y/IMwPIZ7t8rEwaiMNQHqtfhvE67Z1iXHEeEmSIGp09q/ByjcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780877498; c=relaxed/simple;
	bh=V0kYIIvrIeCHLQ8a3wc6DSRe9JDMTon7cWNexfUqcao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o4asMBFEgFiP2RTDoqpU0eLrU7oUdQ/aWbaH9LkwIoGWIh8xMDQaD87cXyNvWyYSkvhapH68Q6OoBbjp+XZx+ZOFmHj4JRVz3bm8ip8IGjEAvqy7IdhR/gGeR605DUbpSE+mFdfBrkExPxCR0aZX6hwmzbtlVmfhD1xEhxi+ddY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=e7RkjrOH; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="e7RkjrOH"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-307263ad0cbso4722845eec.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jun 2026 17:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1780877496; x=1781482296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7iRu3+QlhKqNKahUpScbtHabnmDiSQhKgGceKe0jaQ=;
        b=e7RkjrOHhv++qxwhAuWd/AuFvCQY4F7jRBDn/V3rOo730Eqd7fB9WiFgyLeBBCr2ir
         WFYVCiGMDjrSGmxZG9c6kRmm3qnUPue3RBP3EwUyY3pplXB2/qXz3cpEyTDRl81xw6mh
         GwxeojuIlsiiSV5tpczuDZ01x8Fsu/pA8lz2ZgqdX13/HENe9FsbarExDj3ImIIC3N/S
         cXqiQc6okzGjr8p4KkePcy6cJYQ01swMZBeaXDsMEmdFhFgDXohFfyJmIYi0W2G8zvmR
         uF7hZ+dYbPLBSLF9y/WoTpmAhYoEKUpc6Q/XIYuE2kT3HPtBJZIsYuSe435UfMZjMeRU
         er/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780877496; x=1781482296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z7iRu3+QlhKqNKahUpScbtHabnmDiSQhKgGceKe0jaQ=;
        b=dK4eTYm6ZuVhLReiECGDk9EtTkT7YZbw0gemydg+8inZgk18vZAm3FdNJjOUnzD8TW
         s71f5rFAa7ymBnQstExUI+6dokEuEB1DSWVqchiQ5Y1an0R908k+4dU+soXYZPY7SlMc
         Fg+pZs5c12z6Drw6TTSpXubedOBaUqaf0jkKAE/1yAUJOUdrvScmvGsRowrLYwOHYO6w
         Rn4M3bs+Jf6kSFVXMr60IvC/RTFFjSYDU/dirCF1LUTK2kyRygaKy8PE9oK+Kr8QciNg
         t1PhMBj8qRQRm8PhhI57hNvc060jQmU12xXHERhYO99Kz45+ydwj6Ce9zwQuWslhD18A
         C0wA==
X-Gm-Message-State: AOJu0Yylyptyg1qYuGUqh3wXZ21HgfhMt0DjwFimqu7UwqUXIIcV7xpF
	pjrWyCKTdD3PApYRxIWXzWfhC3+MxCbjEH0rkOhHjMHkaoU7U8bv0y8aiDKFpaGJJSUtziQZVvr
	imEFK5Q==
X-Gm-Gg: Acq92OEji/n/7HLknWTww04NAVlAIoKFrul71cxPRNZotkjA6ZVsU/PPNRkRDmFAxJO
	QTuiRyCcSzVhqWIdjB1DHscn7Tnhng8bGx8KqNYoN+FsHs+rAdbb8Udj8aVGDmkQgujzgH6abgu
	VXEhCF+kBGmJR6Y/rsIrVCiSMZFLquNqX5hRZxGrT8tbU9XS/Fl1DfjPBGikLwWkkE5VVF+qxbD
	Qkd3Hswc0qVFn7xmSoMWufW5HbzwXkUoIjYPzn7C5E51gwB+SRwl0TwxfpgV04Wh/pigACeBry6
	OfH7tHCuaJ+qFr8UOZGcITD2gdRWubYwx4l/clm9dRjtC/fkzK6F5CsqKdpByt7f4GR/W5VuySf
	cCEubORxORIySGO6kogklAyaT/k9qNwv7P/PBndAn05XIuc/yd7GA6oz55Ahh0LPRWwqWoC0oi9
	cdZJW4kBrN795eSG43Tg==
X-Received: by 2002:a05:7300:5356:b0:2d9:db50:c6a5 with SMTP id 5a478bee46e88-3077abe9a9amr9120785eec.0.1780877496218;
        Sun, 07 Jun 2026 17:11:36 -0700 (PDT)
Received: from p1.. ([2607:fb90:ecaf:d942:ceea:844:6820:3308])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db528dcsm18032945eec.3.2026.06.07.17.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 17:11:35 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	davem@davemloft.net,
	edumazet@google.com,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH nf] netfilter: nf_log: validate MAC header was set before dumping it
Date: Sun,  7 Jun 2026 17:11:24 -0700
Message-ID: <20260608001124.309352-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The fallback path of dump_mac_header() guards the MAC header access
only with "skb->mac_header != skb->network_header", without checking
skb_mac_header_was_set().  When the MAC header is unset, mac_header is
0xffff, so the test passes and skb_mac_header(skb) returns
skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
dev->hard_header_len bytes out of bounds into the kernel log.

This is reachable via the netdev logger: nf_log_unknown_packet() calls
dump_mac_header() unconditionally, and an skb sent through AF_PACKET
with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
unset (__dev_queue_xmit(), which would reset it, is bypassed).

Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
uses.  Only skbs with an unset MAC header are affected; valid ones are
dumped as before.

 BUG: KASAN: slab-out-of-bounds in dump_mac_header (net/netfilter/nf_log_syslog.c:831)
 Read of size 1 at addr ffff88800ea49d3f by task exploit/148
 Call Trace:
  kasan_report (mm/kasan/report.c:595)
  dump_mac_header (net/netfilter/nf_log_syslog.c:831)
  nf_log_netdev_packet (net/netfilter/nf_log_syslog.c:938 net/netfilter/nf_log_syslog.c:963)
  nf_log_packet (net/netfilter/nf_log.c:260)
  nft_log_eval (net/netfilter/nft_log.c:60)
  nft_do_chain (net/netfilter/nf_tables_core.c:285)
  nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:307)
  nf_hook_slow (net/netfilter/core.c:619)
  nf_hook_direct_egress (net/packet/af_packet.c:257)
  packet_xmit (net/packet/af_packet.c:280)
  packet_sendmsg (net/packet/af_packet.c:3114)
  __sys_sendto (net/socket.c:2265)

Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/netfilter/nf_log_syslog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 7a8952b049d1..ed5283fb6b67 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -815,7 +815,7 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 fallback:
 	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len &&
+	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
 	    skb->mac_header != skb->network_header) {
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
-- 
2.43.0

