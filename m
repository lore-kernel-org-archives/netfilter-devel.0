Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06371D529
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773612; cv=none; b=XXfV/jwXizxbjEWInqsC7G7F/RHUvSGV9ckZMlY62cTnH+CKGISAWU/f1COFZe8KVq6r6NIBKEHGtl7YoWm9iDd/DoWHbwA0x/Nc+jA0PBHmFtD/RQUQM+4JfDOk5rTWh7frMb7DTIaToEWcS9Rlihi0qmJ4lWDml7IUtMooKKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773612; c=relaxed/simple;
	bh=ifnP4nviAZmeuDtI2EXgLWJhQubYj9ks+3bVFbtksac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HoS40SDTPRJNp0MFl3UeenIRd645WdhObVCd1UAyqItWzDgJ2LnlkLkFnlcEa61QQQzxaeD7ZBMdbULiaKXYAuAPEEHdEfLqDdRwz6Wd8BLtfMn6KodO/5pI/kxhFDxoPnGSMrI8rxZsIEqA/xZlu/yMNNSMoUMD1iU9QFg4H7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u0hAl-000117-E5; Fri, 04 Apr 2025 15:33:27 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: sbrivio@redhat.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 0/3] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
Date: Fri,  4 Apr 2025 15:32:23 +0200
Message-ID: <20250404133229.12395-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sontu Mazumdar reports incorrect matching in the pipapo set type.

First patch adds debug infrastructure (conditional for CONFIG_DEBUG_NET)
to add rudimentary avx register tracking.

Second patch is the actual fix.

Third patch adds a test case.

I checked that selftest passes with all three patches applied,
that the new selftest fails without the fix and that the
register tracking added in patch 1 also produces a WARN splat.

Florian Westphal (3):
  nft_set_pipapo: add avx register usage tracking for NET_DEBUG builds
  nft_set_pipapo: fix incorrect avx2 match of 5th field octet
  selftests: netfilter: add test case for recent mismatch bug

 net/netfilter/nft_set_pipapo_avx2.c           | 220 ++++++++++++++++--
 .../net/netfilter/nft_concat_range.sh         |  39 +++-
 2 files changed, 243 insertions(+), 16 deletions(-)

-- 
2.49.0

