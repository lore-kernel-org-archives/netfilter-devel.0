Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41F61CC14D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695463; cv=none; b=Vtx/edxdNVC5kt4+p5uaiHHZ8UEAoqQubf+jEYvMeeE9XnVgE517IelLv7RCt8lYC4Jaa9aWTTp9OqvTqD+to1+3n74RO89IR1tlL72Kfodxh4P4mvcD+YtWH32Qv+LWujajvNIBuIO5xAzeIetm95+HTVz/BXdqKlrCay6qVFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695463; c=relaxed/simple;
	bh=hb0HMcgMxDiHW+y1bxxGD3JhsTe+jRc/rBEyYae2pEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OMiMwadm6Slc/9no3chgairJnUQgzvITM8VQxPQOW9/YcbDhmUgPZ7vljzdMnOY/a8RcMRCNif+XLwZLeMDPZc2TyctQsClliNCfqCL+35WmUdSaqn1ADrhCKvp0KmGsAspha+x3uG5ThQjKy7S1CJK9lRRKcdYD2QlaKhzQ9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hwt4efW7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hwt4efW7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a9l2AD2xCUyQKBQ+1qJ9nDVdf9aMXzwvjNe/aVi/Hw8=; b=hwt4efW7OkzInyOBeEbcgx8jka
	JcSwHWhUXQlHgwI2L4TgzGmJtuWyf+nmjw7CWdBzylOXX6IVcHfyMR8LWmGhUvoXjaArtJeYUGvta
	IqEAM3UlDWdaDjNom9kERBRQYu/pvzzJRk0F0G3aM7UnBXqDd+232zaKTrltWrFGAIfUtwYNMzCww
	eiH+H3NoZwzQf7smF4GRr3tDZVbtVicSueOzggTnMmL7i3EtjQaYLiPoF1Iir3X3WZdY82OMdYIC4
	ETNHc932zzWdWVWdelvW3PkYqB/XWzjN8PI9EASw/8jnOTywAF5NQPUlYbTnd+KUrwpxRYqAl3BdF
	hKrRlvhg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3cnl-000000003sf-2Bck;
	Wed, 23 Oct 2024 16:57:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Date: Wed, 23 Oct 2024 16:57:23 +0200
Message-ID: <20241023145730.16896-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v5:
- Extract the initial set of patches making netdev hooks name-based as
  suggested by Florian.
- Drop Fixes: tag from patch 1: It is not correct (the pointless check
  existed before that commit already) and it is rather an optimization
  than fixing a bug.

This series makes netdev hooks store the interface name spec they were
created for and establishes this stored name as the key identifier. The
previous one which is the hook's 'ops.dev' pointer is thereby freed to
vanish, so a vanishing netdev no longer has to drag the hook along with
it. (Patches 2-4)

Furthermore, it aligns behaviour of netdev-family chains with that of
flowtables in situations of vanishing interfaces. When previously a
chain losing its last interface was torn down and deleted, it may now
remain in place (albeit with no remaining interfaces). (Patch 5)

Patch 6 is a cleanup following patch 5, patches 1 and 7 are independent
code simplifications.

Phil Sutter (7):
  netfilter: nf_tables: Flowtable hook's pf value never varies
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Use stored ifname in netdev hook dumps
  netfilter: nf_tables: Compare netdev hooks based on stored name
  netfilter: nf_tables: Tolerate chains with no remaining hooks
  netfilter: nf_tables: Simplify chain netdev notifier
  netfilter: nf_tables: Drop __nft_unregister_flowtable_net_hooks()

 include/net/netfilter/nf_tables.h |  4 +-
 net/netfilter/nf_tables_api.c     | 74 +++++++++----------------------
 net/netfilter/nft_chain_filter.c  | 48 ++++++--------------
 3 files changed, 35 insertions(+), 91 deletions(-)

-- 
2.47.0

