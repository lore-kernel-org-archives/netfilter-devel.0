Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE24A21340;
	Wed, 31 Jul 2024 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722461880; cv=none; b=ZGhGTIeTmX4Q9O0XgDy1nIe68c6qg/Pt+ItOgAeyodKkAMasJZu0IT7hD4+IytPBp5UNyPApPwMPJ8Gp3/eWK+x5yHpg5r8J/X7j5HqlHVPGB1zK4lAlMO+PaAHK7/lQkiOdyzgCVvQrdFgqBk+qIPqQ0aBTpGqF3/dB4urKxMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722461880; c=relaxed/simple;
	bh=z4sfCDYaoPl8VdL11BMrYk1jxXysdacTPiKZr//sgIs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PLJDNqyRvdje7xj1kz4wNk+z+8FGjeDT8UdsPVl6MSZG5NF/jmDB4zZniUZxCHx1SDDVNVop1QvgSlkPrw58v+/xaJrbSeDSyq8xbGkw3GPP91KGvlknomQOjw7OIiESuwA6S7V50jxscQZTXD35BVr+h7qNGLVNNzeIT8bbJvE=
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
Subject: [PATCH net 0/2] Netfilter fixes for net
Date: Wed, 31 Jul 2024 23:30:44 +0200
Message-Id: <20240731213046.6194-1-pablo@netfilter.org>
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

Fix a possible null-ptr-deref sometimes triggered by iptables-restore at
boot time. Register iptables {ipv4,ipv6} nat table pernet in first place
to fix this issue. Patch #1 and #2 from Kuniyuki Iwashima.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-07-31

Thanks.

----------------------------------------------------------------

The following changes since commit 0bf50cead4c4710d9f704778c32ab8af47ddf070:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2024-07-30 18:41:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-07-31

for you to fetch changes up to c22921df777de5606f1047b1345b8d22ef1c0b34:

  netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init(). (2024-07-31 23:21:34 +0200)

----------------------------------------------------------------
netfilter pull request 24-07-31

----------------------------------------------------------------
Kuniyuki Iwashima (2):
      netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().
      netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().

 net/ipv4/netfilter/iptable_nat.c  | 18 ++++++++++--------
 net/ipv6/netfilter/ip6table_nat.c | 14 +++++++++-----
 2 files changed, 19 insertions(+), 13 deletions(-)
