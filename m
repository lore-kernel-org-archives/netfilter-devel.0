Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC29E231830;
	Sat, 16 May 2026 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932601; cv=none; b=JFK7uCi0GNDRWJEAUtP4eayYigfb5d95ZXLu3WZVayMPznAxE/SU9PkqcDMXlSQryemWDxb8wKA8axwHhd4sjHNqxb2q94Dq8Iv+GbGXJnlQbVNTM8NCQ8AnH3vK/pGjnmE7N78RKd1pHgRBRANPumA2vxQB6E5xl52PBxULnEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932601; c=relaxed/simple;
	bh=ZJfbekSEIynvZHoz9g7nIET251nPamkS6ZsAujIeqf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XEPCfwy1ZvU4kZ0TqduQbaHn8scwlBkLEX3K+9nEt0Py/71J8gL71phCvLNoDSu0d6jNz9y1zw/iLWTVu1TfZzrFK+QdO/f2yHHHNnVSfSEziJ+F+keC5daOF5ZkjtNMsGOI4ngmdHZiOcZt2gNJ8QgMHBOY7sQyvEJkGWr2Fmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cfrB3euo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cfrB3euo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D6B22601A2;
	Sat, 16 May 2026 13:56:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932591;
	bh=hAL/CMd2bZJ6BgSA3AbyZA9G5EK0nxLqi/FlYaGSVdg=;
	h=From:To:Cc:Subject:Date:From;
	b=cfrB3euo0OBrcx28tXtJ5Lpux16AtnTX6dnfZVoS5EQp+Z87UcU+7XfPXmAAlRELz
	 HGaYzKqkLxOG20Jf+cP7s9DdRl1/YwREKJWfpioKHRcyfbgIZ0Y5y+adHc29UubcJM
	 6I+YpvCLaxW4ohYTMm1o28Apx3zrSjeK0RPhqLcmKg9LG7aYwKJrjGFTraQxtRHY0S
	 kKH1KCYmTZwaMXp5XHRPk/jiQlKiERKQTobluPk2/kTCLnhAS1ArKOY4A0reXrUW1/
	 0iZgUGGq+uBbAdOo4lByE/ZUZf97L2TNPkO0rz2VwqFFToxHQPKyN0qGO/w0KYMmad
	 sgQbnB276WFYw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 00/12] Netfilter/IPVS fixes for net
Date: Sat, 16 May 2026 13:56:15 +0200
Message-ID: <20260516115627.967773-1-pablo@netfilter.org>
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

1) Fix small race windows in nf_ct_helper_log() when accessing helper,
   from Florian Westphal.

2) Fix potential infinite loop and race conditions in IPVS caused by
   frequent user-triggered service table changes, from Julia Anastasov.

3) Fix a race condition when dumping ipsets for restore,
   from Jozsef Kadlecsik.

4) Fix inner transport offset in IPv6 in nft_inner when extension
   headers come before the layer 4 transport header, from Yizhou Zhao.

5) Fix incorrect iteration over IPv4 ranges in several hash set types,
   from Nan Li.

6) Fix incorrect order when restoring BH in nft_inner_restore_tun_ctx(),
   from Florian Westphal.

7) Validate option array from ip6t_hbh checkpath() to fix an off-by-one
   access, from Zhengchuan Liang.

8) Fix race condition between ipset list -terse and concurrent updates,
   from Jozsef Kadlecisk.

9) Fix race condition when inserting elements into a hash bucket, also
   from Jozsef.

10) Annotate access to first free slot in hashtable, from Jozsef Kadlecsik.

11) Ensure sufficient headroom in br_netfilter neigh transmission,
    from Lorenzo Bianconi.

12) Hold reference on skb->dev in nfqueue exit path, bridge local input
    is speciall since skb->dev != state->indev, allowing for net_device
    to go away while packet is sitting in nfqueue. From Haoze Xie.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-05-16

Thanks.

----------------------------------------------------------------

The following changes since commit 93d809adc13001e9d3a3ceb8d1e60fae2fb740d6:

  Merge branch 'vsock-virtio-fix-vsockmon-tap-skb-construction' (2026-05-12 12:52:18 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-05-16

for you to fetch changes up to e196115ec330a18de415bdb9f5071aa9f08e53ce:

  netfilter: nf_queue: hold bridge skb->dev while queued (2026-05-16 13:23:01 +0200)

----------------------------------------------------------------
netfilter pull request 26-05-16

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_conntrack_helper: fix possible null deref during error log
      netfilter: nft_inner: release local_lock before re-enabling softirqs

Haoze Xie (1):
      netfilter: nf_queue: hold bridge skb->dev while queued

Jozsef Kadlecsik (4):
      netfilter: ipset: fix a potential dump-destroy race
      netfilter: ipset: Fix data race between add and list header in all hash types
      netfilter: ipset: Fix data race between add and dump in all hash types
      netfilter: ipset: annotate "pos" for concurrent readers/writers

Julian Anastasov (1):
      ipvs: avoid possible loop in ip_vs_dst_event on resizing

Lorenzo Bianconi (1):
      netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()

Nan Li (1):
      netfilter: ipset: stop hash:* range iteration at end

Yizhou Zhao (1):
      netfilter: nft_inner: Fix IPv6 inner_thoff desync

Zhengchuan Liang (1):
      netfilter: ip6t_hbh: reject oversized option lists

 include/net/ip_vs.h                         |   3 +-
 include/net/neighbour.h                     |   8 +-
 include/net/netfilter/nf_queue.h            |   1 +
 net/bridge/br_netfilter_hooks.c             |   6 +-
 net/ipv6/netfilter/ip6t_hbh.c               |   4 +
 net/netfilter/ipset/ip_set_core.c           |   5 +-
 net/netfilter/ipset/ip_set_hash_gen.h       |  57 ++++++---
 net/netfilter/ipset/ip_set_hash_ipmark.c    |   6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c    |   5 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c  |   5 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c              | 187 ++++++++++++++++++----------
 net/netfilter/nf_conntrack_helper.c         |  13 +-
 net/netfilter/nf_queue.c                    |   4 +-
 net/netfilter/nfnetlink_queue.c             |   2 +
 net/netfilter/nft_inner.c                   |   3 +-
 16 files changed, 211 insertions(+), 103 deletions(-)
