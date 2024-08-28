Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF8AD156875;
	Wed, 28 Aug 2024 21:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724881643; cv=none; b=t+zApIX53n+8XE9PdVSgTyK7UZvftMglA5dvwVMFbhWX4Gd3kBxQp1DsZOmsOe5ltkEqkx62be+wqyJNUE/Gm246wKZzGV4rcRIreK9XRKSho9cXvZJq6n0fb70nTFYnXieTD+RLGrZWM+PQL6cwly6HvtS3VAczdgrj+9YLm3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724881643; c=relaxed/simple;
	bh=NQiWokQAjGw6gIvPax91lSkOf0D9XA230vnXUtWyoY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Hs5hCDeraahHs1Pjr7S2cuONXmVXUJzolTkf1hQYI55/qiP/Suo7ulPwj7oAGNCVVEeDEET7J/hu/zLR8pSG3WX5scYhqAryAqLysGCvWVVUCjiaNVz0pVVOIatmsxBpuqFaIl7YVvZytOezVlYPY1kB9zglLSLp1rtNOj7Dog0=
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
Date: Wed, 28 Aug 2024 23:47:06 +0200
Message-Id: <20240828214708.619261-1-pablo@netfilter.org>
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

Patch #1 sets on NFT_PKTINFO_L4PROTO for UDP packets less than 4 bytes
payload from netdev/egress by subtracting skb_network_offset() when
validating IPv4 packet length, otherwise 'meta l4proto udp' never
matches.

Patch #2 subtracts skb_network_offset() when validating IPv6 packet
length for netdev/egress.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-08-28

Thanks.

----------------------------------------------------------------

The following changes since commit 8af174ea863c72f25ce31cee3baad8a301c0cf0f:

  net: mana: Fix race of mana_hwc_post_rx_wqe and new hwc response (2024-08-23 14:24:24 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-08-28

for you to fetch changes up to 70c261d500951cf3ea0fcf32651aab9a65a91471:

  netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation (2024-08-27 18:11:56 +0200)

----------------------------------------------------------------
netfilter pull request 24-08-28

----------------------------------------------------------------
Pablo Neira Ayuso (2):
      netfilter: nf_tables: restore IP sanity checks for netdev/egress
      netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation

 include/net/netfilter/nf_tables_ipv4.h | 10 ++++++----
 include/net/netfilter/nf_tables_ipv6.h |  5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)
