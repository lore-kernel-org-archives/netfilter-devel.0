Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510748;
	b=2VP49SRagZK1WXBfwTQZiYbZVSCnkcPFeusDJAQiiR4ORlfx8CwFHI9kLv3Y9OuegYft
	 MljWB5wvWvcfv2CZOhDUpRBYa53BALbizMFtifVlreL26emjHDssa3xceIhZy5jXrbsly
	 nxiBtIcBjoLCJFKEm4u51kASLK4Xv7qCMgees3uAu5pjE6cNpKf3BhpFOn/Nmpqp3Sc1V
	 B47o6AS5AN4mZtNjnS2ZAiMtDKlXE2pWyjIG3t7QH2gi1/Gh0CzWCA5HcRS8gqc8wwAq+
	 pXQbZhSg7CXQEujWVD1gVSv8LY/QGBwMWLdub1cbxbJOLAFx54eNH5BbouaV9yIjGuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510748;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=vL0uva0kDdgFyyEqNs7Zsoau2xkqgInZrttfe2t0o1A=;
	b=uHpgONGFNoFEwLYVo/Hndo7Oy9H6bYf6b+ku2t3NlRPQqmF9eOLQXnJntUa3rA3Owj4/
	 s6j/g7ru5bvyBOZIJTjGuNueRU2VZMvA3NAmySP/qxKCUFlgkpRdJMXZ200LpbkJJ+mkE
	 Zr2oe1Ly1A0erDeItRmz/UGMrVT+7+QsC/fWqB/zOsKIexslmKK1bSe3z7x5kXiBzpzID
	 YXomSBIQgy5BxSErXnm84fDmwCoyzMkkUHfpkV+NCxhyapQEMCKtJpMx4wXlAZANtmq0Q
	 Ir9Dt0OcjBnzC7ZeUNAQrCjUQ4KNcXAo/DEsGq7Ms8laFWIvMPf80F+ckIEvH19zE4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86FD606A32A;
	Tue, 20 Oct 2026 15:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59821F000CD;
	Tue, 20 Oct 2026 15:39:07 +0000 (UTC)
Subject: Re: [PATCH net 10/10] netfilter: nf_conntrack_netlink: fix inverted
 IPv6 tuple filter
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:38:37 +0000
Message-ID: <179251071742.3135.9247422492065061476@kernel.org>
In-Reply-To: <20261019150249.1879516-11-pablo@netfilter.org>
References: <20261019150249.1879516-11-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The first sentence of the commit message describes the pre-patch
  behaviour backwards.

--

netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter

This commit drops the negation in front of ipv6_addr_cmp() in the IPv6
branch of ctnetlink_filter_match_tuple(). With that change, the
CTA_IP_SRC and CTA_IP_DST filters return 0 only when the addresses
differ, which matches the IPv4 path.

> ctnetlink_filter_match_tuple() returns 0 (no match) when the IPv6
> source or destination address differs from the filter, because the
> !ipv6_addr_cmp() test is inverted.

[Severity: Low]
Does this first sentence describe the pre-patch behaviour backwards?

ipv6_addr_cmp() is a memcmp() wrapper and returns 0 for equal addresses:

include/net/ipv6.h:ipv6_addr_cmp() {
	return memcmp(a1, a2, sizeof(struct in6_addr));
}

Before the patch, ctnetlink_filter_match_tuple() had:

	if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
	    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
			   &ct_tuple->src.u3.in6))
		return 0;

That code returned 0 when the addresses were equal. When they differed,
it fell through and the entry counted as a match. The quoted sentence
describes the behaviour after the fix, not the bug.

The next sentence ("the negation makes the branch trigger on a match
instead of a mismatch") does describe the bug correctly, so the
paragraph contradicts itself.

Could the first sentence be reworded to say that the function returned
0 when the IPv6 address matched the filter?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
