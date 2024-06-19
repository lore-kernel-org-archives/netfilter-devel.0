Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0989C1848;
	Wed, 19 Jun 2024 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816752; cv=none; b=pWsaYFxaSPkas63dD8mjO5xzGxbFQVkv3o4llMVP3yoB3OqTtouuuevQTiEAMy7OypOclaVImWGbTNOb7AsICGkNICBJF3nRLA0ZA6t4cyGSX8iz2ycCawhr6oThkwgIXlOP+J7No+aNf9XTXsnKK47xRjTlynT73hB7Rmucr7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816752; c=relaxed/simple;
	bh=AFWtC+KFuj3ZvwsSS+G3o68131MSoPf01hAva18aIXU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P0TvkMLzh43MNEtGsx1XRVq5RhB2S42Ar0JETTqpWZL9/xQ8aOb8ZBxxoK7pc/RKrbaO9V4B6MNBvv1SLdAbzx0mIdGufrHDSXAebyvcVc12t90NwTiakhlhHW7rViRCZUndJDAesbcqWNKPUH1t8uzX13TMgRkTmTElcgDaVao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/5] Netfilter fixes for net
Date: Wed, 19 Jun 2024 19:05:32 +0200
Message-Id: <20240619170537.2846-1-pablo@netfilter.org>
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

Patch #1 fixes the suspicious RCU usage warning that resulted from the
	 recent fix for the race between namespace cleanup and gc in
	 ipset left out checking the pernet exit phase when calling
	 rcu_dereference_protected(), from Jozsef Kadlecsik.

Patch #2 fixes incorrect input and output netdevice in SRv6 prerouting
	 hooks, from Jianguo Wu.

Patch #3 moves nf_hooks_lwtunnel sysctl toggle to the netfilter core.
	 The connection tracking system is loaded on-demand, this
	 ensures availability of this knob regardless.

Patch #4-#5 adds selftests for SRv6 netfilter hooks also from Jianguo Wu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-06-19

Thanks.

----------------------------------------------------------------

The following changes since commit a8763466669d21b570b26160d0a5e0a2ee529d22:

  selftests: openvswitch: Set value to nla flags. (2024-06-19 13:10:53 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-06-19

for you to fetch changes up to 221200ffeb065c6bbd196760c168b42305961655:

  selftests: add selftest for the SRv6 End.DX6 behavior with netfilter (2024-06-19 18:42:10 +0200)

----------------------------------------------------------------
netfilter pull request 24-06-19

----------------------------------------------------------------
Jianguo Wu (4):
      seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors
      netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core
      selftests: add selftest for the SRv6 End.DX4 behavior with netfilter
      selftests: add selftest for the SRv6 End.DX6 behavior with netfilter

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix suspicious rcu_dereference_protected()

 include/net/netns/netfilter.h                      |   3 +
 net/ipv6/seg6_local.c                              |   8 +-
 net/netfilter/core.c                               |  13 +-
 net/netfilter/ipset/ip_set_core.c                  |  11 +-
 net/netfilter/nf_conntrack_standalone.c            |  15 -
 net/netfilter/nf_hooks_lwtunnel.c                  |  67 ++++
 net/netfilter/nf_internals.h                       |   6 +
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/config                 |   2 +
 .../selftests/net/srv6_end_dx4_netfilter_test.sh   | 335 ++++++++++++++++++++
 .../selftests/net/srv6_end_dx6_netfilter_test.sh   | 340 +++++++++++++++++++++
 11 files changed, 776 insertions(+), 26 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_dx4_netfilter_test.sh
 create mode 100755 tools/testing/selftests/net/srv6_end_dx6_netfilter_test.sh
