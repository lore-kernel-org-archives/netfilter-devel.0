Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB70C23EAAB;
	Tue, 25 Nov 2025 22:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110008; cv=none; b=cVfuu+2dA7nPFtQH1yOC3QERN792paVPic6mdvTRtQ1zpdW1fBGTGyTXlND0vIFiykb5tYFlbd8neve1TrWKK9y3WKGSBsGn0CnX4nio3av1rso71z+ebPm9LiFu5vDxDUmXjut11/cTnHgEXlrVRNjxGUgo+vVdgbrdHzl+tqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110008; c=relaxed/simple;
	bh=tWygIw+uEkUsKxeVbFx0r/s15aTal/KA40rz/GcyFsA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sx84pDII1QafxvmihU/Jt9NMqhSVMLyYYORt+uCCTHAo7EAOMxm5sCcyzNnS03XCapI3h4zgQnHCXI4S6JKRh9AjBx/Rv+6Ytuf/c2mYQJvLVn1qIYUQt7S3DnOWLNPJ8kPm+Nh6YFjvIej3z4wjJiEJ6lUXV4dhWuAvt3mC1nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cGEC7CZf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cGEC7CZf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7535D60265;
	Tue, 25 Nov 2025 23:33:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764109997;
	bh=8ShfHaitAKrkd0xxHYvm+k/Oa1eNt+gzZXam5DiZQMc=;
	h=From:To:Cc:Subject:Date:From;
	b=cGEC7CZfo2Cl7ZIlpzgZk77G+xciidedcWRBI7Xi5Tnnd4vwp8Qz6ZI2Q2nIiDG/X
	 mGvPEH4X1+sUEU6bRsIa6Z59pPkyZhVuR+EZly+oodv/4WFmb68/ADvOVn8mu0tM0B
	 Nmq0gCclmWx3Mq/4F/7nan4fmHBvtILBCCRdoyJ2Xuv7SWZ9xQtK7U6Axe4s3ksKUG
	 i/NuTvgxentzxwxKJ1I+b5Im5XRBaMeC96V9vyMa9TZRxVsDGW2Xyar5e74zS77tzw
	 SvJ953fYbCW9a6KJvRz3rB0cJgp/q5oO10k84FtiL9R0TYVJe7YpPIHmbvN5M991XY
	 Ey5SxKmDZ5Naw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 00/16] Netfilter updates for net-next
Date: Tue, 25 Nov 2025 22:32:56 +0000
Message-ID: <20251125223312.1246891-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

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

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-11-25

Thanks.

----------------------------------------------------------------

The following changes since commit 61e628023d79386e93d2d64f8b7af439d27617a6:

  Merge branch 'net_sched-speedup-qdisc-dequeue' (2025-11-25 16:10:35 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-11-25

for you to fetch changes up to b6300ae47df247e8294b4d0b1457bd318cf1011c:

  netfilter: nf_tables: improve UAPI kernel-doc comments (2025-11-25 20:37:11 +0000)

----------------------------------------------------------------
netfilter pull request 25-11-25

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

Pablo Neira Ayuso (6):
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
 net/netfilter/nf_conncount.c                       | 193 ++++++++----
 net/netfilter/nf_flow_table_core.c                 |   5 +-
 net/netfilter/nf_flow_table_ip.c                   | 293 ++++++++++++++++---
 net/netfilter/nf_flow_table_offload.c              |   2 +-
 net/netfilter/nf_flow_table_path.c                 | 323 +++++++++++++++++++++
 net/netfilter/nft_connlimit.c                      |  54 ++--
 net/netfilter/nft_flow_offload.c                   | 252 ----------------
 net/netfilter/xt_connlimit.c                       |  14 +-
 net/openvswitch/conntrack.c                        |  16 +-
 .../selftests/net/netfilter/nft_flowtable.sh       | 116 +++++++-
 17 files changed, 954 insertions(+), 450 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_path.c
