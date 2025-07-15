Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C49221F34
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592547; cv=none; b=CvRWugOx3dU+jkWnUAKpFbGVWkosYsUZSercqXBiI+7ruP6m+H2DpyliG/RJKOrJAOTC8fZWCDqGVj3LyUcg5UPwUhLu2zmnMC63Nm8RqNuAdPwK3+W7Q4Ur1XdwN2UPBLaiAZfn2E+jpZoYc+SKA7kOwAW1k8wqLIWadl3VmDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592547; c=relaxed/simple;
	bh=SJEoj1iiXsMK9SoRAXgoQnbRI4BgHqT3T+Yey7cLwjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zx7FPAnGL55pBC7OoxyxFSC8Ijf4XUn2ziZPGdJycTxBzRj0gWY+iCd4TCz0LD137HJUE5XujCdM+bjezMcrDUMRAllMnNIrOn5MJF4VCYGtL37P0mRFLkv+4UFQDS3+ZmRlL0yrwi7Uh8f9qeb1wwy358JsqSd0O6MQjYIMO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WMwGmh/c; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WMwGmh/c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RtBv4NIrsL9VpYTusKyxfvSboxRinKIjfKCC5B/WbUI=; b=WMwGmh/cVJfFd2oQ67iaPehe3Y
	GEvT4SeGNOYRu72NTIAp0hdKoVJxwLznC7cH+7j7tOHAQThHA7H5mybrcz0Bb1p6JI3JvqFrfuc+B
	4Ak9yuY/wYX0q/HP1Uvrdd4BtdOnMLWuDMBcvh2kolb5hY5PxpH6LZIrF5HR7a2SJnjD37Ox7iJD9
	PKnhUQDEt5GECLcu3BeemUk48mpAxH2aMj1s3EKS4cTKohQHtlVla2Km+/9ud+l4oaEkYJSjY4P30
	ZaXadpkDFywZ6A3QBeqStqYQZ4lm0QeHtK0MtkY7PDcptTbKEDUm7nmzXtM34kdEdr0geAkdm/Egf
	vMcbVE5w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubhNf-000000003BG-3LAU;
	Tue, 15 Jul 2025 17:15:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/3] Support wildcard netdev hooks
Date: Tue, 15 Jul 2025 17:15:35 +0200
Message-ID: <20250715151538.14882-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the remaining needed code change to support wildcard hook specs.
Patch 3 also adds shell test cases to cover the functionality. The
flowtable variant is skipped if 'nft list hooks' does not provide
flowtable information as this requires NFNL_HOOK_TYPE_NFT_FLOWTABLE in
kernel.

Phil Sutter (3):
  mnl: Support simple wildcards in netdev hooks
  parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
  tests: shell: Test ifname-based hooks

 src/mnl.c                                     | 19 +++++---
 src/parser_bison.y                            | 11 +----
 .../features/list_hooks_flowtable_info.sh     |  7 +++
 .../netdev_chain_name_based_hook_0.json-nft   | 34 ++++++++++++++
 .../dumps/netdev_chain_name_based_hook_0.nft  |  5 +++
 .../chains/netdev_chain_name_based_hook_0     | 44 ++++++++++++++++++
 .../testcases/flowtable/0016name_based_hook_0 | 45 +++++++++++++++++++
 .../dumps/0016name_based_hook_0.json-nft      | 32 +++++++++++++
 .../flowtable/dumps/0016name_based_hook_0.nft |  6 +++
 9 files changed, 188 insertions(+), 15 deletions(-)
 create mode 100755 tests/shell/features/list_hooks_flowtable_info.sh
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_name_based_hook_0.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_name_based_hook_0
 create mode 100755 tests/shell/testcases/flowtable/0016name_based_hook_0
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.json-nft
 create mode 100644 tests/shell/testcases/flowtable/dumps/0016name_based_hook_0.nft

-- 
2.49.0

