Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0350B2857DD
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752692053; cv=none; b=r8xXJ5r9Dirny5SCvJSC/3bFXrpchQE7oPIjCn5IA1mgHxFE0vJ6CVeldmiCBK30PpICjD2ta9wPPDoxhfbJq0Y7FEhNeDWzfMb2Eo1bXT/FFn9fEvBG+RAfs6vtmhjeLYYSJPDwiZF4w0qQ0LtZI0r9gl5mg+xO076PLozbZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752692053; c=relaxed/simple;
	bh=Sp2uOltFKruvAnrDgZSd5Wh1je+t3X1gAdg7at7x7hA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qGQ54XbtPDeXYG2vN9beNxK159udzoDfJedbsrfOVCCqcQ9KmnuQWBAEjN1E6iRdzjcFZEc5Unnv1MdT7jiMfzvQhS3DvaRTl869+Kn5+WPFm6ZeHU00Bi3WUh2GN65uij2gs0WZLH4f1uCJRAaLsLIjcxKzCCv7Fn+11wYErK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IyYOsqhu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IyYOsqhu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lz3YXaRFqlwX+KQUrzdeFbJaJGv7qAsbOYghpnSpqSc=; b=IyYOsqhu2z8KSU8Nm+WOYXbhzg
	MqdsBJMMOinW7hb8YZFoLKeQYzeQEX+ctl3593QPRQIoCW+xC9iXU60KQEYgUGjRvkzVEyoP08p7c
	scvPA4kblw0002I4Ckkv36nzPNfsoRhYIZg8Nj3xfa07CnpoG3asBMkRpxDx/0C1+pFMuMeuOrVds
	EHyc3KmYAvOtinlow0Cgj3SieaJfF65HOF7bi5m407yhX8mqjLr+t9WPQDz3R/SlzzhvP7d5ycjhL
	AbYrRHUEL0eeqw0ty5cNAtfRdQBKXgnPe35aiWUYWWmUjMxPkZ2RakpeGGAFWDa1bMt6Ez1lCB6g7
	xfyD7SdQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc7GZ-0000000082D-1phz;
	Wed, 16 Jul 2025 20:54:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 0/3] Support wildcard netdev hooks
Date: Wed, 16 Jul 2025 20:53:59 +0200
Message-ID: <20250716185402.32532-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 src/mnl.c                                     | 20 +++++++--
 src/parser_bison.y                            | 11 +----
 .../features/list_hooks_flowtable_info.sh     |  7 +++
 .../netdev_chain_name_based_hook_0.json-nft   | 34 ++++++++++++++
 .../dumps/netdev_chain_name_based_hook_0.nft  |  5 +++
 .../chains/netdev_chain_name_based_hook_0     | 44 ++++++++++++++++++
 .../testcases/flowtable/0016name_based_hook_0 | 45 +++++++++++++++++++
 .../dumps/0016name_based_hook_0.json-nft      | 32 +++++++++++++
 .../flowtable/dumps/0016name_based_hook_0.nft |  6 +++
 10 files changed, 217 insertions(+), 17 deletions(-)
 create mode 100755 tests/shell/features/list_hooks_flowtable_info.sh
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_name_based_hook_0
 create mode 100755 tests/shell/testcases/flowtable/0016name_based_hook_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.nft

-- 
2.49.0

