Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAFC1552E7;
	Thu, 11 Jul 2024 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720690811; cv=none; b=oMtNmKnCwBrd3OROkw60V/s7oJXzR2VYiZE4za2XvaNKYxn3sohWBXOLQj0XK5BK8+yfg3U7QoAdw7iWjctFwZG5HwNmZdgTqFZ3oA7mTl9oFMTpd5pCzl9JEz9V2XN/SEe3+Blzm4V/lkfAkG9qIivFYcQvS/qJJiLeNdrhGQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720690811; c=relaxed/simple;
	bh=GpmIRdTbwDZV+h9pHoIED+v/Sae/8nkPHcCR7vlTJ5E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NyNjRUzNl34OFp2WezW6ZUtXC30lhOjfzFvEGdxc5jzfV57jnzK4u6M6jaWCLAFOLj7OI7/AhVKaL2hHtnTI4ZSbUnA7CT7gY1MsfuACadFeqkLQrsFPLuFafRTcrcSoXL/Bw/Gj5RA93CHE6L5O3A20Uj5+sZetru6bfk6vH1Q=
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
Date: Thu, 11 Jul 2024 11:39:46 +0200
Message-Id: <20240711093948.3816-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter fixes for net:

Patch #1 fixes a bogus WARN_ON splat in nfnetlink_queue.

Patch #2 fixes a crash due to stack overflow in chain loop detection
	 by using the existing chain validation routines

Both patches from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-07-11

Thanks.

----------------------------------------------------------------

The following changes since commit c184cf94e73b04ff7048d045f5413899bc664788:

  ethtool: netlink: do not return SQI value if link is down (2024-07-11 11:19:07 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-07-11

for you to fetch changes up to cff3bd012a9512ac5ed858d38e6ed65f6391008c:

  netfilter: nf_tables: prefer nft_chain_validate (2024-07-11 11:26:35 +0200)

----------------------------------------------------------------
netfilter pull request 24-07-11

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nfnetlink_queue: drop bogus WARN_ON
      netfilter: nf_tables: prefer nft_chain_validate

 net/netfilter/nf_tables_api.c   | 158 ++++------------------------------------
 net/netfilter/nfnetlink_queue.c |   2 +-
 2 files changed, 14 insertions(+), 146 deletions(-)
