Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7DA210E3;
	Wed, 17 Jan 2024 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507249; cv=none; b=CkXyqPYoiqeibdgnPNhkQME39nb08HMnpToWIztsjpm47601wrUPhOtRAWTwMZK0JMm+0HGqNNCB3bqAHNq7DJdDnrw0j0cr3PBNxRrSTtm0FHYPZDEhWHVWsDrzTSeHH4HqtNCjU/i/vhxRyBchhmrK9uDKYzaHxM/fmhmujuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507249; c=relaxed/simple;
	bh=cTNDdHH6V1G0jQMFGRVtyP30a7wQ1dA/sZVBC4n4+VM=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=aMEW/FIQU7aLO8uTAuJd5XYVPyYqRWDTfyPqqwKnRSSP3oAzvyCO2s9KnfO3PDOALtyRhBdtfl9VKDL/WcpVSXfsSNT8DnjVgn69lgTj7vKeLjnj/ZrmuvMsg0Hzol8UiZl7LKTR7LrZ1wM10DsK6M3xSGlTdcYPvTvjMxtZq1I=
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
Subject: [PATCH net 00/14] Netfilter fixes for net
Date: Wed, 17 Jan 2024 17:00:16 +0100
Message-Id: <20240117160030.140264-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter fixes for net. Slightly larger
than usual because this batch includes several patches to tighten the
nf_tables control plane to reject inconsistent configuration:

1) Restrict NFTA_SET_POLICY to NFT_SET_POL_PERFORMANCE and
   NFT_SET_POL_MEMORY.

2) Bail out if a nf_tables expression registers more than 16 netlink
   attributes which is what struct nft_expr_info allows.

3) Bail out if NFT_EXPR_STATEFUL provides no .clone interface, remove
   existing fallback to memcpy() when cloning which might accidentally
   duplicate memory reference to the same object.

4) Fix br_netfilter interaction with neighbour layer. This requires
   three preparation patches:

   - Use nf_bridge_get_physinif() in nfnetlink_log
   - Use nf_bridge_info_exists() to check in br_netfilter context
     is available in nf_queue.
   - Pass net to nf_bridge_get_physindev()

   And finally, the fix which replaces physindev with physinif
   in nf_bridge_info.

   Patches from Pavel Tikhomirov.

5) Catch-all deactivation happens in the transaction, hence this
   oneliner to check for the next generation. This bug uncovered after
   the removal of the _BUSY bit, which happened in set elements back in
   summer 2023.

6) Ensure set (total) key length size and concat field length description
   is consistent, otherwise bail out.

7) Skip set element with the _DEAD flag on from the netlink dump path.
   A tests occasionally shows that dump is mismatching because GC might
   lose race to get rid of this element while a netlink dump is in
   progress.

8) Reject NFT_SET_CONCAT for field_count < 1, from Pavel Tikhomirov.

9) Use IP6_INC_STATS in ipvs to fix preemption BUG splat, patch
   from Fedor Pchelkin.

10) Fix a slow down due to synchronize_rcu() in ipset netlink interface
    with swap/destroy and kernel side add/del/test, from Jozsef Kadlecsik.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-01-17

Thanks.

----------------------------------------------------------------

The following changes since commit ea937f77208323d35ffe2f8d8fc81b00118bfcda:

  net: netdevsim: don't try to destroy PHC on VFs (2024-01-17 10:56:44 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-24-01-17

for you to fetch changes up to 080898f8e782734987f127c73a69ebeab7b5f5e8:

  netfilter: ipset: fix performance regression in swap operation (2024-01-17 12:02:52 +0100)

----------------------------------------------------------------
netfilter pull request 24-01-17

----------------------------------------------------------------
Fedor Pchelkin (1):
      ipvs: avoid stat macros calls from preemptible context

Jozsef Kadlecsik (1):
      netfilter: ipset: fix performance regression in swap operation

Pablo Neira Ayuso (8):
      netfilter: nf_tables: reject invalid set policy
      netfilter: nf_tables: validate .maxattr at expression registration
      netfilter: nf_tables: bail out if stateful expression provides no .clone
      netfilter: nft_limit: do not ignore unsupported flags
      netfilter: nf_tables: check if catch-all set element is active in next generation
      netfilter: nf_tables: do not allow mismatch field size and set key length
      netfilter: nf_tables: skip dead set elements in netlink dump
      netfilter: nf_tables: reject NFT_SET_CONCAT with not field length description

Pavel Tikhomirov (4):
      netfilter: nfnetlink_log: use proper helper for fetching physinif
      netfilter: nf_queue: remove excess nf_bridge variable
      netfilter: propagate net to nf_bridge_get_physindev
      netfilter: bridge: replace physindev with physinif in nf_bridge_info

 include/linux/netfilter/ipset/ip_set.h     |  2 ++
 include/linux/netfilter_bridge.h           |  6 ++--
 include/linux/skbuff.h                     |  2 +-
 net/bridge/br_netfilter_hooks.c            | 42 ++++++++++++++++++++++------
 net/bridge/br_netfilter_ipv6.c             | 14 +++++++---
 net/ipv4/netfilter/nf_reject_ipv4.c        |  9 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c        | 11 ++++++--
 net/netfilter/ipset/ip_set_core.c          | 31 +++++++++++++++------
 net/netfilter/ipset/ip_set_hash_netiface.c |  8 +++---
 net/netfilter/ipvs/ip_vs_xmit.c            |  4 +--
 net/netfilter/nf_log_syslog.c              | 13 +++++----
 net/netfilter/nf_queue.c                   |  6 ++--
 net/netfilter/nf_tables_api.c              | 44 +++++++++++++++++++++---------
 net/netfilter/nfnetlink_log.c              |  8 +++---
 net/netfilter/nft_limit.c                  | 19 ++++++++-----
 net/netfilter/xt_physdev.c                 |  2 +-
 16 files changed, 150 insertions(+), 71 deletions(-)
