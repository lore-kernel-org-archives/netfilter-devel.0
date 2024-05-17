Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D404EB44
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951187; cv=none; b=SQQGg9QVN+KY2AUOAHkhrwzRP3+McIk+G4amcZh7aVyLWn5qJuupQFoOMZTJB35wppayAsQLgt7evhX5pnp+WKgmNn7g0NHvQmNsD0TbyGgPVdmFUxzHl81BG0xuYFKRO+9l5B91F0aRXFS2pDIxFeMqlQUbRpfwn5ivSv1YGXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951187; c=relaxed/simple;
	bh=8NKALPENpWWbz8eH8wJ2xVrECSxv68bZg21JaIhFh6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b8qcMokF97JBuESboei6EGJOJtUuHr8NcsMeTuE9G3LLIxmON9XT1jdKdFSoCH+mVbZRSJs9/3vgekbjmr+giUvAmjPy9s7oYDFgjGA6XoZZFWVIPR6r6SHkNP6oQAKVXbeMbOyV5t+GKgkc2QAqYPhaUCvrRChlnxLNYgLvmUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=E/rQykkR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="E/rQykkR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H1w5lOSqZs3tCGEl5cw3xrlo4gL/TV1OMOwsEJ/GFSs=; b=E/rQykkR0HWWLjW7kx06IEqI0w
	fU+z+c3wmCjSiw9uYbVjkbi9TfzQwsFvM1SWnWcez1VIAmaRY7R6DEBnA3v8X7ySiqj3aEiWm5X6V
	ar9ahuG7m/aQoY4XWnaiJj3MBBRBhtCxhL3qlxG0bw24v31O+AtTAjsv9Vb+448/CllQaSLc6QDr5
	1vHu2OlXkD9ifm5pzwLSJnEXKshX4SmNH3U2TUNNYTQxLn9r0LEq05/FKBmCG2HB3CNW2d0oZ1YUS
	wtNngU2kArAE+UuAWI/HGof9xkzVxW6htwoc4JmM14MC8iirsAGH5vX7QKa7W/sG3aY1eyf/5Ax04
	zShZNhOg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s7xHt-000000001dP-3tUJ;
	Fri, 17 May 2024 15:06:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Thomas Haller <thaller@redhat.com>
Subject: [PATCH v2 0/7] Dynamic hook interface binding
Date: Fri, 17 May 2024 15:06:08 +0200
Message-ID: <20240517130615.19979-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- New patch 6 adding notifications for updated hooks.
- New patch 7 adding the requested torture test.

Currently, netdev-family chains and flowtables expect their interfaces
to exist at creation time. In practice, this bites users of virtual
interfaces if these happen to be created after the nftables service
starts up and loads the stored ruleset.

Vice-versa, if an interface disappears at run-time (via module unloading
or 'ip link del'), it also disappears from the ruleset, along with the
chain and its rules which binds to it. This is at least problematic for
setups which store the running ruleset during system shutdown.

This series attempts to solve these problems by effectively making
netdev hooks name-based: If no matching interface is found at hook
creation time, it will be inactive until a matching interface appears.
If a bound interface is renamed, a matching inactive hook is searched
for it.

Ruleset dumps will stabilize in that regard. To still provide
information about which existing interfaces a chain/flowtable currently
binds to, new netlink attributes *_ACT_DEVS are introduced which are
filled from the active hooks only.

This series is also prep work for a simple wildcard interface binding
similar to the wildcard interface matching in meta expression. It should
suffice to turn struct nft_hook::ops into an array of all matching
interfaces, but the respective code does not exist yet.

Phil Sutter (7):
  netfilter: nf_tables: Store user-defined hook ifname
  netfilter: nf_tables: Relax hook interface binding
  netfilter: nf_tables: Report active interfaces to user space
  netfilter: nf_tables: Dynamic hook interface binding
  netfilter: nf_tables: Correctly handle NETDEV_RENAME events
  netfilter: nf_tables: Add notications for hook changes
  selftests: netfilter: Torture nftables netdev hooks

 include/net/netfilter/nf_tables.h             |   8 +-
 include/uapi/linux/netfilter/nf_tables.h      |   6 +-
 net/netfilter/nf_tables_api.c                 | 204 ++++++++++++------
 net/netfilter/nft_chain_filter.c              |  80 ++++---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_interface_stress.sh     | 106 +++++++++
 6 files changed, 309 insertions(+), 96 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh

-- 
2.43.0

