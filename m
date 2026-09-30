Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC5C3EC810;
	Wed, 30 Sep 2026 07:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754118; cv=none; b=UdAHk24rgNUv1MBWwdISfxjGgqxIGJaPgmSqpw5RY4gSNv2AViWmjuUGYr++0/FLBwJ3/C0KgwtA9KNzvV+D/+ENap3YNU/e7X4+iVd/EesbBd5a113Al0ZU6HLiz9Bb3NIUkP4NN5Kud9VtQxSfWrkMM4mKLEeJDxVTFfTeamU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754118; c=relaxed/simple;
	bh=e5IGc1yzNvgMrn9KOinvg4QennMzgSuNUhLBeP+G8SY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SEm1J7zf1ktxv4BFIQK+qS5Ee5+kgNyJgBuSE0wRtz+zd+mkLiHSG++hSWHHY7Gakw5uHz9kbrGtcSb9s7z0z+dLlPtIxMjTEqVLORooX9qpaPRinK1fh12b9WA4fEBFCe/NxklAQ7sx9RF6wWFpsm72KnSwUyd4tNSjMn9kyhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=khNLGErr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="khNLGErr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790754106;
	bh=NDfGTh6zAumAy+7VUaNquZ8ROHMD9tlBWFhUPh/qDgE=;
	h=From:To:Cc:Subject:Date:From;
	b=khNLGErr1nEjSAZAZBa5bHb89kljKFUiyRmottcf/7ITUD1W7TnYclGWyc6sDpJfr
	 0rAmP+D8ZSulsFGy/VpOt1JyyxRJvRy7vXjYSVboUj/TMgLh6ppuCOhqD/0GfihnUo
	 e0dJ1vyap05QlzZNphjribD3aVQqfOhLLfe08/36QHNb9MaeXPgkry737tnXj75DmP
	 7Q7WFi/YTtXBtwxJoO+MH6yJT7xLiSQg5MjvBzMTte3vWFRc2ZzBHH6kNPKiVYOd1H
	 wHrSA2d5HcyAKkn1pbpw23mEh7PTV4SBgV0UIPZQVdjD8jxb7qlGRgq+i3cXsJqwJP
	 LBKwaf/3QrwlQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3DEC260054;
	Wed, 30 Sep 2026 09:41:46 +0200 (CEST)
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
Subject: [PATCH net,v2 00/10] Netfilter/IPVS fixes for net
Date: Wed, 30 Sep 2026 09:41:31 +0200
Message-ID: <20260930074142.298353-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: drop the patch 02/11 in previous PR as requested by Paolo Abeni.

-o-

The following batch contains Netfilter fixes for net. This batch
fixes crashes as recent feature regression, one of the due to a
dependency that has been pulled into -stable:
 
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
 
1) Fix accounting of cache entries in IPVS LBLC for destinations,
   which eventually fills up the table and trigger recurrent
   resizing, from Julian Anastasov.
 
2) Limit IPVS cache growth for LBLCR and LBLC schedulers,
   from Zhiling Zou.
 
3) Restrict IP_VS_CONN_F_ONE_PACKET for normal connections,
   do not allow to use it with templates. Also from Julian.
 
4) Sanitize flags in IPVS sync messages received in the backup.
   From Julian Anastasov.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-30

Thanks.

----------------------------------------------------------------

The following changes since commit 9c572a83037a7dcd653ba3a9cc468c16b857d0c9:

  net/sched: fix potential stack infoleak in em_text_dump() (2026-09-22 19:14:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-30

for you to fetch changes up to 3ae37eafd36694bb2d3227f60ac98fbf602470a2:

  netfilter: flowtable: restore ieee80211 forward path (2026-09-30 09:35:20 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-30

----------------------------------------------------------------
Aohan Mei (1):
      netfilter: nft_flow_offload: drop flowtable reference on init error path

Fernando Fernandez Mancera (1):
      netfilter: bpf: reject invalid NAT manipulation types

Florian Westphal (1):
      netfilter: ipset: do not update comments from kernel-side adds

Julian Anastasov (3):
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

 include/linux/netdevice.h               |  3 +++
 include/net/netfilter/nf_flow_table.h   |  2 +-
 net/mac80211/iface.c                    |  7 +++++++
 net/netfilter/ipset/ip_set_bitmap_gen.h |  2 +-
 net/netfilter/ipvs/ip_vs_conn.c         |  3 +++
 net/netfilter/ipvs/ip_vs_lblc.c         |  4 ++++
 net/netfilter/ipvs/ip_vs_lblcr.c        |  3 +++
 net/netfilter/ipvs/ip_vs_sync.c         | 33 ++++++++++++++++++++++++++++++---
 net/netfilter/nf_flow_table_core.c      |  7 ++++++-
 net/netfilter/nf_flow_table_offload.c   | 14 +++++---------
 net/netfilter/nf_flow_table_path.c      |  3 +++
 net/netfilter/nf_nat_bpf.c              |  3 +++
 net/netfilter/nf_nat_core.c             |  5 +++--
 net/netfilter/nft_flow_offload.c        |  7 ++++++-
 net/netfilter/nft_set_rbtree.c          |  2 ++
 net/sched/act_ct.c                      |  2 +-
 16 files changed, 81 insertions(+), 19 deletions(-)
