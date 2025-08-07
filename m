Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFFA27876E;
	Thu,  7 Aug 2025 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566205; cv=none; b=a1IOw1RP92zsGQFPCFQjlWwQHb7bjYan5YwB1j4WJosDeXVLnqI/+T7ajkNvpR8SIwgiFJaGg/uI65IhlYgdHUMEBbMFATmhrl0Tm/5pl+vGBEYsIWgLqtYMr9mXu3KAIAYAaYEdfZMMcWVKYq8YezR26VMz463dWsWhmL+khn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566205; c=relaxed/simple;
	bh=qFmLI1J0kGNOCGzVj56Pnm+N8xInvd97RkgeH7diB8o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hAAGnrmqXhctXFYgSwdSn/pATOOf1N0hnJQ5ixvU2y3yZYDTSiJsGRHWfyhGu/DQcTf31gJk6iHzQPdD3vT0hySU4F2ep1RyqN+Of+leuXC4aVjj0P61TFN14DEicxCo14aY0cw6cIHPvD9MuNUMnUv8h1TQUiJGGJDpex6XPbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=chE/wCp9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iHZgL8d9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="chE/wCp9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iHZgL8d9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 753BB60A3D; Thu,  7 Aug 2025 13:29:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566195;
	bh=gTc5kOzGjljs+wVP/Ll+gPx0NFqpkq/G/0V6KS8kic4=;
	h=From:To:Cc:Subject:Date:From;
	b=chE/wCp9FhgLjTtzjecX8SW1tqjy/F5oolb+FHZPf2SyN6d9RNMGXVKmroOKKlZYq
	 vdifWbRwSqGFJCg8+zBRKpTf8/h8h/y6Fwi+d3OhtRG/JtPaGmzdx7ff3+k0hW55DR
	 mB5N1L4BDykb6AC2vaLt8pU/c5I58o2MWGrvmZ9OAIVI6IDlsDGiZRv2Fu8IxKmGFF
	 oPKlEOkU47b1U1jBxHe0DmsHrWo8+jzPxR2vdLmbwRTn1Up0XkpGjm5rjkbmhgtgnb
	 PuMfFHM0G44cWRgjFH1TNEhlAuB0UMZfZdmRy5I4ZNftiXg40wlbwSMR3Y30W4kbgh
	 +mfKT7R3AOSrQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EFF8060A3D;
	Thu,  7 Aug 2025 13:29:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566193;
	bh=gTc5kOzGjljs+wVP/Ll+gPx0NFqpkq/G/0V6KS8kic4=;
	h=From:To:Cc:Subject:Date:From;
	b=iHZgL8d9hvwPjanlbbQ02WENZ3flAu/ke5XUrRuvLB5OLUalSv0QxL2ExFcEqzxke
	 8yyqdFzkYE53Yg5ar4OpLYdCralxIYDqUdErUIhyit8hHhG2vcQiWP1vj1g9yvP48A
	 TolaSZZMy0TSqgEZ96BLkk0h5rUScXiypfcJGcYHgGGUcqa1wCbaw9eh7PYI2UGBkl
	 XwmVRSl8JJTdwWxAoh0kBA4qG/ke/R25TnHfnKT9FJ6TVzlt5EVDoB8m+27k2hSV2o
	 fr7ThaNo528Vd9HW8q+JrERf8VtmhDq9VmpO/Iq9ZnlLrSC82QBvUnutaXz1gjtydi
	 N0SyRfN5rl96g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/7] Netfilter fixes for net
Date: Thu,  7 Aug 2025 13:29:41 +0200
Message-Id: <20250807112948.1400523-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Reinstantiate Florian Westphal as a Netfilter maintainer.

2) Depend on both NETFILTER_XTABLES and NETFILTER_XTABLES_LEGACY,
   from Arnd Bergmann.

3) Use id to annotate last conntrack/expectation visited to resume
   netlink dump, patches from Florian Westphal.

4) Fix bogus element in nft_pipapo avx2 lookup, introduced in
   the last nf-next batch of updates, also from Florian.

5) Return 0 instead of recycling ret variable in
   nf_conntrack_log_invalid_sysctl(), introduced in the last
   nf-next batch of updates, from Dan Carpenter.

6) Fix WARN_ON_ONCE triggered by syzbot with larger cgroup level
   in nft_socket.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-08-07

Thanks.

----------------------------------------------------------------

The following changes since commit d942fe13f72bec92f6c689fbd74c5ec38228c16a:

  net: ti: icssg-prueth: Fix skb handling for XDP_PASS (2025-08-05 18:03:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-08-07

for you to fetch changes up to 1dee968d22eaeb3eede70df513ab3f8dd1712e3e:

  netfilter: nft_socket: remove WARN_ON_ONCE with huge level value (2025-08-07 13:19:26 +0200)

----------------------------------------------------------------
netfilter pull request 25-08-07

----------------------------------------------------------------
Arnd Bergmann (1):
      netfilter: add back NETFILTER_XTABLES dependencies

Dan Carpenter (1):
      netfilter: conntrack: clean up returns in nf_conntrack_log_invalid_sysctl()

Florian Westphal (4):
      MAINTAINERS: resurrect my netfilter maintainer entry
      netfilter: ctnetlink: fix refcount leak on table dump
      netfilter: ctnetlink: remove refcounting in expectation dumpers
      netfilter: nft_set_pipapo: don't return bogus extension pointer

Pablo Neira Ayuso (1):
      netfilter: nft_socket: remove WARN_ON_ONCE with huge level value

 MAINTAINERS                             |  1 +
 net/bridge/netfilter/Kconfig            |  1 +
 net/ipv4/netfilter/Kconfig              |  3 ++
 net/ipv6/netfilter/Kconfig              |  1 +
 net/netfilter/nf_conntrack_netlink.c    | 65 +++++++++++++++------------------
 net/netfilter/nf_conntrack_standalone.c |  6 +--
 net/netfilter/nft_set_pipapo_avx2.c     | 12 +++---
 net/netfilter/nft_socket.c              |  2 +-
 8 files changed, 46 insertions(+), 45 deletions(-)
