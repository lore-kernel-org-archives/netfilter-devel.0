Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57FCD30B;
	Thu, 13 Jun 2024 01:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240540; cv=none; b=MJ42/cBkUjekIWHLeyu1+QVxWM0TSXOuNV4v6aTtVHAJfbJlUWeVMD9Lff/iTjfXCVDqyFgqEFXP0CCPCQKSPRr+utouBo+PABhvQTCmFPSsHtyte5U3sWJda3+yKvAUQU6jh62mRWoNy6KBigujhxJtEZplKsAln1RqusNODaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240540; c=relaxed/simple;
	bh=2dJuckz3yorBpwcuXcD0Q4iaaPHoFmIoH4i94c3bUNM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HT0E1ckfoolVfdbJblwTXVe/pjuJtqkzwI2Chlw97DFXgTqyIce6lQ4ucuRUpN7L7UAxcouX13v28WUMtIPuKPkKRMdHDNmmg6pno68XibHjhwhlecEnw2KCkcPsrEUWLo+Xo41AxyzWnvLia76N9GTgg60bPWBIvY2vbLQu7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 00/40] Netfilter fixes for -stable
Date: Thu, 13 Jun 2024 03:01:29 +0200
Message-Id: <20240613010209.104423-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This round includes pending -stable backport fixes for 4.19.

This large batch includes dependency patches and fixes which are
already present in -stable kernels >= 5.4.x but not in 4.19.x.

The following list shows the backported patches, I am using original
commit IDs for reference:

1) 0c2a85edd143 ("netfilter: nf_tables: pass context to nft_set_destroy()")

2) f8bb7889af58 ("netfilter: nftables: rename set element data activation/deactivation functions")

3) 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")

4) 3b18d5eba491 ("netfilter: nft_set_rbtree: allow loose matching of closing element in interval")

5) 340eaff65116 ("netfilter: nft_set_rbtree: Add missing expired checks")

6) c9e6978e2725 ("netfilter: nft_set_rbtree: Switch to node list walk for overlap detection")

7) 61ae320a29b0 ("netfilter: nft_set_rbtree: fix null deref on element insertion")

8) f718863aca46 ("netfilter: nft_set_rbtree: fix overlap expiration walk")

9) 24138933b97b ("netfilter: nf_tables: don't skip expired elements during walk")

10) 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")

11) f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")

12) a2dd0233cbc4 ("netfilter: nf_tables: remove busy mark and gc batch API")

13) 6a33d8b73dfa ("netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path")

14) 02c6c24402bf ("netfilter: nf_tables: GC transaction race with netns dismantle")

15) 720344340fb9 ("netfilter: nf_tables: GC transaction race with abort path")

16) 8e51830e29e1 ("netfilter: nf_tables: defer gc run if previous batch is still pending")

17) 2ee52ae94baa ("netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction")

18) 96b33300fba8 ("netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention")

19) b079155faae9 ("netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration")

20) cf5000a7787c ("netfilter: nf_tables: fix memleak when more than 255 elements expired")

21) 6069da443bf6 ("netfilter: nf_tables: unregister flowtable hooks on netns exit")

22) f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")

23) 0ce7cf4127f1 ("netfilter: nftables: update table flags from the commit phase")

24) 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")

25) c9bd26513b3a ("netfilter: nf_tables: disable toggling dormant table state more than once")

26) ("netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 4.19)")
    NB: This patch does not exist in any upstream tree, but there is a similar patch already in 5.4

27) 917d80d376ff ("netfilter: nft_dynset: fix timeouts later than 23 days")

28) fd94d9dadee5 ("netfilter: nftables: exthdr: fix 4-byte stack OOB write")

29) 95cd4bca7b1f ("netfilter: nft_dynset: report EOPNOTSUPP on missing set feature")

30) 7b1394892de8 ("netfilter: nft_dynset: relax superfluous check on set updates")

31) 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on transaction abort")

32) 6b1ca88e4bb6 ("netfilter: nf_tables: skip dead set elements in netlink dump")

33) d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")

