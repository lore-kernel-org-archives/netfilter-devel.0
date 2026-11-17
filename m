Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931156;
	b=k+awcH8Yb9ZUEvTG82t4N3Rkdv9sI1zvhAsE+e343GduT6Si7kydvlei8lzTUvGFKKEC
	 HJrmhmAVx65FZWog7bYQdalzrkvCd1TqAeUZ3Q+N9GAgXjqLGmH9g7bjgo1qKs3Pbpm6Q
	 7TtkDor9DlZnf6Uv24tEYWH52skb6IkeG/RbjVhJxiXg0f+TJ13BrXQPHl59/d5KHCAqW
	 5y6Ce/1/4bgQ4Qn9p0wR0wIhTNJueT2zguhUi8SZ7zq+/1V7J/Aa+wOfJFhtWh472mFhZ
	 8i1ud9iYwkm2Tr3UXKtQbtEMzhUWsIXxydYG4Wqkvl80xaXifSrlWk+qQWmdHMylG8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931156;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wRvLC/duRnkLpVyfMHjM1aAbAG9IUqQQUDafN8L2a/A=;
	b=2xUxSPJzvWh0Fbg4igtx5ojeyEOPhSs3GQ/n4Bq+FnAFJwq1i6iO9G1N9NjBkwXZAi7n
	 nXueBePZf21GvJv1JWFkwzb+1Fg8dK4xOHKH3OqGliezG+F8ai9bdnZGYkfeQXaTVCC/7
	 tHYljQcvWU89wSWXmMmhDamfUIQ01enjkENlpMf3QFO6pkHr0xyD2kHL4IRRD0tAp5GT7
	 CeVdmqpA/gq9ojhjSQghvl6Oz1gsalBL+TVqNvVCzmHLk6FUBS4MFvuZZE90gzKOPT3gB
	 u3jgzq9YLo9npZx6xnvZBYLmNRBCouY02rQldm5LaRM8NHZAADbiPcoBHfntAqTDZcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94900606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94900606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0669560342; Tue, 17 Nov 2026 16:59:12 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_log 0/2] test updates
Date: Tue, 17 Nov 2026 16:58:58 +0100
Message-ID: <20261117155900.31418-1-fw@strlen.de>
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

1) Extend nfulnl_test's print_pkt() to also output NFULA_HWTYPE, NFULA_HWLEN,
NFULA_HWHEADER, and the bridge port. Update the existing test case to
expect the new output.

2) Add an nftables-style shell test framework for nfulnl hook/family/hwheader
logic, with per-test network-namespace isolation. Add six testcases
asserting hwheader presence/absence and indev correctness across
prerouting, output, forward, netdev-ingress, ARP, and bridge-forward
hooks. Keep tests out of make check since they require root.

Passes with both nf:main and the nf ulog / syslog patches on the ML.

Florian Westphal (2):
  utils: nfulnl_test: print NFULA_HWTYPE/HWLEN/HWHEADER
  tests: add shell test framework covering nfulnl hook/family hwheader logic

 tests/shell/lib.sh                            | 140 ++++++++++++++++++
 tests/shell/run-tests.sh                      |  66 +++++++++
 .../testcases/nfulnl/0001-prerouting-loopback |  36 +++++
 .../testcases/nfulnl/0002-output-no-hwheader  |  43 ++++++
 .../testcases/nfulnl/0003-forward-hwheader    |  74 +++++++++
 .../nfulnl/0004-netdev-ingress-hwheader       |  29 ++++
 .../shell/testcases/nfulnl/0005-arp-hwheader  |  69 +++++++++
 .../nfulnl/0006-bridge-forward-indev          |  88 +++++++++++
 utils/nfulnl_test.c                           |  26 ++++
 utils/nfulnl_test.sh                          |   4 +-
 10 files changed, 573 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/lib.sh
 create mode 100755 tests/shell/run-tests.sh
 create mode 100755 tests/shell/testcases/nfulnl/0001-prerouting-loopback
 create mode 100755 tests/shell/testcases/nfulnl/0002-output-no-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0003-forward-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0004-netdev-ingress-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0005-arp-hwheader
 create mode 100755 tests/shell/testcases/nfulnl/0006-bridge-forward-indev

-- 
2.56.1

