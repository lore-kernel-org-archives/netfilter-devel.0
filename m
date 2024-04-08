Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D63125D6
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712610951; cv=none; b=iHSHiqyzUps+XCec2vQslEg1JLqQt37OA2Ixeaa6XsRhDNulEcAfbQdPvIZAnpK8WAsORWISgfrM4KgBvjcnOxWwW1CRxiVTb146oCdnDzi0X6pr0JZjxTTGspmEllniscnly734svqJKAKV7hY1PwmlsLXF3Rmu3vMUbM8PCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712610951; c=relaxed/simple;
	bh=cfRQoRbIMV47Js9dVmJWA4e46HewRTWnqHTwWJPkuew=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=LgKAqWD0OiP5oELP7/BmsYkq4n4OsEakcX5DbBOrThHO3WMnPqC1EF2b/75pZfYhU5zrQFWY+swwDY22u/urmFc/votJq0FMraHJULaup6eNR7jjb4lkwEuCwNNIX/zgMixfKRPePNSjU/i6uIuOjuFVa0ohnZOOVpsoNcZ21uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 0/4] add missing requirements in tests/shell
Date: Mon,  8 Apr 2024 23:15:36 +0200
Message-Id: <20240408211540.311822-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Several patch to add missing requirements, this has been detected while running
tests on -stable 5.4.

Pablo Neira Ayuso (4):
  tests: shell: payload matching requires egress support
  tests: shell: chains/{netdev_netns_gone,netdev_chain_dev_gone} require inet/ingress support
  tests: shell: maps/{vmap_unary,named_limits} require pipapo set backend
  tests: shell: check for reset tcp options support

 tests/shell/features/reset_tcp_options.nft         | 5 +++++
 tests/shell/testcases/chains/netdev_chain_dev_gone | 2 ++
 tests/shell/testcases/chains/netdev_netns_gone     | 2 ++
 tests/shell/testcases/maps/named_limits            | 2 ++
 tests/shell/testcases/maps/vmap_unary              | 2 ++
 tests/shell/testcases/packetpath/payload           | 2 ++
 tests/shell/testcases/packetpath/set_lookups       | 2 ++
 tests/shell/testcases/packetpath/tcp_options       | 2 ++
 tests/shell/testcases/sets/typeof_sets_concat      | 2 ++
 9 files changed, 21 insertions(+)
 create mode 100644 tests/shell/features/reset_tcp_options.nft

-- 
2.30.2

