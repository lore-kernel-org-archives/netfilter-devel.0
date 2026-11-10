Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316692;
	b=RE5M3vRbUJRNYuq7jlyjDv38hrnSJnoXDOJ7RyAfMxoG2USLXz9+MfRKwOiB7NYb0NoG
	 bRrDeOZ2mUX+UveSH9hh+nx0/pe+fu2U4nNdUWgjKcvR40lAMiA6aEBEO8zRtDPsir2TK
	 jxfZ2wzoLthb7QKc32HpDlQK9P8918GTuufRWF2PblWSzJks+ZNZL9G6FSs5vgXMjtejV
	 q6UFHra3AY3teRaGYOi1RiBZ2Ie7SjXq7I29cLXLh147nQ3fitZP7nNzaKJ3KY2dLzyzs
	 yGmvnwwwQuYm6s57/mEnRZvDIalP2okK5l9MUhhPRPz6My1SglYw2yh8N7huq8re9Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316692;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:
	 DKIM-Signature;
	bh=tjga7yAmU2boqIOFeKpZOtE3XU+KEhdq7EjG922YHLw=;
	b=Ie+oPMdP6n5AmQ49+XDoUE1zhW4q/2G9RGGAew7D8XZqCM3bcWq8zJa1kGAblzFQLvYd
	 O9qvSFMJaHxGwiW8/ezSaiku1r87KtoGuOFQ2iJdPAE0fZDxWqQXd0Cs0mm4XnjkRQ64O
	 PtlV4N8kvfW0RbZEKfZM0VcNby9C+HKcQLAziOOSs99ZuhwqQpVbuJvg1UeEBIRDhHabM
	 X7EQ74ArYPVlcBd7C2G5x9kNpLQGo9zNn6pHnS5FlkEob7R3amVqqQ8MZZVZKYb0R5oi5
	 WNcksUBOI+/HgeinFSeNX6EzvR+343dlN1z66/SsxRNI6wxJDTFRC0/FwHYvPxzqA1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=N2x457HI;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B5606A7E6
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:18:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B1B5606A7E6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=N2x457HI
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 2303560D35
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:18:09 +0100 (CET)
Received: (qmail 19320 invoked by uid 990); 10 Nov 2026 13:18:08 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Tue, 10 Nov 2026 14:18:08 +0100
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
Subject: [PATCH net 1/2] ipv6: honor rule suppression in raw FIB lookups
Date: Tue, 10 Nov 2026 13:16:38 +0000
Message-ID: <20261110131638.15004-5-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261110131638.15004-3-leonard@lausen.nl>
References: <20261110131638.15004-3-leonard@lausen.nl>
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
	bh=yXTcJ+nJ9IPAJvuMp26XPWLLRuBFjw9BVW3bjoDsx58=;
	b=N2x457HIb74/FY0ZjgBIbThGAptuJF+/8x+hhhjmR0q/X3+hh6Pa7sJq/JzPnOactF7LRIqE0Z
	XhECSFGmYalSVxfT16MIE0I05WFtZnXgQKuuGUsUjue4bKNz5iGk7ox0Tl9UFpiHuSgti7FO0qr2
	tZxt0u9wb8osNB5qszwDaaDjxlwuf9oq6XnGdwwiI5HBg5mb6hxVOmp3Xb6bHamlEYVeX+qH9Rq7
	KN7fvsIDQsg34W0D7XVW0Z+Tj/7m598slFanvgkInm91YupDV2CynOkl8WMXdZArA9IAlBLRd4yu
	CwuLVkQ2uddCpL65sORS0WmFC25GdWrpspayepipR7BH91fJ5zQvhFHogK5X7BNW3g0jADka834T
	YhhlW3DfDBRPapTLCheosbNCqGA9akMRxYXhctvi+6TlRFLPso1fSCALeTX5CIum6AFcDqykch0W
	jLPATIToeEHeWicvgkzU52GUDIvUjPUuE5KLSdwqXq9SDoMYY+JKOW1HHwb+QSRv+f5l2NnO3naV
	nkHLbQjmi/EEwOq3VN6t1ME1sfoNGEh+un6DZMzQUs/21dTvcMdq4Apg4/Isee46IELUU59VwNd6
	5LWzS35eueW+auDSCDyuMhRykNAXDCZxag3EfR/TfhfELklKgXoXqaLLE5Tw5T80vthPB6JK59oE
	I=

