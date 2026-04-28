Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1193D3485;
	Tue, 28 Apr 2026 09:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370331; cv=none; b=MRU48vMOydukieucw9MaWVYJrh4DCY2H8eleJWLPE3/XDgbOSQx3VtbYPUHzmMO0ZQm6kJNWqfs6xjE7ep8nqtIc6HAH2uiV8pTWgW0a6/EHE/wcn2EeC6XxOi+qE/Sbdn9GI+b6e0cDF1P4J131nZLbMeyAfdl3Sv7Y+t8P98c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370331; c=relaxed/simple;
	bh=t3+bEsDaz7g54CbeOixB4iyx0PvcqR96DczMMd/fMdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aMPhKv5zu5BX10fPWvZVHkLMYuKSSy+CAvfcMKGS2Q0ZU7/2ZFHOLPcnBkjAZTngLjddvbZ0R5x4rcUw3FY3GN7u/g3dINPK5pt3G4IzBNSPHmJzsSrwOx71T6Mj4GSU8oXYBEvXqURXDkxB3pNapeqhGxRHvIB7849/jlpVA9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C/CNnYTS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C/CNnYTS"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D7D666017E;
	Tue, 28 Apr 2026 11:58:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777370325;
	bh=xKpqR2VzDX1pX8BEavzzwMG8vcSMDz76g5T9oKBwMYg=;
	h=From:To:Cc:Subject:Date:From;
	b=C/CNnYTSa3uncY5OAU8HrsPME5tun+QExSnLwDpWXq9WNrNbmnovvkIzPu741g7ud
	 B2UVmQMWVDD9J72lMpmB0x3WKObXYZL0oU2bj8TIeDx+65lx2blSsOcf8nfvoEpHas
	 pgrVCK+/15iyTzXxzNV6MfIXvBCrkKhnocDuQkjRQkhn66UHDGZZ2Sd4CaQMuMOaNd
	 LK5bmM96T5MXNx2WAq8QDH31i4PQpcmPNDtyIvNBztVVJJvibCvLNLqDWDtgmbnG8A
	 sPtch9gPE2Uqi4cuCf/L4q841LM9ajI41bT75X0VL6qCj1Vwm3fso+VrsAuVGBc72i
	 XltC3lnqwFeaA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v2 0/8] Netfilter fixes for net
Date: Tue, 28 Apr 2026 11:58:31 +0200
Message-ID: <20260428095840.51961-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reposting this PR without IPVS fixes:

https://patchwork.kernel.org/project/netdevbpf/patch/20260424190513.32823-1-pablo@netfilter.org/

until the remaining issues are addressed.

-o-

Hi,

The following patchset contains Netfilter fixes for net:

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

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-04-28

Thanks.

----------------------------------------------------------------

The following changes since commit 711987ba281fd806322a7cd244e98e2a81903114:

  netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check (2026-04-20 23:45:44 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-04-28

for you to fetch changes up to 8cf6809cddcbe301aedfc6b51bcd4944d45795f6:

  netfilter: nf_conntrack_sip: don't use simple_strtoul (2026-04-24 20:09:57 +0200)

----------------------------------------------------------------
netfilter pull request 26-04-28

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: use list_del_rcu for netlink hooks
      netfilter: nf_conntrack_sip: don't use simple_strtoul

Jiexun Wang (1):
      netfilter: xt_policy: fix strict mode inbound policy matching

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
 net/netfilter/nf_conntrack_sip.c  | 152 +++++++++++++-----
 net/netfilter/nf_nat_sip.c        |   1 +
 net/netfilter/nf_tables_api.c     | 314 +++++++++++++++++++++++++++-----------
 net/netfilter/nft_bitwise.c       |   3 +-
 net/netfilter/xt_policy.c         |   2 +-
 9 files changed, 412 insertions(+), 128 deletions(-)
