Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA512F6918;
	Wed, 14 Oct 2026 01:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791941858; cv=none; b=kDF0ZdNpSGB6BIlHClXaBJe7GhRbYvQufSe9kFB2CFPL6dUI/xxwetJN7sOeIihxH0wD4VF92AB1VwlynKv026JwygF1aD/Rh5w/w2YKhWU+5mlyd+GLQuKOGEGvsH8R8dz6wgU085tl9HvCe42qaKZtmij5GM9bstxm7D6yz1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791941858; c=relaxed/simple;
	bh=Z9CtFutt3i5y9QcAljwbrTddCnkQNqW5WvaWJhg8yD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN4N1dACiaSGrWCZq8UoYkM3228c3ZsKFNS+GMO+xogAcD3f3IznINHCs96Daei+tssI7mYj8pXC+7FhSJBXgcgmq16v3t79Iz+torFULfgSDB/+bYM338VpkslcRYziHRF8nYuABXnLzEIBhGBbZ77d18021AMFEG34ogeszD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=KApWyCvu; arc=none smtp.client-ip=111.22.67.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="KApWyCvu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=KApWyCvutzsByHycrs9Lso5nUm+ttLKjiYtiwSf82Z0gDgwjsGUmclbbADzZYu282mPvt4gA3bOtX
	 zr4hyRvG8ESvnhwHQmL9PqFkKKN3PZjsRPwx+fEhZw40PsZwAs3+bfii2LtgNraJ7zZrjwyADzdDHf
	 EFkCA7+dCS2ixXuA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56acedcd0163-e42f5;
	Wed, 14 Oct 2026 09:37:20 +0800 (CST)
X-RM-TRANSID:2ee56acedcd0163-e42f5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.99])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86acedcce873-3aa20;
	Wed, 14 Oct 2026 09:37:20 +0800 (CST)
X-RM-TRANSID:2ee86acedcce873-3aa20
From: lvjunyu <lvjunyu@cmss.chinamobile.com>
To: netdev@vger.kernel.org,
	netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kuba@kernel.org,
	lvjunyu <lvjunyu@cmss.chinamobile.com>
Subject: Re: [PATCH v3] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets
Date: Tue, 13 Oct 2026 17:00:59 +0800
Message-ID: <20261013090059.2590-1-lvjunyu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008054228.752274-1-lvjunyu@cmss.chinamobile.com>
References: <20261008054228.752274-1-lvjunyu@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thank you for the review.

> [High] The fix covers only one caller, __udp_manip_pkt() in
> net/netfilter/nf_nat_proto.c.

The scope is intentional.  The LCO state this patch fixes is specific
to the UDP encapsulation path: udp_set_csum() writes a complete
(folded, complemented) checksum into uh->check while leaving
csum_start pointing at the inner transport header.  This split state
arises only for locally generated VXLAN/Geneve outer headers that
traverse the conntrack NAT OUTPUT path.

The flowtable software fast path (nf_flow_nat_ip_udp and friends) is
not reached by these packets.  VXLAN outer headers are locally
generated via vxlan_xmit() -> udp_set_csum() and enter the OUTPUT
chain.  The flowtable hook (nf_flow_offload_ip_hook) is registered
at NF_INET_FORWARD, which locally generated packets do not traverse.
Even after the conntrack entry is established, subsequent outer
packets still follow OUTPUT -> POSTROUTING -> __udp_manip_pkt(),
because flowtable offload applies to forwarded flows, not locally
generated ones.

For the sibling call sites:

- tcp_manip_pkt() and icmpv6_manip_pkt(): the offload target is the
  TCP/ICMPv6 header itself (csum_start + csum_offset == &hdr->check),
  so the LCO condition does not arise.  The seed path is correct for
  these protocols.

- Headers embedded in ICMP errors
  (nf_nat_icmp_reply_translation): byte copies in the ICMP payload,
  not live checksum-offloaded data; ip_summed is typically NONE or
  COMPLETE.

- tcf_nat_act() and IPVS: these paths handle LCO-state encapsulated
  UDP packets in theory, but the practical deployment scenario
  (locally generated VXLAN + MASQUERADE --random-fully) is specific
  to the conntrack NAT OUTPUT path.

A helper-level fix in inet_proto_csum_replace4/16/_by_diff() would
cover all ~45 call sites at once and is architecturally preferable.
However, modifying core checksum helpers that are shared by TCP, UDP,
ICMPv6, eBPF, OVS, GSO offload, and ILA requires a separate, more
thorough analysis and test cycle.  This patch is scoped to the UDP
path where the bug is observed and verified; the helper-level
approach is planned as a follow-up.

--
lvjunyu