IPv6 raw FIB lookups populate f6i and nh in fib6_result, but not rt6.
fib6_rule_suppress() only examines rt6, so fib6_lookup() ignores
suppress_prefixlength and suppress_ifgroup.

With a policy rule that suppresses the main-table default route before
looking in a VPN table, an ordinary route lookup selects the VPN while
an nftables FIB lookup returns the suppressed default. Strict reverse-path
filtering can then drop replies arriving over the VPN. Policy-aware BPF
FIB lookups use the same raw lookup path.

Select the suppression inputs according to the lookup callback. For raw
lookups, use the FIB entry's destination prefix length and the selected
nexthop's device. Keep the existing inputs and destination-reference
handling for dst-based lookups.

Preserve raw results marked RTF_REJECT. The rule engine only calls the
suppression callback when the rule action returns zero. Dst-based lookups
return an error for terminal reject routes and therefore skip suppression,
whereas raw lookups can return zero with a rejection encoded in the result.
Suppressing that result would allow a later rule to bypass the rejection.
Check the result flags so blackhole nexthop objects are covered too.

Investigated with AI assistance after VPN failures on a Samsung laptop.
The original bug was reproduced on unmodified v7.4-rc2 in QEMU without
kernel instrumentation. The final fib6_rules.c compiles without warnings
and its extracted suppression callback passes focused ASan/UBSan tests.
On the rebuilt v7.4-rc2-based laptop kernel, all ten added nft_fib.sh
checks pass. Separate probes also preserve all three terminal reject types
and blackhole nexthop results with and without either suppression option.

Fixes: 138118ec96cb ("net/ipv6: Add fib6_lookup")
Link: https://github.com/firewalld/firewalld/issues/1600
Assisted-by: LLM
Signed-off-by: Leonard Lausen <leonard@lausen.nl>
---
 net/ipv6/fib6_rules.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 0ffd7b47a046..e8a44b540291 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -283,19 +283,29 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
 						struct fib_lookup_arg *arg)
 {
 	struct fib6_result *res = arg->result;
-	struct rt6_info *rt = res->rt6;
+	struct rt6_info *rt = NULL;
 	struct net_device *dev = NULL;
-
-	if (!rt)
-		return false;
-
-	if (rt->rt6i_idev)
-		dev = rt->rt6i_idev->dev;
+	int plen;
+
+	if (arg->lookup_ptr == fib6_table_lookup) {
+		/* Raw lookups report reject routes without an error. */
+		if (res->fib6_flags & RTF_REJECT)
+			return false;
+		plen = res->f6i->fib6_dst.plen;
+		dev = res->nh->fib_nh_dev;
+	} else {
+		rt = res->rt6;
+		if (!rt)
+			return false;
+		plen = rt->rt6i_dst.plen;
+		if (rt->rt6i_idev)
+			dev = rt->rt6i_idev->dev;
+	}
 
 	/* do not accept result if the route does
 	 * not meet the required prefix length
 	 */
-	if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
+	if (plen <= rule->suppress_prefixlen)
 		goto suppress_route;
 
 	/* do not accept result if the route uses a device
@@ -307,8 +317,10 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
 	return false;
 
 suppress_route:
-	ip6_rt_put_flags(rt, flags);
-	res->rt6 = NULL;
+	if (rt) {
+		ip6_rt_put_flags(rt, flags);
+		res->rt6 = NULL;
+	}
 	return true;
 }
 
-- 
2.55.0

