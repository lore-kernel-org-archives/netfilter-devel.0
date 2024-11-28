Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CF14F20C;
	Thu, 28 Nov 2024 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796597; cv=none; b=sBXyGDyOVIK2T+sRyYkU0tnz3Q4//ZDiZ2K53TttxT3RduTcnnG/q6pnAAXljXgdDQyddfr1IJEDMnRm2CaruzOEWh+ojR/4vnA6uuQKogyNkjxpmXJHOWCw8oESgtOtwtHVoVDtPjpM6KiyJGSE1UcyyUz5DN/bQj8ILruv7Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796597; c=relaxed/simple;
	bh=yUzFztjRSL2LObLNO0iTkwOv4/SemMYANO8Av6MC7OI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bzD+oj6lH88Bf/8sSLRqSQ65ZtaF1VLXwf1V/oJcnUvZzQec2o1EKwBOPVLMwOJkTbE73dpeLpS51jbDXbePRARIxnafja1kQk8AHyOqhnCtcmJ2oWsk6CYslbVjQnLXbFEBEmyoTPkIsZwG08XRL9kRD3ZsNlJbU067/x3nkdE=
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
Subject: [PATCH net 0/4] Netfilter fixes for net
Date: Thu, 28 Nov 2024 13:23:01 +0100
Message-Id: <20241128122305.14091-1-pablo@netfilter.org>
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

for you to fetch changes up to c24e5dbe2e66a24b1713d893806e3fb340df3501:

  netfilter: nft_inner: incorrect percpu area handling under softirq (2024-11-28 13:14:24 +0100)

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
