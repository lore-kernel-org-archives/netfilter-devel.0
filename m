Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218A6193072;
	Wed, 26 Jun 2024 23:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719445140; cv=none; b=iD0ImkUOYtgLBNbl8NBH9VbZJDQAGXQZrR+g2/9kEtHgzJdxaFx3tt94RyYSkhomz3mNlEukBriQEWWFoZkF4bN5MEQ6UHJAF2oKXHrOJSn3LtCME7LiMYm11g+TRJiVH2+8NO6bgs/MtUo3cX3UBG9BeSIG1CkpxLTrAARu0bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719445140; c=relaxed/simple;
	bh=H6+X8o5gCJR7GeC8Ea6KPH4ohUSoOM5EDQEmUefiDWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pwwsBmZu71OqAKHaBryMj3yJ2Nu8bK9GzTAMQlbjel/LrhqeMgx13j9mZ6FXFpemDBJz5wydWJPZpI3DyHLx1XOr10/ckRu6l6dIJ1oMbqw4LAk/NMUWgY8//yvVnPlLkYMN1mgKqYk3tuqX0uhoBeJPXgNITJvSVmcNs6M24hQ=
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
	fw@strlen.de,
	torvalds@linuxfoundation.org
Subject: [PATCH net 0/2] Netfilter fixes for net
Date: Thu, 27 Jun 2024 01:38:43 +0200
Message-Id: <20240626233845.151197-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains two Netfilter fixes for net:

Patch #1 fixes CONFIG_SYSCTL=n for a patch coming in the previous PR
	 to move the sysctl toggle to enable SRv6 netfilter hooks from
	 nf_conntrack to the core, from Jianguo Wu.

Patch #2 fixes a possible pointer leak to userspace due to insufficient
	 validation of NFT_DATA_VALUE.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-06-27

Thanks.

----------------------------------------------------------------

The following changes since commit 058722ee350c0bdd664e467156feb2bf5d9cc271:

  net: usb: ax88179_178a: improve link status logs (2024-06-24 10:15:09 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-06-27

for you to fetch changes up to 7931d32955e09d0a11b1fe0b6aac1bfa061c005c:

  netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers (2024-06-27 01:09:51 +0200)

----------------------------------------------------------------
netfilter pull request 24-06-27

----------------------------------------------------------------
Jianguo Wu (1):
      netfilter: fix undefined reference to 'netfilter_lwtunnel_*' when CONFIG_SYSCTL=n

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nf_hooks_lwtunnel.c | 3 +++
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_lookup.c        | 3 ++-
 4 files changed, 14 insertions(+), 5 deletions(-)
