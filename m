Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0147B2F530F
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669630; cv=none; b=pBRed/zBMWDkaC89fXABVfCWKEeNRfJ3fyZ+qXeTHRYV0PxhxTeJ5qwm+dPxVeC1I13YLymtiJ7ycj4xHeJLE2lldfcfLQ+esd9c/mlSZI643iihUcETY4oPdOl+++SbIQq7E9U/HazRjQWb2TR0ADJltN+x/mV7hn9Zen1CUI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669630; c=relaxed/simple;
	bh=D5YG85f+qsPyV8mCeNP9lHp9xQG5dW7SoV6xiF9hz3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XJgDWeu5YJhVVzCA+XtuYVXM4tssFa0HzpJbChCf26ziZIeZIxXSjhYhxXKCXfGKKwcsoj6Xl5iQZb7Gr+XH+BxFCkZEcKfDTNNCzZUNTjE8jR20CpSsHi1+LAl2ZJnKiiNUTfjLykbkXg+P+sGEMxHBWuvqs4E9vOO+xBZXBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ed6BYiPg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ed6BYiPg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4FDwGDn9YxHX1gm6w2y9L2D+FutD1v5DYeyYsih0KxE=; b=Ed6BYiPgGdAdlQDTAX5UOENQ/y
	XN3oTqrbNPU/Wz/yIqCTzNG5xlJGXMFnLiVHncw07+a1i1pDfbRhtJ84GYVnujQHnK4i384lgbYxo
	L9/cP1jhDLX0oHe+ywXhSzNfIAdjyQN+71Prr3FsHz+RTLu8XWW2ofJE2wbWTX9rPnCcXLT/FVk0s
	sVQSedNPuenexejO05n0PBR4J2OygjR4alfhEQofjy9fjPg/lROfSLVdmXv+l+3ZF3p0lXPPGhJXg
	VfgoCRD7jdkB+MCDmzmCDtHQsN9s5jqrzIYcsuKFC36A15ADed6vJ/tXIcw2R4iiQrLarNwjcFbmh
	aHWTN0Eg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1Qw-00000000447-1DCj;
	Wed, 16 Jul 2025 14:40:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 0/4] Support wildcard netdev hooks
Date: Wed, 16 Jul 2025 14:40:16 +0200
Message-ID: <20250716124020.5447-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2:
- New patch 1 fixing for excessive mnl_attr_nest_end() calls
- Introduce a helper function in patch 2 which also sanity-checks an
  array index - this is a copy of libnftnl's function for the same
  purpose, but we rather get rid of the dupicated calling code instead
  of exposing (and thus maintaining in future) the function from
  libnftnl

This is the remaining needed code change to support wildcard hook specs.
Patch 4 also adds shell test cases to cover the functionality. The
flowtable variant is skipped if 'nft list hooks' does not provide
flowtable information as this requires NFNL_HOOK_TYPE_NFT_FLOWTABLE in
kernel.

Phil Sutter (4):
  mnl: Call mnl_attr_nest_end() just once
  mnl: Support simple wildcards in netdev hooks
  parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
  tests: shell: Test ifname-based hooks

 src/mnl.c                                     | 22 ++++++---
 src/parser_bison.y                            | 11 +----
 .../features/list_hooks_flowtable_info.sh     |  7 +++
 .../netdev_chain_name_based_hook_0.json-nft   | 34 ++++++++++++++
 .../dumps/netdev_chain_name_based_hook_0.nft  |  5 +++
 .../chains/netdev_chain_name_based_hook_0     | 44 ++++++++++++++++++
 .../testcases/flowtable/0016name_based_hook_0 | 45 +++++++++++++++++++
 .../dumps/0016name_based_hook_0.json-nft      | 32 +++++++++++++
 .../flowtable/dumps/0016name_based_hook_0.nft |  6 +++
 9 files changed, 191 insertions(+), 15 deletions(-)
 create mode 100755 tests/shell/features/list_hooks_flowtable_info.sh
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_name_based_hook_0
 create mode 100755 tests/shell/testcases/flowtable/0016name_based_hook_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.nft

-- 
2.49.0

