Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72833E7BCE;
	Sun, 27 Sep 2026 22:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548484; cv=none; b=NhdmuLgjTlGQdCb+cNawqoCn0GuoNRqs+85063TkLD99exbjBZEQuPDnLKocotnFx1A2kGNeYaW7GISf3ya1beXI31g6cbaBNoxjFrZVHmqE0z4T/nmT6JfkX6Cfh1JTy3BP0JDRg3rZ8sKz2s7EP55o0IVCW2+tjzWJ4dI324M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548484; c=relaxed/simple;
	bh=uwG8rc0BMGGPQcp/24v/pq6mK3c1rcIg82KdpDVSRv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k4gF3mNxlqH0hqVd+RYI7DLQTTEqlnM4z+P8jIRX2lV/ugji1QB7hpWDzidCbqQV7AF9Rwrr+/NQiYE7ikdmVxY2ojBUyKFh4nOgmdyjqfP/41pqHtHIuwvb22Hv/T4lkQ+bvpAYZs1tikcSWsRaZyikLcJnXA2B9HfCw+18i8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NtM2bMSQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NtM2bMSQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548480;
	bh=htq3o40FA8U9d5IjwSFnSLFBdPZ3FP9IAR+5JsPPjwM=;
	h=From:To:Cc:Subject:Date:From;
	b=NtM2bMSQGrMnzawVG2HQkUBWM1g0Mh9JX6yfPMvR7RXe4DDSfctgcrKUe+FKEJxuk
	 m4X3N0wETay6PupeVhM9mqBW2u16zyjp5nknDqgibhdyuxAumb0kpBXdJc/yIR6wb9
	 lHA77/Yqp/utGAgRMgXQTpPTtfIjuFg0rnd3Dvif8le7GAkxEwqp/rCPX23/d7Dvg8
	 DwYeVuspcic/IBWrHX2/2/BJ8OWxcB+5g8def2VD4+D1e66G35YXYKMZd8SM+WfHsv
	 jWE+20oIv8xQfsKIUj2zb/IB2nywUrzV7qVe2gzheGhp+/PB8Hr63WjgTVwzaOY+PX
	 cKTeY/CwKGIJQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CB44360058;
	Mon, 28 Sep 2026 00:34:39 +0200 (CEST)
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
Subject: [PATCH net-next 00/11] Netfilter updates for net-next
Date: Mon, 28 Sep 2026 00:34:25 +0200
Message-ID: <20260927223436.269024-1-pablo@netfilter.org>
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

The following patchset contains Netfilter updates for net-next. The
fixes included in this batch are deemed to handle correctness issues
present in the Netfilter tree:

1) TCP sequence tracking is not reset inconditionally by synproxy when
   recycling an entry, sashiko reports the zero offset case skips it.
   Add a new function to inconditionally reset TCP sequence tracking.
   From Fernando F. Mancera.

2) Update documentation to reflect that the default maximum number of
   expectations (nf_conntrack_expect_max) is nf_conntrack_buckets / 64.
   From Shaojie Sun.

3) Remove useless break; after return in nft_osf, from Linkui Xiao.

4) Fix typos in comments in the netfilter tree, from Hemanth Selam.

5) Remove a few conntrack error stats duplicated updates,
   from Phil Sutter.

6) Do not bump invalid and drop conntrack error stats when packet is
   dropped, this is another duplicate. also From Phil.

7) Set on netns pointer before registering the flowtable, this is
   a requirement by the next patch, not fixing an existing issue.
   From Qingfang Deng.

8) Remove unnecessary workqueue work flush for all of the existing
   netns when device is gone. Also from Qingfang Deng.

9) Rework-fix nfnetlink_hook to correctly deal with large netlink
   dumps. Use sequence numbers to detect interference with hook
   updates while netlink dump is ongoing. From Phil Sutter.

10) Fix ctnetlink dump filtering by the IPv6 address, this has
    only work correctly for IPv4 this far, from Piotr Kubik.

11) ctnetlink filtering by zone is supported, but the ctnetlink
    dump filtering infrastructure was never updated to include a
    flag from userspace, update it to fill this gap.
    From Ilya Maximets.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-09-28

Thanks.

----------------------------------------------------------------

The following changes since commit 014d795c73837ea2339a4ea8e8f82c6e959b845d:

  idpf: fix kernel-doc parameter descriptions (2026-09-25 18:26:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-09-28

for you to fetch changes up to 46da6029bf468ce3c426cb8b4abf96976ed9d4c8:

  netfilter: conntrack: make filtering by zone discoverable (2026-09-27 23:39:21 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-28

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: synproxy: fix reset of ct seqadj when reopening a connection

Hemanth Selam (1):
      netfilter: fix several typos in comments

Ilya Maximets (1):
      netfilter: conntrack: make filtering by zone discoverable

Linkui Xiao (1):
      netfilter: osf: remove unreachable break in nf_osf_ttl()

Phil Sutter (3):
      netfilter: conntrack: Untangle insert_failed counter from others
      netfilter: conntrack: Untangle drop and invalid counters
      netfilter: nfnetlink: Fix for interrupted hook dumps

Piotr Kubik (1):
      netfilter: ctnetlink: fix inverted IPv6 address match in dump filter

Qingfang Deng (2):
      net/sched: act_ct: set net pointer before publishing flowtable
      netfilter: flowtable: check namespace before iterating flows

Shaojie Sun (1):
      netfilter: conntrack: fix nf_conntrack_expect_max default value in documentation

 Documentation/netlink/specs/conntrack.yaml         |   6 +
 Documentation/networking/nf_conntrack-sysctl.rst   |   2 +-
 include/net/netfilter/nf_conntrack_seqadj.h        |   1 +
 include/net/netns/netfilter.h                      |   2 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 net/ipv4/netfilter/arp_tables.c                    |   2 +-
 net/netfilter/core.c                               |  18 ++-
 net/netfilter/ipset/ip_set_core.c                  |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   5 +-
 net/netfilter/nf_conntrack_netlink.c               |  19 ++-
 net/netfilter/nf_conntrack_seqadj.c                |  17 +++
 net/netfilter/nf_flow_table_core.c                 |  17 +--
 net/netfilter/nf_nat_core.c                        |  11 ++
 net/netfilter/nf_synproxy_core.c                   |   4 +-
 net/netfilter/nfnetlink_hook.c                     |  74 ++++++-----
 net/netfilter/nfnetlink_osf.c                      |   1 -
 net/sched/act_ct.c                                 |   2 +-
 .../selftests/net/netfilter/conntrack_dump_flush.c | 145 ++++++++++++++-------
 .../net/netfilter/conntrack_icmp_related.sh        |   2 +-
 20 files changed, 229 insertions(+), 104 deletions(-)
