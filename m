Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916257;
	b=1AhtKkQ5vEjXul4yIPfavG7ZC+hiB5Hv8bRDQ6gPl7m++iuWaXT04X+T84wYEehw+2jQ
	 Fw4BMhHwc9DdfKDoXpeH5wMxh2l2ydZo9KHSNWaAmcMrMOHxsogqCeYnx2r8LUKjxv6aF
	 WS0Aq0MwF+xKYg7K8DzwxNcl1KCod/+baeHpceWhvh2dOWtCDJB2KCpKDxOducwFAS17V
	 4fBgdAV0T9xDshrmFPQ0oMPh/3uf/LC1Oxbi5nf9vyl0yivjso9KOyXBD2Hf9mTSowSxT
	 BaTLfAtoYXql5pWjywYwzHIGUbG1jjVXcSdzl9Xvm2X0n/+h78SVf8AQTZ5zN0hS7hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916257;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y6zf2N60fSC9ABEK/KMu7iPGdvSapISfF2mCsCsKd6c=;
	b=l7VrSrunPmjPz/yhjI/JWR1IfaINNAxAnTmJtE3aPD/D7U4PBAG161lW5sF6MaWaK3lO
	 +yveN3FrfiGP/D+NjnsSlj2uH7Jyyc54HeSDedi8O4byBd8nexlQTT+ok30BAJ1dTcJrF
	 TAvVeM9mA28GZs8zYjxMcA2S7HCvFCWmNc4QkSgPBqDoVjytUG6TmzzaRC9j2wKqqemIO
	 nd1OdTAVxtND8j9n1PVusxLfN82iWndbqFZIvu6dBks9lwDSv/IKxrzYfE5Pi3ziHNLCB
	 PLwyCq8rYLgozM3LFQyMEINeuD6xdxPGmkLfIJb/7LmlXtxpFo8xXjeGOdJ7DbkSlRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE789606A883
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE789606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A50C26055A; Tue, 17 Nov 2026 12:50:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/6] netfilter: logging cleanups
Date: Tue, 17 Nov 2026 12:50:40 +0100
Message-ID: <20261117115046.15435-1-fw@strlen.de>
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
  netfilter: nfnetlink_log: don't log hwheader on output hooks
  netfilter: nfnetlink_log: only add timestamp on the input path

 net/netfilter/nf_log_syslog.c        |  28 ++---
 net/netfilter/nfnetlink_log.c        | 151 ++++++++++++++++++++-------
 net/netfilter/nfnetlink_log_common.h | 106 +++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      |  18 +---
 4 files changed, 232 insertions(+), 71 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h

-- 
2.56.1
