Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471F341AB8;
	Fri, 10 Jul 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694274; cv=none; b=IAyZaS7BupRMUKFcnnjXQfGKgQF6lYj74IpNCTLUzhq7FcfOH5Q7wo94ZEFmrUyaIcAbfopiDCdKSCBAOp4ABefjpkoulK19+2BJpWTZRI3noQbwcvZ1jD2Hvfv4IRjwoq0hNG7fVgDW3AP8ddrftUy1sNHPzEs2Qqb8ddn/FRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694274; c=relaxed/simple;
	bh=lveKF/lgznwoXUuYbgg5NoUa8Lq2ohx7aF9CTjCyI60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MpOAC+u2UQ0PK6zyO57NgtbrrJdw3ZTkdO+G4GBgClZDafl1KxpMKuMIyUkIrXRoenJr1TQWmqUy6o3SwCzqOzT+SiraWtVMrid1/bY7mj6/XE7OU4mIID6hZtO8AWaSYXZuE2XW9feSVrajFa1CtmrkdhAI3ZD3J+Sdvr0rnlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C4E9A60491; Fri, 10 Jul 2026 16:37:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/9] netfilter: updates for net
Date: Fri, 10 Jul 2026 16:37:24 +0200
Message-ID: <20260710143733.29741-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*.
These are fixes for bugs except patches 6 and 9 which fix issues added in
last PR and 7.1-rc1.

1) Reject unsupported target families in xt_nat_checkentry().
From Wyatt Feng.

2) Fix inverted time_after() check in ecache_work_evict_list().
Causes pointless work rescheds and thus way longer time to
clear the pending event backlog. From Yizhou Zhao.

3) Fix a use-after-free in br_ip6_fragment() caused by a dangling prevhdr
pointer.  From Xiang Mei.

4) Fix incorrect conntrack zone comparison in nf_conncount tuple
deduplication. Pass IP_CT_DIR_ORIGINAL, not zone direction.
From Yizhou Zhao.

5) Add bridge tunnel flowtable regression test for a bug that
   got fixed in the previous PR.  From Zhengyang Chen.

6) Use the correct direction when setting up tunnel routes in the flowtable
xmit path.  From Pablo Neira Ayuso.  This fixes a bug added in the
previous PR.

7) Reload IP header after potential skb head reallocation in IPVS.

8) Fix incorrect IPv6 transport offsets in TCP application code. Correct the
ICMPv6 header offset to ensure proper checksumming with extension headers,
from Julian Anastasov.  this is a followup to the previous PR.

9) Remove null-termination requirement for xt_physdev masks, this broke
   device names with 15 characters.

Please, pull these changes from:
The following changes since commit 4fa349156043dc119721d067329714179f501749:

  net/iucv: take a reference on the socket found in afiucv_hs_rcv() (2026-07-10 16:24:43 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-07-10

for you to fetch changes up to f468c48d488d0ea2df3422b3e1dfafae1611e853:

  netfilter: xt_physdev: masks are not c-strings (2026-07-10 16:28:47 +0200)

----------------------------------------------------------------
netfilter pull request nf-26-07-10

----------------------------------------------------------------
Florian Westphal (2):
  ipvs: reload ip header after head reallocation
  netfilter: xt_physdev: masks are not c-strings

Julian Anastasov (1):
  ipvs: fix more places with wrong ipv6 transport offsets

Pablo Neira Ayuso (1):
  netfilter: flowtable: use correct direction to set up tunnel route

Wyatt Feng (1):
  netfilter: xt_nat: reject unsupported target families

Xiang Mei (Microsoft) (1):
  netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()

Yizhou Zhao (2):
  netfilter: ecache: fix inverted time_after() check
  netfilter: nf_conncount: fix zone comparison in tuple dedup

Zhengyang Chen (1):
  selftests: netfilter: add bridge tunnel flowtable regression

 net/ipv6/netfilter.c                          |  4 +-
 net/netfilter/ipvs/ip_vs_app.c                | 10 ++--
 net/netfilter/ipvs/ip_vs_core.c               |  3 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |  6 +-
 net/netfilter/nf_conncount.c                  |  6 +-
 net/netfilter/nf_conntrack_ecache.c           |  2 +-
 net/netfilter/nf_flow_table_core.c            |  6 +-
 net/netfilter/xt_nat.c                        |  9 +++
 net/netfilter/xt_physdev.c                    |  5 --
 .../selftests/net/netfilter/nft_flowtable.sh  | 55 +++++++++++++++++++
 10 files changed, 81 insertions(+), 25 deletions(-)

-- 
2.54.0
