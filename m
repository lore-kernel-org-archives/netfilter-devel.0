Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F8B5111BB;
	Mon,  7 Sep 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801461; cv=none; b=YY3hX8+CTzOa72+RWH4GAlS9vdjcMHVO+FSMw5kF2TZk3XwW23XY1j5MM/X7zlbDYrZLY4mQcFiP+EE0OgsCNgkvc1J7yCEd5RECYKEFppXH5TWqdEL1QOgInIHV1X7chqxnLG+g4o/8XRl6xMiwyJxcCADf81uy4nLyvdGnh2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801461; c=relaxed/simple;
	bh=xKfwSGhhH3BbqJGertPlsHTVY4ImpDlnewKFxzE9+Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cxu8EQK48SPl0voC51qFBenJZvw8wpY5ILhhvR/gZM+RCnE2D/Yw3Gz0KbKRlOW6S67kLnQEAbCFZNV3W6dTxECciv/43hH6jIZ8a8MaR6VbbSPqpMu34IKEVTpw8vGzgiiQQ+mWcvxtyGApR6wwqW7oPjia0yZUan6Uwjpg8tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D/mXeJKp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D/mXeJKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801456;
	bh=afifqUi6Dx73QCCc7nFoL55Bf9UGkLVbHOmtTb3cL0Q=;
	h=From:To:Cc:Subject:Date:From;
	b=D/mXeJKpb5STkvukLYFInxDf9BCa924RGmCPoG019JCO/J1INXPBja6XPcdRuDg15
	 /CGzGQ0fjdW1A+/ZxQeh1fu0++sIGOK1I2ukpVjNTxQmpQ5jhSQAarPAbSzUsthQlX
	 jj4o0LC+P3x6NBJ6aTfS/DFPOS62MkgqvYVJRhLltt9+Zz+vebivtljaB0MOI4k00m
	 rAy+XYgFbEB+GxHQwAIz9j2tAceIbsHIqiCAlxh+JaEpTMkSaU6PxKklTSRsb8pf22
	 BIeELvOL1L0XnRKleF+pioGvR0qfy7o3He0DGrAqeoBDNlDFTY6OpopUEKRafVx8eB
	 o/JcX6E2Diu5A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1B07607CF;
	Mon,  7 Sep 2026 19:17:35 +0200 (CEST)
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
Subject: [PATCH net,v2 0/9] Netfilter/IPVS fixes for net
Date: Mon,  7 Sep 2026 19:17:23 +0200
Message-ID: <20260907171732.1407739-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: Keep back all the patches that Jakub's LLMs are complaining
    about.

-o-

The following patchset contains Netfilter/IPVS fixes for net:
 
1) Reject malformed messages in IPVS sync, from Kyle Zeng.
 
2) Fix possible stale infoleak in IPVS sync, also from Kyle Zeng.
 
3) Out-of-bound read in the SIP conntrack helper, from
   Joas Antonio dos Santos.
 
4) UaF on cttimeout module removal, from Chengfeng Ye.
 
5) Unregister nf_loggers before netns teardown to fix UaF,
   also from Chengfeng Ye.
 
6) Fix race in nfnetlink_log due to concurrent instance destruction,
   from Florian Westphal.
 
7) Remove arp_table 32bit compat interface, this is already off in
    many distributions, from Florian Westphal.
 
8) Set IP6T_F_PROTO flag is e->ipv6.proto is set on to deal with
    insufficient validation of xtables extensions when used from
    legacy ip6tables, from Florian.
 
9) Set on the NLM_F_DUMP_FILTERED flag when all is filtering out
   in ctnetlink, from Ilya Maximets.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-07

Thanks.

----------------------------------------------------------------

The following changes since commit 1d2929d0850fff683b8aff051275945e65f082c8:

  net: psp: do not inherit the Rx association on clone (2026-09-01 15:12:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-07

for you to fetch changes up to 7a099b347fef536a84068076e2d384f044e5cfc5:

  netfilter: report NLM_F_DUMP_FILTERED when all is filtered out (2026-09-07 18:48:56 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-07

----------------------------------------------------------------
Chengfeng Ye (2):
      netfilter: cttimeout: prevent UAF during module unload
      netfilter: nf_log: unregister loggers before per-net teardown

Florian Westphal (3):
      netfilter: nfnetlink_log: cope with concurrent instance destruction
      netfilter: arp_tables: remove the 32bit compat interface
      netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Ilya Maximets (1):
      netfilter: report NLM_F_DUMP_FILTERED when all is filtered out

Joas Antonio dos Santos (1):
      netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng (2):
      ipvs: reject invalid states in connection template sync records
      ipvs: fix reversed sequence option serialization

 include/linux/netfilter_arp/arp_tables.h |  19 --
 net/ipv4/netfilter/arp_tables.c          | 472 +------------------------------
 net/ipv6/netfilter/ip6_tables.c          |   5 +
 net/netfilter/Kconfig                    |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c          |  20 +-
 net/netfilter/nf_conntrack_netlink.c     |   2 +
 net/netfilter/nf_conntrack_sip.c         |   2 +-
 net/netfilter/nf_log_syslog.c            |   2 +-
 net/netfilter/nfnetlink_cttimeout.c      |   2 +-
 net/netfilter/nfnetlink_log.c            |  15 +-
 10 files changed, 34 insertions(+), 507 deletions(-)
