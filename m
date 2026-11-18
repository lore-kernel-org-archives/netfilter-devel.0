Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003072;
	b=exIrIxsMt81w0VfmZq9tmHlxj6oXVOh9o3cyyA7V32sBIuGmYm4ItwFU2M573SWmXMr7
	 Hbv6cYh4iozquZCWz6zNW40Hvkc9n9r0fMLdlt4NOa3tSj0hQfEFJT+xs1BNk1NIIhf3T
	 X8zgy2kQNhapndnqEiFaILkD0Ewoy7E9fWZi9j0ry3VwgtPRvurY/YXkQLVZDGUcMXXgG
	 i32wVXLqRmYJqiznzMB/22nVLtytZgZCe62uNHlKfvEj8izlx7v6cIHK+/ltHzrth0TA6
	 aJL45W6dV6fgLSkbEugJ57nWSK2nOTkigTxhoYHQ9ShQTqd915vmDvNIQ7kli6zmPXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003072;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttB3OjP5/MnRE/9Zo7mCCAfehs0DO5fs2RMP/s+yBEE=;
	b=GbyEI24b9e81Kib/9pJElf8wY9mswlbzMZE6Vwo+QroyEGu92xPHZP1M/lt2U5ae1WO6
	 rb5ZNdosd2cnJ6qfSb0+fFLSMci4QAGyk89QEhg75grxxM0v7I8d1kCCEHmLfScRFKSc+
	 oUwm8V1VviT8zhb8Ppnyl0B75qgwbVkesdnL566v8UZtHcvmYPhEfNZua77IXOvsCqipe
	 TQBONGJMUXQhZllfF/bZL38isD7TBS6AoWdKa/tHkdBFUgYEnnCV/+NottrKXfZcFjaE2
	 mWsmxeDmW17si7yptT52BEr5LxZUELx5kxJfzz8fm+IOEfvXiVASKzezcmEgSoHppig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA692606A32A
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA692606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2B79B60633; Wed, 18 Nov 2026 12:57:44 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/6] netfilter: logging cleanups
Date: Wed, 18 Nov 2026 12:57:26 +0100
Message-ID: <20261118115732.9529-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
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

v2: LLM cargo-culting and more paranoia checks.
Couldn't find any place where skb->dev == NULL && indev != NULL, but
I consider logging slowpath so I just gave up and had LLM blindly
follow AI/sashiko "advice".

See patches for details.

1) Remove dead ARPHRD_SIT special-casing from MAC/HW header logging in
nf_log_syslog and nfnetlink_log. The branch became unreachable once SIT
tunnel hard_header_len was zeroed.

2) Fix MAC header dump in nf_log_syslog to use skb_mac_header_len() clamped
to dev->hard_header_len instead of unconditionally logging hard_header_len
bytes, preventing reads into the IP/IPv6 header.

3) Refactor hw address extraction into a shared helper for nfnetlink_log and
nfnetlink_queue. Clamp dev_parse_header() result to 8 bytes and validate
skb preconditions in the common helper. Add BUILD_BUG_ON assertions for
identical container struct layouts.

4) Use skb_mac_header_len() from indev instead of hard_header_len from
skb->dev for NFULA_HWHEADER length. Omit the NFULA_HWHEADER attribute when
the computed length is zero.

5) Skip hwheader logging on output hooks where the MAC header is stale. Gate
emission with a family-and-hook aware nfulnl_pre_egress() check.

6) Emit the nfnetlink_log timestamp only on the input path, since output-path
skb->tstamp may carry an SO_TXTIME delivery deadline rather than an
observation time. Replace the broken raw hooknum comparison with
nfulnl_pre_egress() so ARP and NETDEV families no longer emit timestamps
at their output hooks.

Florian Westphal (6):
  netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header logging
  netfilter: nf_log_syslog: fix MAC header dump to use real header length
  netfilter: nfnetlink_log: fix up dev_parse_header usage
  netfilter: nfnetlink_log: use real mac header length for hwheader
  netfilter: nfnetlink: don't log hwaddr/hwheader on output hooks
  netfilter: nfnetlink_log: only add timestamp on the input path

 net/netfilter/nf_log_syslog.c        |  28 ++---
 net/netfilter/nfnetlink_log.c        | 151 ++++++++++++++++++++-------
 net/netfilter/nfnetlink_log_common.h | 117 +++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      |  19 +---
 4 files changed, 244 insertions(+), 71 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h

-- 
2.56.1

