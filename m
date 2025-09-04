Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E22B29ACC2;
	Thu,  4 Sep 2025 07:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756970757; cv=none; b=jgKhaveAp83xlm0cJjmz+L7SAyH9dOTWqmoz+3uhpcyc7g1nzwmyrYQoYDVWzmA0jqIyuW5zIJLeig08QZ24qSY3ef7OVXHuaJwR4bo2+aJ8LhL0NA/jqQwLHmS5RgNmB2er+5N7a74lfh0oZLzKKyDzI0An7eUTwN03pZS6Z2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756970757; c=relaxed/simple;
	bh=EwQL87VnW1LZeq5ITni3DxjfuNdl/IoRmrvCynO3dqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IqupBsaw4SfMOnkewlAMsO1HoKGg/4hzMydKvuyV2d7Z4LO1yjKD0wiKZbIR9sJk+iHy4G3hXp2/THKwevZlis/T4uO1n5DYKRkmOqR9kSmPEVjc7HCjPiLUdTkZowG7LsAVd3SrrQXnlJp3EAg5MXuGtS46xP82bYeRTXDXn5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 167846062E; Thu,  4 Sep 2025 09:25:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net 0/2] netfilter: updates for net
Date: Thu,  4 Sep 2025 09:25:46 +0200
Message-ID: <20250904072548.3267-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: in patch 1, prefer volatile to stdatomic.h. No other changes.

The following patchset contains Netfilter fixes for *net*:

1) Fix a silly bug in conntrack selftest, busyloop may get optimized to
   for (;;), reported by Yi Chen.

2) Introduce new NFTA_DEVICE_PREFIX attribute in nftables netlink api,
   re-using old NFTA_DEVICE_NAME led to confusion with different
   kernel/userspace versions.  This refines the wildcard interface
   support added in 6.16 release.  From Phil Sutter.

Please, pull these changes from:
The following changes since commit 8156210d36a43e76372312c87eb5ea3dbb405a85:

  ax25: properly unshare skbs in ax25_kiss_rcv() (2025-09-03 17:06:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-09-04

for you to fetch changes up to 4039ce7ef40474d5ba46f414c50cc7020b9cf8ae:

  netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX (2025-09-04 09:19:25 +0200)

----------------------------------------------------------------
netfilter pull request nf-25-09-04

----------------------------------------------------------------
Florian Westphal (1):
      selftests: netfilter: fix udpclash tool hang

Phil Sutter (1):
      netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX

 include/uapi/linux/netfilter/nf_tables.h           |  2 ++
 net/netfilter/nf_tables_api.c                      | 42 ++++++++++++++++------
 .../selftests/net/netfilter/conntrack_clash.sh     |  2 +-
 .../selftests/net/netfilter/conntrack_resize.sh    |  5 +--
 tools/testing/selftests/net/netfilter/udpclash.c   |  2 +-
 5 files changed, 38 insertions(+), 15 deletions(-)
