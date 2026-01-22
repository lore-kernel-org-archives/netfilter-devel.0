Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D713A7051;
	Thu, 22 Jan 2026 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099392; cv=none; b=iI7E199n1DmdxVv6/FZg52yLm2LUn9Nt44rnx7DME4zXH9n2YGzQ1o7eJ67Zirzpty6ibOXurp2gBe7f0Uhaum1cgdHJaHeGXiY3WRwSWEEbUMFrd6vF4BTcklHf3WSsxwP2U2e3ReCJHpiwWOIg9eNmniYIccONvQyWN3yG4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099392; c=relaxed/simple;
	bh=FEycXx+RYgWq8HGbK/OaSQm5gyOitWC2lmYms3y9hY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jjFDJbQvZNmmRCzQk08BZQf8GA4urp/OJVUExsMqgra4WrSUAH5CVckBwwlMQdqdW9eBGH1XAOH3VVR5WZF3XrKB99ZKC94kcTCaqOZL2IqfLFaG4K8eQTDH9NQllCequA4oOFLSFP6ZsFgdb7VyCxfo8flYtzeW0GToyN1jC8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D5C746033F; Thu, 22 Jan 2026 17:29:38 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/4] netfilter: updates for net-next
Date: Thu, 22 Jan 2026 17:29:31 +0100
Message-ID: <20260122162935.8581-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains nftables fixes for *net-next*.

There is an issue with interval matching in nftables rbtree set type:
When userspace sends us set updates, there is a brief window where
false negative lookups may occur from the data plane.  Quoting Pablos
original cover letter:

This series addresses this issue by translating the rbtree, which keeps
the intervals in order, to binary search. The array is published to
packet path through RCU. The idea is to keep using the rbtree
datastructure for control plane, which needs to deal with updates, then
generate an array using this rbtree for binary search lookups.

Patch #1 allows to call .remove in case .abort is defined, which is
needed by this new approach. Only pipapo needs to skip .remove to speed.

Patch #2 add the binary search array approach for interval matching.

Patch #3 updates .get to use the binary search array to find for
(closest or exact) interval matching.

Patch #4 removes seqcount_rwlock_t as it is not needed anymore (new in
this series).

Please, pull these changes from:
The following changes since commit b00a7b3a612925faa7362f5c61065e3e5f393fff:

  net: atp: drop ancient parallel-port Ethernet driver (2026-01-22 13:32:53 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-01-22

for you to fetch changes up to 5599fa810b503eafc2bd8cd15bd45f35fc8ff6b9:

  netfilter: nft_set_rbtree: remove seqcount_rwlock_t (2026-01-22 17:18:13 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-01-22

----------------------------------------------------------------

Pablo Neira Ayuso (4):
  netfilter: nf_tables: add .abort_skip_removal flag for set types
  netfilter: nft_set_rbtree: translate rbtree to array for binary search
  netfilter: nft_set_rbtree: use binary search array in get command
  netfilter: nft_set_rbtree: remove seqcount_rwlock_t

 include/net/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c     |   3 +-
 net/netfilter/nft_set_pipapo.c    |   2 +
 net/netfilter/nft_set_rbtree.c    | 429 ++++++++++++++++++++----------
 4 files changed, 291 insertions(+), 145 deletions(-)

-- 
2.52.0
