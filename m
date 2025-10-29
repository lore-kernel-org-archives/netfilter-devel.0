Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897628C006;
	Wed, 29 Oct 2025 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746190; cv=none; b=J0d2LYxecZZNXHJzrBJ+FCHnMT8ROKMqbPcl9hdmjmW6O3ikdwpYloMTzjS3mvzcq15I7gdXOs8JiE4qZ8HI3sMEJicD5biIqjmcN5Hmn52N54birksxJltpycOQmbZn0I2uU5pPFW9Kv1I4LXRMGw/NzafA6rmv5N5mfOPg0c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746190; c=relaxed/simple;
	bh=0OYZ8CvmYgJwbaQvv/QEVBAgamctE9L5Gi55kHL5sKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=et6Jujgxlh/nByHutU7rzP2bGeqhNfzotBPyiQG/zQ0g4BY/6cxn/3LVwkShJBhlc/5oZ1wAU2nSco9R0DJDRpm6h1CXXCqImLHK2MJvShaW/ONxuDQyLeziuEKMF1fwYUyPNq3TwUBSI3I07ZXyCiA13vOUT14Tt+zGxgu2SMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 77C8761AF5; Wed, 29 Oct 2025 14:56:26 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/3] netfilter: updates for net
Date: Wed, 29 Oct 2025 14:56:14 +0100
Message-ID: <20251029135617.18274-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) its not possible to attach conntrack labels via ctnetlink
   unless one creates a dummy 'ct labels set' rule in nftables.
   This is an oversight, the 'ruleset tests presence, userspace
   (netlink) sets' use-case is valid and should 'just work'.
   Always broken since this got added in Linux 4.7.

2) nft_connlimit reads count value without holding the relevant
   lock, add a READ_ONCE annotation.  From Fernando Fernandez Mancera.

3) There is a long-standing bug (since 4.12) in nftables helper infra
   when NAT is in use: if the helper gets assigned after the nat binding
   was set up, we fail to initialise the 'seqadj' extension, which is
   needed in case NAT payload rewrites need to add (or remove) from the
   packet payload.  Fix from Andrii Melnychenko.

Please, pull these changes from:
The following changes since commit 8df206f7b63611dbaeb8628661d87fe994dcdf71:

  Merge branch 'bug-fixes-for-the-hibmcge-ethernet-driver' (2025-10-28 19:11:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-10-29

for you to fetch changes up to 90918e3b6404c2a37837b8f11692471b4c512de2:

  netfilter: nft_ct: add seqadj extension for natted connections (2025-10-29 14:47:59 +0100)

----------------------------------------------------------------
netfilter pull request nf-25-10-29

----------------------------------------------------------------

Andrii Melnychenko (1):
  netfilter: nft_ct: add seqadj extension for natted connections

Fernando Fernandez Mancera (1):
  netfilter: nft_connlimit: fix possible data race on connection count

Florian Westphal (1):
  netfilter: nft_ct: enable labels for get case too

 net/netfilter/nft_connlimit.c |  2 +-
 net/netfilter/nft_ct.c        | 30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 4 deletions(-)

-- 
2.51.0

