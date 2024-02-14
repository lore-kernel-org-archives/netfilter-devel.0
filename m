Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A9B2574B;
	Wed, 14 Feb 2024 23:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953913; cv=none; b=fgWjFxkyYWQwE/zlIlaU9VxlO9fMYYubqtDvTC8wtAWdRCGHyZOrC2AA/hpSv/yrcOKsCwICm/Jb8ipwh7A88+1pK30NTQqSgqY92QCs73EV10f7/OLbPewvPF5hOFxGQK311A4fxTAs3k/gfpnb6xFyH2nS5hpitH4AOupXAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953913; c=relaxed/simple;
	bh=4QLgaQNrRu44iCW7rJtZCzi0nf7pOFIhWpI/51CCkBk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LQve5ZwfWmVEc4u8BYiUF85l50PF2Te5tV5x2pTA5mujIHOWQhE4WhPAGYaBq9bx/KB00DuzG3RQjfOmK6KFlTOlKjrepM7qMiC9NpqvxjIQRVYkAoCZTu30emYj/tk4xR4Y/aJBfLdOD1yHq7eUCnAcsif4Jyp4aEAW+NOVUaI=
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
Date: Thu, 15 Feb 2024 00:38:15 +0100
Message-Id: <20240214233818.7946-1-pablo@netfilter.org>
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

1) Missing : in kdoc field in nft_set_pipapo.

2) Restore default DNAT behavior When a DNAT rule is configured via
   iptables with different port ranges, from Kyle Swenson.

3) Restore flowtable hardware offload for bidirectional flows
   by setting NF_FLOW_HW_BIDIRECTIONAL flag, from Felix Fietkau.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-02-15

Thanks.

----------------------------------------------------------------

The following changes since commit 9b23fceb4158a3636ce4a2bda28ab03dcfa6a26f:

  ethernet: cpts: fix function pointer cast warnings (2024-02-14 12:50:53 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-02-15

for you to fetch changes up to 84443741faab9045d53f022a9ac6a6633067a481:

  netfilter: nf_tables: fix bidirectional offload regression (2024-02-15 00:20:00 +0100)

----------------------------------------------------------------
netfilter pull request 24-02-15

----------------------------------------------------------------
Felix Fietkau (1):
      netfilter: nf_tables: fix bidirectional offload regression

Kyle Swenson (1):
      netfilter: nat: restore default DNAT behavior

Pablo Neira Ayuso (1):
      netfilter: nft_set_pipapo: fix missing : in kdoc

 net/netfilter/nf_nat_core.c      | 5 ++++-
 net/netfilter/nft_flow_offload.c | 1 +
 net/netfilter/nft_set_pipapo.h   | 4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)
