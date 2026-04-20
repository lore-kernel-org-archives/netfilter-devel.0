Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4B82147F9;
	Mon, 20 Apr 2026 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722543; cv=none; b=QNENfDiY4Q6ub9EnIlklN4VOH5JdgoL0/PpAGrAmE8RTFwojwLb79fv600Mt/nzxb1ABg3gt+2oU7jfvbJMnEI9Kp+M6/vVwiL3Wjna/HM4Wk8B4Kz7NxyOwACEV6vcdXObnHRVw3Aig/EDmvjX8J9IzO6Q9ZHAF++8bbuv8cy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722543; c=relaxed/simple;
	bh=62x1WzfEb0ccT7e3EvMGCt9289fKT2axCIwUEPqFv/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l3KsJTLbYALHFjfMmCMozoockRy/xrP0m4aevbv0EZ4g2yx05jnpv9FfrPhgnSi5AgTZzUVUKwLhcgtqf4T9e879oX+gKYkkST13NfCyjDAcLiJUPyJ9Og3IXX2fRWSkNTdYo4AWJI5OuS9dqj8Ebl27dyvdOcpjwaOslNtFBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gDKqIOsD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gDKqIOsD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CAB5C6017E;
	Tue, 21 Apr 2026 00:02:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776722539;
	bh=EVrBbQ74Psqq42IjC9L/dsxq9oV3R/lVXUOfHOqhevo=;
	h=From:To:Cc:Subject:Date:From;
	b=gDKqIOsDaJGVIKHJQWd+DY9oem6cJhkpgU0xUkaLtPnODgixBV8GMQzmSx9isldhX
	 8kSF+MOsfjlr6OoI0MHQCifp0MTz0Gtfg23Q7k6SjUdUQYZR87iAigdgjY4htSUe/p
	 NO7nNh/QvK41KkIINggq7gY7pNzPtK0PdUzuJ32p8XxW+0ZzUJFgZp6Cju55ebaCmR
	 EqI2JHY3z9aAxz2ls0BeIhzFcquQxGf5eXTgcYtCzhurnrEFfGeNYyDLsct7JpYE5W
	 4Z+4ysS8RDO2NEouwazpA25uE9dbfVSpDO2W8pjn1HgXXt0ECgXSui4LcsJyzCLAuv
	 E7byAgy1Ba/LQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/8] Netfilter/IPVS fixes for net
Date: Tue, 21 Apr 2026 00:02:07 +0200
Message-ID: <20260420220215.111510-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter/IPVS fixes for net:

1) nft_osf actually only supports IPv4, restrict it.

2) Address possible division by zero in nfnetlink_osf, from Xiang Mei.

3) Remove unsafe use of sprintf to fix possible buffer overflow
   in the SIP NAT helper, from Florian Westphal.

4) Restrict xt_mac, xt_owner and xt_physdev to inet families only;
   xt_realm is only for ipv4, otherwise null-pointer-deref is possible.

5) Use kfree_rcu() in nat core to release hooks, this can be an issue
   once nfnetlink_hook gets support to dump NAT hook information, not
   currently a real issue but better fix it now. From Florian Westphal.

6) Fix MTU checks in IPVS, from Yingnan Zhang.

7) Fix possible out-of-bounds when matching TCP options in
   nfnetlink_osf, from Fernando Fernandez Mancera.

8) Fix potential nul-ptr-deref in ttl check in nfnetlink_osf,
   remove useless loop to fix this, also from Fernando.

This is a smaller batch, there are more patches pending in the queue
to arm another pull request as soon as this is considered good enough.

AI might complain again about one more issue regarding osf and
big-endian arches in osf but this batch is targetting crash fixes for
osf at this stage.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-20

Thanks.

----------------------------------------------------------------

The following changes since commit a663bac71a2f0b3ac6c373168ca57b2a6e6381aa:

  net: mctp: fix don't require received header reserved bits to be zero (2026-04-20 11:46:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-20

for you to fetch changes up to 711987ba281fd806322a7cd244e98e2a81903114:

  netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check (2026-04-20 23:45:44 +0200)

----------------------------------------------------------------
netfilter pull request 26-04-20

----------------------------------------------------------------
Fernando Fernandez Mancera (2):
      netfilter: nfnetlink_osf: fix out-of-bounds read on option matching
      netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check

Florian Westphal (1):
      netfilter: conntrack: remove sprintf usage

Pablo Neira Ayuso (3):
      netfilter: nft_osf: restrict it to ipv4
      netfilter: xtables: restrict several matches to inet family
      netfilter: nat: use kfree_rcu to release ops

Xiang Mei (1):
      netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO

Yingnan Zhang (1):
      ipvs: fix MTU check for GSO packets in tunnel mode

 net/ipv4/netfilter/iptable_nat.c  |  4 ++--
 net/ipv6/netfilter/ip6table_nat.c |  4 ++--
 net/netfilter/ipvs/ip_vs_xmit.c   | 19 +++++++++++++----
 net/netfilter/nf_nat_amanda.c     |  2 +-
 net/netfilter/nf_nat_core.c       | 10 +++++----
 net/netfilter/nf_nat_sip.c        | 33 +++++++++++++++-------------
 net/netfilter/nfnetlink_osf.c     | 45 +++++++++++++++++----------------------
 net/netfilter/nft_osf.c           |  6 +++++-
 net/netfilter/xt_mac.c            | 34 +++++++++++++++++++----------
 net/netfilter/xt_owner.c          | 37 +++++++++++++++++++++-----------
 net/netfilter/xt_physdev.c        | 29 ++++++++++++++++---------
 net/netfilter/xt_realm.c          |  2 +-
 12 files changed, 136 insertions(+), 89 deletions(-)
