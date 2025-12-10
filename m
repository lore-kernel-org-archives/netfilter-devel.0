Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA71E5B7A;
	Wed, 10 Dec 2025 11:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765364885; cv=none; b=mnO93l+TkSWHNUpOdyq6sWWWTMhhPqOHgWJzKBOTdcfu32O6NMAR7EP8pCb+8ZafpjOQhpUGNmtOFMaJFAUPWF8/rD1DRhYtJ9jEONHDiv7CEIYTRoVzg+DiSPslYFTyQb361OnLjSOUGA6z2Kkf8T5m6w4nCa/6kkhwgP05OYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765364885; c=relaxed/simple;
	bh=CoY0ovMbMEotOaFoyVEpnXjtxv6xus3fkOqe8aKWE7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nj+FW00hojt6UksyIAvVUjfeSly7S7XUDc0iPzBYGfKjauZgR6ab2siuAQRLO9h8R9BXAB5WHsiLa2b4TiQdgJPegy2RrA2Irh+siHR1UE3qRpcBq3hadZDqVknE5tkJQmGQLcXYvFd5qOl7pTU2RnDao01Xb9rSUY6ztJ0nE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1F8C460331; Wed, 10 Dec 2025 12:07:59 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/4] netfilter: updates for net
Date: Wed, 10 Dec 2025 12:07:50 +0100
Message-ID: <20251210110754.22620-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Fix refcount leaks in nf_conncount, from Fernando Fernandez Mancera.
   This addresses a recent regression that came in the last -next
   pull request.

2) Fix a null dereference in route error handling in IPVS, from Slavin
   Liu.  This is an ancient issue dating back to 5.1 days.

3) Always set ifindex in route tuple in the flowtable output path, from
   Lorenzo Bianconi.  This bug came in with the recent output path refactoring.

4) Prefer 'exit $ksft_xfail' over 'exit $ksft_skip' when we fail to
   trigger a nat race condition to exercise the clash resolution path in
   selftest infra, $ksft_skip should be reserved for missing tooling,
   From myself.

Please, pull these changes from:
The following changes since commit 6bcb7727d9e612011b70d64a34401688b986d6ab:

  Merge branch 'inet-frags-flush-pending-skbs-in-fqdir_pre_exit' (2025-12-10 01:15:33 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-12-10

for you to fetch changes up to b8a81b0ce539e021ac72825238aea1eb657000f0:

  selftests: netfilter: prefer xfail in case race wasn't triggered (2025-12-10 11:55:59 +0100)

----------------------------------------------------------------
netfilter pull request nf-25-12-10

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_conncount: fix leaked ct in error paths

Florian Westphal (1):
      selftests: netfilter: prefer xfail in case race wasn't triggered

Lorenzo Bianconi (1):
      netfilter: always set route tuple out ifindex

Slavin Liu (1):
      ipvs: fix ipv4 null-ptr-deref in route error path

 net/netfilter/ipvs/ip_vs_xmit.c                    |  3 +++
 net/netfilter/nf_conncount.c                       | 25 ++++++++++++----------
 net/netfilter/nf_flow_table_path.c                 |  4 +++-
 .../selftests/net/netfilter/conntrack_clash.sh     |  9 ++++----
 4 files changed, 24 insertions(+), 17 deletions(-)
