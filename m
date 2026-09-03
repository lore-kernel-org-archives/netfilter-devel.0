Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D4F4A0C;
	Thu,  3 Sep 2026 00:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396119; cv=none; b=aCirE5R3UMXGFOlsJSRWiR4Pns8eOKUDizWDIkbWz2opII4S0PyFWpGtaoNP5NNS7o3q6i6W3wpk0kZGPt1dQuCsCn6CScxbtyOyXeGJ23TI2/DzopqEXwPxYmXUHr00gd06kglC8Lrgl8vBET1ltMiJumO0qykaLMwXxrpPsYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396119; c=relaxed/simple;
	bh=TRmEKZkJR2+ELkH+wGihNLpLrG2wU/P9yqnpLpOWfiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KAjri6d+GGZhPJnpvKpsHMZrblocas3Fraz9/1Bgzl3cV/QpGa4jTMGPzEqpNouVC2JN0UdOeQ/e3WFSyY3jm0sutDe00wfImL+CQOYLf1r/HFn7WXn0wQoUfBM+/ZDewW3crt+LODqmwxyv++cKtz9Z24DtGExL6UXBuy/sTAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BgAESIuZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BgAESIuZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396113;
	bh=DGRqmWTzMUZYreLjp6xAI8yhjLHm4ZsGNtWWla6cqLU=;
	h=From:To:Cc:Subject:Date:From;
	b=BgAESIuZ+N439D4/Ba8y+/j0gTF/NC9OWEJscaoMqz7Oy4vW9pbsCiq4JzdOe+au5
	 VXBWZ7BdLE1nmlVpnICClbU4Hos3PqSCxsToBpIAmsBbkyY5PVglJu3+kcdhCDTMlw
	 ExI1cSWMOYJDbKXCWSh+IJmvabSBcd7RSawuVyVLJOOfUpDlq3SPt0R/o1hzH0+kst
	 GBWlnNlFRkzpFLBkBBb/NLPUXqqUZxpqyC48yE/6zfhM7kcnoFjI2L006T9csogAzi
	 9DS8eFxJQo4uXABuElEY/wl+fLqzvqzjDI0VOq+TMI2OZRR3pWG8qzuP9dR2XhyUzY
	 jpOHSbTILR+1g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 447366079C;
	Thu,  3 Sep 2026 02:41:53 +0200 (CEST)
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
Subject: [PATCH net 00/12] Netfilter/IPVS fixes for net
Date: Thu,  3 Sep 2026 02:41:37 +0200
Message-ID: <20260903004149.1037028-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Reject malformed messages in IPVS sync, from Kyle Zeng.

2) Fix possible stale infoleak in IPVS sync, also from Kyle Zeng.

3) Out-of-bound read in the SIP conntrack helper, from
   Joas Antonio dos Santos.

4) UaF on cttimeout module removal, from Chengfeng Ye.

5) Unregister nf_loggers before netns teardown to fix UaF,
   also from Chengfeng Ye.

6) Limit IPVS cache growth for LBLCR and LBLC schedulers,
   from Zhiling Zou.

7) Restrict checksum offset to known supported protocols in
   nft_payload, from Florian Westphal.

8) Fix race in nfnetlink_log due to concurrent instance destruction,
   from Florian Westphal.

9) Hold nfnl mutex from event notifier path of nfnetlink_queue to deal
   with race between close() and UNBIND request on same portid, also
   from Florian.

10) Remove arp_table 32bit compat interface, this is already off in
    many distributions, from Florian Westphal.

11) Set IP6T_F_PROTO flag is e->ipv6.proto is set on to deal with
    insufficient validation of xtables extensions when used from
    legacy ip6tables, from Florian.

12) Set on the NLM_F_DUMP_FILTERED flag when all is filtering out
    in ctnetlink, from Ilya Maximets.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-03

Thanks.

----------------------------------------------------------------

The following changes since commit 1d2929d0850fff683b8aff051275945e65f082c8:

  net: psp: do not inherit the Rx association on clone (2026-09-01 15:12:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-09-03

for you to fetch changes up to 5dfd63737fb19c6b179799d3ae784673152f61eb:

  netfilter: report NLM_F_DUMP_FILTERED when all is filtered out (2026-09-03 01:39:28 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-03

----------------------------------------------------------------
Chengfeng Ye (2):
      netfilter: cttimeout: prevent UAF during module unload
      netfilter: nf_log: unregister loggers before per-net teardown

Florian Westphal (5):
      netfilter: nft_payload: restrict checksum offsets to known values
      netfilter: nfnetlink_log: cope with concurrent instance destruction
      netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
      netfilter: arp_tables: remove the 32bit compat interface
      netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Ilya Maximets (1):
      netfilter: report NLM_F_DUMP_FILTERED when all is filtered out

Joas Antonio dos Santos (1):
      netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng (2):
      ipvs: reject invalid states in connection template sync records
      ipvs: fix reversed sequence option serialization

Zhiling Zou (1):
      ipvs: bound LBLCR and LBLC cache growth

 include/linux/netfilter_arp/arp_tables.h |  19 --
 net/ipv4/netfilter/arp_tables.c          | 472 +------------------------------
 net/ipv6/netfilter/ip6_tables.c          |   5 +
 net/netfilter/ipvs/ip_vs_lblc.c          |   3 +
 net/netfilter/ipvs/ip_vs_lblcr.c         |   3 +
 net/netfilter/ipvs/ip_vs_sync.c          |  20 +-
 net/netfilter/nf_conntrack_netlink.c     |   2 +
 net/netfilter/nf_conntrack_sip.c         |   2 +-
 net/netfilter/nf_log_syslog.c            |   2 +-
 net/netfilter/nfnetlink_cttimeout.c      |   2 +-
 net/netfilter/nfnetlink_log.c            |  15 +-
 net/netfilter/nfnetlink_queue.c          |   8 +-
 net/netfilter/nft_payload.c              |  36 ++-
 13 files changed, 73 insertions(+), 516 deletions(-)
