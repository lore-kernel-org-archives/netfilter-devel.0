Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A223217D2;
	Thu,  9 Jan 2025 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736426140; cv=none; b=uzCB9r/ADfQXPCNsv/D7UOaB05nsgY2WBVesEUBA08oK2llnYT5b8eB8JgBGjXoDBnmbwIl8E3q4CsPIxffnIcu1TkEezP0d+Z6MbQJ0RixXyOyWq0MB7HJAL4Kr9bE5W4SaRcVkkdakHEdbvYpD8TcWwngiOy+JS8YsCeaEnzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736426140; c=relaxed/simple;
	bh=0FDEW/H3clvcjMVAlZTjLBk+RZQwlF70Pl5M8kyQjhA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qam2oiQC6pZOo6S9soBDS19I0nGVWCuxLAvmj+HGQgI5r1hp9oLIi5BqGkFMdDeseQRTEO2llklIrNzHtv4VhuWPRbW4SwNaKj9slz4qCh4epzgK6sGy4xENDISX3MKSaALy4gdIgzbWb/g7y23z7YVbNvBB27HhP4bWvXzBenA=
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
Date: Thu,  9 Jan 2025 13:35:29 +0100
Message-Id: <20250109123532.41768-1-pablo@netfilter.org>
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

1) Fix imbalance between flowtable BIND and UNBIND calls to configure
   hardware offload, this fixes a possible kmemleak.

2) Clamp maximum conntrack hashtable size to INT_MAX to fix a possible
   WARN_ON_ONCE splat coming from kvmalloc_array(), only possible from
   init_netns.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-01-09

Thanks.

----------------------------------------------------------------

The following changes since commit 4f619d518db9cd1a933c3a095a5f95d0c1584ae8:

  net: wwan: t7xx: Fix FSM command timeout issue (2024-12-30 18:00:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-01-09

for you to fetch changes up to b541ba7d1f5a5b7b3e2e22dc9e40e18a7d6dbc13:

  netfilter: conntrack: clamp maximum hashtable size to INT_MAX (2025-01-09 13:29:45 +0100)

----------------------------------------------------------------
netfilter pull request 25-01-09

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: imbalance in flowtable binding
      netfilter: conntrack: clamp maximum hashtable size to INT_MAX

 net/netfilter/nf_conntrack_core.c |  5 ++++-
 net/netfilter/nf_tables_api.c     | 15 +++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)
