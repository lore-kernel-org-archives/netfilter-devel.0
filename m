Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25D429A9FE;
	Wed, 10 Jun 2026 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781114367; cv=none; b=WFlXVkyGwctEO8r9GRf/UFosrq3syRDWvktN7+SXa6tiKI/+T7S+wqvIltgmSuFScYoLGCLrlv03RH/6BdO6uyGnkBnjLuKSN3lxqjHqbIdp2ubxFx0dUdO5V9BjHtUMWFQRBPof+pCs0nUGYSR3+vtPMcetvCa0DC5HZ9nbnug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781114367; c=relaxed/simple;
	bh=RJ3Jm7s1KPIJN4x4zj5ARLMufArVvTkTOOpe4fGptaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eV7yEZURG1SyeOmiAmbsvOrfb6StjzsVI/ch03hJwBtLFBVBEGS8d1ZWHhy03hq8bApo/pBw3kDeSHqkVRU98dVL/D0YDZEDFgwZqrtDN1+caLNS1K3DcbzH66mrIf52Fxds+47k88f4tkEms7zBq6apeexKgxU5w/bECiZu8co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C39DD607E1; Wed, 10 Jun 2026 19:59:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 0/2] netdevsim: add fake FT/CLS_FLOWER offload
Date: Wed, 10 Jun 2026 19:58:42 +0200
Message-ID: <20260610175906.1767-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1) Enable nf_tables offload control plane testing in netdevsim. Tag
   existing offload fn to allow error injection for testing rollback and abort
   logic.

2) Add nft_offload selftest to exercise the control plane and error
   unwind via fault injection.

Florian Westphal (2):
  netdevsim: tc: allow to test nf_tables offload control plane code
  selftests: netfilter: add phony nft_offload test

 drivers/net/netdevsim/tc.c                    |  18 ++-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   6 +
 .../selftests/net/netfilter/nft_offload.sh    | 132 ++++++++++++++++++
 4 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_offload.sh

-- 
2.53.0

