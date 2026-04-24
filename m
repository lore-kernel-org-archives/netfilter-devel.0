Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02993E3172;
	Fri, 24 Apr 2026 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057527; cv=none; b=bJdp4fg5fDmBw3pKEkX9x2js387DuN3lh+I7F2Khb2pp9z5SH7H4ej2yMFG2POS/yXHJORAG34TNLupkbLP/7Auc8JIpPsGVQ+aJ3gycQMPX5lVgH4C9qsl63g1xqXBL6HuYXrLjUruqtXzusXK9qrxlKNjJl5IA4H9kvmgTp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057527; c=relaxed/simple;
	bh=Ad5r06sCwO1/aatRHb6He45AvYPfO9m5ELuf+y2fzwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xf8SoBKRdMFutoBn0Qpivm+isij64GokQdj5HsB6OCF0+3dnTXZNHCa9bKlEX4STCFBhVNzPcwVqJ4FoayP4yCch8ekFdiccimr96HCcuB0ltNKuamEjLzpodVra0u4To7FooQEZhh0eYcb+a4JVorCNTVVR24a/Avs/8awTx3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tYeZBxP9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tYeZBxP9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DA68760178;
	Fri, 24 Apr 2026 21:05:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777057522;
	bh=/0/KtJBrhZnTGCQeHQRR7kXaLmPrAka7XZTGDprQ2YI=;
	h=From:To:Cc:Subject:Date:From;
	b=tYeZBxP9Aez6teFhmWoiCcNHcTr/B2Bprt2ecU7x8MDUF8xdMNH8o6KNRjayUhOQa
	 uEuJk2hSggijVLsDYykpDqod54n+KK1+eg78lJWOAI/vuC5j8LJpSU2/U0850VnC8l
	 oh4qnlvfpEUOoU9JC/nmskufoIan0L9d+4CsUaOoJ+nKbvsgSOy8Xl9D6AbB9FEqWz
	 W3Yr3qtEVNyqviyzT/0D2f7VQyDkVrous3hUccl8YIyeZPANcB1viqrpvN4zacA8a1
	 28XTJZk3HSOKpA4+PNqzqkcnLsho7/2YFaKRoLVN/KNfwOSxQwTTIcQdV6ufigLnCy
	 LQu6lawFFyqGQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/11] Netfilter/IPVS fixes for net
Date: Fri, 24 Apr 2026 21:05:02 +0200
Message-ID: <20260424190513.32823-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) IEEE1394 ARP payload contains no target hardware address in the
   ARP packet. Apparently, arp_tables was never updated to deal with
   IEEE1394 ARP properly. To deal with this, return no match in case
   the target hardware address selector is used, either for inverse or
   normal match. Moreover, arpt_mangle disallows mangling of the target
   hardware and IP address because, it is not worth to adjust the
   offset calculation to fix this, we suspect no users of arp_tables
   for this family.

2) Use list_del_rcu() to delete device hooks in nf_tables, this hook
   list is RCU protected, concurrent netlink dump readers can be
   walking on this list, fix it by adding a helper function and use it
   for consistency. From Florian Westphal.

3) Add list_splice_rcu(), this is useful for joining the local list of
   new device hooks to the RCU protected hook list in chain and
   flowtable. Reviewed by Paul E. McKenney.

4) Use list_splice_rcu() to publish the new device hooks in chain and
   flowtable to fix concurrent netlink dump traversal.

5) Add a new hook transaction object to track device hook deletions.
   The current approach moves device hooks to be deleted around during
   the preparation phase, this breaks concurrent RCU reader via netlink
   dump. This new hook transaction is combined with NFT_HOOK_REMOVE
   flag to annotate hooks for removal in the preparation phase.

6) xt_policy inbound policy check in strict mode can lead to
   out-of-bound access of the secpath array due to incorrect.
   The iteration over the secpath needs to be reversed in the inbound
   to check for the human readable policy, expecting inner in first
   position and outer in second position, the secpath from inbound
   actually stores outer in first position then in second position.
   From Jiexun Wang.

7) Fix possible zero shift in nft_bitwise triggering UBSAN splat,
   reject zero shift from control plane, from Kai Ma.

8) Replace simple_strtoul() in the conntrack SIP helper since it relies
   on nul-terminated strings. From Florian Westphal.

The IPVS fixes for recent net-next updates, from Julian Anastasov:

9) Fix several issues in the new /proc/net/ip_vs_status interface:
   prevent use-after-free by properly updating svc_table_changes
   during service deletion/flushing; bound bucket traversal and add
   loop detection to prevent infinite loops and overflows; use div_u64
   for safer 32-bit math; and restrict file permissions to 0440 to
   protect hash distribution info from non-root users.

10) Fix a race condition between the sysctl interface and the teardown
    of IPVS hash tables. Specifically, it prevents the system from
    trying to schedulework on a table that has already been destroyed.

11) Fix sleeping function called from invalid context bug. On RT
    kernels, standard spinlocks can sleep, but "bit locks" (used by the
    new hash table) do not. Holding a sleeping lock while a non-sleeping
    bit lock is held is illegal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-24

Thanks.

----------------------------------------------------------------

The following changes since commit 711987ba281fd806322a7cd244e98e2a81903114:

  netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check (2026-04-20 23:45:44 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-24

for you to fetch changes up to b51edb039b1dbcdc83e00c31cf5887bd75486dcc:

  ipvs: fix the spin_lock usage for RT build (2026-04-24 20:09:57 +0200)

----------------------------------------------------------------
netfilter pull request 26-04-24

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: use list_del_rcu for netlink hooks
      netfilter: nf_conntrack_sip: don't use simple_strtoul

Jiexun Wang (1):
      netfilter: xt_policy: fix strict mode inbound policy matching

Julian Anastasov (3):
      ipvs: fixes for the new ip_vs_status info
      ipvs: fix races around the conn_lfactor and svc_lfactor sysctl vars
      ipvs: fix the spin_lock usage for RT build

Kai Ma (1):
      netfilter: reject zero shift in nft_bitwise

Pablo Neira Ayuso (4):
      netfilter: arp_tables: fix IEEE1394 ARP payload parsing
      rculist: add list_splice_rcu() for private lists
      netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
      netfilter: nf_tables: add hook transactions for device deletions

 include/linux/rculist.h           |  29 ++++
 include/net/netfilter/nf_tables.h |  13 ++
 net/ipv4/netfilter/arp_tables.c   |  18 ++-
 net/ipv4/netfilter/arpt_mangle.c  |   8 +
 net/netfilter/ipvs/ip_vs_conn.c   |  71 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c    |  63 +++++---
 net/netfilter/nf_conntrack_sip.c  | 152 +++++++++++++-----
 net/netfilter/nf_nat_sip.c        |   1 +
 net/netfilter/nf_tables_api.c     | 314 +++++++++++++++++++++++++++-----------
 net/netfilter/nft_bitwise.c       |   3 +-
 net/netfilter/xt_policy.c         |   2 +-
 11 files changed, 494 insertions(+), 180 deletions(-)
