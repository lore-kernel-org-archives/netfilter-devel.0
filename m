Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9AE4E50C9;
	Fri, 18 Sep 2026 11:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730939; cv=none; b=J/nplwE9dgSv554oeZYBioBONx3t2BhG7oJX0MpuBgoIDYRQkt1z1pa8yf1t1xUmBohmFh2C6wuI8pat+R736OAtRM+blzZIiZRCjyDb9PuXg2jKwK96laIfHc+57HjFdOQhlDYYB2of+2lyoq8tOUT6qU/RgoCw/rpKtiN6GjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730939; c=relaxed/simple;
	bh=/RQHfKgCaU147VxaqvEupAC0iifZR3I20zA7MLbwWlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llYlagzaQliUoCI8LHtMNIQEO1epZdqApwEH83JokHqdzvOBPdBERKPgAgkRS66qEt4bIeu2IbQ0gTLug3IpMe/JxY46GvAzfV7nEXrGx+PuFqqgAbGTyh2avn508UeGvqVj2iEjFXQaM+LEwZuJn8BoJWabw9sDVXnOyYIcNGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LGUvzSnF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LGUvzSnF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730935;
	bh=2AhBNRafA8j6ojIqlQWNUURFuw21/+BbcwdGr0mr26w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGUvzSnF+edscWp7yi9HeNe6gauZVJEScMwBNgkMbzBFmZASqRYvKsA9/pt3j8xRt
	 /+eV4cuIg5OG2ErTixaXs4vIJr7jxiXjIrk9c6sKNmISDfVXIQNdouGJ/rYaejS4Y0
	 fClWQUIWczD7ppOyXanJbbxwQL06ZA6Daxp+ek/AZAS4FP0TF7nkenNUPMSJg3xY1b
	 Ic37mWs0NOvRmpKYXGM5dUZUrGjKunUJKYSoKa17Z7E9sytXZsYxDCzIjraY7iHJTf
	 OYhk2JWNMZ4PrpBRu4PEkHO7PvClIW2WfQ3OYC2rkw5FF07D4+1brg+XTud5JzJZkB
	 p9HCdMMXi7D2w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 81C2D60078;
	Fri, 18 Sep 2026 13:28:54 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 4/8] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Fri, 18 Sep 2026 13:28:40 +0200
Message-ID: <20260918112844.194503-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918112844.194503-1-pablo@netfilter.org>
References: <20260918112844.194503-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

rt_mt6_check() permits rules to be configured with rtinfo->addrnr == 0
even when address matching (IP6T_RT_FST_MASK) is requested.

In the IP6T_RT_FST_NSTRICT path, rt_mt6() evaluates packet routing
addresses against rtinfo->addrs[i] and terminates backwards at the bottom
of the loop:

    if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
        i++;
    }
    if (i == rtinfo->addrnr)
        break;

When addrnr is 0, if the first packet address matches rtinfo->addrs[0],
i is incremented to 1. Because i is now strictly greater than addrnr (0),
the loop termination condition (i == rtinfo->addrnr) is bypassed and will
never be satisfied.

If a crafted IPv6 packet contains matching routing addresses, i will
advance past IP6T_RT_HOPS (16). The subsequent call to ipv6_addr_equal()
reads beyond struct ip6t_rt, triggering UBSAN/KASAN out-of-bounds warnings
or kernel panics.

Fix this by:
1. Rejecting rules in rt_mt6_check() where IP6T_RT_FST_MASK is set but
   rtinfo->addrnr is zero.
2. In rt_mt6(), moving the termination condition (i < rtinfo->addrnr)
   into the for-loop header condition and removing the backwards break
   at the end of the loop body.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: LLM
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 8051425213dd..9880faf3cc7d 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -96,7 +96,8 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			unsigned int i = 0;
 
 			for (temp = 0;
-			     temp < (unsigned int)((hdrlen - 8) / 16);
+			     temp < (unsigned int)((hdrlen - 8) / 16) &&
+			     i < rtinfo->addrnr;
 			     temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -112,8 +113,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				if (i == rtinfo->addrnr)
-					break;
 			}
 			if (i == rtinfo->addrnr)
 				return ret;
@@ -162,6 +161,12 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 		pr_info_ratelimited("too many addresses specified\n");
 		return -EINVAL;
 	}
+
+	if ((rtinfo->flags & IP6T_RT_FST_MASK) && !rtinfo->addrnr) {
+		pr_info_ratelimited("address list match requested but addrnr is 0\n");
+		return -EINVAL;
+	}
+
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
-- 
2.47.3

