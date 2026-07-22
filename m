Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00573CFF66;
	Wed, 22 Jul 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754878; cv=none; b=XeXviRAp+dOILbUwciNmHHGz6jg210HxIK3BYQRiX6K3Bh02QoD5Tg9tBjy3+jj7eX5ksKYyBEE3LapfMKPjCfWXbGpoEJ0ipukcLvrlB1oDaYrLr3jakAafPE9aZndfe4cFVTyt1KVds/ccUFaeW+V8cJKVA7getTYV6FqYnY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754878; c=relaxed/simple;
	bh=ZOzqytELQhReJdKXKYF6kLZvTZhAfy94+r4OcYxq67A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mnTrNAw5DXoG16djNgEUz54XZZGEvO9XrDs04F217X4Ga49/oYB491jTg280oPGJNWnwxT6j8EDuoW0Zx01Sa0bQpl4ZeuBAOP4NioiJCflm8fHN4VdGdHzbtEnRbCEb/DZBErEd5wCRP5yhFJfgd/ufRfeFlJaH3gOfNJzGaec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J6XhrQRu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J6XhrQRu"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8AAD960193;
	Wed, 22 Jul 2026 23:14:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754866;
	bh=hUqFo/glZXVYFQjKzsXOphORjpxmma6f/4AbLQG+Fi0=;
	h=From:To:Cc:Subject:Date:From;
	b=J6XhrQRuv7ZxUZ8zllZ+K3sWW0q4bd8HOPahrHKuZxJSV65Ag58tPg8RBDCARgoEI
	 UJdB9YgspzcwT4YjugfMjL9534pxAVr3sw2ZAf2WA9ftr/QgaU+7roTbq/v+XMNYIB
	 /RhO0pZyF0ssA2bRc7XrMQv6dAGj2BKOZguBzI/Q1yar4PjMNVgstiMAXfC7IeSRAJ
	 XDLTagsKU55W54J3+MatBBO9LdtDMfTe9ApNy/QQw3fEaxKkK3P/SmFXi9HffoAiFR
	 cGcfY5gf8zmp44IOv+FWdEXAJ1saTq/e+xa915BgP86UFssxROs1p361rWwShZ9rh3
	 QziwzKs43r5Ew==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/13] Netfilter/IPVS fixes for net
Date: Wed, 22 Jul 2026 23:14:07 +0200
Message-ID: <20260722211420.153933-1-pablo@netfilter.org>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-07-22

Thanks.

----------------------------------------------------------------

The following changes since commit fca68249b6f5e84859b200b54cb5e0aef98f2b3a:

  Merge branch 'net-fix-two-issues-in-sk_clone-error-path' (2026-07-21 09:15:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-07-22

for you to fetch changes up to 09e0d3e6d4f401e8216227657d5e412553785607:

  netfilter: nft_payload: fix mask build for partial field offload (2026-07-22 20:47:50 +0200)

----------------------------------------------------------------
netfilter pull request 26-07-22

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
 include/net/ip_vs.h                                |  48 +++++-
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
 20 files changed, 452 insertions(+), 313 deletions(-)
