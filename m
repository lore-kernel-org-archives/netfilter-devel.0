Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316F277F36;
	Wed, 24 Jan 2024 19:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123576; cv=none; b=aO8mcdAe/X5m6z4j3rX02mGnrVUi8VLQiQT4N0Fr7P8xQVnOVJPOrQx+RngHKouktT6v2sq5V6N+ENrPkdYyH8bq1pqcVpKAKJYXN9FUKebbMqRMcXfkL6XLZWzmWjw2Ajc2goGa+3h1kof0gkQNCOcnIMhp/x7OYABcKFXMRQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123576; c=relaxed/simple;
	bh=dYx6o0GIqQWcgKk4c2PvW3pTFG+/KNbrMBj8sn2rb4M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ic4qOHsNe+Ji3vcjoRrj5ciJAc7QejLBjwBjkkOi+I6cY3ew6jew2nVvN2gAtxXapWepE26+aoeiJlsS46cvkmLCf72gWdqpANnOdGcaU42/6mHFdfwt/2PHRsZoQ9jO4NfCvbHX77M/xQf0laf3if4NENq4P/ikTL0tiBVhNVA=
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
Subject: [PATCH net 0/6] Netfilter fixes for net
Date: Wed, 24 Jan 2024 20:12:42 +0100
Message-Id: <20240124191248.75463-1-pablo@netfilter.org>
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

1) Update nf_tables kdoc to keep it in sync with the code, from George Guo.

2) Handle NETDEV_UNREGISTER event for inet/ingress basechain.

3) Reject configuration that cause nft_limit to overflow, from Florian Westphal.

4) Restrict anonymous set/map names to 16 bytes, from Florian Westphal.

5) Disallow to encode queue number and error in verdicts. This reverts
   a patch which seems to have introduced an early attempt to support for
   nfqueue maps, which is these days supported via nft_queue expression.

6) Sanitize family via .validate for expressions that explicitly refer
   to NF_INET_* hooks.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-01-24

Thanks.

----------------------------------------------------------------

The following changes since commit 32f2a0afa95fae0d1ceec2ff06e0e816939964b8:

  net/sched: flower: Fix chain template offload (2024-01-24 01:33:59 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-01-24

for you to fetch changes up to d0009effa8862c20a13af4cb7475d9771b905693:

  netfilter: nf_tables: validate NFPROTO_* family (2024-01-24 20:02:40 +0100)

----------------------------------------------------------------
netfilter pull request 24-01-24

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: nft_limit: reject configurations that cause integer overflow
      netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
      netfilter: nf_tables: reject QUEUE/DROP verdict parameters

George Guo (1):
      netfilter: nf_tables: cleanup documentation

Pablo Neira Ayuso (2):
      netfilter: nft_chain_filter: handle NETDEV_UNREGISTER for inet/ingress basechain
      netfilter: nf_tables: validate NFPROTO_* family

 include/net/netfilter/nf_tables.h | 49 +++++++++++++++++++++++++++++++--------
 net/netfilter/nf_tables_api.c     | 20 ++++++++--------
 net/netfilter/nft_chain_filter.c  | 11 +++++++--
 net/netfilter/nft_compat.c        | 12 ++++++++++
 net/netfilter/nft_flow_offload.c  |  5 ++++
 net/netfilter/nft_limit.c         | 23 ++++++++++++------
 net/netfilter/nft_nat.c           |  5 ++++
 net/netfilter/nft_rt.c            |  5 ++++
 net/netfilter/nft_socket.c        |  5 ++++
 net/netfilter/nft_synproxy.c      |  7 ++++--
 net/netfilter/nft_tproxy.c        |  5 ++++
 net/netfilter/nft_xfrm.c          |  5 ++++
 12 files changed, 121 insertions(+), 31 deletions(-)
