Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB155370D6B;
	Thu, 23 Jul 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824779; cv=none; b=b+Lhs+qROhWApFh6uPVFBMgr3dtMkN5IaIvUbmsDCjYIrW9qVK9PUUBIyNXxALmLqZEmtfdWTT9g+/xW+hNZgPsldZNH9ZLLEHkzWn0ZlP6MIUOGLA9wkvF0TtmukIrQ35O1+GKUFf37fkxWB+0BlIwIZlHGtORvyIFuGxEx/WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824779; c=relaxed/simple;
	bh=JTz0XnnBtPGNwIR/dYQOFxfR6E3mNbUiR/TNMTMFoHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Uqk2Ac0erlw9ttMWBhTb5uUZEmch6zgcd0tzQFVOhwrV6PlhYx5reHbgDMcM7QQSVv0uVREPVs+eJMjtXSf+cRaMNo1nfM+Ilttmp3emHEAYnGWQJxRN9yF6cSTULVAwZRlu10+vBZN8N7XTz2x/Q23WSIHhtnEy366VaWtLC2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kbDQ172r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kbDQ172r"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 411E560192;
	Thu, 23 Jul 2026 18:39:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824764;
	bh=JVd8ZlG0HD5YnOhuinoeHXiSdb+326ggkmUCekhbvus=;
	h=From:To:Cc:Subject:Date:From;
	b=kbDQ172rC6+P13Ct3S0e3ZzqIuva37BkkET3lt3zLfC049shoWAHZhVzgcndX0sYZ
	 fxigpI4beI7PeDxSwNjskCBxb5GIXFpOxJXTX4auqaT4OtGi5+yWptwbeKAmjouGsO
	 Fgf1Y+ew5vyfxss00XEv6Dic3F5zaz7X2jOfznT/6UFcrRn29lAeIagjMsJYqU9p2l
	 oYm7hKI8xN0N55Tke2Bzv1qEAfZbkLAMrTaJInHvIixZuMbANJqI7ggTp8sdHq1KZZ
	 JbSMcEO94+XIMe8nrVlMkseUZwijokMq/CdHiZdOIDFgBpVSd8Y4xSu5kuXtDhkY2M
	 fWijxlum2owVQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v2 00/13] Netfilter/IPVS fixes for net
Date: Thu, 23 Jul 2026 18:38:57 +0200
Message-ID: <20260723163910.274695-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is v2, remove an invalid kernel-doc comment in 9/13.

-o-

Hi,

The following batch contains Netfilter/IPVS fixes for net. This batch
includes a mix of IPVS follow ups related to Sashiko reports, as well as
crash fixes for connection tracking expectation, helpers, ipset and
nf_tables mostly for old bugs. This also includes a fix for the
flowtable tunnel selftest.
 
1) Use s32 instead of s16 to calculate the remaining payload containing
   SIP messages, otherwise underflow is possible allowing out-of-bound
   memory access beyond the skb->data area. From Xiang Mei.
 
2) Fix the counter check in the flowtable selftest for tunnels, from
   Lorenzo Bianconi.
 
3) Add and use nf_ct_expect_related_pair() to add the RTP and RTCP
   expectations under the expectation lock, this is required by the SIP
   and H.323 NAT helpers. This fixes a possible reinsertion of an
   expectation with the DEAD flag set on while looping to find
   consecutive ports.
 
4) Fix ipset UaF during table resize by blocking comment updates on
   kernel-side adds. From David Lee.
 
5) Do not propagate the IP_VS_CONN_F_ONE_PACKET flag when using IPVS
   state synchronization, otherwise reaching stale freed from
   ip_vs_conn struct is possible, Zhiling Zou.
 
6) Adjust the hn1 hash node when the forwarding method changes between
   MASQ and non-MASQ for an already hashed connection.  This can leave
   stale hash nodes pointing to a freed struct ip_vs_conn and trigger
   UaF while reading /proc/net/ip_vs_conn. From Julian Anastasov.
 
7) nft_object rhltable needs to be per table, just like chain rhltable,
   otherwise UaF from object lookup path while netns is being released.
   There is also the nlevent path that can reach stale objects. Placing
   this rhltable under the table hierarchy fixes this issue.

8) Reject invalid combined usage of hashlimit tables with and without
   XT_HASHLIMIT_RATE_MATCH flag mode, otherwise access to uninitialized
   .burst field of dsthash_ent is possible.
 
9) Fix checksum validations in IPVS performed from LOCAL_IN,
   from Julian Anastasov.
 
10) Fix incorrect packet offset to layer 4 protocol in IPVS, uncovered
    by Sashiko, from Julian Anastasov.
 
11) Skip the mangling of ICMP replies for non-first fragments, also
    reported by Sashiko. Also from Julian.
 
12) Clear ip_vs_conn flags under the spinlock to fix a possible data
    race. From Julian Anastasov.
 
13) Fix incorrect calculation of the payload bitmask in the nf_tables
    hardware offload support, leading to UBSAN splat. From Xiang Mei.
 
Julian Anastasov clarifies that some of the IPVS patches might still
result in pre-existing issues reports by Sashiko, they are ready to
follow up on that.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-07-23

Thanks.

----------------------------------------------------------------

The following changes since commit fca68249b6f5e84859b200b54cb5e0aef98f2b3a:

  Merge branch 'net-fix-two-issues-in-sk_clone-error-path' (2026-07-21 09:15:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-07-23

for you to fetch changes up to 39e88f28fb32bf02bd4b525c24c842c9cff5663d:

  netfilter: nft_payload: fix mask build for partial field offload (2026-07-23 18:17:55 +0200)

----------------------------------------------------------------
netfilter pull request 26-07-23

----------------------------------------------------------------
David Lee (1):
      netfilter: ipset: do not update comments from kernel-side hash adds

Julian Anastasov (5):
      ipvs: adjust double hashing when fwd method changes
      ipvs: fix the checksum validations
      ipvs: fix places with wrong packet offsets
      ipvs: do not mangle ICMP replies for non-first fragments
      ipvs: clear the nfct flag under lock

Lorenzo Bianconi (1):
      selftests: netfilter: nft_flowtable.sh: fix offload counter verification for tunnel tests

Pablo Neira Ayuso (3):
      netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
      netfilter: nf_tables: make nft_object rhltable per table
      netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Xiang Mei (1):
      netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Xiang Mei (Microsoft) (1):
      netfilter: nft_payload: fix mask build for partial field offload

Zhiling Zou (1):
      ipvs: do not propagate one-packet flag to synced conns

 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/net/ip_vs.h                                |  45 ++++-
 include/net/netfilter/nf_conntrack_expect.h        |   3 +
 include/net/netfilter/nf_tables.h                  |   4 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |  22 +--
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    | 192 ++++++++++++++++-----
 net/netfilter/ipvs/ip_vs_core.c                    | 190 ++++++++++----------
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  19 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  48 ++----
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  54 ++----
 net/netfilter/ipvs/ip_vs_xmit.c                    |  42 +++--
 net/netfilter/nf_conntrack_expect.c                |  35 +++-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_nat_sip.c                         |  22 +--
 net/netfilter/nf_tables_api.c                      |  34 ++--
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 .../selftests/net/netfilter/nft_flowtable.sh       |  14 +-
 20 files changed, 449 insertions(+), 313 deletions(-)
