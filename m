Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AF554F89;
	Thu, 21 Mar 2024 11:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711020086; cv=none; b=AbdGpSUV3MYo2Foebwz3spl9+/YZqUv5/nInPKKslvX4kPenOeNEwQ+HzGYvmS+PnY58AAQ3mg8K1bvHNI5kptsNNcVO97wIlYMTpjkmkHhN2bzBCrpBRCsqAeYZfgSDLmqAp4XbuRLg4/Yl9bxw8+lNulT+M6Oh7PSPnIVKmhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711020086; c=relaxed/simple;
	bh=dgcYgmlarTCQWg9j4VVOldGPOW0VJqWYp52FkwDZlYE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ehLunRIX1dlf6KQQGCCe1JaFKQx23iE9SbEdazeoekjhYKYADbCun3vfMFRaaaMrrGJ5a3rTrgeDEBUWHcTnXrVCa3wYFgcwdCnEyeCWsDBWC2d8McWEoCUKmus4CYrNq2JZ7lZ50m8XriICsfu58wHnTmpLSqjxN65ee2/QwCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 0/3,v2] Netfilter fixes for net
Date: Thu, 21 Mar 2024 12:21:14 +0100
Message-Id: <20240321112117.36737-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: Amended missing SOB in patch 3/3.

-o-

Hi,

The following patchset contains Netfilter fixes for net. There is a
larger batch of fixes still pending that will follow up asap, this is
what I deemed to be more urgent at this time:

1) Use clone view in pipapo set backend to release elements from destroy
   path, otherwise it is possible to destroy elements twice.

2) Incorrect check for internal table flags lead to bogus transaction
   objects.

3) Fix counters memleak in netdev basechain update error path,
   from Quan Tian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-03-21

Thanks.

----------------------------------------------------------------

The following changes since commit 9c6a59543a3965071d65b0f9ea43aa396ce2ed14:

  Merge branch 'octeontx2-pf-mbox-fixes' (2024-03-20 10:49:08 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-03-21

for you to fetch changes up to 7eaf837a4eb5f74561e2486972e7f5184b613f6e:

  netfilter: nf_tables: Fix a memory leak in nf_tables_updchain (2024-03-21 12:12:06 +0100)

----------------------------------------------------------------
netfilter pull request 24-03-21

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nft_set_pipapo: release elements in clone only from destroy path
      netfilter: nf_tables: do not compare internal table flags on updates

Quan Tian (1):
      netfilter: nf_tables: Fix a memory leak in nf_tables_updchain

 net/netfilter/nf_tables_api.c  | 29 +++++++++++++++--------------
 net/netfilter/nft_set_pipapo.c |  5 +----
 2 files changed, 16 insertions(+), 18 deletions(-)
