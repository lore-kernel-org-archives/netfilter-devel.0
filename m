Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316648;
	b=t70s0/GYWK0E8a/uprT6lsBn0oK4KgA0oqptNPUJScX4hmGk9mXjVzwWC7J53vMYA94A
	 ICNhnALM5+Jse5Eb7BkBbvcmRDMPAsR1LK5dE3VkguLgoaBIxBE3reFph6Udheg8CWvLT
	 7aZZL9Y6Yg83YRZ5t/DUE2Liwp/89VshdkXwbouviVHJBH+mx75e7jMyY/D3rLt/NIMci
	 b9CEuRHczzS9ycciANkXmiZ6L8KTxCbMQA6cv8FgQDejul8BDw54ubERvZSP7CBsWccaz
	 yQudNyMEdw5mSe61rCaN8grHEDj0R2jCSIAKA/ss2Vm4Wr2bgTANSmv+TfI89YF6Zww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316648;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=Xz69vwdlgbH2AiksoxbbdfVj3ichWtpOW5WINr/u1E8=;
	b=rGK/8pEVJERNDJXAbv+fEnfHw0CheHjubs3ZVXEp4V+4ImLiZSUCyP7anKHgsAt5634C
	 mSdEA03LlMgYXOwTZe04RrJYUDsR0+jNny12XuNK8NLvAUlMZUnb50Wc/lQNNVXA3DS2f
	 Nti3OyCC0q5oDrICgddwB6g67zNDEIJ3ocNXeHUapjiZe/8AXTOES2HkPRg9lGiSE9+w9
	 mVTN5ZD1mVHxwueMomu6Gf88yf5KFyjrv8LEup3G5aBMd2fnb8tqsqRcRCrpQ2ulEdr/v
	 HwQSvW3S1s8lPG7aKHGqqoc2JGG4Uoem78e1pGkx1UW20pq/eU9dCzcPeAqQVE/sLuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=qEMbmOVZ;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334A6071E4F
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B334A6071E4F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=qEMbmOVZ
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 11A9F60C4A
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:17:18 +0100 (CET)
Received: (qmail 18734 invoked by uid 990); 10 Nov 2026 13:17:17 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 10 Nov 2026 14:17:17 +0100
From: Leonard Lausen <leonard@lausen.nl>
To: netdev@vger.kernel.org
Cc: leonard@lausen.nl,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] ipv6: honor rule suppression in raw FIB lookups
Date: Tue, 10 Nov 2026 13:16:36 +0000
Message-ID: <20261110131638.15004-3-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
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
X-Rspamd-Bar: -
X-Rspamd-Report: MID_CONTAINS_FROM(1) BAYES_HAM(-2.996444) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -1.596444
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=4jabfNk/+Si/BEhfu5MnAq/+ZlUBEjAIZzdfp/sdPnU=;
	b=qEMbmOVZF0bxGo/52K9MwG4xc0nsDg9y6Jfdko5itxLM892vRRoqMGTAgEkd2mg2XPc0d1taCA
	r157Erj6MXjgvg5dgPYR/t9+g+TMInPbnPbLSUX8tqgEfog8idPABSa/BoSnlImaz40hMCfwvVzr
	/gl5qS37QzAWMcc8Zo7/CXXCJtyVkMcdhQhZd2uYgihhxFNnDXmXj4FCopPgVxDhDeX0tX43he9B
	ysU7D1cDSQNeIpjcGG3wcpVQFlLI/3Cmh6EGxoCa6/aCSk27dSk6MDGn9NwTNQNIFPS4L3xR8X/f
	ZIKwqHqcaM6rI8m6o9DODamoMgMAXEPGccoROX5CsKR5SBAtTkrY54p43qbps0E4YIv82jzxae/y
	WMkzuNJYUtCDC0FH749MgHZhaiWMMbEkUMBkzCUZVF37o4YwHkg7aW94+efbp5X3OxjbxJOQ6N/o
	p15f7WdDVKJHA+XYgqKtGajHVAa5VVrOPlcLi/POG08L1etIbhasycdQle4NbStWA9IAD++WplNw
	CnEW1/0jYmE6V99nUp3QjzBhcFnbyhBmkJK5JrAHi9iDAZwmZglKC99bufx4N9wEOnf2mgA8OEeX
	xlkVYxoHbqjJg5T3k4+V91NnioG286wLGTudqxd5RkZrQt4B5ieX6s3JhZ8oe+OGcJT3AwiBS5ui
	Q=

IPv6 raw FIB lookups ignore suppress_prefixlength and suppress_ifgroup
because the suppression callback only examines the dst-based result.
This can make nftables select a suppressed main-table default instead of
a VPN route, causing strict reverse-path filtering to drop VPN replies.

Patch 1 supplies the prefix length and output device from the appropriate
result representation. It preserves reject results: raw lookups can
return success with RTF_REJECT set, whereas dst-based lookups report an
error and skip suppression. Destination-reference handling is unchanged.

Patch 2 extends the existing nft_fib.sh fixture with unicast suppression
and retention checks, plus a loop covering all three terminal reject
route types under both suppression attributes.

The series targets net and is based on v7.4-rc2 (7475ea8b5861).

Validation:
- The original VPN failure was reproduced on unmodified v7.4-rc2 in QEMU
  without kernel instrumentation.
- The final fib6_rules.c compiles without warnings with the laptop's
  existing configuration. Its extracted suppression callback passes 17
  ASan/UBSan checks, including reject results from blackhole nexthops and
  destination-reference handling.
- On the rebuilt v7.4-rc2-based laptop kernel, all ten added selftest
  cases pass and nft_fib.sh exits successfully. A separate twelve-probe
  test confirms that blackhole, unreachable, prohibit and blackhole
  nexthop results remain terminal with no suppression, prefix suppression
  and matching interface-group suppression.

OpenAI Codex assisted with investigation, reproduction, implementation,
testing and these descriptions. The prompts asked it to investigate the
VPN failure, validate on v7.4-rc2, simplify the series and preserve
terminal reject routes. Both patches carry Assisted-by: LLM.

Leonard Lausen (2):
  ipv6: honor rule suppression in raw FIB lookups
  selftests: netfilter: cover IPv6 FIB rule suppression

 net/ipv6/fib6_rules.c                         | 32 ++++++---
 .../selftests/net/netfilter/nft_fib.sh        | 68 +++++++++++++++++++
 2 files changed, 90 insertions(+), 10 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.55.0

