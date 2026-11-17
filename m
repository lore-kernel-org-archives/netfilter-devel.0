Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913712;
	b=F9obB5AoqGobkZEUSIzl1aD0OD9nzzNzZOJ0JL7yJBlxARSCVYheeFrIT9Qg9KyMtqC2
	 sZiJVXXl6FhpwvkJULB3HIokX92USUF+jq8lJGhumr9pLNBQnFLWwDqDHMkyH+3xJdXoz
	 YtKqzydf11wxJDXQrEXzDJt2OshKJA3mirRkUGie4yMzbkFA8qeOWsLdT7S6jDeLHbSSc
	 /c2aKLdBBIibYvFIdM08ZL48geaXk4zCuSx/u6Ikly2Q3yjSm+DT6ECi0mnscbOxjQXXt
	 ufuMeldWxDTdWlYyjvHqFeftvXj/s+Wq/LZoU660TbKSp2MPNlf0n1D+BDDAz2cGXpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913712;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=g2FT5J33g2gQI9Jq9qpJtj8sknYwea8FHdJe1wI2CJU=;
	b=zjq36y5ZsNc4RhTqd5zcg//Jj/huGUAUba33plX3pCmR9OjUuhOz7kB1LhftOQfSWLWu
	 xPfvDTUKTbBlbyvfR39LMnsS6LLBEQEn/a6aDTCIt5qcjKRXD3b2tJz6m76sTmedti8h9
	 JiigmqGewmlA0NwHlu8XFxsiiRplofEKC61PjmDaSZmvF8dZIC3XQcDvjM4dH/Z+5AXVA
	 IfeOlM2TItN3pRoGGw+2kbMHqwsYzcSN16yxPq6SCkoIkXReXXrjUHby0QAuoJqg9rs8N
	 r7ZS7IkThG/EpjsTC2RRafkJmBYje9luzLtIonB530p8VM8w+DZSXDOT1M4narGjzwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=lMgTZtdh;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF1606A89E
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EBF1606A89E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=lMgTZtdh
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 5B5F460FB2
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 12:08:28 +0100 (CET)
Received: (qmail 22445 invoked by uid 990); 17 Nov 2026 11:08:28 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 17 Nov 2026 12:08:28 +0100
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
Subject: [PATCH net v4 1/2] ipv6: Honor suppress_prefixlength in fib6_lookup()
Date: Tue, 17 Nov 2026 11:08:11 +0000
Message-ID: <20261117110813.9894-3-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261117110813.9894-2-leonard@lausen.nl>
References: <20261117110813.9894-2-leonard@lausen.nl>
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
X-Rspamd-Bar: -----
X-Rspamd-Report: REPLY(-4) BAYES_HAM(-2.999675) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -5.599675
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=5AkPUOak53iMkPFFarJNAx9WrRA2KUnE60tZ659yQ/s=;
	b=lMgTZtdhISgEYNaXOqq81BCFsGYJnza6tVmV7S6SlGhwGhuA24uYv5K0oN1Oipn+s1ObsRva0h
	Y2L42VAsZnhPwczzjtORlEhEGbaILc+9kp++zba9CqheNdHXf9S8wWI8Gn+So/O7bEPNtjmh7Dcm
	Xv6cT7jFh+FCv4A3pIJgg6nm+11cAWFbPdM8/Dk5XaYhsz7xe3ltXfhDu7EZZGdasRmjfxEtS7O3
	1BAjS2ugWY00DOZj5SX7c+cA+OiiV2C2wX3OwUT1FV1268aHRJSPbnzkFaTLIuiceCxi8f11XY3o
	DAWY2yH4GqS7W5O7Az1CoqbTgj+tEY15pFmp1DMGoyMyTAuAeuwooPRZ7GiDhMK+uv29CYncpwB0
	ILl/lSZlZFWgifGsMb7QRO/KHNR54PQdsh3Dygnd+DhL7LDU/nxGlNWE6KxAhCmHlru9Agw0Udwy
	++guyuXlxM4zyb/3taBROFe1B+1ROsesTYS5x57cLk3VymXLdowS13ASfDSGX9QOKZLUQ8VE6vTv
	Vj/de5tTQ1E64XnDnwkYpjul1uBauVmIXQhA/MUz4LaRBYAic4QAUYA46bPpe0GcxcDgf/LZmVHy
	QPupFhLCWjAbsvd7b74AmDM/WRDTpd8TksT82y5pqUf7lAhNvL4VNsk2qZXvkuAPC5k5W6iHDOPv
	g=

When custom FIB rules are configured, fib6_lookup() performs the lookup
via fib6_rule_action_alt() which calls fib6_table_lookup() and only
populates the f6i, nh, fib6_flags and fib6_type fields of the FIB
result. However, fib6_rule_suppress() only examines the rt6 field, which
is only populated when the lookup is performed via one of the callers of
fib6_rule_lookup() such as ip6_route_output(). As a result,
fib6_lookup() ignores suppress_prefixlength.

This was not a problem for nftables until commit 1c32b24c234b
("netfilter: nft_fib_ipv6: switch to fib6_lookup") switched the FIB
expression from ip6_route_lookup() / nf_ip6_route() to fib6_lookup().
Since then, with a rule that suppresses the default route in the main
table before looking up a VPN table (as commonly configured for
WireGuard), the FIB expression returns the suppressed default route
instead of the VPN route. Strict reverse path filtering then drops
replies received over the VPN.

Fix by evaluating suppress_prefixlength against the prefix length of
the FIB entry when the lookup is performed via fib6_lookup().

fib_rules_lookup() only invokes the suppress callback when the rule
action returns 0. Unlike __fib6_rule_action(), fib6_rule_action_alt()
returns 0 for reject routes and instead sets RTF_REJECT in the result.
Do not suppress such routes so that they continue to terminate the
lookup, as with ip6_route_output() and IPv4. Check the flags in the
result rather than in the FIB entry so that blackhole nexthop objects
are also covered.

suppress_ifgroup is not handled since fib6_table_lookup() does not
perform multipath selection and the nexthop it returns might not be the
one that is eventually used.

Observed during WireGuard use and reproduced on unmodified v7.4-rc2,
without instrumentation or error injection. Verified with namespace
probes and nft_fib.sh on the rebuilt v7.4-rc2-based kernel.

Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
Link: https://github.com/firewalld/firewalld/issues/1600
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
v4:
- Drop the preceding cached-exception fix; dst-based suppression remains
  unchanged. The fib6_lookup() change itself is unchanged from v3.

Verified on the rebuilt v4 laptop kernel (7.4.0-rc2+ #6): all six added
checks pass in full normal and eight-second-delayed nft_fib.sh runs.
Both runs exit 0; twelve separate reject-route controls also pass.

V3 review:
https://lore.kernel.org/netdev/20261117091340.GA581197@shredder/T/#t

 net/ipv6/fib6_rules.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 0ffd7b47a046..7efb0515b5c8 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -286,6 +286,12 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
 	struct rt6_info *rt = res->rt6;
 	struct net_device *dev = NULL;
 
+	if (arg->lookup_ptr == fib6_table_lookup) {
+		/* fib6_table_lookup() returns 0 for reject routes. */
+		return !(res->fib6_flags & RTF_REJECT) &&
+		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
+	}
+
 	if (!rt)
 		return false;
 
-- 
2.55.0

