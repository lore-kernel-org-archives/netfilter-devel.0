Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498C37B40A;
	Sun, 27 Sep 2026 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546907; cv=none; b=idEf/SunDhaL4lbjYwOK2Cf16Lw+Gql7antgUtVLzwB3571+ccQ+VAdd8fAelmYGphvzH1NhjGW0Ehae++YdjnmAaFeHgFzNAlbI6l103H7t7BvdUvZ88IoHP9b5yifq3hAMODiaVZ4qADFWv67FyYNKyUlEEwClC75Xzb8bvY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546907; c=relaxed/simple;
	bh=ij8vfrEFQdjSgzIknZJVMVKOanx0UJWCsyX+bHDx4xU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PkfRGHEo8ClPxgsHcliJTFOIeq1S+ceIMNXiLTOtVow2ibKwL7hdTFJcxx5yZbmUDkof1JeKmm8axmisDtDeedAMEzoKOtz0lVTx3tdJlYQeFKRoWsnz8QkJxqVZjUdGEqR0OuJL3Vca0cAn2FIoR8sgGSrOfxqNOm/0ZWh7rnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t/LCiAr/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t/LCiAr/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546901;
	bh=KDTBsPIOmVtfNijhSGUsw6tFWU+BiXxGVcQd5iEjIWM=;
	h=From:To:Cc:Subject:Date:From;
	b=t/LCiAr/NDqsNqUuCBILBnh29gufQnrq24VbQuDeAI09ZIYcBsVgxek6HV4ReNlmu
	 2k+2JX6FXnHVNgGzk2FHGt1faKlqtUTPGJUvDDyvj+f8bNqCT1rjDrOFnxLOFZdIXM
	 EUZTlsWHzptX7Rux40dCLAd8B+ztSVNj4beV2OyPncryTHADLxd4kRfGXiR54c61mN
	 1mw+P/x5KztexoY/J8UASdkN44gHhPR4p2DSxiYXUblatx522R0tL9USrx30crSAvs
	 /S/VGK2l3kpQb3OJUyDo4R0do0h2y7GdCTaKfWL4/SB4M/397zVykUPu0PVnsVVtpI
	 J9JwXDG33TQow==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0610A603D8;
	Mon, 28 Sep 2026 00:08:20 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 00/11] Netfilter/IPVS fixes for net
Date: Mon, 28 Sep 2026 00:08:05 +0200
Message-ID: <20260927220816.268206-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter fixes for net:

1) Expand existing ipset fix for bitmap sets to disallow comments
   updates from kernel-side adds, from Florian Westphal.

2) Drop flowtable reference if nf_ct_netns_get() fails, otherwise
   flowtable cannot ever be removed, from Aohan Mei.

3) nft_rbtree GC should collect end elements that contained in
   this transaction batch, new or deleted elements are never
   expired. From Weiming Shi.

4) Restrict nf_nat_bpf so it does not set unknown NF_NAT_MANIP_*
   values, from Fernando F. Mancera.

5) Flowtable GC must skip flows that are pending hardware updates,
   generalize the PENDING flag and use it to inhibit GC.

6) Restore flowtable with ieee80211 which broke due to a relatively
   recent commit, which was pulled in by -stable, causing a regression
   in 6.18 kernels.

And the following IPVS fixes:

1) Prevent buffer overflow in IPVS sync reported by sashiko, it
   should only be reproducible on very old 2.6.x kernels,
   from Julian Anastasov.

2) Fix accounting of cache entries in IPVS LBLC for destinations,
   from Julian Anastasov.

3) Limit IPVS cache growth for LBLCR and LBLC schedulers,
   from Zhiling Zou.

4) Restrict IP_VS_CONN_F_ONE_PACKET for normal connections,
   do not allow to use it with templates. Also from Julian.

5) Sanitize flags in IPVS sync messages received in the backup.
   From Julian Anastasov.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-27

Thanks.

----------------------------------------------------------------

The following changes since commit 9c572a83037a7dcd653ba3a9cc468c16b857d0c9:

  net/sched: fix potential stack infoleak in em_text_dump() (2026-09-22 19:14:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-27

for you to fetch changes up to 5957f55e476000330f59193b607abcfc0e89d18a:

  netfilter: flowtable: restore ieee80211 forward path (2026-09-27 22:46:56 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-27

----------------------------------------------------------------
Aohan Mei (1):
      netfilter: nft_flow_offload: drop flowtable reference on init error path

Fernando Fernandez Mancera (1):
      netfilter: bpf: reject invalid NAT manipulation types

Florian Westphal (1):
      netfilter: ipset: do not update comments from kernel-side adds

Julian Anastasov (4):
      ipvs: fix buffer overflow when sending sync messages
      ipvs: fix missing counter decrement in lblc
      ipvs: do not create invisible templates
      ipvs: filter some flags received in the backup server

Pablo Neira Ayuso (2):
      netfilter: flowtable: generalize pending status bit
      netfilter: flowtable: restore ieee80211 forward path

Weiming Shi (1):
      netfilter: nft_set_rbtree: skip transaction elements during GC

Zhiling Zou (1):
      ipvs: bound LBLCR and LBLC cache growth

 include/linux/netdevice.h               |  3 ++
 include/net/netfilter/nf_flow_table.h   |  2 +-
 net/mac80211/iface.c                    |  7 +++++
 net/netfilter/ipset/ip_set_bitmap_gen.h |  2 +-
 net/netfilter/ipvs/ip_vs_conn.c         |  3 ++
 net/netfilter/ipvs/ip_vs_lblc.c         |  4 +++
 net/netfilter/ipvs/ip_vs_lblcr.c        |  3 ++
 net/netfilter/ipvs/ip_vs_sync.c         | 56 ++++++++++++++++++++++++++-------
 net/netfilter/nf_flow_table_core.c      |  7 ++++-
 net/netfilter/nf_flow_table_offload.c   | 14 +++------
 net/netfilter/nf_flow_table_path.c      |  3 ++
 net/netfilter/nf_nat_bpf.c              |  3 ++
 net/netfilter/nf_nat_core.c             |  5 +--
 net/netfilter/nft_flow_offload.c        |  7 ++++-
 net/netfilter/nft_set_rbtree.c          |  2 ++
 net/sched/act_ct.c                      |  2 +-
 16 files changed, 95 insertions(+), 28 deletions(-)
