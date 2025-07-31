Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034342798F5
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754001001; cv=none; b=pvRcNU5RHlI8RJSVQDq98v6cpAKEx6pvqvpFq1h9XHlrQ0yFHthWEECm0LlporQLBodDSSs59pQ2wZNW/OVbLKkkoNAH7CVgMQ4nsa4dShTpDYZ4PJSW39jRw2Y5ENG+dU5fw3+Jba2bIj0LY1F2pU8V3vqzJE1Zw/AOXm3syOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754001001; c=relaxed/simple;
	bh=uSP3loLubXi/nb+26WzQNLjG6VHtW0x1NUJB/GuzS1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a1T8OWCKGcPEHcAY2H+ld0zCVpUphqiX9NdSNbAYpa1rC3ZP2UOhxGwVTMEesC+bajckshBn1prjIdpq+HVO9PPJMpwE+1+B32ld7XlYTgCwQB69NXcygX2023ye68PxY3/NuvSfE3BoJKuzx9D7eiAuKQJZJt2wQ3dfoXsamUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dwq+H6wq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dwq+H6wq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=djY34RTdRhUwY7VGrDSExCGrzmTDPKC8DYJk9hGvmKE=; b=Dwq+H6wqSLCdfBzYJqzarJ4ZmI
	hk6kfjVnslN8sUf6twySxT4It7l2l2e1RFkhC4rwLws3Fbmy46nZ4Jpj+BTv0SWfHr1/In9MR8lwM
	ulF4k7KY+oGnEUqYuZofcZXEEFFOb6ptLWhgh0WqkbIYhNFkDQES5TfarOnlPrgoRgeJQOAIPv/Gw
	W9HFAwNM2/5/Ibve60S+4c/9gIAO+ejC4UZcomfMNWSEKOvv7cbzSRJe4Y7JgIQ4Hv9i9cYzVmSY+
	l5biwC3SdtXUyYHKjef51lGPY7o2kJHKfnevgm+CUTQgK1TLVY45mpH9y/SQk6XnS0+jVomPjREuW
	UZda8vDg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhbmY-000000003KB-3V3n;
	Fri, 01 Aug 2025 00:29:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v5 0/3] Support wildcard netdev hooks
Date: Fri,  1 Aug 2025 00:29:42 +0200
Message-ID: <20250731222945.27611-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v4:
- Adjust code to NFTA_HOOK_PREFIX attribute

Changes since v3:
- Unrelated patch 1 pushed out separately
- Fixed variable types and function prefix in patch 1
- Document interface wildcard support in nft.8

Changes since v2:
- New patch 1 fixing for excessive mnl_attr_nest_end() calls
- Introduce a helper function in patch 2 which also sanity-checks an
  array index - this is a copy of libnftnl's function for the same
  purpose, but we rather get rid of the dupicated calling code instead
  of exposing (and thus maintaining in future) the function from
  libnftnl

This is the remaining needed code change to support wildcard hook specs.
Patch 3 also adds shell test cases to cover the functionality. The
flowtable variant is skipped if 'nft list hooks' does not provide
flowtable information as this requires NFNL_HOOK_TYPE_NFT_FLOWTABLE in
kernel.

Phil Sutter (3):
  mnl: Support simple wildcards in netdev hooks
  parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
  tests: shell: Test ifname-based hooks

 doc/nft.txt                                   | 30 +++++++++++--
 include/linux/netfilter/nf_tables.h           |  2 +
 src/mnl.c                                     | 26 +++++++++--
 src/parser_bison.y                            | 11 +----
 .../features/list_hooks_flowtable_info.sh     |  7 +++
 .../netdev_chain_name_based_hook_0.json-nft   | 34 ++++++++++++++
 .../dumps/netdev_chain_name_based_hook_0.nft  |  5 +++
 .../chains/netdev_chain_name_based_hook_0     | 44 ++++++++++++++++++
 .../testcases/flowtable/0016name_based_hook_0 | 45 +++++++++++++++++++
 .../dumps/0016name_based_hook_0.json-nft      | 32 +++++++++++++
 .../flowtable/dumps/0016name_based_hook_0.nft |  6 +++
 11 files changed, 225 insertions(+), 17 deletions(-)
 create mode 100755 tests/shell/features/list_hooks_flowtable_info.sh
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_name_based_hook_0
 create mode 100755 tests/shell/testcases/flowtable/0016name_based_hook_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.nft

-- 
2.49.0

