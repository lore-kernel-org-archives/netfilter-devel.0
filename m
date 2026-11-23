Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442253;
	b=zDlMQSA8ij8rOCgsanPUw/1t1vCE+SKHB8qyquPrnqTQeh3ypYbsurJcRwiKtBM6rPD2
	 ZJsD5nY8Fox1G4AoEZocphpY0IPntc6HO+k6SuuzsTHVJccELr0LgJkhH5AZjJyEFbEja
	 v/ulzCmWtLllG6rhL+gJX8E4tobgnVSXarZ1UbAenKA/S5VRLQiSE1iqvkZGoaMR6RlFj
	 aTxsgvQK1pezMOgoLAhX+ELF6hdsNGS5PRTnQIfhKe5kHCG9rpEX2Dpga8Bo/7nRFDyXl
	 WZTFPyMNZX3fhgembgTDzCbBGNxpzHDBEQ7yvM6xD077IVfS1ZO+Q9jxsmb6yZvrptg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442253;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=7SI/DiBssfhU9Uu/0FH5++/7d/NOpovqpYP40+fwK+A=;
	b=TLH/MAcEky/2F/0DIHLtALClAXAQeF5LnvIBcWR6D6vaHzkC/AosImt7KqgrJMe1gmh/
	 80Az5f5jg/lXjQi8yix+Rd5EtORM4JKb27w1Yt9FoATPwttnbnY1UFZHlSbMb8/US6hE9
	 dNw4tfwFbBLpFQyTpkvVOaOpQ9TW0mjzg/k42itdairgwm9gkDMc253EWCpDtoUDGtjK8
	 +xrU9f6uclIih5suIGBpnpa8kY+vfMiWjdYxtw8pYhQEhRbMeeyq5Thj0s9OsmcUIozon
	 2Wj6G/hPeR0GuikYkJb0gdFme716S2rsMrwF41AL4GZN/pvTSgQLwNxzu5aFmYsDFRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZWgiOr6n;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C15606A331;
	Mon, 23 Nov 2026 13:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2C15606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZWgiOr6n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442250;
	bh=7SI/DiBssfhU9Uu/0FH5++/7d/NOpovqpYP40+fwK+A=;
	h=From:To:Cc:Subject:Date:From;
	b=ZWgiOr6n2wSEK/zRl0BwU2wlOR2K0AOGWM57/JiNnFyl0SQxkS8LdHvCssN9XhrK2
	 eTvMHi8GGF4hZru77ms7Dmgwlbw3Rqhd9Huwo7bjlwxE9f0uPLR9CzRDaeKhMV1tdp
	 Vd0JDQYkxzuTkli6FIIKDyEa75hRh7fCoSyQFy1sC34LOnixv4i6iqFBYBO761riBr
	 jonR3sJT4z/hzqMAE25fQsCFSznjo1M06b2oHTWurmwoSV+HhSeoSTt9iv1DAPgQYU
	 7hgSF36+J5YfXS/RcoRnzho4Bvyr9cHGM81XwfZdTS4H6HO+58nEFvt1sxR7Dsszbm
	 lqVmckBn0MEWg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2A2DA602CF;
	Mon, 23 Nov 2026 14:57:30 +0100 (CET)
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
Subject: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Date: Mon, 23 Nov 2026 14:57:11 +0100
Message-ID: <20261123135726.3940688-1-pablo@netfilter.org>
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
Content-Transfer-Encoding: 8bit

v2: address cover letter errata.

-o-

Hi,

The following batch contains Netfilter updates for net-next. This is
composed of four groups:

1) Patch 1 addresses a race in the nf_conntrack_buckets sysctl handler,
   that has been reported by LLM. From Fernando F. Mancera.

2) Patches from 2 to 7: This is a conntrack hardening series to address
   LLM reports of the issues related to skbuff mangling while a ct is
   already present, leading to mismatch protocol numbers, ie. ct becomes
   stale since it does not represent this skbuff. This is unlikely to
   happen in a real world. From Florian Westphal.

3) Patch 8 updates nft_synproxy to address SYN and ACK packets only, just
   like ip{6}t_SYNPROXY does. From Fernando F. Mancera.

4) Patch 9 validate hook priority so nft_ct template is narrowed down
   to be used where it makes sense. From Florian Westphal.

5) The ipset hash types conversion to rhashtable, including a new
   rhashtable helper function to flush and destroy the hashtable.
   This is a rework that aims at fixing the existing resize races in
   the ipset hash type, which has triggered a myriad of LLM patches
   addressing the symptoms but not the core issue. This large so
   we prefer net-next for these series. Series from Florian Westphal,
   plus one patch for rhashtable to add a flush and destroy helper
   function by Herbert Xu.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23

Thanks.

----------------------------------------------------------------

The following changes since commit 994089a3fa3882f27f4bed9fc5815ee7df502e88:

  Merge tag 'nf-next-26-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next (2026-11-17 12:05:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-11-23

for you to fetch changes up to 80b89c83c8672becbc94ff7ad92ad5ef01d48fab:

  netfilter: ipset: re-add forceadd support (2026-11-23 14:03:47 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-23

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: conntrack: prevent nf_conntrack_buckets race condition

Florian Westphal (12):
      netfilter: conntrack: validate skb->_nfct and packet headers
      netfilter: conntrack: refactor helper call logic in nf_confirm()
      netfilter: conntrack: verify L4 protocol before calling helper
      netfilter: conntrack: replace open-coded helper invocation
      netfilter: conntrack: harden helper invocation with tuple revalidation
      netfilter: nft_ct: validate timeout object protocol
      netfilter: nft_ct: validate hook and priority for ct zone set
      netfilter: ipset: add rhashtable boilerplate stubs
      netfilter: ipset: replace internal hash table with rhashtable
      netfilter: ipset: also report mem size for cidr storage to userspace
      netfilter: ipset: re-add IP_SET_HASH_WITH_MULTI support
      netfilter: ipset: re-add forceadd support

Herbert Xu (1):
      rhashtable: Add rhashtable_flush_and_free helper

Nguyen Ngoc Thang (1):
      netfilter: nft_synproxy: only handle pure SYN and ACK packets

 include/linux/rhashtable.h                   |   40 +-
 include/net/netfilter/nf_conntrack_helper.h  |    2 +
 include/net/netfilter/nf_tables.h            |    4 +
 lib/rhashtable.c                             |  186 ++-
 net/netfilter/ipset/ip_set_hash_gen.h        | 2176 ++++++++++++++------------
 net/netfilter/ipset/ip_set_hash_ip.c         |    6 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |    6 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |    6 +-
 net/netfilter/ipset/ip_set_hash_mac.c        |    3 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   74 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |    6 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |    6 +-
 net/netfilter/nf_conntrack_core.c            |  119 +-
 net/netfilter/nf_conntrack_ovs.c             |   53 +-
 net/netfilter/nf_conntrack_proto.c           |  173 +-
 net/netfilter/nf_conntrack_standalone.c      |   18 +-
 net/netfilter/nf_tables_api.c                |   48 +-
 net/netfilter/nft_ct.c                       |   87 +-
 net/netfilter/nft_synproxy.c                 |    8 +-
 24 files changed, 1850 insertions(+), 1201 deletions(-)
