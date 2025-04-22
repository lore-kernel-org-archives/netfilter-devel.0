Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425562C108E;
	Tue, 22 Apr 2025 20:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353437; cv=none; b=o+Xb8z3NllAMgUMGKft7zXrNiWEkg9Z/IAFB7JgvHmYEYEQzob24USEY+mJLXsxEjJa2tYxZzE2R8HrsGD6qDtiQH7soiVfqB2hV5F9eajaDGgZ2mkdBA6dga/DFDovGl9Sm5lIE6TacRYs9VpfG18Y4lvneg6W2gDvwYNRUoJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353437; c=relaxed/simple;
	bh=cfqlclV7rlb58wBm3clmCBE6P26650KIuUuZUS1/9IY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QYqnYAtqRFtEsaKqg/P9JsDBoa3xsSpNW/pqOlguYGEr8wrYe+LatH9ro3fsrHtfLxynsjqNKjPiIKijN/HITPv4NnUncDUBmJDj11tZAj8dDpxIhnTZGrRAHmKUN+cejVWRcF6OmZ9Dvj2NMBF5ZIvzkv9k5EPzjLuyxN/cb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cvh5DzyY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WLWG5ISL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cvh5DzyY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WLWG5ISL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 98B24609B3; Tue, 22 Apr 2025 22:23:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353432;
	bh=RMDD+4XAInnUNqQ2tUcnfN0YgiUr0xjTvaHXu9jLJcw=;
	h=From:To:Cc:Subject:Date:From;
	b=Cvh5DzyY8Q2D+WB/V7GxU03s2YCcafm/gxuyslCg/nn34f0VZK1KADIa8n5Fqskdw
	 OSuML2+QnZIv2UhxcLyMHW4ZEvNqHpSC6UMJ6JLYk5X6u2bAzwzKFEGqdX75XCvA9o
	 UUmubbPeKFpRxX4O8S1V/udn+AA+B3P7dIzdpnvsoaiuoqdjewjN3a7vKEtOx4IXRl
	 bICW9pEi/CcoVuFuVkgSHQuYWhzF9scV4v5pYDiHCuT1QIaBJVWO/u7yrOy8tD4Aun
	 5Jcj4f0D1na+qW+1+7oQJY+piWGTTkUMVuUniwW5eCFjAZYviJ6XaCG8oIYMGFs+GF
	 sZAusTbxptKYw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1048B609AF;
	Tue, 22 Apr 2025 22:23:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353427;
	bh=RMDD+4XAInnUNqQ2tUcnfN0YgiUr0xjTvaHXu9jLJcw=;
	h=From:To:Cc:Subject:Date:From;
	b=WLWG5ISLtVJPQdVYIc4wwG0q4hGxt/DMe090EdgGk3rGUp0LkfV7u4EO3QhIOGrBH
	 CW54q2GYjN6e3hledMjb87a5FhP4PoviTk7U8W8AbkfRY0pd5/8Vo2LPgmbaSdR1bv
	 rO22+G6wNGats/UIc4TlRtjJBu6z2cPw7ozd+KovFjKZDkwgySWV2fSvgBRQQ7S8UX
	 lJs1Rb5bzLKCoDdiuXZL7hAZlPve+SRWw0v+G+qMPnQ3LEd/L1BmKCWUbnJfHb0cVE
	 oh/h1GnSxK8uA6Nf962IuzdDP7tIQlBOiyGMl01goqahORDtWFEYP1j3G+/5fKVXr2
	 moDO883ulxi9g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 0/7] Netfilter updates for net-next
Date: Tue, 22 Apr 2025 22:23:20 +0200
Message-Id: <20250422202327.271536-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

1) Replace msecs_to_jiffies() by secs_to_jiffies(), from Easwar Hariharan.

2) Allow to compile xt_cgroup with cgroupsv2 support only, from Michal Koutny.

3) Prepare for sock_cgroup_classid() removal by wrapping it around
   ifdef, also from Michal Koutny.

4) Disable xtables legacy with PREEMPT_RT, from Sebastian Andrzej Siewior
   and Florian Westphal.

5) Remove redundant pointer fetch on conntrack template, from Xuanqiang Luo.

6) Re-format one block in the tproxy documentation for consistency,
   from Chen Linxuan.

7) Expose set element count and type via netlink attributes,
   from Florian Westphal.

This is an initial batch with updates, more updates coming soon.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-04-22

Thanks.

----------------------------------------------------------------

The following changes since commit 45bd443bfd8697a7da308c16c3e75e2bb353b3d1:

  net: 802: Remove unused p8022 code (2025-04-22 07:04:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-04-22

for you to fetch changes up to 2cbe307c60463dc47bf590bc93709398c4c4b3bb:

  netfilter: nf_tables: export set count and backend name to userspace (2025-04-22 22:17:07 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-22

----------------------------------------------------------------
Chen Linxuan (1):
      docs: tproxy: fix formatting for nft code block

Easwar Hariharan (1):
      netfilter: xt_IDLETIMER: convert timeouts to secs_to_jiffies()

Florian Westphal (1):
      netfilter: nf_tables: export set count and backend name to userspace

Michal Koutný (2):
      netfilter: xt_cgroup: Make it independent from net_cls
      net: cgroup: Guard users of sock_cgroup_classid()

Pablo Neira Ayuso (1):
      netfilter: Exclude LEGACY TABLES on PREEMPT_RT.

Xuanqiang Luo (1):
      netfilter: conntrack: Remove redundant NFCT_ALIGN call

 Documentation/networking/tproxy.rst      |  4 ++--
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/Kconfig                              | 10 ++++++++++
 net/bridge/netfilter/Kconfig             |  8 ++++----
 net/ipv4/inet_diag.c                     |  2 +-
 net/ipv4/netfilter/Kconfig               | 15 ++++++++-------
 net/ipv6/netfilter/Kconfig               | 13 +++++++------
 net/netfilter/Kconfig                    |  2 +-
 net/netfilter/nf_conntrack_core.c        |  4 +---
 net/netfilter/nf_tables_api.c            | 26 ++++++++++++++++++++++++++
 net/netfilter/x_tables.c                 | 16 +++++++++++-----
 net/netfilter/xt_IDLETIMER.c             | 12 ++++++------
 net/netfilter/xt_TCPOPTSTRIP.c           |  4 ++--
 net/netfilter/xt_cgroup.c                | 26 ++++++++++++++++++++++++++
 net/netfilter/xt_mark.c                  |  2 +-
 15 files changed, 110 insertions(+), 38 deletions(-)
