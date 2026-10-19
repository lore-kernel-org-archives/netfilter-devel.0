Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422187;
	b=NtlkLZ+6B+g1+9vurwt+ujs84tSbQGM5U7hhgAVeQsg4jaDlIOWqsRn40syEDuYms46q
	 6Ws+PqtH3T0r62qZyndAe0z6T/eg6v8DLnTp+Glm/hHt4u5KczL67ydYfT+5onDXSdOgz
	 zf8w/VDa9hGwDJJZS3f/fl/tppqw6HRt53D8nNnt0/ZG4MTRsfbBG2RTe6Vail9PB2yL7
	 RNNyWpV891wFzaqHvgUYAkdeFGbZAHBDvHQ016FkPZWsc/afMBl9zakLqSgXsYIEvGFdH
	 v8wX1h2Mtg6sq3kt7WAf6c4aNLm0NCWc+hSMZQpem7Zo17W3ygZ9GnggHtMtTVYhQnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=v9cgZkzXfJum8LMGLQnaHUy+a1LoPyGxau8ueJsc2kE=;
	b=Qk/YtQALe1vWg1QkHFIsPrOUK/F+iayjeHQz1yqvd7C5ADY1q9LeCFEu1LIM6xsWybDw
	 YYUS4LMnn+VgZjRhXvZONWN6rR0o1d5G7yllYRxM/S5g9ZNrsDTNupAAUb83Hf8xFechE
	 B6zYJbuTACHJ4o+rVKk3txWLqJMCxNaAy3VbPBfOZjDPWA6ziXPehw0MXEvZoPOj8Pv4J
	 kYxPqG6rRUwtaDjwo5aCnd4ngtSH7ep1ZjBv+Y7xK6eIn+Soun5xfwK6EceNTG1HC0D6I
	 4amhMmslk4BRA5q5vjr2g8TfeHaLuU61E0kQvL+BS593s7XQZz74sJFtDxLQl10jVEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TCLdCUCH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DE6607D34C;
	Mon, 19 Oct 2026 15:03:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35DE6607D34C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TCLdCUCH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422176;
	bh=v9cgZkzXfJum8LMGLQnaHUy+a1LoPyGxau8ueJsc2kE=;
	h=From:To:Cc:Subject:Date:From;
	b=TCLdCUCHdXutnNUIejtrEhyORq2G2tiOPo6TztfkjoOx/M/F1xLlxwt9njHMxvvRB
	 9uqzu8DD8qEF4bvZtFlBMHYYADn3ZStgsspP08hdopUVG+XI+qykNJVthTIjSKTP+t
	 U+vtqzABe0Kb3aRpFz5SlyucVtlowm8SROD/OPSLItecwuarVB3AWNzi3Gmg6Xmg2p
	 bh41XLFBE7zI9N9+ZdRWs9BCFCvu6B2nw7W+4KF2H7ElYzO3smmUEwh9ZlYtw5BjcI
	 8zxpSgteAHemI7UHnHaltSHAiIX7I2uAw33svNcTbz8Oy9SfEBcJ7kyCL2y3ELoCWf
	 R7C1LXWnK5W5w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A58426005C;
	Mon, 19 Oct 2026 17:02:55 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 00/10] Netfilter/IPVS fixes for net
Date: Mon, 19 Oct 2026 17:02:39 +0200
Message-ID: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS for net:

1) Fix IPv6 nexthdr offset truncation in fragment reassembly,
   this has been uncovered by LLM, from Jeremy Jean.

2) Restrict checksums in nfqueue to known protocols and offset,
   after this patch the plan is to re-enable nfqueue in userns,
   this came via LLM report. from Florian Westhphal.

3) Fix races when handling overload flag in IPVS, this patch
   is not perfect but Julian considers this improves the situation.
   This was uncovered by LLM. From Julian Anastasov.

4) Error handling for IPVS sync_threshold sysctl, from Joel Granados.

5) Use skb_vlan_tag_get_id() to retrieve the VLAN id, discard tci
   bits, when handling VLAN in the flowtable, from Shuangfeng He.

6) Initialize IPCB for inet/ingress reject, uncovered by LLM.

7) Restrict completion of binary search array to anonymous set.

8) Restrict DCCP option matching to avoid out-of-bound read,
   from Sung Byeongchan.

9) Reset transport header offset in flowtable after tunnel
   decapsulation to fix issue with qdisc xmit path,
   from Lorenzo Bianconi.

10) Fix inverted matching in ctnetlink dump filtering,
    from Liu Chao.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-10-19

Thanks.

----------------------------------------------------------------

The following changes since commit ab699d296e066eb64f51d2a8a1d42237a3b186c8:

  Merge branch 'net-always-dissect-gso-packets-in-__virtio_net_hdr_to_skb' (2026-10-06 15:35:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-10-19

for you to fetch changes up to cd37ab22a74e05aae5c16c67295cbf5188b16268:

  netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter (2026-10-19 14:14:03 +0200)

----------------------------------------------------------------
netfilter pull request 26-10-19

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nft_payload: restrict checksum offsets to known values

Joel Granados (1):
      ipvs: skip committing sync_threshold when proc_dointvec fails

Julian Anastasov (1):
      ipvs: fix more races around the overload flag

Jérémy Jean (1):
      netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset

Kyle Zeng (1):
      netfilter: nf_reject: initialize IPCB at inet ingress

Liu Chao (1):
      netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple filter

Lorenzo Bianconi (1):
      netfilter: flowtable: reset transport header after nf_flow_encap_pop()

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: narrow down range completion to anonymous sets

Shuangfeng He (1):
      netfilter: flowtable: use the vlan id, not the full tci, in the tuple key

Sung Byeongchan (1):
      netfilter: xt_dccp: handle reserved options as single-byte

 include/net/ip_vs.h                     | 50 +++++++++++++++++++++------------
 net/ipv4/netfilter/nf_reject_ipv4.c     |  5 ++++
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c     |  5 ++++
 net/netfilter/ipvs/ip_vs_conn.c         |  8 +++---
 net/netfilter/ipvs/ip_vs_ctl.c          | 41 ++++++++++++++-------------
 net/netfilter/ipvs/ip_vs_dh.c           | 16 ++---------
 net/netfilter/ipvs/ip_vs_fo.c           |  2 +-
 net/netfilter/ipvs/ip_vs_lblc.c         |  4 +--
 net/netfilter/ipvs/ip_vs_lblcr.c        |  8 +++---
 net/netfilter/ipvs/ip_vs_lc.c           |  2 +-
 net/netfilter/ipvs/ip_vs_mh.c           |  2 +-
 net/netfilter/ipvs/ip_vs_nq.c           |  2 +-
 net/netfilter/ipvs/ip_vs_ovf.c          |  2 +-
 net/netfilter/ipvs/ip_vs_rr.c           |  2 +-
 net/netfilter/ipvs/ip_vs_sed.c          |  4 +--
 net/netfilter/ipvs/ip_vs_sh.c           |  2 +-
 net/netfilter/ipvs/ip_vs_twos.c         |  4 +--
 net/netfilter/ipvs/ip_vs_wlc.c          |  4 +--
 net/netfilter/ipvs/ip_vs_wrr.c          |  2 +-
 net/netfilter/nf_conntrack_netlink.c    |  8 +++---
 net/netfilter/nf_flow_table_ip.c        |  6 ++--
 net/netfilter/nft_payload.c             | 40 +++++++++++++++++++++-----
 net/netfilter/nft_set_rbtree.c          |  3 +-
 net/netfilter/xt_dccp.c                 |  2 +-
 25 files changed, 134 insertions(+), 92 deletions(-)
