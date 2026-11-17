Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913710;
	b=eM28vS6StYRydJDqhJjk6JPoYCNiPcBjsR9bFssCPBJZonVX/7DgzaeiFUdXL+04y+fO
	 ho1pHhI051SAO/v9UWaQz+ey7mmdg/ykKMNQg+mhJfghikxs0Od9jmc8NyL2syheWzAHL
	 ZihruqobpL7ZrvKemSaNhRolVhdMFYONtEpKkxzhJksZV+8FPPXScFhKOT8onOalf7KBp
	 Jp+xOYws4/GSvMtV9hAcgnhnCS5vXZFYr/+tzWleqtXOuzZsJQ9l++i4CmbZpa1Gy3Ky8
	 pLU12XKq4cG33UV4yV1qwCRyD+n0a/hAA4AJ9aPaCk87AVO9RnH6FHPLD/mgVm1d3zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913710;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=bElf91F0TDGB0uVW6EDy7Ea2SeZyP2p1hq68BB9tv3M=;
	b=5Il0fOJrcT8u/UiUhdylZn4D9eyxZ6KsIcookJC460dvv3QAKbQSsJ1WKmCDcpgaIYgp
	 ArDdhS5eqdOwOf7j4bmVelMu8uiQtJQisG+BBlAloaUKBr1lo7jWB7uDow6dTZJev9zIB
	 DS8kJnMDG6l4OQgjqVD3dRgVcC5Zl7U2JSfrsJjWGJWL6rf5bpHEGwqZMDRbbxRrDE//Q
	 ISneFBi6/pzbX/sliH/YIE47FW52jZ5w/KNLuhhIkkpNtrBcc5X4x+F0r0lV4A2edNXh5
	 9WW/zh71WmvB/WITndQeuJWcMZzmw0QAbqY629hVrn7MHXoyMn7bhThTVlZUSc1avRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=DowB7CRb;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C7A606A33B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:08:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31C7A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=DowB7CRb
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id D0E6E60DF3
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:08:25 +0100 (CET)
Received: (qmail 22106 invoked by uid 990); 17 Nov 2026 11:08:25 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 17 Nov 2026 12:08:25 +0100
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
Subject: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in fib6_lookup()
Date: Tue, 17 Nov 2026 11:08:10 +0000
Message-ID: <20261117110813.9894-2-leonard@lausen.nl>
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
X-Rspamd-Report: MID_CONTAINS_FROM(1) BAYES_HAM(-2.99937) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -1.59937
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=vUMxaJE9CM9kOao/0IjJwCXP/HS6Q7+W3oTGXUJmYz8=;
	b=DowB7CRbKriw+t/ovbD0hD6xHVK6kHKoydTbuiw+JtVrRiEO7RoQSuCHTRTjyeLmWiPVEEKrdn
	1AmYSI5+3PBr8gamW3DC7C1q4Zp6VplsCrg9Ei/56dm/m0VmipQSBhBGtwlOVsG50gQDLKF79ENT
	MyHgSXBRDKm+86/IaVpG56Wu0tgGyd7j6tjcaz8Pr+bhsOTcp0Zh5Gc99AxGgdge8hWAf4aP4yO4
	8mRvLTPGqmOjNM75avlIGDJ9QkzJphHofFklTV8L/jxuXwImpQDDU2y4sB86dgPKjO1Lv4vOoEsf
	EDks3TqS90ZrO1/MDe/E2MDHdiHV6DEx88L65biexhuOY8KzCw5Xd2vFidnU3b4bVvaJlYR5ZpUz
	D/eXtEOWeqyvKIBJRCsQq7Iayzxf93lxd9vE6TDqP9ZbZQ5UOfHafrW6rvn1VKXBqXuYK5UKhJJ8
	dkJw0fGFvjdtNnI9o/e5oasWtZ3sBiayBqUSKdnrSCDlxmWi4O+sNj0bMFhFsZ7UrRxmhflnuOKo
	bnllFfKQ5vB70AqC0ystk0DqkaedX0ScNL4Lafre09XoDjm2ynRubaVu5Vs0WbDBOKOLojfkOWsi
	lhnp5B5YWpFEPL3sCrXkWLtw13mAjnCUE4JH8Eo9JkLKvqtLLviuEDGWD16VtN33yvcQ5TzxKnER
	k=

This revision removes the cached-exception patch and its PMTU test, as
requested. The series fixes the nftables regression introduced by
1c32b24c234b and leaves dst-based prefix suppression unchanged. The
cached-exception work is deferred to net-next after the fib6_lookup()
fix is present there. Interface-group suppression also remains deferred.

Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
terminal reject results, including blackhole nexthop objects. Patch 2
adds six checks to nft_fib.sh using its existing fixture.

Changes since v3:
- Drop the cached-exception fix and its PMTU regression case.
- Remove the PMTU-only gateway and peer setup from the test fixture.
- Renumber the remaining fix and test patches as a two-patch series.

V3 review:
https://lore.kernel.org/netdev/20261117091340.GA581197@shredder/T/#t

The rebuilt v7.4-rc2-based laptop kernel now contains the v4 series,
without the deferred cached-exception fix. All six added selftest checks
pass in normal and eight-second-delayed runs; both full runs exit 0.
Twelve separate reject-route controls also pass. The changed source
compiles without warnings and passes 17 focused ASan/UBSan callback
checks. Automated kernel-log checks were unavailable. Target-net runtime
and full W=1 config builds remain unchecked.

OpenAI Codex assisted with investigation, reproduction, implementation,
tests and descriptions. Prompts asked it to investigate VPN failures,
simplify the series and address review feedback.

Leonard Lausen (2):
  ipv6: Honor suppress_prefixlength in fib6_lookup()
  selftests: netfilter: cover IPv6 FIB prefix suppression

 net/ipv6/fib6_rules.c                         |  6 ++
 .../selftests/net/netfilter/nft_fib.sh        | 90 +++++++++++++++++++
 2 files changed, 96 insertions(+)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.55.0

