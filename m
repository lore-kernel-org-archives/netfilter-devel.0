Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841311;
	b=gexwF5AWwBCbw3rdchJSibfitll3a3NWq07PVngrG59Deot5ZEwWVwhZiId9YkgOA44a
	 uxVS6BPPxUe2c6vsGZdSLz7M6/KVnvAZ2w4D7s6+/KOrt9KvVCUt7hdFtFAVhjgeJyIb/
	 d5uKsxYtSV+byZ2JH60uO0wF3QLh/yr3Z5xeHRn7YblZyekk1h5Qvg1XICEh4IlodeAqU
	 r9JbXhRPTeMt4mMQrp7QNp6lcQSkKzGV0S9+X4INV485TlF66eQYxuZk4UoDI4yc/CJPy
	 bJ8Ps3Ahmhdt4SgZzYYJVy/hekUZNcrZixWTU+aSmYolkl553YRyyuP+XlQ2c38gWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841311;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=t4gHpP4H2Ksz/Yzkd0M1q7ZQ0MFcNwP5TlblCualRd0=;
	b=2rTkCIJ3gCnojdB6CDJ21b3fIF0efxO6g28fQ10OXSpVAxjRf5AFgIJ1zm1D5B/pmog9
	 J/3s1MO4FMxDn4xrzI80urikIDvezkDVDhUCXBk4lopk8CKaBjufQ8dk4TSmlQ+SfNfk2
	 jr74SFN8oXr376MbqzIvGXMBCAV/daWPzRCmXhn6ijukaQor9WAGe1g40lS8d4Qe565nS
	 1KMc0/v03KvS9P5k8bmFZp0hwvJCos9gLUpTKcfHa3cTDov5+QLl8Qg0lFONAdDmHKGue
	 F3p1Wj7w8XPSxGlZPHDAAFQ4v/feJHJlfh/LedJdQOlp9gGJFPncvcNr3BZYCQEeeWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=UQhB2oO2;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB93606A31C
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 15:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEB93606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=UQhB2oO2
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id DC20F610E8
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 16:01:41 +0100 (CET)
Received: (qmail 22766 invoked by uid 990); 16 Nov 2026 15:01:41 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Mon, 16 Nov 2026 16:01:41 +0100
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
Subject: [PATCH net v3 0/3] ipv6: Honor prefix suppression for FIB lookups and cached routes
Date: Mon, 16 Nov 2026 15:01:27 +0000
Message-ID: <20261116150132.9594-1-leonard@lausen.nl>
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
X-Rspamd-Report: MID_CONTAINS_FROM(1) BAYES_HAM(-2.990565) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -1.590565
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=9VUargRA+llLPhlaHqp7nVxV42OmmixbozWbpTCEDjE=;
	b=UQhB2oO26xg0BF8W7MP4JQ3dnYrFDI793YEdxhmqtTcNBeoiAZuW2lqpsAl1i/6aPQG+OUCsrj
	E6I0GhlqKfOE7xcTYWQC2aHenXAAm/GJRqHGytLMKP70SRxzguxjYVT1YDsyqr00qG2tL20LXoV8
	4YsyKLv3D+WwUGvkX/YEqQv4AzxthllTeQfJDQc7OtLVZwYrJj5i3UdWqitMC7BFOTB5YeQ94yPH
	vjV3AzfwlzGCiQs95PRMA8LmaRIEjTnWNFDzUSLw0aAqNLwYS/+F3R8zHC/IVqvSit2SfXM5cBcC
	A3264SxA8848c6vPI8ZsnkrzjyFJ6bawVoDmzys7RWTfLxsW0HMkcKKF7/RHa8+fgaAv9ERyAGOP
	Dta2GndD9ea6yJohHoP3m5Q3HJTJ/0ZsyjjdV02trHMnjYCXAlSZ1pd9BUdP45iz4WOTKHHP3xZC
	gwK1gLvuww8LNTD4Xhg8jvDyVoqx5Hhj/nur7bmd/vTfudMoIebRYHFUxnpdj0acjb3ytM6SMcoS
	oRMb6uPSez+H3fd+M8762myEaHm1wqpJeQUQirpNROyslxO/r1wYokCYh6pxF/2xDgIW+rucdBT1
	0Qb3PIJCcp0bMtxvSHfJkOiMTgJNcqLyFgG6946aNHtUL8AqF9u0R85lVRQEXuGxv8+E5kb+TnOP
	c=

This revision also takes a stab at addressing the cached-exception disagreement
identified in review. The fix remains small and is a separate patch so it can
be picked up or discarded independently of the fib6_lookup() change.

Patch 1 uses the parent FIB entry's prefix length for dst-based
suppression. PMTU and redirect exceptions have /128 prefixes even when
their parent is a default route. Reading rt->from under the existing RCU
read lock fixes that comparison; a detached destination retains its old
behavior. Interface-group checks and reference handling are unchanged.

Patch 2 adds the fib6_lookup() prefix-suppression check from v2, with the
reviewer's requested message, Fixes tag, original initializer and comment.
It preserves reject results, including blackhole nexthop objects. Support
for interface-group suppression in fib6_lookup() remains deferred.

Patch 3 reuses nft_fib.sh's fixture. Besides the six existing suppression
checks it seeds a real PMTU exception via ICMPv6 Packet Too Big and checks
that the parent default route is suppressed. The extra case uses the
existing peer namespace and adds no new devices or dependencies.

Changes since v2:
- Add the separate cached-exception fix and PMTU regression case.
- Adopt the maintainer's terminology, message, Fixes tag and comment.
- Remove Assisted-by and retain the original rt initializer.
- Run the checks after the default-table tests, preserving coverage before
  custom IPv6 rules are configured and avoiding logging RPF during probes.
- Label ruleset-load failures, skip unsupported optional features, and
  check ordinary rejection errors using the C locale.

V2: https://lore.kernel.org/netdev/20261115114434.10343-2-leonard@lausen.nl/

Verified on the rebuilt v7.4-rc2-based kernel: all seven added checks
pass and the complete nft_fib.sh run exits 0. A run with an eight-second
delay also exits 0. The PMTU reproducer creates a real mtu-1280 exception,
then confirms that both ordinary and nftables lookups continue to the
later table when the parent default is suppressed. Twelve reject-route
probes, including blackhole nexthop objects, remain terminal.

The source compiles without warnings and passes focused callback tests.
Automated kernel-log checks were unavailable in the namespace test
session. Target-net runtime and full W=1 allyesconfig/allmodconfig builds
remain unchecked. The series is based on v7.4-rc2 (7475ea8b5861).

OpenAI Codex assisted with investigation, reproduction, implementation,
tests and descriptions. The prompts asked it to investigate the VPN
failure, simplify the series and address review feedback.

Leonard Lausen (3):
  ipv6: Use the FIB prefix length when suppressing cached routes
  ipv6: Honor suppress_prefixlength in fib6_lookup()
  selftests: netfilter: cover IPv6 FIB prefix suppression

 net/ipv6/fib6_rules.c                            |  13 ++-
 tools/testing/selftests/net/netfilter/nft_fib.sh | 109 +++++++++++++++++++++++
 2 files changed, 121 insertions(+), 1 deletion(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.55.0

