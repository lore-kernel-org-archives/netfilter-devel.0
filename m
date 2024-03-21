Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EF7365;
	Thu, 21 Mar 2024 00:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710979609; cv=none; b=J0wQOJKzYKwwzlbNcbM1BQEXkAEsrF9PK+r6NX0prD7LbYDaCNQV5lO1Ge5IloNp2xf8wjNy+5wO8gaiLF2fCMbBQDF+TfXdQq29fE0BacwbiAlu81PjnEE/DJ9lc7l+V1xfat+eWxvkj055oon53YySMXYa41+mjJUtYZ8/l6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710979609; c=relaxed/simple;
	bh=XT1soTVQw9gYxMS6ZL+CJVcTgrpaZUCps9nSy0ePO8A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RflNosOItDac5/NTQo7AfsN+lM1m9ZHsLWNTWCLn3ma53xB1rcc7kPcFRPBDVu2C5RmslHCrLhpFQ8y+0Xm4h3bgyOEmdpVQR0SBUsU9A4lSic2AgLJ8Qr9oAQKrTKXzF1KzxpGqMFwmt/kOjpas35EhieN6pwm2DREiFZoXUYM=
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
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu, 21 Mar 2024 01:06:32 +0100
Message-Id: <20240321000635.31865-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

for you to fetch changes up to 1c2e3b462542241d2e6f4d32f8356608ff51f487:

  netfilter: nf_tables: Fix a memory leak in nf_tables_updchain (2024-03-21 00:46:03 +0100)

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
