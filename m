Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789131714B7;
	Sun, 23 Mar 2025 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724572; cv=none; b=UrcWx9m7LIY2JovQwuiQNbMbwwmVoWkIOflB8Qjyh1NbH61Z5fPMmELdNa09+elV89Ll+u5vu9JGl9j8uBmirpMK3VWolz2J9lEHDv3AWcLSkAKH+cGn1pg/bzAENZgIG9vUwLx8XknEQsDYx8GLvpEV5fK/TI1yajxM5nA2ccg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724572; c=relaxed/simple;
	bh=90fuXTxuhpswf3Bjhs5KtWTyd0z/K4YE+TJnCruOGRA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G7r8m6WU+oH63tn/BeIBU4i8w5RCH4Q9eLSMo8IBplNPMuawN3YuB0yvXY2u0wGXltd3PiFx4EhliXHWLy+2FYIKBJ2Uvx/5VCUgcw5ibf3vkBuJ5olFMOlJDhQvjWHA+K2z0Yhbe9vmjZOG7cD1r620diYlGnQ7dd42cNljXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mGhj8JN9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mzV/zQ4S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mGhj8JN9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mzV/zQ4S"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A87916038F; Sun, 23 Mar 2025 11:09:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724568;
	bh=HwL/Zn4kwtC/FuFWmdEhUetBiarqhNlKkWkoacrCREQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mGhj8JN95Gn//LS/JZSHCWi9I+uux+opPz/5ZlzzSCW55b7vV/XV0yy3miEvl0Cfc
	 gt5iY7L2pMexsJm7dFy6uSpVrLJEhrfRI+e0WMJdev0b5oKxTBZx4C8ttPs7zNZLRg
	 05Orv8ndxZJglhO9sLiP4GqakJ+g3eWWNAHHVO8y0jMpHVOvqCiQRxQu3X14I7AcMH
	 mrx52rNUZZNQbMx2Vx0/sSZ8CWAIQAYGYSqr5Yf/txDp4yxzVeWWVIWQpk90fNN2Li
	 mIxwN3URDQFp8un1NwH+l7GareIEsEUAXsyZihn/GTwaKBPI8TLAJ+dKQ6t79MjYJG
	 qyj2xeMtjYgYA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 12DD86037B;
	Sun, 23 Mar 2025 11:09:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724566;
	bh=HwL/Zn4kwtC/FuFWmdEhUetBiarqhNlKkWkoacrCREQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mzV/zQ4S+wtUBM2rz+hBsdN80EOA5SNx4Tfdcxwb6QuxlrGOJsJKEgYil75EFOVyu
	 gVnppjKEsz+Tn4f1TzRN38wCfpon1SFETbqLF+HJrzn77cIznALHyAvKqfD76+hQoi
	 rc3kT4sN99dNfLVgM1SEW1jyFh0UfxVNVy3pbf0QxSB31+e3Gqf/DRpXs2JefdcDHu
	 InHJGMk62iQbxEcNqEUKiA39agL75gc7KOMDHCOLDqby1HDqTziRxNchMmU5DeqpGD
	 pCwcH1dzaMvX6E2gtoLIfD8VTec1aTB48dRmE7XQPwxvR6IzioIz/E7gxXlSLrVJ2G
	 gft4o7aGi6v+g==
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
Date: Sun, 23 Mar 2025 11:09:15 +0100
Message-Id: <20250323100922.59983-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

1) Use kvmalloc in xt_hashlimit, from Denis Kirjanov.

2) Tighten nf_conntrack sysctl accepted values for nf_conntrack_max
   and nf_ct_expect_max, from Nicolas Bouchinet.

3) Avoid lookup in nft_fib if socket is available, from Florian Westphal.

4) Initialize struct lsm_context in nfnetlink_queue to avoid
   hypothetical ENOMEM errors, Chenyuan Yang.

5) Use strscpy() instead of _pad when initializing xtables table name,
   kzalloc is already used to initialized the table memory area.
   From Thorsten Blum.

6) Missing socket lookup by conntrack information for IPv6 traffic
   in nft_socket, there is a similar chunk in IPv4, this was never
   added when IPv6 NAT was introduced. From Maxim Mikityanskiy.

7) Fix clang issues with nf_tables CONFIG_MITIGATION_RETPOLINE,
   from WangYuli.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-03-23

Thanks.

----------------------------------------------------------------

The following changes since commit 71ca3561c268a07888ba9ce089ab8c3f54710cd4:

  Merge branch 'mptcp-pm-code-reorganisation' (2025-03-10 13:36:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-03-23

for you to fetch changes up to e3a4182edd1ae60e7e3539ff3b3784af9830d223:

  netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE (2025-03-23 10:53:47 +0100)

----------------------------------------------------------------
netfilter pull request 25-03-23

----------------------------------------------------------------
Chenyuan Yang (1):
      netfilter: nfnetlink_queue: Initialize ctx to avoid memory allocation error

Denis Kirjanov (1):
      netfilter: xt_hashlimit: replace vmalloc calls with kvmalloc

Florian Westphal (1):
      netfilter: fib: avoid lookup if socket is available

Maxim Mikityanskiy (1):
      netfilter: socket: Lookup orig tuple for IPv6 SNAT

Nicolas Bouchinet (1):
      netfilter: conntrack: Bound nf_conntrack sysctl writes

Thorsten Blum (1):
      netfilter: xtables: Use strscpy() instead of strscpy_pad()

WangYuli (1):
      netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE

 include/net/netfilter/nft_fib.h         | 21 +++++++++++++++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c       | 11 +++++------
 net/ipv6/netfilter/nf_socket_ipv6.c     | 23 +++++++++++++++++++++++
 net/ipv6/netfilter/nft_fib_ipv6.c       | 19 ++++++++++---------
 net/netfilter/nf_conntrack_standalone.c | 12 +++++++++---
 net/netfilter/nf_tables_core.c          | 11 ++++-------
 net/netfilter/nfnetlink_queue.c         |  2 +-
 net/netfilter/xt_hashlimit.c            | 12 +++++-------
 net/netfilter/xt_repldata.h             |  2 +-
 9 files changed, 79 insertions(+), 34 deletions(-)
