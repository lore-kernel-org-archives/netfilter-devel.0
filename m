Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A20B1459FA
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626388; cv=none; b=PTHOFz6XzGRcNAsposKANkTqHM7xaSQAAp1Ukp76hVeqYPPuIOnW4/SUKDwy5ZxuFuFnwhmPLjqouFsh8FV/9jwPnIQF2O6Xwxb/VZdVBKjX9doDRvyT86dJY8FZ1pwi2soz2kXrFWRd9xUPok7U03v8TKzf5uy+wdRI5s0yVzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626388; c=relaxed/simple;
	bh=oKgFxt2mIkdrMgHeyAEe8iLpRy+8wQySaHRO8TbonOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=refZ2VlkrY0lLVYuZaNVc5qESjbcyJ2GN2sRGp3NwqIrGmu/VIn7E7xfmmkRg9OJ38VOyYW7ONneCcExcMRJ3ILVrfsLzf8E/laW3s2ST/j3PPUah5LC/yOdIS/tMtAHV1JnFcmYilXZWSqxUKKbxDip+9YvCLpK6Ma6jYNgNJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JNHMjOFN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JNHMjOFN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OAOKyJPXfyhzrw0nANA4NaAvAG1NpQNfXcYMwSZ3PE4=; b=JNHMjOFN5PeTtTR/58JDEK4FzQ
	exH2mrBjbfOqkIvg/o+p3PONx5KULQWafFx6Wj8u2KDQ+ZMUsYDCnZ22JS6X1hj8LfWokY80w+lcy
	YkhKymzF2xePFXZAA/A+51ASOWc/toYQMmu5E8JlrOh7dtApG8zxslBYGru7qfelnT74zAdXCxENH
	wygjkvqjbnts0zeRuUeZN7v/9VHKwqidpirGEIPMDFQWADF5TQuteHPs5aM1oTOlKQn5RFxxbC+aR
	293w6uz+QaXv8wHiCECxVvNMjH623ISeEk2RccDcfMdEZ1vlYlRoHYGgHGdLiWJVC+bbshva9MaxM
	qhK73bGA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whuhO-000000002j4-3Otg;
	Thu, 09 Jul 2026 21:46:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2 0/5] Address Sashiko review of NAT hook dump code
Date: Thu,  9 Jul 2026 21:46:07 +0200
Message-ID: <20260709194612.1995795-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- New patch 1
- Fixed three aspects of patch 3
- Fixed two issues of patch 5

Patch 1 fixes a bug (actually, two) in old code. Latter patches benefit
from the fix it implements.

Patch 2 is mere preparation to add the missing case handling to
nfnl_hook_dump_nat().

Patch 3 fixes for missing READ_ONCE() calls when addressing hook ops
array elements.

Patch 4 adds missing multipart dump support to nfnl_hook_dump_nat.

Patch 5 adds code to detect and mitigate concurrent hook updates while
amidst a multipart dump to nfnl_hook_dump_nat.

Link: https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de

Phil Sutter (5):
  netfilter: nfnetlink_hook: Fix for EINTR due to index too large
  netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
  netfilter: nfnetlink_hook: Address hook ops using READ_ONCE()
  netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
  netfilter: nfnetlink_hook: Fix for concurrent NAT hooks dump and
    change

 net/netfilter/nfnetlink_hook.c | 75 +++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 23 deletions(-)

-- 
2.54.0

