Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792836A009;
	Fri, 12 Jun 2026 09:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781256146; cv=none; b=N7xCPn4zigzazt5OHFAkY/OYccx99ATJsm62CU/GSs6j9ztJQVwPR2izeO9YRdWQZa0Px5kCaAx1HEjxOQ0RaPRAtS0IONURaYxl392SFH6TubncsHSLGCzGRdQbhGEkrn7V6PB/Gbavc7q6qDuybwL3Xw5HAiiuJs/FiR4CGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781256146; c=relaxed/simple;
	bh=dq4ZY9BknbSjPjIvik5Y/re2KvfeV9+X9cAKUvXwhoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kyAKFzYrG+4AWCKJ7MyH1Wx2+6mtdRJigOXFsyv+rLobO2tY/nmFoi7PTPkstu2ZoA4GjYhj5fGI2LLSlACPPR911Qfmu7wbLNKKnPO0/guLCuIiY2AJDEGrKwOcXrpB8rKQsgI/UkGhziDqyhpxII9e+TXnpTtxJbJvCls9rlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1E4E7607E1; Fri, 12 Jun 2026 11:22:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 0/2] netdevsim: add fake FT/CLS_FLOWER offload
Date: Fri, 12 Jun 2026 11:22:07 +0200
Message-ID: <20260612092209.11966-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: fix up error reporting via extack
    shellcheck cleanups
    sort config toggles

1) Enable nf_tables offload control plane testing in netdevsim. Tag
   existing offload fn to allow error injection for testing rollback and abort
   logic.

2) Add nft_offload selftest to exercise the control plane and error
   unwind via fault injection.

Florian Westphal (2):
  netdevsim: tc: allow to test nf_tables offload control plane code
  selftests: netfilter: add phony nft_offload test

 drivers/net/netdevsim/bpf.c                   |   6 -
 drivers/net/netdevsim/tc.c                    |  20 ++-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 tools/testing/selftests/net/netfilter/config  |   6 +
 .../selftests/net/netfilter/nft_offload.sh    | 132 ++++++++++++++++++
 5 files changed, 158 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_offload.sh

-- 
2.53.0

