Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836BD5812B;
	Tue, 23 Apr 2024 11:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870675; cv=none; b=MXAUM8l16Y6LALMYGUc10VY0oexrZQWcdAWEur4OsHmeLegyveHYaSIlPivDzU3CQJgE3Ry6aKq4zNRIzig0v9tNYewI3exXU4vru7AUbzqYleQf9D0Ir1tBKkuPeYPfSU37Lb34POsNS0uEU9AeBGYlaI4XXm6KRBtmzJ4cFuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870675; c=relaxed/simple;
	bh=6RXqbgT4QhNDRadiGfBo/yMJyUMnA8pGfQWDMzAf8kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iEvTgf+jrJTeZ+O6IYlUey+wNstQyzGp+yOJ3GpxcoRvHZk0HNMu7Ok7hyrE2UMPaU6R7Eo7We1XBCoKcaBz+bU4AYJkvmyu0RxwJ/4LnpZjdPt8BFTJQfHu0zlkxkMhWJvbD/GXV3IxCPCjJQo00z5V8yNn0tI4wWO4kk6O/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3B-0006v8-Ld; Tue, 23 Apr 2024 13:11:01 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
Date: Tue, 23 Apr 2024 15:05:43 +0200
Message-ID: <20240423130604.7013-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the last planned series of the netfilter-selftest-move.
It contains cleanups (and speedups) and a few small updates to
scripts to improve error/skip reporting.

I intend to route future changes, if any, via nf(-next) trees
now that the 'massive code churn' phase is over.

Florian Westphal (7):
  selftests: netfilter: nft_concat_range.sh: move to lib.sh infra
  selftests: netfilter: nft_concat_range.sh: drop netcat support
  selftests: netfilter: nft_concat_range.sh: shellcheck cleanups
  selftests: netfilter: nft_flowtable.sh: re-run with random mtu sizes
  selftests: netfilter: nft_flowtable.sh: shellcheck cleanups
  selftests: netfilter: skip tests on early errors
  selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3

 .../selftests/net/netfilter/br_netfilter.sh   |   4 +
 .../selftests/net/netfilter/conntrack_vrf.sh  |  40 +--
 .../selftests/net/netfilter/nft_audit.sh      |   3 +-
 .../net/netfilter/nft_concat_range.sh         | 187 +++++-------
 .../selftests/net/netfilter/nft_flowtable.sh  | 274 ++++++++++--------
 .../testing/selftests/net/netfilter/rpath.sh  |  10 +-
 6 files changed, 263 insertions(+), 255 deletions(-)

-- 
2.43.2

