Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EA5EC3;
	Thu, 22 Feb 2024 00:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560533; cv=none; b=VmwhpIKYWurgnVyHDFTsI1E5WuaLZEL9mkHyRWSC7OPhXmJkvbaIfq/7qTwTJW0Moplix1bAE9qRrR0PyHY+r4L2qG4jHORFYw2Jg/E9nrdupibmrYvpU+1zYzeNLzqRq5RVTofJVQXV8Ry6HQ2XvqflA53rWDl30MZ6LDSccvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560533; c=relaxed/simple;
	bh=EGPFsgSaeo0ypk5Yg0SlooiamS5Q8KQO5RFHuVMz4PI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uEW8rUoikonz2d200YJFiYXTx8PZUOddsIdB91qx4hPUuisd05DPK6eZT0PBa0/QcJp/uJ38BQn4xdnf1cPVtSc1xVTYfGeEQDAddoyzRcAY6z04mwl6srQj6oLZ/ncB0WEcOVzPRXC/o1RDWjknEF9jywjS4awJz7gdsbZBBWg=
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
Date: Thu, 22 Feb 2024 01:08:38 +0100
Message-Id: <20240222000843.146665-1-pablo@netfilter.org>
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

1) If user requests to wake up a table and hook fails, restore the
   dormant flag from the error path, from Florian Westphal.

2) Reset dst after transferring it to the flow object, otherwise dst
   gets released twice from the error path.

3) Release dst in case the flowtable selects a direct xmit path, eg.
   transmission to bridge port. Otherwise, dst is memleaked.

4) Register basechain and flowtable hooks at the end of the command.
   Error path releases these datastructure without waiting for the
   rcu grace period.

5) Use kzalloc() to initialize struct nft_hook to fix a KMSAN report
   on access to hook type, also from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-02-22

Thanks.

----------------------------------------------------------------

The following changes since commit 40b9385dd8e6a0515e1c9cd06a277483556b7286:

  enic: Avoid false positive under FORTIFY_SOURCE (2024-02-19 10:57:27 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-02-22

for you to fetch changes up to 195e5f88c2e48330ba5483e0bad2de3b3fad484f:

  netfilter: nf_tables: use kzalloc for hook allocation (2024-02-22 00:15:58 +0100)

----------------------------------------------------------------
netfilter pull request 24-02-22

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: set dormant flag on hook register failure
      netfilter: nf_tables: use kzalloc for hook allocation

Pablo Neira Ayuso (3):
      netfilter: nft_flow_offload: reset dst in route object after setting up flow
      netfilter: nft_flow_offload: release dst in case direct xmit path is used
      netfilter: nf_tables: register hooks last when adding new chain/flowtable

 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 17 ++++++--
 net/netfilter/nf_tables_api.c         | 81 ++++++++++++++++++-----------------
 3 files changed, 57 insertions(+), 43 deletions(-)
