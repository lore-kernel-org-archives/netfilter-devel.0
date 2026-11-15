Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794743238;
	b=CmF2MyLaiDXNWMyr3n18/Kb+eUmCSoCs2tM+VaawxXuv6drpxjT3jS+gfYTIn9WuecTq
	 1SrfFSRxVEO9BkxGLo/oI3hz/EXEvmqkyjyBBC8bY0Dtkco2CuK+Zl4erhz2lntEKmWvE
	 Fe8TFRP+LuXNnIFMyacom/EU3HrvylSv4UruKi0cEfUvkDFmMzvab7W6DaOYTGkZPIutr
	 PAZkYkiHND/RmSGHbZ1iNJOSp1/6+T2MOpdQUTI759GpnSRc264tiG6xtTlfWpRa54vIh
	 zAlxpI8y8R2+hSR7SU3IS5GyobcdqlNeWaUA26Vba5OVcfO9Ws7KUlPK33KWn76P+FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794743238;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=GAr23D9nNi7WaHhPmdqYBMIdEmHnJfaXPVTLJAkqPSA=;
	b=Q4INP5+oIgFprUe0WxsHkesFyIINwxewlccPofRDN+rNr4SnZCC3wJop88rdxVTfLzxf
	 dPGPNIBZffl2cuIdlyWCA2QlMwq+CIn7NyR3AT1HVgfNusmCWgfQ0Gs0JTxg92w+vweVp
	 wgLT+a1vB5As1Z6GocbDg7+SdF5NNuPXNH7gEdFmj79rJlAocR8Jy95AH0eXHLgN72XEx
	 iqKcjvFtlvGncuip26FMaaFeKe0GUpQMA8uxP2sRPOeSrOPDYi3JyEFZ0qH1tnytH98wU
	 b4u8lXlEcQ7wbZilwHpdw3bMGP/Yj5qBmQ4/krIMDx3fD2tYA+REyT6kv4B+DFpMuVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=n8e082mi;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B79606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 11:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39B79606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=n8e082mi
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 9961860D50
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 12:47:16 +0100 (CET)
Received: (qmail 20124 invoked by uid 990); 15 Nov 2026 11:47:16 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Sun, 15 Nov 2026 12:47:16 +0100
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
Subject: [PATCH net v2 1/2] ipv6: honor prefix-length suppression in raw FIB lookups
Date: Sun, 15 Nov 2026 11:44:32 +0000
Message-ID: <20261115114434.10343-4-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261115114434.10343-2-leonard@lausen.nl>
References: <20261115114434.10343-2-leonard@lausen.nl>
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
X-Rspamd-Report: REPLY(-4) BAYES_HAM(-2.999999) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -5.599999
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=GnUi2hnE6trAibYh7rXsZTD1pr9yyipJAU4UexF4GbU=;
	b=n8e082miTxM4FvKJ5NF/KkjTncoELCe5Xg8PIyjGgh5f1330jUikC+oyHhcxe0FvgfVUwauVvI
	p18aFen7uaHiNCh8x1MNX/6QCD1MNV/idzOu19jrHLeV9b4ya17qwThuzo5yCY3IhRJFOeBb39wk
	6VvL01vSq2Ad4uXdVEHept/yJVNbdljFnHarQ1aPjgR2vJjuq+rax2zzx+w83hx4kZVYHnxmNLUc
	mhcX5RL7hDmJGnwhz23o4g8clDjsPaA0FmU9zaNoZtHs0Z2erIqClvzDmObNMrm9q9WuOfrCj8vP
	Mk3Rqz6Dph9qiCYJVEun8ocA3r4yCsN9FqirqFgoZd/DmXNC/jnVyIUkLkPkZ6nNXv9nRgWNptgJ
	fXt4WZg5cx71OTUkvpMYIN/l6N26ahuKICrBig51O9HiDGykFUdv7nEJnji89qLlZGooTJZrkkGF
	UnorecimBZmp3QB0df5LZ9YWXH3QZ/kIgKJl8sAJqikw5dXyJysN4+JgrUNmNcX/bzWOE+pR/i7F
	bwspCRnfmp3Ipr4n/qtiX2xNV2A9OGPBxJRd9EldkSOw+racZUv5E2Jc7xaDxay/Vf56bsCCcgyl
	YPbALgJyM5riQli2KViSxEfL/OnuLhcpLaJqpqSWWOzO22Q21yhiEpY0pBaipvA7Jk1QeJw4txm1
	o=

IPv6 raw FIB lookups populate f6i and nh in fib6_result, but not rt6.
fib6_rule_suppress() only examines rt6, so fib6_lookup() ignores
suppress_prefixlength.

With a policy rule that suppresses the main-table default before looking
in a VPN table, an ordinary route lookup selects the VPN while an nftables
FIB lookup returns the suppressed default. Strict reverse-path filtering
can then drop replies arriving over the VPN.

For raw lookups, evaluate suppress_prefixlength against the FIB entry's
destination prefix length. Preserve results marked RTF_REJECT: raw lookups
can return zero with a rejection encoded in the result, while dst-based
lookups return an error and skip suppression. Check the result flags so
blackhole nexthop objects are covered as well.

Keep the dst-based path unchanged. Raw suppress_ifgroup handling also
remains unchanged because the table lookup's nexthop need not be the
final multipath selection.

Fixes: 138118ec96cb ("net/ipv6: Add fib6_lookup")
Link: https://github.com/firewalld/firewalld/issues/1600
Assisted-by: LLM
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
Investigated with AI assistance after VPN failures. Reproduced on
unmodified v7.4-rc2 and verified with nft_fib.sh on the rebuilt kernel.

 net/ipv6/fib6_rules.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 0ffd7b47a046..ceb4180bcf2f 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -283,9 +283,16 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
 						struct fib_lookup_arg *arg)
 {
 	struct fib6_result *res = arg->result;
-	struct rt6_info *rt = res->rt6;
+	struct rt6_info *rt;
 	struct net_device *dev = NULL;
 
+	if (arg->lookup_ptr == fib6_table_lookup) {
+		/* Raw lookups report reject routes without an error. */
+		return !(res->fib6_flags & RTF_REJECT) &&
+		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
+	}
+
+	rt = res->rt6;
 	if (!rt)
 		return false;
 
-- 
2.55.0

