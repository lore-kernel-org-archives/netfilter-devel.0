Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3E535894;
	Wed, 14 Aug 2024 22:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674052; cv=none; b=c9XQS8M1SqhOLEyCPqEx+MduFq2aJc3oPytfP5yOmLGUWNpmsLdJXa7BnFypmUoxz0frVdBCpJycWK5G0LQjyTntOmMdBHFW056E1y7n6bwuBFUcxRz20AmbPrXsL31GpTSJl6N9me5unDs4IqnevIu4A+1aTFi7v7kax/1lTZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674052; c=relaxed/simple;
	bh=64+IuF3L/P+ii0pf83OmtJri/7oxvWcUZXcQgl54M0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ieylrHjcQBGY6e2VGyDVIk2ZyV4lN4xAu4CVHJEPHgsVAtU3gaeoMizY8EfTU/as1skNDiroXB38/Dkw6KfBCT2I+A8Tj2ZTUcyE7oVX/mK1o244FTyOmKAV4aOZGVzXyp7EBUAsvEc1YOjpXR7kMs72Kl4Vpshk46s7Qf+2nbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 0/8] Netfilter fixes for net
Date: Thu, 15 Aug 2024 00:20:34 +0200
Message-Id: <20240814222042.150590-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for net:

1) Ignores ifindex for types other than mcast/linklocal in ipv6 frag
   reasm, from Tom Hughes.

2) Initialize extack for begin/end netlink message marker in batch,
   from Donald Hunter.

3) Initialize extack for flowtable offload support, also from Donald.

4) Dropped packets with cloned unconfirmed conntracks in nfqueue,
   later it should be possible to explore lookup after reinject but
   Florian prefers this approach at this stage. From Florian Westphal.

5) Add selftest for cloned unconfirmed conntracks in nfqueue for
   previous update.

6) Audit after filling netlink header successfully in object dump,
   from Phil Sutter.

7-8) Fix concurrent dump and reset which could result in underflow
     counter / quota objects.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-08-15

Thanks.

----------------------------------------------------------------

The following changes since commit a2cbb1603943281a604f5adc48079a148db5cb0d:

  tcp: Update window clamping condition (2024-08-14 10:50:49 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-08-15

for you to fetch changes up to bd662c4218f9648e888bebde9468146965f3f8a0:

  netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests (2024-08-14 23:44:55 +0200)

----------------------------------------------------------------
netfilter pull request 24-08-15

----------------------------------------------------------------
Donald Hunter (2):
      netfilter: nfnetlink: Initialise extack before use in ACKs
      netfilter: flowtable: initialise extack before use

Florian Westphal (2):
      netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
      selftests: netfilter: add test for br_netfilter+conntrack+queue combination

Phil Sutter (3):
      netfilter: nf_tables: Audit log dump reset after the fact
      netfilter: nf_tables: Introduce nf_tables_getobj_single
      netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests

Tom Hughes (1):
      netfilter: allow ipv6 fragments to arrive on different devices

 net/bridge/br_netfilter_hooks.c                    |   6 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   4 +
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nf_tables_api.c                      | 147 ++++++++++++++-------
 net/netfilter/nfnetlink.c                          |   5 +-
 net/netfilter/nfnetlink_queue.c                    |  35 ++++-
 tools/testing/selftests/net/netfilter/Makefile     |   1 +
 .../selftests/net/netfilter/br_netfilter_queue.sh  |  78 +++++++++++
 8 files changed, 228 insertions(+), 50 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
