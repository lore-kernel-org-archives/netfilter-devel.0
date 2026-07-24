Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2663C10AE;
	Fri, 24 Jul 2026 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890186; cv=none; b=RgTXMk+1kB3IsBAjOFIZx//lvnLP1z+EzBNhB3OVreaxpdQrZdBLAzMMJsybyVcXISGEityGGgSmCmkZZTYSOKNJTZsn7Q88kmqbc/1JlyI2vGOeTIsxMUdr8fBUJPoK7h/0dDi4cWfi69xVda/2dvxRTDenNQsOoBGoEY5KIRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890186; c=relaxed/simple;
	bh=uW2xzHOzF6Z/nrW0jmeSGNNP2cBla52TvLflycN7y/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMcAXT8f1ZDb9SksYOl7coC/bQ0qyD/3pOdiSc7fqIvcYQkJJDhmoy4IZDCjtj7bERvYSWLaGeq+yrDXjaR1yjWeCP8N+RP+YY8bi6NKYe8TbbcEGR/PHWnNd0FKwV3owUnFGFAmeCJqO8NJeULJEIB8qWrMo5oJoB8h8GPHLiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a0Juvjtb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a0Juvjtb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1B23D6019C;
	Fri, 24 Jul 2026 12:49:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890181;
	bh=ALT8cgcDYszf3Lu3zzBXtKjXM2UT90eG8prsUEDa6u8=;
	h=From:To:Cc:Subject:Date:From;
	b=a0JuvjtbBq8JduKmiap8ZTbd2lj0WCBpYC57kexOV2VlmD3FRJOWxAP1ANAtbHuR6
	 DL2GYOkQaPSG4kKLjYVA2K7u2iUUSrJLkjw6XIMy3SxSJuViLSn+fU0+LcYaKvnKUn
	 RBAENSWrU9PD5ky4+M7BsRqBbzXm/IEKLb/MEgNbzQOKzURug2Gjn/J1sW10KTNn4T
	 6nMH1v+7FJSwi5YueQxa6AYiZaDm97dPoc7L7LwNY3H/jcq5Eivqz1TBZAZsgARaTR
	 G4gX0NmR8b7JajUpKmYStENW73bvMfbTO8m3PUUqNJeC2O8DcwakwD6sk5IUxfB+Tn
	 kBHha16nBp/og==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 0/7] Netfilter/IPVS updates for net-next
Date: Fri, 24 Jul 2026 12:49:25 +0200
Message-ID: <20260724104932.437729-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS updates for net-next,
just a small batch with accumulated pending updates:

1) In IPVS, use system_dfl_long_wq instead of system_long_wq, from
   Ismael Luceno.

2) Add missing .checkentry in xt_tcpmss for IPv6, this is a follow up
   to a recent harderning, from Florian Westphal.

3) Address a sashiko report in the NAT SIP helper, from Florian Westphal.

4) Tear down flow entries with stale routes using the GC, this is to
   detect route updates when hardware offload is enabled.

5) Pass master conntrack as parameter to functions instead of using
   exp->master as preparation work to turn exp->master into a cookie.

6) Move expectation event_mask to the nf_conntrack_expect object,
   again as preparation work to turn exp->master into a cookie.

7) In IPVS, use kzalloc_obj{s}() typesafe allocations, from Subasri S.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-07-24

Thanks.

----------------------------------------------------------------

The following changes since commit 89d8006259b81dd25c962f6cc8d7ab268d6ea426:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-07-23 14:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-07-24

for you to fetch changes up to cca2780b61947fd27ec621541edd0902e193a609:

  ipvs: use type-safe allocation helpers in ip_vs_rht_alloc (2026-07-24 11:45:19 +0200)

----------------------------------------------------------------
netfilter pull request 26-07-24

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: xt_tcpmss: extend checkentry to ipv6
      netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet

Ismael Luceno (1):
      ipvs: Move defense_work and est_reload_work to system_dfl_long_wq

Pablo Neira Ayuso (3):
      netfilter: flowtable: tear down flow entries with stale dst from GC
      netfilter: conntrack_helper: pass master conntrack to helper functions
      netfilter: nf_conntrack_expect: store event cache in expectation

Subasri S (1):
      ipvs: use type-safe allocation helpers in ip_vs_rht_alloc

 include/linux/netfilter/nf_conntrack_amanda.h | 1 +
 include/linux/netfilter/nf_conntrack_ftp.h    | 1 +
 include/linux/netfilter/nf_conntrack_irc.h    | 1 +
 include/linux/netfilter/nf_conntrack_tftp.h   | 1 +
 include/net/netfilter/nf_conntrack_expect.h   | 3 +++
 include/net/netfilter/nf_flow_table.h         | 8 ++++++++
 net/netfilter/ipvs/ip_vs_core.c               | 9 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c                | 6 +++---
 net/netfilter/ipvs/ip_vs_est.c                | 2 +-
 net/netfilter/nf_conntrack_amanda.c           | 2 +-
 net/netfilter/nf_conntrack_broadcast.c        | 6 ++++++
 net/netfilter/nf_conntrack_ecache.c           | 7 +------
 net/netfilter/nf_conntrack_expect.c           | 5 +++++
 net/netfilter/nf_conntrack_ftp.c              | 2 +-
 net/netfilter/nf_conntrack_irc.c              | 2 +-
 net/netfilter/nf_conntrack_netlink.c          | 5 +++++
 net/netfilter/nf_conntrack_tftp.c             | 2 +-
 net/netfilter/nf_flow_table_core.c            | 2 ++
 net/netfilter/nf_flow_table_ip.c              | 8 --------
 net/netfilter/nf_nat_amanda.c                 | 7 ++++---
 net/netfilter/nf_nat_ftp.c                    | 4 ++--
 net/netfilter/nf_nat_irc.c                    | 2 +-
 net/netfilter/nf_nat_sip.c                    | 5 +++++
 net/netfilter/nf_nat_tftp.c                   | 5 ++---
 net/netfilter/xt_tcpmss.c                     | 1 +
 25 files changed, 61 insertions(+), 36 deletions(-)
