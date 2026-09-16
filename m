Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E054BA1F1;
	Wed, 16 Sep 2026 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600620; cv=none; b=dN4feFCELBOkCfhK4GHQMabLN1s75zGc9dct5KBU+kEJLXGwlI6rAMdiOrTEz4/GbNWPBr0GkhMwxCHesInhDDPxg7F+WcmgPqtOazHO9FT0NXvDAfImxuLJLdVaij6QriJ0UFTzDJ9XARLcUczOLAez0mUrF7dGwlGvlZNcz68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600620; c=relaxed/simple;
	bh=r7pBaUBxw3xOb8KYvIhU3DLDZsCLCBiv8UsgNVUMdls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NJPicNA2B2JPsYeKkNMwiwJPJvOd+Nx/Aci6ueOcqY5znK+8U9oLLEDwbezJ81VwpkL3zUydcNOgAaYuLOsF1E+sxoQhjUariktbVskH89qmkaMFMglde1MIrEZBv1iitBvnM06yFCNF0tL33DxqTCv2Y7IyyaqPJN9Ks3MVKQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UGss3Ajo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UGss3Ajo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600615;
	bh=FhKvU2lAmQGHzBrHlcQkBr1s4HxlDRhQuXlCwCORBUg=;
	h=From:To:Cc:Subject:Date:From;
	b=UGss3AjozwwP0Tlgt8e6abJ7n9Xjh2TVHI+muViP4C2CDKyOMpSd8eni3A19njEMQ
	 h/jUOSdpv4TREdqUsTE9c0ZJpyUm7shH/jMd7QmRNwLgLCGrK33Flq8DmmaDEyy3m8
	 Uthsx+LeI+rJDXGRo2l3teJXH8pKvSRcgT4xWDCvu3H9T8xFi2ykaTZEq0shExIKCM
	 W3dsTcEJWbvYTJ2EryfmQFkAwCXy2vK2790YwV3s35biitVq1loxZXc4Rx6ppY/Wv4
	 sd0+Y6DOkbkGyCROTaAB5BKCtsbGG1XeJBloLAO0MaPH+vfCK7EZlJq7OdkK97PJ2o
	 +iZ3DdFtVA+0g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 34B3060088;
	Thu, 17 Sep 2026 01:16:55 +0200 (CEST)
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
Subject: [PATCH net 00/10] Netfilter/IPVS fixes for net
Date: Thu, 17 Sep 2026 01:16:41 +0200
Message-ID: <20260916231652.127456-1-pablo@netfilter.org>
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

1) Set on HW_DEAD after HW_PENDING is cleared in the flowtable offload
   to ensure GC does not zap it, from Jérémy Jean.

2) Hold the nfnetlink_queue mutex while removing the queue instance
   from the netlink notifier that handles NETLINK_URELEASE to fix a
   possible race with the UNBIND command. From Florian Westphal.

3) Reject route with NULL rt6i_idev in ip6t_rpfilter. From Weiming Shi.

4) Reject rtinfo->addrnr set to zero from ip6t_rt .checkentry path.
   This also fortifies the datapath loop as per Florian's request.
   From Luxiao Xu.

5) Fix checksuming in nft_synproxy for IPv6, from Karl Mehltretter.

6) Revalidate ihl before calling icmp_send() in IPVS,
   from Julian Anastasov.

7) Sanitize flags in IPVS sync messages that are received in the
   backup, from Julian Anastasov.

8) Fix suspicious RCU usage splat in ctnetlink with expectations.

9) Remove WARN_ON_ONCE in dev_fill_forward_path(). Recent support
   from IPIP tunnels allow for loops. From Farhad Alemi.

10) Check for expired catchall elements in the insert and deactivate
    path. From Aohan Mei.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-17

Thanks.

----------------------------------------------------------------

The following changes since commit ceac0de741bfb47ca255eee075257b3bb31f0651:

  netlink: do not free nlk->groups while lockless readers can use it (2026-09-15 18:44:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-17

for you to fetch changes up to d9be517d5aef7ebf132b0f33965c7a8232a02da9:

  netfilter: nf_tables: skip expired catchall elements on insert and delete (2026-09-17 01:00:01 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-17

----------------------------------------------------------------
Aohan Mei (1):
      netfilter: nf_tables: skip expired catchall elements on insert and delete

Farhad Alemi (1):
      net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check

Florian Westphal (1):
      netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

Julian Anastasov (2):
      ipvs: revalidate ihl before icmp_send
      ipvs: filter some flags received in the backup server

Jérémy Jean (1):
      netfilter: flowtable: publish HW_DEAD after worker is done

Karl Mehltretter (1):
      netfilter: nft_synproxy: use the family-aware checksum helper

Luxiao Xu (1):
      netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read

Naman Gulati (1):
      netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name

Weiming Shi (1):
      netfilter: ip6t_rpfilter: reject routes without inet6_dev

 net/core/dev.c                        |  2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c    |  2 +-
 net/ipv6/netfilter/ip6t_rt.c          | 11 ++++++++---
 net/netfilter/ipvs/ip_vs_core.c       |  6 ++++++
 net/netfilter/ipvs/ip_vs_sync.c       | 33 ++++++++++++++++++++++++++++++---
 net/netfilter/nf_conntrack_netlink.c  |  3 ++-
 net/netfilter/nf_flow_table_offload.c |  7 ++++++-
 net/netfilter/nf_tables_api.c         |  8 ++++++--
 net/netfilter/nfnetlink_queue.c       |  8 +++++---
 net/netfilter/nft_synproxy.c          |  3 ++-
 10 files changed, 67 insertions(+), 16 deletions(-)
