Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F262D9EDB;
	Wed, 28 Jan 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614922; cv=none; b=kll0qEtY0+EkqIIrVrANqa/+tvTB9lDCOHqVGWG10JQNlPkcEzc5AlFkney1gmV4Kq4h6Tn1qGSTkk6qKPLDRVFsx+BYK7HJnMVd6a3KYml9Ieic8SYw4q7tfQ4P/7p792SZNUlFsoqa4fbI3OhE8VZiTui8CXaVIWV3thEz4wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614922; c=relaxed/simple;
	bh=UXwJBXzoRVPAwW4gySv934q5snc/aJEijnpgR+Jq88E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WhGoJf1brJn0ikvdCa4DyZY1Xv+/e2HstBy1u2ZAFTnwa6fV2GK5RfTvIHusKMLa4JN/O0euBYRvLraeTxWd+nW1vr472fwx+VOsa9dvLClV21diuZvbKJ71839acyZkCempv7HVKperqpKf8D8ZnSdJmCjutE0kP5a8GoZqQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 75C8860520; Wed, 28 Jan 2026 16:41:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/9] netfilter: updates for net-next
Date: Wed, 28 Jan 2026 16:41:46 +0100
Message-ID: <20260128154155.32143-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net-next*:

Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
infrastructure.  Patch 5 extends test coverage for this.
From Lorenzo Bianconi.

Patch 6 removes a duplicated helper from xt_time extension, we can
use an existing helper for this, from Jinjie Ruan.

Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
verdict processing.  Before this list walk was required due to in-order
design assumption.

Patch 8 fixes an esoteric packet-drop problem with UDPGRO and nfqueue added
in v6.11. Patch 9 adds a test case for this.

Please, pull these changes from:
The following changes since commit 239f09e258b906deced5c2a7c1ac8aed301b558b:

  selftests: ptp: treat unsupported PHC operations as skip (2026-01-27 17:57:28 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-01-28

for you to fetch changes up to f0ba90068f33a2d18fa4cc848ea7477d489194bf:

  selftests: netfilter: nft_queue.sh: add udp fraglist gro test case (2026-01-28 16:29:55 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-01-28

----------------------------------------------------------------
Florian Westphal (2):
  netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
  selftests: netfilter: nft_queue.sh: add udp fraglist gro test case

Jinjie Ruan (1):
  netfilter: xt_time: use is_leap_year() helper

Lorenzo Bianconi (5):
  netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
  netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
  netfilter: flowtable: Add IP6IP6 rx sw acceleration
  netfilter: flowtable: Add IP6IP6 tx sw acceleration
  selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest

Scott Mitchell (1):
  netfilter: nfnetlink_queue: optimize verdict lookup with hash table

 include/net/netfilter/nf_queue.h              |   4 +
 net/ipv6/ip6_tunnel.c                         |  27 ++
 net/netfilter/nf_flow_table_ip.c              | 243 +++++++++++++---
 net/netfilter/nfnetlink_queue.c               | 263 ++++++++++++------
 net/netfilter/xt_time.c                       |   8 +-
 .../selftests/net/netfilter/nft_flowtable.sh  |  62 ++++-
 .../selftests/net/netfilter/nft_queue.sh      | 142 +++++++++-
 7 files changed, 612 insertions(+), 137 deletions(-)
-- 
2.52.0
