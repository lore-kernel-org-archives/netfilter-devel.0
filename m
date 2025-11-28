Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD651F4C96;
	Fri, 28 Nov 2025 00:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289440; cv=none; b=HPVSQu9lMLUhT7YUxGRFgsglV+7XnzsBo7vbtDRq8N1uvLhpEAKOvDK5HFCsO1AAuJUcn2rnolLX65JXDETJy2zISsopdjJXq/C8I4IX6VeubJCRSd1QHeJ7hwH8FKdHGRJOLO/0SqoqTcCGkjdRRoag85Q5gZS8x0CkjmwTRng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289440; c=relaxed/simple;
	bh=FfS/j8RjgpGtQd2Eh5qXw1udXulpD0uGzsljYhMEU2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wd0LXFA6IksxOkv22FYh48+8fred1OWTU9n+8LIjV6Y9amxGKLuPJ79fUTuzth6vE1APHBd56EtFBin8FMTSUNs5vN0R56BFKihqcUSmBcHVXFjL3CUuFaLCU1SGUuIM5jY/JMCA5JXVh6lOyOZDEgYl3tZCwX62jevctJSU/Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MsubFDFT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MsubFDFT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ECA0A600B5;
	Fri, 28 Nov 2025 01:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289429;
	bh=MrdUIDK0l321bInS09hJCGVIThdakPSG0MHO7waWPrc=;
	h=From:To:Cc:Subject:Date:From;
	b=MsubFDFT5CredTG3UZUeCAZ5+waNXPxRbEuOyQllC142hwqAxSmfwszVHQhXGdue4
	 aJWO5tb0dDUx3SNTYsnO9FiqkSrUkFGFE3Os5mjSx8z0HxYmVcpmo8HCDC6wqI8V7t
	 VaSTEkwri+G6fHQ4e7qT4XZCTh/dP2bNXQt2HdT+6pMlDNkkTdErvVTDXVX+ASEPul
	 bG6CMTgIZ7I2b+HxT2Pd4ty50dMSFLKf8CVP76u68nN8w6a2FTed9bdlQukN5sxg3s
	 xcWim1Jh9gNLJn3nuWsBpxAu7lJnjPTssj6LsKRQT5q47dGjI3+EhkI9yUo7U8GOCU
	 NSwyez9K8rDLg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next,v3 00/17] Netfilter updates for net-next
Date: Fri, 28 Nov 2025 00:23:27 +0000
Message-ID: <20251128002345.29378-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3: - Incorrect out.ifidx in the flowtable IPV6 neigh xmit path, reported
      by the AI robot.
    - Fix memleak in connlimit in case no conntrack or tuple can be fetched
      when creating rbconn node and list, reported by AI robot.
    - Fix missing WRITE_ONCE in conncount update support, reported by AI robot.
    - Fixes for the nft_flowtable.sh extension made by Lorenzo Bianconi.
--

The following batch contains Netfilter updates for net-next:

0) Add sanity check for maximum encapsulations in bridge vlan,
   reported by the new AI robot.
 
1) Move the flowtable path discovery code to its own file, the
   nft_flow_offload.c mixes the nf_tables evaluation with the path
   discovery logic, just split this in two for clarity.
 
2) Consolidate flowtable xmit path by using dev_queue_xmit() and the
   real device behind the layer 2 vlan/pppoe device. This allows to
   inline encapsulation. After this update, hw_ifidx can be removed
   since both ifidx and hw_ifidx now point to the same device.
 
3) Support for IPIP encapsulation in the flowtable, extend selftest
   to cover for this new layer 3 offload, from Lorenzo Bianconi.
 
4) Push down the skb into the conncount API to fix duplicates in the
   conncount list for packets with non-confirmed conntrack entries,
   this is due to an optimization introduced in d265929930e2
   ("netfilter: nf_conncount: reduce unnecessary GC").
   From Fernando Fernandez Mancera.
 
5) In conncount, disable BH when performing garbage collection
   to consolidate existing behaviour in the conncount API, also
   from Fernando.
 
6) A matching packet with a confirmed conntrack invokes GC if
   conncount reaches the limit in an attempt to release slots.
   This allows the existing extensions to be used for real conntrack
   counting, not just limiting new connections, from Fernando.
 
7) Support for updating ct count objects in nf_tables, from Fernando.
 
8) Extend nft_flowtables.sh selftest to send IPv6 TCP traffic,
   from Lorenzo Bianconi.
 
9) Fixes for UAPI kernel-doc documentation, from Randy Dunlap.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-11-28

Thanks.

----------------------------------------------------------------

The following changes since commit db4029859d6fd03f0622d394f4cdb1be86d7ec62:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2025-11-27 12:19:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-11-28

for you to fetch changes up to d3a439e55c193b930e0007967cf8d7a29890449b:

  netfilter: nf_tables: improve UAPI kernel-doc comments (2025-11-28 00:07:19 +0000)

----------------------------------------------------------------
netfilter pull request 25-11-28

----------------------------------------------------------------
Fernando Fernandez Mancera (4):
      netfilter: nf_conncount: rework API to use sk_buff directly
      netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
      netfilter: nft_connlimit: update the count if add was skipped
      netfilter: nft_connlimit: add support to object update operation

Lorenzo Bianconi (4):
      netfilter: flowtable: Add IPIP rx sw acceleration
      netfilter: flowtable: Add IPIP tx sw acceleration
      selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest
      selftests: netfilter: nft_flowtable.sh: Add the capability to send IPv6 TCP traffic

Pablo Neira Ayuso (7):
      netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
      netfilter: flowtable: move path discovery infrastructure to its own file
      netfilter: flowtable: consolidate xmit path
      netfilter: flowtable: inline vlan encapsulation in xmit path
      netfilter: flowtable: inline pppoe encapsulation in xmit path
      netfilter: flowtable: remove hw_ifidx
      netfilter: flowtable: use tuple address to calculate next hop

Randy Dunlap (2):
      netfilter: ip6t_srh: fix UAPI kernel-doc comments format
      netfilter: nf_tables: improve UAPI kernel-doc comments

 include/linux/netdevice.h                          |  13 +
 include/net/netfilter/nf_conntrack_count.h         |  17 +-
 include/net/netfilter/nf_flow_table.h              |  26 +-
 include/uapi/linux/netfilter/nf_tables.h           |  14 +-
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h       |  40 +--
 net/ipv4/ipip.c                                    |  25 ++
 net/netfilter/Makefile                             |   1 +
 net/netfilter/nf_conncount.c                       | 211 ++++++++-----
 net/netfilter/nf_flow_table_core.c                 |   5 +-
 net/netfilter/nf_flow_table_ip.c                   | 293 +++++++++++++++---
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nf_flow_table_path.c                 | 330 +++++++++++++++++++++
 net/netfilter/nft_connlimit.c                      |  54 ++--
 net/netfilter/nft_flow_offload.c                   | 252 ----------------
 net/netfilter/xt_connlimit.c                       |  14 +-
 net/openvswitch/conntrack.c                        |  16 +-
 .../selftests/net/netfilter/nft_flowtable.sh       | 126 +++++++-
 17 files changed, 980 insertions(+), 459 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_path.c
