Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DC2CA6F;
	Thu,  5 Dec 2024 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733358554; cv=none; b=Q/H3rp/0+geEkgNPUWCfEjgtSbp2ybGya/cupaN2MYfwheF9XD2khdVPj26acHiYRdaRXFmWh4yM/tD/LoIM7hQfdAg0H00UN9wkqyev1Lc/X6TMTQw7zKmqF3exEw7RMasDQfftfVlwDKa47NF1z+IFrHKooSY2scXifkD5x7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733358554; c=relaxed/simple;
	bh=+szOf6bVfZiHZSXsndCUgqOi3EqfEUiGhvDYTSZxRfo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cThQVzDIj6i+k9WM1LNj2xKwnIR3SAFqyFkrpq7uooCmrnTW8mEsX+oyhOYyY+xNWzezpfllHTuQ++pZa8nWKoVPZV7Ydbg7l1mEshDK5fqKtoTwUzz9I18WlKAszhDb46NcAHZoZo12WEk3/KiFemNpGvWR8yQUNOZe68sVih8=
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
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Thu,  5 Dec 2024 01:28:48 +0100
Message-Id: <20241205002854.162490-1-pablo@netfilter.org>
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

1) Fix esoteric undefined behaviour due to uninitialized stack access
   in ip_vs_protocol_init(), from Jinghao Jia.

2) Fix iptables xt_LED slab-out-of-bounds due to incorrect sanitization
   of the led string identifier, reported by syzbot. Patch from
   Dmitry Antipov.

3) Remove WARN_ON_ONCE reachable from userspace to check for the maximum
   cgroup level, nft_socket cgroup matching is restricted to 255 levels,
   but cgroups allow for INT_MAX levels by default. Reported by syzbot.

4) Fix nft_inner incorrect use of percpu area to store tunnel parser
   context with softirqs, resulting in inconsistent inner header
   offsets that could lead to bogus rule mismatches, reported by syzbot.

5) Grab module reference on ipset core while requesting set type modules,
   otherwise kernel crash is possible by removing ipset core module,
   patch from Phil Sutter.

6) Fix possible double-free in nft_hash garbage collector due to unstable
   walk interator that can provide twice the same element. Use a sequence
   number to skip expired/dead elements that have been already scheduled
   for removal. Based on patch from Laurent Fasnach

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-12-05

Thanks.

----------------------------------------------------------------

The following changes since commit 04f5cb48995d51deed0af71aaba1b8699511313f:

  Documentation: tls_offload: fix typos and grammar (2024-11-28 12:09:06 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-12-05

for you to fetch changes up to 7ffc7481153bbabf3332c6a19b289730c7e1edf5:

  netfilter: nft_set_hash: skip duplicated elements pending gc run (2024-12-04 21:37:41 +0100)

----------------------------------------------------------------
netfilter pull request 24-12-05

----------------------------------------------------------------
Dmitry Antipov (1):
      netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia (1):
      ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Pablo Neira Ayuso (3):
      netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
      netfilter: nft_inner: incorrect percpu area handling under softirq
      netfilter: nft_set_hash: skip duplicated elements pending gc run

Phil Sutter (1):
      netfilter: ipset: Hold module reference while requesting a module

 include/net/netfilter/nf_tables_core.h |  1 +
 net/netfilter/ipset/ip_set_core.c      |  5 +++
 net/netfilter/ipvs/ip_vs_proto.c       |  4 +--
 net/netfilter/nft_inner.c              | 57 +++++++++++++++++++++++++++-------
 net/netfilter/nft_set_hash.c           | 16 ++++++++++
 net/netfilter/nft_socket.c             |  2 +-
 net/netfilter/xt_LED.c                 |  4 ++-
 7 files changed, 72 insertions(+), 17 deletions(-)
