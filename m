Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B42A2512C8;
	Wed,  8 Oct 2025 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759928391; cv=none; b=iAaCu0wMpF9hVxrkyVxnP1wV8V6p2lwJTwurH/9OY9aegr3tRK+fGeyQ3JlZTGr93tsFfiyffu6o6WEG+e1m8HyvwW2oZUliH7+VXjkWRZI5EDakLC2ikYFvaw7vgddkGnr4cPxDNQUU4MyNKxf6h8IxrsL/nvj8vowvQVN1qLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759928391; c=relaxed/simple;
	bh=RCXBj4j70WAEuAw7p4BCz+eX/3JJaO+E/7fc7KpQLkY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NpDe6F8hwBNBqijSKm5N5WzuuuoMWmWGCDULmxe74bBGAdlYPt7oXfr0ShMAOjLeVBLVz3gyMnhl9I1rlsHPe9Cd9PVwnBj9UwTZb4OPWMnqFea4G1BhaPcVe0iZtGHrjRK03bet2mdhgbT6UrWf0Jfrz2gt1CKvoEeFL2Msv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 25E2A602F8; Wed,  8 Oct 2025 14:59:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/4] netfilter: updates for net
Date: Wed,  8 Oct 2025 14:59:38 +0200
Message-ID: <20251008125942.25056-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following patchset contains Netfilter fixes for *net*:

1) Fix crash (call recursion) when nftables synproxy extension is used
   in an object map.  When this feature was added in v5.4 the required
   hook call validation was forgotten.
   Fix from Fernando Fernandez Mancera.
2) bridge br_vlan_fill_forward_path_pvid uses incorrect
   rcu_dereference_protected(); we only have rcu read lock but not
   RTNL.  Fix from Eric Woudstra.

Last two patches address flakes in two existing selftests.

Please, pull these changes from:
The following changes since commit 2c95a756e0cfc19af6d0b32b0c6cf3bada334998:

  net: pse-pd: tps23881: Fix current measurement scaling (2025-10-07 18:30:53 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-10-08

for you to fetch changes up to e84945bdc619ed4243ba4298dbb8ca2062026474:

  selftests: netfilter: query conntrack state to check for port clash resolution (2025-10-08 13:17:31 +0200)

----------------------------------------------------------------
netfilter pull request nf-25-10-08

----------------------------------------------------------------
Eric Woudstra (1):
      bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()

Fernando Fernandez Mancera (1):
      netfilter: nft_objref: validate objref and objrefmap expressions

Florian Westphal (2):
      selftests: netfilter: nft_fib.sh: fix spurious test failures
      selftests: netfilter: query conntrack state to check for port clash resolution

 net/bridge/br_vlan.c                               |  2 +-
 net/netfilter/nft_objref.c                         | 39 +++++++++++++++
 .../selftests/net/netfilter/nf_nat_edemux.sh       | 58 +++++++++++++++-------
 tools/testing/selftests/net/netfilter/nft_fib.sh   | 13 +++--
 4 files changed, 89 insertions(+), 23 deletions(-)
