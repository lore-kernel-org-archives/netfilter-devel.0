Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A6E4DAF8A;
	Fri, 18 Sep 2026 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730935; cv=none; b=mFfqjq9dxeASia4z5arPE7AcWT67EuPP/frEwtA0fPewtreDUTu6i2x+xJrOjKxqNO/5W3pMcsUHG9DuLkqlcK2Hy8GPn63U2yiGqx5bfs6OdAhkhEdqEKG7ci8L+Wws4IM2zAH+Rxb1MQUMLaSJRUE3ZiJTs0VthZbGtqRImfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730935; c=relaxed/simple;
	bh=QG0Kzi8AxLW1Ug1aRw/qDeOS2gP1yb9+uRXdJXQJITQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OD8WlgLKsn7PCNGv3vbSymxTE60co9yV33Zm8ocLbmN/LERXZq6Yvt1p2ExHIOD+aXgdGz/1dCr4w3CTlBER8rpyEcNqAvLD4KezAb/yxqWre0gr6asuzS4NzkCwwAJjF138/w//DM3iU16/x4I5302oSrdwOTmbJDQh4dtIPDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sSlXlmV3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sSlXlmV3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789730929;
	bh=5YOZGdpwwID2GjJG+21n9dl43hI9af3fXYyT7f7ZgUE=;
	h=From:To:Cc:Subject:Date:From;
	b=sSlXlmV3fP0BqkhpWG6c+jUg5Q6vRpgL1xtyEN7TtvQChBxGe5k4NFElJ4UwQr297
	 NtmQcsG4uuZMH44WwVMJzizvIGMaks4x1zWFwnYnKAi5UgSDr6soDtFdQAAmw7O+uq
	 73AORbydnWnvd1XlYj4vlvgLmVaoV+oR87Sk4/bTQ+pdptGlkQ0R5EZkvcTDrbtR+Z
	 iZBv37T1+YSViP6ALzbM/3udBUcuUhg89emeGeW6FplwJ431EBJ5IzJLkEqWrCPt69
	 l1m9hZ8FE0fSxCLQyjc73PqEOXy+90wBIoCnAn6wE5Fdb5pUdr0rZ+XxJvxEiIoIB5
	 0m/z/24PLPYtQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 068B36005D;
	Fri, 18 Sep 2026 13:28:48 +0200 (CEST)
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
Subject: [PATCH net,v2 0/8] Netfilter/IPVS fixes for net
Date: Fri, 18 Sep 2026 13:28:36 +0200
Message-ID: <20260918112844.194503-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

v2: - keep back IPVS patch
      "ipvs: filter some flags received in the backup server"
      so Julian has a change to revisit the commit description.
    - Add check for dead bit in nf_tables catchall patch.

-o-

Hi,

The following patchset contains Netfilter/IPVS fixes for net, they are:

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
 
7) Fix suspicious RCU usage splat in ctnetlink with expectations.
 
8) Check for expired catchall elements in the insert and deactivate
   path. From Aohan Mei.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-18

Thanks.

----------------------------------------------------------------

The following changes since commit 3b95a04eb5f95bf6a016a1bb9ff37d3eee48de63:

  Merge branch 'mptcp-misc-fixes-for-v7-3-rc4' (2026-09-17 08:14:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-18

for you to fetch changes up to 70194dc37670bd08e44b471389861cc01bd3a3c9:

  netfilter: nf_tables: skip expired catchall elements on insert and delete (2026-09-18 11:24:05 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-18

----------------------------------------------------------------
Aohan Mei (1):
      netfilter: nf_tables: skip expired catchall elements on insert and delete

Florian Westphal (1):
      netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

Julian Anastasov (1):
      ipvs: revalidate ihl before icmp_send

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

 net/ipv6/netfilter/ip6t_rpfilter.c    |  2 +-
 net/ipv6/netfilter/ip6t_rt.c          | 11 ++++++++---
 net/netfilter/ipvs/ip_vs_core.c       |  6 ++++++
 net/netfilter/nf_conntrack_netlink.c  |  3 ++-
 net/netfilter/nf_flow_table_offload.c |  7 ++++++-
 net/netfilter/nf_tables_api.c         | 10 ++++++++--
 net/netfilter/nfnetlink_queue.c       |  8 +++++---
 net/netfilter/nft_synproxy.c          |  3 ++-
 8 files changed, 38 insertions(+), 12 deletions(-)
