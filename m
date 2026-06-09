Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F673B102F
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 22:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781045708; cv=none; b=GxJFffR94nBYJW4nh5/OXCjCKXugtNw/hcy6hd+WFp/D/YZgd4hGq+KXFy6xnXX6bzN/QwSEWgERz6LMAWKFvm4KCOGU2xL5ULYFHJgVxLp3FdzLww8V8d3IlBNSnVDfJzfb1RkZFKk4ML4v0sGjPCJkF/MyEGsODGrKDEzqEXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781045708; c=relaxed/simple;
	bh=cN2iBuJp0OH+ga/cWJp+skXLIFTfjBActHQGiM5oFe4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ShOAIdSZ/ezbGFXGyX6dLb51Dx4UAcOqHnlMs/xDHqWyCqPg54dLmwAXnrZ6702dVkWNq5XldFvvFoUu2A3x8Y/ZcZJ9Ukj7NlyhQQCw/q5adYTFcLQdgr1fOxIKVIBqHUi9uTkk0ZrOlwQAVyegQ5ccMV6gAWqMag/Ox2yApAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=A87Vo1wb; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="A87Vo1wb"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf2247e38eso63477105ad.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781045705; x=1781650505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=muZ3vjFRk63tiEJGYLsHZWxrvBPLEZq8RG8RC1ri0ds=;
        b=A87Vo1wbFMq2v4QqCsZSoodugsmY9wsuJZdd/CXGq4sD2Ks7ipt12Pd0X/ooLVYGZM
         woslrsyap5pJTjVbArWF29v6/bqlBE03XvfFS2N5d4137iMy1LXuGuAC0+FAvRM8zlXv
         R4dGjvtGpUBTT8yH/O79664qibTlaEygh4/n2sbqtBnoWvH4szKnHVspa22aEABWKfET
         BROLEZQRuIakSc69zB+olszWBoao2XQvuurpn97Puf09tf63og1DqrKfjUrlP/n6X5Sd
         Nwh68k8a0jKsTVHjwBPe3Hj6WouqlCS/U8gzCz5RPESq2sIZSsGDgY2titksKsz7F7WF
         VATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781045705; x=1781650505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muZ3vjFRk63tiEJGYLsHZWxrvBPLEZq8RG8RC1ri0ds=;
        b=kUnygtlXOSt2fUho1sO1e7IR893dqbZqgZMEjfyzz1KsnaIb6GwywOo14upI829V6+
         r+HaOchWqos3s8cseU5+4657z8ovzD2K7ETUri6LkJHyMWFt27ohnT6PhH2k8LBgFLv6
         2N/p3+2nV+I7TRA/WUWJkuXRWpYChucOWgkbARLAVvdlmCSMoEHg0OMfpU4xm4J+XnMY
         b/8BxPRnt3oIUmQu+qrNogLq2+39RkTY///ja4OdcVq9OzbIE/bG1gKi6/7GZtp+2sMC
         DelF7KyEFdQuyeGW3CAs/usJ0IYWR4rGeG/4iOBBxDYquTj7To0P9aRnEDfGWZFqnvBx
         T3Cw==
X-Gm-Message-State: AOJu0YydUAufQmMzLEv1/z/BReIzVLo3D6MVajbZtXWPZRLWhLATMuAG
	QJjNPiF0f4pSs7pNFWzMdhhB5w8kg8Ia0/swjrsd62xRJq0VM7RPbokko9J29uqP8tOhLK5pizL
	VxygscUFT
X-Gm-Gg: Acq92OGM0pQCaOD1FVy3bPnns7HwydOokvbqXo4zKM+cUzQF5MmTcfgZ6sUfcgX2StV
	WEKkrNr7nXY8CursoIURDTRLHmNgZwFtZJ6kw2WVnrI26w+4tZztUikncrsuAokedrfaZPgwmLa
	hlFWiocZ7TpFuaO5R60nAy3RZQ/ZhxlZhUpV22FUtjNnNkgp8EYaWtVO41HhBKpHF5yR4OCbvuC
	uWB3sefG3YoPXC81gcnSm8emYm/YWoAundfWjoTTOX1PYeckpXg7jQGgKjgULIDEMJ5e+/2UdBR
	4hvqjSMhU0kxco0wvKkyN9dlPvdpVhh9QtJA9l7YIdraRJmjyhFw/DuQpjyNW7WMS2+uZEiyYbZ
	zzuPswVTiKnR1odVoPZjQEPl+okI5h08wSmbrKB78Aa0SPaNtWPfcuQV5oxntdXmIEyiYl/75I+
	ZE3rSthkErxzWzC/gppPA=
X-Received: by 2002:a17:902:fc46:b0:2bf:2188:a90f with SMTP id d9443c01a7336-2c1e85c5ae8mr247665575ad.32.1781045705294;
        Tue, 09 Jun 2026 15:55:05 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec8e:a6b9:eb68:80b2:fbec:ee04])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e627sm229150985ad.52.2026.06.09.15.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 15:55:04 -0700 (PDT)
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
Subject: [PATCH net v2] netfilter: nf_log: validate MAC header was set before dumping it
Date: Tue,  9 Jun 2026 15:55:02 -0700
Message-ID: <20260609225502.54239-1-xmei5@asu.edu>
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
skb_mac_header_was_set(). When the MAC header is unset, mac_header is
0xffff, so the test passes and skb_mac_header(skb) returns
skb->head + 0xffff, ~64 KiB past the buffer; the loop then reads
dev->hard_header_len bytes out of bounds into the kernel log.

This is reachable via the netdev logger: nf_log_unknown_packet() calls
dump_mac_header() unconditionally, and an skb sent through AF_PACKET
with PACKET_QDISC_BYPASS reaches the egress hook with mac_header still
unset (__dev_queue_xmit(), which would reset it, is bypassed).

Add the skb_mac_header_was_set() check the ARPHRD_ETHER path already
uses, and replace the open-coded MAC header length test with
skb_mac_header_len(). Only skbs with an unset MAC header are affected;
valid ones are dumped as before.

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
v2: replace length check with skb_mac_header_len 

 net/netfilter/nf_log_syslog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 7a8952b049d1..e37b09b3203b 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -815,8 +815,8 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 fallback:
 	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len &&
-	    skb->mac_header != skb->network_header) {
+	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) != 0) {
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-- 
2.43.0