34) 60c0c230c6f0 ("netfilter: nft_set_rbtree: skip end interval element from gc")

35) bccebf647017 ("netfilter: nf_tables: set dormant flag on hook register failure")

36) 7e0f122c6591 ("netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()")

37) 4a0e7f2decbf ("netfilter: nf_tables: do not compare internal table flags on updates")

38) 552705a3650b ("netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout")

39) 994209ddf4f4 ("netfilter: nf_tables: reject new basechain after table flag update")

40) 1bc83a019bbe ("netfilter: nf_tables: discard table flag update with pending basechain deletion")

Please, apply.
Thanks.

Florian Westphal (4):
  netfilter: nf_tables: defer gc run if previous batch is still pending
  netfilter: nftables: exthdr: fix 4-byte stack OOB write
  netfilter: nf_tables: mark newset as dead on transaction abort
  netfilter: nf_tables: set dormant flag on hook register failure

Ignat Korchagin (1):
  netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()

Pablo Neira Ayuso (34):
  netfilter: nf_tables: pass context to nft_set_destroy()
  netfilter: nftables: rename set element data activation/deactivation functions
  netfilter: nf_tables: drop map element references from preparation phase
  netfilter: nft_set_rbtree: allow loose matching of closing element in interval
  netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
  netfilter: nft_set_rbtree: fix null deref on element insertion
  netfilter: nft_set_rbtree: fix overlap expiration walk
  netfilter: nf_tables: don't skip expired elements during walk
  netfilter: nf_tables: GC transaction API to avoid race with control plane
  netfilter: nf_tables: adapt set backend to use GC transaction API
  netfilter: nf_tables: remove busy mark and gc batch API
  netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
  netfilter: nf_tables: GC transaction race with netns dismantle
  netfilter: nf_tables: GC transaction race with abort path
  netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
  netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
  netfilter: nft_set_hash: try later when GC hits EAGAIN on iteration
  netfilter: nf_tables: fix memleak when more than 255 elements expired
  netfilter: nf_tables: unregister flowtable hooks on netns exit
  netfilter: nf_tables: double hook unregistration in netns path
  netfilter: nftables: update table flags from the commit phase
  netfilter: nf_tables: fix table flag updates
  netfilter: nf_tables: disable toggling dormant table state more than once
  netfilter: nf_tables: bogus EBUSY when deleting flowtable after flush (for 4.19)
  netfilter: nft_dynset: fix timeouts later than 23 days
  netfilter: nft_dynset: report EOPNOTSUPP on missing set feature
  netfilter: nft_dynset: relax superfluous check on set updates
  netfilter: nf_tables: skip dead set elements in netlink dump
  netfilter: nf_tables: validate NFPROTO_* family
  netfilter: nft_set_rbtree: skip end interval element from gc
  netfilter: nf_tables: do not compare internal table flags on updates
  netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
  netfilter: nf_tables: reject new basechain after table flag update
  netfilter: nf_tables: discard table flag update with pending basechain deletion

Phil Sutter (1):
  netfilter: nft_set_rbtree: Add missing expired checks

 include/net/netfilter/nf_tables.h        | 132 +++---
 include/uapi/linux/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c            | 529 +++++++++++++++++++----
 net/netfilter/nft_chain_filter.c         |   3 +
 net/netfilter/nft_compat.c               |  32 ++
 net/netfilter/nft_dynset.c               |  24 +-
 net/netfilter/nft_exthdr.c               |  14 +-
 net/netfilter/nft_flow_offload.c         |   5 +
 net/netfilter/nft_nat.c                  |   5 +
 net/netfilter/nft_rt.c                   |   5 +
 net/netfilter/nft_set_bitmap.c           |   5 +-
 net/netfilter/nft_set_hash.c             | 111 +++--
 net/netfilter/nft_set_rbtree.c           | 387 ++++++++++++++---
 net/netfilter/nft_socket.c               |   5 +
 net/netfilter/nft_tproxy.c               |   5 +
 15 files changed, 977 insertions(+), 286 deletions(-)

-- 
2.30.2

