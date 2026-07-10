Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295D233956
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696461; cv=none; b=Oa67xN1WM8f/3mA0ztxIrVMw7zdsvzL674Yu79j5H5cRvWz3eyoaZflGVnVe0UGaMeuOQC9/OpbC9oI261hLhyQmXbPKY9tE0kIBSWFaGR8SbetWIPsZ5fXN5axni8dJq5/tk6XtKMBc5Va7bmessUlJNvEiNAMXJkDk3KO+17g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696461; c=relaxed/simple;
	bh=iSKg2SBRaMp9VOihsrTIupFZWj48TiP04y6oEfLtjg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DWbqeHN98yRNgLgszqLKpVoTsJ3sn1xwn4ffoxJX/ud0wLobmfSNSvKAW8npjpFcmVyXEfgCD7XkfvB5d6g3Elt+YByEYDPfUVLpGWLvzS4ZW09vlRC+jJrCpHiU656MjPrnE3EnHXhTmv5o3v/9BxBI42/WUyN9kUB3zZiBUM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fKsmfMqm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fKsmfMqm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tXdUdP+69GcHXqoiHvR4I+pyH1o+muaUj6VGyieeW/A=; b=fKsmfMqmtVF9pzqbLOBkTvtawK
	uijACXLNPfQjPcWuwcG0mxDEdZE5/Xz4S5psSVTj2op6rdXTSmCJ+DuGY4vkDTh+mLgl+vXEIXzMF
	RfORWnwNI/+LLUgnCx17RzF+/hrAr4RR1zXIhDm5v9ooX5fcajIMQgB04zDC0FJZF2VXqwJP/40b3
	wzWvqOWhNoOd1Kk3WNDewopF+Gh9j8iyfALeCQc2IbelplTbQA8UNnBCNRu7Ayn7PCopfZ4rZvDgd
	tmo/etOUSJyrpMqWvcOdAddb2yH5W1mvtHXAVKQ8mUTPomkpFRN8YjKrrJxGQ5BX2HV+lIv47Tmd4
	pZVBXJvA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wiCvh-000000001tw-3PcM;
	Fri, 10 Jul 2026 17:14:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v3 0/4] Address Sashiko review of NAT hook dump code
Date: Fri, 10 Jul 2026 17:14:07 +0200
Message-ID: <20260710151411.2358773-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v2:
- Drop patch 1 again. Fixing nfnl_hook_dump's broken NLM_F_DUMP_INTR
  flag setting in corner-cases is out of scope of this series and should
  be solved in a more elegant way in nfnetlink itself.
Changes since v1:
- New patch 1
- Fixed three aspects of patch 3
- Fixed two issues of patch 5

Patch 1 is mere preparation to add the missing case handling to
nfnl_hook_dump_nat().

Patch 2 fixes for missing READ_ONCE() calls when addressing hook ops
array elements.

Patch 3 adds missing multipart dump support to nfnl_hook_dump_nat.

Patch 4 adds code to detect and mitigate concurrent hook updates while
amidst a multipart dump to nfnl_hook_dump_nat.

Link: https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de

Phil Sutter (4):
  netfilter: nfnetlink_hook: Pass cb object to nfnl_hook_dump_nat()
  netfilter: nfnetlink_hook: Address hook ops using READ_ONCE()
  netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
  netfilter: nfnetlink_hook: Fix for concurrent NAT hooks dump and
    change

 net/netfilter/nfnetlink_hook.c | 48 ++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 14 deletions(-)

-- 
2.54.0

