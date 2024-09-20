Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D6F183CD2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2024 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863841; cv=none; b=R6kpgBAgx9P70mz8PGqHEQ2xiaBu1e7ncRD2NL9IbSZ/xxIA6Z0Py1bBa8dZwo9+QHtcQCHiq6iugni2jS5OKLY8Pp5p1tMspycVvsR3fqGcBaNTk+4u+8fd47FJWkAb64vKNA0FF/G9SY8YPcfoAke5V62MIs6suRocnzpAMkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863841; c=relaxed/simple;
	bh=BtE2U43+KkDHSFzKzUwsdPUlY3bTsJKGlmpkLFQzmSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MnCun/xEEGExAtPQhK4Sb7V/hTsrqzCleY7qCDAXa+NizOVGgUMowQIXCAkGAuHYkIYUpBiPf7pycOGxdFoj4GXxJqQPm8PFEtk/SHphwNjmS06/kyKUnUFwAHKPL/ud8yfrQfDuFMVfi/44ESl76SYi4OuE9qTpD6AOcmOR7dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=klCX8OsV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="klCX8OsV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M/u68Tv9z7f3M10cVHhbNyPsYNmq0vza0YU3HZwWFOU=; b=klCX8OsV5O5u9K4jUz2tXzt7bu
	9ftFbbJWkIyAF2KOaJxzVrFP4FR2+C/kqtz4mMyDAh3Lp22w4pAx8WQxS1ogoFVC7nHcLKdhmNwvR
	iyJxwzEEb0t9/ftWJHStSo3xLHJKkbH3ZYEAo7FCvzrCjFKqu0PM2CnX76v05ZkDLKDZO19XNcSV9
	sg9ljiQP3Rmy/ES1emGnMdxHbs5H5StMVFhJOHHqkNQ62SLPeTkmNZq6ImStQ200GzY14itvIC5zK
	3VZFavmqX16ieu8jaTl/BDuwC5SM/ZTlMjDcBALlbCvx4tc/shd+NrfK33A76+IAs6gC62T7aTkQa
	CiD7WIUA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1srkAY-000000006JF-0UTQ;
	Fri, 20 Sep 2024 22:23:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v4 00/16] Dynamic hook interface binding
Date: Fri, 20 Sep 2024 22:23:31 +0200
Message-ID: <20240920202347.28616-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v3:
- Introduce RCU for nf_hook_ops: Readers iterate through each nft_hook's
  ops_list and we want to remove individual list entries in netdev event
  handlers. This requires to extend nf_hook_ops by an rcu_head if we
  don't want to call synchronize_rcu() in netdev notifier callbacks.
- RCU-free an nft_hook and ops using call_rcu() and a callback.
- Check nla_strscpy() return value to make sure user-defined ifname
  string length is less than IFNAMSIZ.
- Drop __nft_unregister_flowtable_net_hooks(), it's redundant (noticed
  while reviewing nft_hook free sites).
- Return error in netdev notifier callbacks if hook registration fails.
- Upon NETDEV_CHANGENAME, try to register the new name first before
  unregistering the old one.
- Use kmemdup() instead of kzalloc() && memcpy().

Patch 1 eliminates a pointless check and allows for some code
consolidation.

The next three patches introduce external storing of the user-supplied
interface name in nft_hook structs to decouple code from values in
->ops.dev or ->ops value in general.

Patch 5 eliminates a quirk in netdev-family chain netdev event handler,
aligns behaviour with flowtables and paves the way for following
changes.

Patches 6-10 prepare for and implement nf_hook_ops lists in nft_hook
objects. This is crucial for wildcard interface specs and convenient
with dynamic netdev hook registration upon NETDEV_REGISTER events.

Patches 11-13 leverage the new infrastructure to correctly handle
NETDEV_REGISTER and NETDEV_CHANGENAME events.

Patch 14 prepares the code for non-NUL-terminated interface names passed
by user space which resemble prefixes to match on. As a side-effect,
hook allocation code becomes tolerant to non-matching interface specs.

The final two patches implement netlink notifications for netdev
add/remove events and add a kselftest.

Phil Sutter (16):
  netfilter: nf_tables: Flowtable hook's pf value never varies
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Use stored ifname in netdev hook dumps
  netfilter: nf_tables: Compare netdev hooks based on stored name
  netfilter: nf_tables: Tolerate chains with no remaining hooks
  netfilter: nf_tables: Introduce functions freeing nft_hook objects
  netfilter: nf_tables: Introduce nft_hook_find_ops()
  netfilter: nf_tables: Introduce nft_register_flowtable_ops()
  netfilter: nf_tables: Drop __nft_unregister_flowtable_net_hooks()
  netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
  netfilter: nf_tables: chain: Respect NETDEV_REGISTER events
  netfilter: nf_tables: flowtable: Respect NETDEV_REGISTER events
  netfilter: nf_tables: Handle NETDEV_CHANGENAME events
  netfilter: nf_tables: Support wildcard netdev hook specs
  netfilter: nf_tables: Add notications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/linux/netfilter.h                     |   3 +
 include/net/netfilter/nf_tables.h             |  11 +-
 include/uapi/linux/netfilter/nf_tables.h      |   5 +
 net/netfilter/nf_tables_api.c                 | 411 ++++++++++++------
 net/netfilter/nf_tables_offload.c             |  51 ++-
 net/netfilter/nft_chain_filter.c              |  73 ++--
 net/netfilter/nft_flow_offload.c              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 149 +++++++
 9 files changed, 521 insertions(+), 185 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.43.0

