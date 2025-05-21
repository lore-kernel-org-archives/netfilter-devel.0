Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728B629CB55
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 20:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860289; cv=none; b=gk+mZ7vCc2pEVeoyQADFSzWo6A3Yfym1Dt2F0/0hn0mJ9S5H1/GjdnQUNV/GsW7Hdqf+KsAMdQ92h87SuvGWpYmNzvy3CcwJYFch7xaU6tyDS0VrlX6en6/GY6C0/7nGkXNeL0HKXdy07yMf6+ugreiNzcXVv67EE7cIhBPeI4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860289; c=relaxed/simple;
	bh=qBz4h9eeQJrgMt0Nnp5qjU6AY4Sg/WejtK4SUeQaj+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uhW9otJ3w5r5TUrFnq6wBYVoCRiqHqbMJOTH2yMiQoNB+qmKeHF93IUs6yIYkxxQ/qXm4d4VIzJM681CNdymWGEJZYJCDM7Pvz0/TNZ/hK8TlC1lyMJ6goDGiqvXE4keo2EL9sQJvwavr5uu5WdIlyXSGTB7dhsu1Vd+t6mx+R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZT6s8JJX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZT6s8JJX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lrFtXELY+JWl9tQcjHOpGAioocxA+VQEcLj5wZFhfmc=; b=ZT6s8JJXTbVEdE35gvhW7LBIj5
	nAaWP6iXqjZnOw3S0mCayLoR6KU5LIubpHuqTnTW5DtasYbUgMRnKx0uHsZG5g4HxpPePqnkz0hK0
	ghUAJYsZ9dGf5mmhZIZKzQgOgCCEn057KO1sm9O5wknnTNtHShsqCDjMCCxAAh3+E3hYKooNIHeOD
	72HIXnMmzLxMOJ6XXYJUoT6SihSdDNOCf6oYgVDLr3hZDMvccpb58zhQUNdCuHUJaQhej6R7v5P86
	w5weCaYbXGxrJz4XlCkahV3YSf/afEEP0M1S0r8DWvQW/Z6MaUVAtkOQpBd9clpN+TRTdF7xv+7yX
	phO2TTLQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHqIv-000000007Rd-2nDz;
	Wed, 21 May 2025 22:44:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v7 00/13] Dynamic hook interface binding part 2
Date: Wed, 21 May 2025 22:44:21 +0200
Message-ID: <20250521204434.13210-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v6:
- Misc changes in patch 5 (described in there)
- New patch 10
- Patch 11 adjusted to new patch 10
- Patch 12 adds new NFNLGRP_NFT_DEV for the new notifications
- Fix typo in patch 12's subject line

Patches 1-5 prepare for and implement nf_hook_ops lists in nft_hook
objects. This is crucial for wildcard interface specs and convenient
with dynamic netdev hook registration upon NETDEV_REGISTER events.

Patches 6-9 leverage the new infrastructure to correctly handle
NETDEV_REGISTER and NETDEV_CHANGENAME events.

Patch 11 prepares the code for non-NUL-terminated interface names passed
by user space which resemble prefixes to match on. As a side-effect,
hook allocation code becomes tolerant to non-matching interface specs.

The final two patches implement netlink notifications for netdev
add/remove events and add a kselftest.

Phil Sutter (13):
  netfilter: nf_tables: Introduce functions freeing nft_hook objects
  netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
  netfilter: nf_tables: Introduce nft_register_flowtable_ops()
  netfilter: nf_tables: Pass nf_hook_ops to
    nft_unregister_flowtable_hook()
  netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
  netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
  netfilter: nf_tables: Respect NETDEV_REGISTER events
  netfilter: nf_tables: Wrap netdev notifiers
  netfilter: nf_tables: Handle NETDEV_CHANGENAME events
  netfilter: nf_tables: Sort labels in nft_netdev_hook_alloc()
  netfilter: nf_tables: Support wildcard netdev hook specs
  netfilter: nf_tables: Add notifications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/linux/netfilter.h                     |   3 +
 include/net/netfilter/nf_tables.h             |  12 +-
 include/uapi/linux/netfilter/nf_tables.h      |  10 +
 include/uapi/linux/netfilter/nfnetlink.h      |   2 +
 net/netfilter/nf_tables_api.c                 | 402 ++++++++++++++----
 net/netfilter/nf_tables_offload.c             |  51 ++-
 net/netfilter/nfnetlink.c                     |   1 +
 net/netfilter/nft_chain_filter.c              |  94 +++-
 net/netfilter/nft_flow_offload.c              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 151 +++++++
 11 files changed, 593 insertions(+), 136 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.49.0

