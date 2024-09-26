Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADEF1AC8B0
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344615; cv=none; b=HqtMtmf/Io0LtPPvcwHUUD8FCk9jeBfi/6gbeHJSrh9DKEtKj+mDKkKm/qfBdEM/zOheIXrysfBHm/5NHvTeMMbDp5pnSy1S9/cr1LZQoB1IsjJSYiyhoZ6a81AfMqj9l71MrkwdgNZdTlQkVThVYP8WOCC4szFWWNQlde8dt5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344615; c=relaxed/simple;
	bh=kIuFEBXZtbyFlPHf8zJiDDObrFpnpdhw8ggkGkvrKjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ByzTrGIORcO3kovExAlGJj2z1fY6kJvod6XEQd97nhZbN0bmow7xWlx3nrwSSPPTXRr0snIWqJALsSQpEGT9BgnHwQxiCPN6FlGWyx9kpScC8WKGjc2dV+Y731lklbJjGEx/g4kukdsAXldvWmmZWtEQY8DhIQdXCNtB2qiY/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=J+dds6Tw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="J+dds6Tw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wwpPgd99MrWQWoJfHjiup3WyVJYGk5+RNwf5nBtyh9c=; b=J+dds6TwOux+7pLwWAPLszCd2l
	Za1i2Diy9Xntn6o0jRHXVzOwmStM1UJAyj+2e7b0JqRJz5udM5qDZNavEdsCx+XORYtNIToAogPPJ
	B64vQRhHdlKmH41yYkb1vRRPlb5qr44aGQ61xZOtF3hbdYLZhROBIHqPgsMqFCON8KJichNjFv/J5
	k09nsEoT2xIw0NzfwkCd7d4++ygev81vsEttXJbt2UMpD+LndywTuDt/tKuzqqP6HWCe3YeCqe3KH
	qS8wmsA45GJd5cfr4wLG560r4Gch7EgjMMJIqL1XHAdx110aMeLfr+FnCctyR8F47JtrP1Oqc7Hrt
	MLuCHbsg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stlEy-000000006Fr-20PO;
	Thu, 26 Sep 2024 11:56:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v5 00/18] Dynamic hook interface binding
Date: Thu, 26 Sep 2024 11:56:25 +0200
Message-ID: <20240926095643.8801-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v4:
- Extend netlink notifications to clarify confusing DELDEV, NEWDEV
  messages with identical interface name for CHANGENAME events. Include
  the interface name spec, so user space may log e.g.:
  | add device flowtable ip t f2 hook f2_i* { f2_if1 }
  | delete device flowtable ip t f1 hook f1_if2 { f2_if1 }
  (upon renaming f1_if2 to f2_if1)
- Add missing annotation to new NFTA_DEVICE_* attributes.
- Fix for NETDEV_CHANGENAME event unregistering the newly registered
  hook again.
- Drop extras from chain's netdev notifier needed for chain deletion
  support.
- Limit max run-time of kselftest (build system set
  kselftest_timeout=1800, leading to 24min run-time).

Patch 1 eliminates a pointless check and allows for some code
consolidation.

The next three patches introduce external storing of the user-supplied
interface name in nft_hook structs to decouple code from values in
->ops.dev or ->ops value in general.

Patch 5 eliminates a quirk in netdev-family chain netdev event handler,
aligns behaviour with flowtables and paves the way for following
changes. Patch 6 cleans up remnants afterwards.

Patches 7-11 prepare for and implement nf_hook_ops lists in nft_hook
objects. This is crucial for wildcard interface specs and convenient
with dynamic netdev hook registration upon NETDEV_REGISTER events.

Patches 12-15 leverage the new infrastructure to correctly handle
NETDEV_REGISTER and NETDEV_CHANGENAME events.

Patch 16 prepares the code for non-NUL-terminated interface names passed
by user space which resemble prefixes to match on. As a side-effect,
hook allocation code becomes tolerant to non-matching interface specs.

The final two patches implement netlink notifications for netdev
add/remove events and add a kselftest.

Phil Sutter (18):
  netfilter: nf_tables: Flowtable hook's pf value never varies
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Use stored ifname in netdev hook dumps
  netfilter: nf_tables: Compare netdev hooks based on stored name
  netfilter: nf_tables: Tolerate chains with no remaining hooks
  netfilter: nf_tables: Simplify chain netdev notifier
  netfilter: nf_tables: Introduce functions freeing nft_hook objects
  netfilter: nf_tables: Introduce nft_hook_find_ops()
  netfilter: nf_tables: Introduce nft_register_flowtable_ops()
  netfilter: nf_tables: Drop __nft_unregister_flowtable_net_hooks()
  netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
  netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
  netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
  netfilter: nf_tables: Wrap netdev notifiers
  netfilter: nf_tables: Handle NETDEV_CHANGENAME events
  netfilter: nf_tables: Support wildcard netdev hook specs
  netfilter: nf_tables: Add notications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/linux/netfilter.h                     |   3 +
 include/net/netfilter/nf_tables.h             |  14 +-
 include/uapi/linux/netfilter/nf_tables.h      |  10 +
 net/netfilter/nf_tables_api.c                 | 447 ++++++++++++------
 net/netfilter/nf_tables_offload.c             |  51 +-
 net/netfilter/nft_chain_filter.c              | 122 +++--
 net/netfilter/nft_flow_offload.c              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 151 ++++++
 9 files changed, 593 insertions(+), 208 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.43.0

