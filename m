Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E4E1E480;
	Thu, 28 Nov 2024 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797530; cv=none; b=LZqRfsQTkllCzIXn2KTTgUGhpNVcEMEXiSOpZeJAQ6LoBHLxfTzGjZGQyhrC2+y8iJJs1QjTkJB/n9A9q2mPohCPlkh2hRctlJomZ/gwBJjKcA7enhOJsVZXx4er8L+cfaAMAl80j9tM8YxQiYIpXCsCioMXdZYwi+5aZLAH5HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797530; c=relaxed/simple;
	bh=aKRvzpzB1/3MVHmcg0D9z3RLnmbmO+h5pc2cerOJNz4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s4x4zS+yvF3OVBQH+vY3bwINj4PiOPiDOzwb4NqP8Egmr4KHtCanEDoZcDFUf2u/QfijBskeW3x6n79yJu+K2X4U+g58NKMbwh6G+A1zGD0pZ377Nt+C7sJ/e+JPtVPeBiyp7fiZMYWlllfdr8N7B4rX8VTWPEuX9nnzcDsXkD4=
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
Subject: [PATCH net,v2 0/4] Netfilter fixes for net
Date: Thu, 28 Nov 2024 13:38:36 +0100
Message-Id: <20241128123840.49034-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: Amended missing Fixes: tag in patch #4.

-o-

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix esoteric UB due to uninitialized stack access in ip_vs_protocol_init(),
   from Jinghao Jia.

2) Fix iptables xt_LED slab-out-of-bounds, reported by syzbot,
   patch from Dmitry Antipov.

3) Remove WARN_ON_ONCE reachable from userspace to cap maximum cgroup
   levels to 255, reported by syzbot.

4) Fix nft_inner incorrect use of percpu area to store tunnel parser
   context with softirqs, reported by syzbot.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-28

Thanks.

----------------------------------------------------------------

The following changes since commit 04f5cb48995d51deed0af71aaba1b8699511313f:

  Documentation: tls_offload: fix typos and grammar (2024-11-28 12:09:06 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-11-28

for you to fetch changes up to e4e12f81c14c8c0c5a2920587ad2619abf1b8e30:

  netfilter: nft_inner: incorrect percpu area handling under softirq (2024-11-28 13:32:17 +0100)

----------------------------------------------------------------
netfilter pull request 24-11-28

----------------------------------------------------------------
Dmitry Antipov (1):
      netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia (1):
      ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Pablo Neira Ayuso (2):
      netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
      netfilter: nft_inner: incorrect percpu area handling under softirq

 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/ipvs/ip_vs_proto.c       |  4 +--
 net/netfilter/nft_inner.c              | 56 ++++++++++++++++++++++++++--------
 net/netfilter/nft_socket.c             |  2 +-
 net/netfilter/xt_LED.c                 |  4 ++-
 5 files changed, 50 insertions(+), 17 deletions(-)
