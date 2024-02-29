Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7019A179;
	Thu, 29 Feb 2024 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709164911; cv=none; b=lhZv+2i3spHsIP8Gul7pEZ7asX+L/VLC454MHehu/b07BFan+C2nkk3gJ451lO1xiZ9EwXWiFim3I74VJokCr7kPc3uOFmrP5Z0VtJhKHqHGK58FOUbOVn8/YYwSwuq3Uuf7+qYVbCK5cmudAgwcH1nMfOKC6ugz0o6OLIAcMro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709164911; c=relaxed/simple;
	bh=VwniBers1j1ov/NZ2S5ekbwMqneJ+aSdwcluq5ZTHA0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HYiYL8UO0tW/M2wJjvxdeUKjguBw5MtujLO+7zGS+B/l0AR8PZTNubb1IaZOfV1dbJtSUnW6K3HAO2GGtzXZh+6hXSN6Hy/qymzEJE5Igr0Tnd6xqf9yUaE0fbtl86QMkLoOu+afgYkEY7s6qxjY2GtCfkhyJg+sPuNxLq07yd4=
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
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu, 29 Feb 2024 01:01:32 +0100
Message-Id: <20240229000135.8780-1-pablo@netfilter.org>
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

Patch #1 restores NFPROTO_INET with nft_compat, from Ignat Korchagin.

Patch #2 fixes an issue with bridge netfilter and broadcast/multicast
packets.

There is a day 0 bug in br_netfilter when used with connection tracking.

Conntrack assumes that an nf_conn structure that is not yet added to
hash table ("unconfirmed"), is only visible by the current cpu that is
processing the sk_buff.

For bridge this isn't true, sk_buff can get cloned in between, and
clones can be processed in parallel on different cpu.

This patch disables NAT and conntrack helpers for multicast packets.

Patch #3 adds a selftest to cover for the br_netfilter bug.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-02-29

Thanks.

----------------------------------------------------------------

The following changes since commit 359e54a93ab43d32ee1bff3c2f9f10cb9f6b6e79:

  l2tp: pass correct message length to ip6_append_data (2024-02-22 10:42:17 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-02-29

for you to fetch changes up to 6523cf516c55db164f8f73306027b1caebb5628e:

  selftests: netfilter: add bridge conntrack + multicast test case (2024-02-29 00:22:48 +0100)

----------------------------------------------------------------
netfilter pull request 24-02-29

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: bridge: confirm multicast packets before passing them up the stack
      selftests: netfilter: add bridge conntrack + multicast test case

Ignat Korchagin (1):
      netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()

 include/linux/netfilter.h                          |   1 +
 net/bridge/br_netfilter_hooks.c                    |  96 +++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c         |  30 ++++
 net/netfilter/nf_conntrack_core.c                  |   1 +
 net/netfilter/nft_compat.c                         |  20 +++
 tools/testing/selftests/netfilter/Makefile         |   3 +-
 .../selftests/netfilter/bridge_netfilter.sh        | 188 +++++++++++++++++++++
 7 files changed, 338 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/netfilter/bridge_netfilter.sh
