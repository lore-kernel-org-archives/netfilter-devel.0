Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AAF539A;
	Thu, 10 Jul 2025 00:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752108416; cv=none; b=AnGkayfmA5euliwmqT4D5lctk/CdXCA5aJcydkOUv2tlIRkFoRUfeZtAJYvDLpOVFtM/018Ujxb0g8qiMBkIQ9DXt/zwfrQPzDjGe7gDjXR4B7YatYhL3jFUENMZK4vP3YE6hCCt1ZOveYMxvTQlEIDrB5C0lpFS3VEE6u3/TNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752108416; c=relaxed/simple;
	bh=5V6bxhbPGq2EpcDd31XfHxY2VgucdOO6Ajsc/FdThhg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D9kyEcCDcFxUmf+EuvCiO3MEhYk6IJs5HKc9WrYXFnVSoRNIQ0jFikIWqs0mClWzuNUev9fXogyfXJEwgSbfjxCGzCcHb0zwqadfZRJxL+Y38sU+vg3/pWSiIKVUEXuMY2itsvXLU9FYpPxk04pSsuEgSypWOYlE6/gBPI9J/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fVS/+UmG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cr7ZXFW/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fVS/+UmG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cr7ZXFW/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CC2346026D; Thu, 10 Jul 2025 02:46:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108405;
	bh=B02sd/QFPkWoSluT7FOA8q0klkfukff4RZJThynUksQ=;
	h=From:To:Cc:Subject:Date:From;
	b=fVS/+UmGKfuukl6Smit3NX8YhzO6mfULly8I5uM0tQrF0XjlmZMnIScPWRoQsiD8J
	 CYCL5GPgOdKTHDG8Nre/KsLh8eUyAbJEdvNzwyB3ms2Zemrmfqlw6luciIUxYI/YmW
	 SQbNhre5HiFPWbmCISPhhcES3CnZ047fkLQg6FKhVoiQz37+I/2UYkjwF6Z/hopeVq
	 Hivl2BFzGowoMOCieckE6SdQI2fiqiJpM7tuUZaTI74C8v71tYLN0+bfcZj8Ss+yXp
	 oi2p84DV75mRmqCDN/QB5YeT01x3JwSoOUYmrjFvNoSOfmmvrq1wPlaJwcd8l5nSci
	 Wha/zS5oQ6k7w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BB8456026D;
	Thu, 10 Jul 2025 02:46:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752108403;
	bh=B02sd/QFPkWoSluT7FOA8q0klkfukff4RZJThynUksQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cr7ZXFW/7BTW9aBeA3+rBWC/Pzc6TP3Ng0cvrx+xDLvdUjkQ71ymTU+sDS2eq5B+w
	 B4uYKoRtOy18V8CnDiTTG0mb+uWPqoHozzfpDoFDt954A6sx4Zc8ABEBFil5etNNd4
	 QIw6HIb/mR8dVT58oAkYwS3pMsVikffVs3o+A6iEkEzbrofEsV21WQ8EYg/h1uKUsY
	 /eF44d4A68CB6jZAf97SBYXGXupI46x+V8iVCKKB9kDmPw9/p4ygRw0qS4fASPIG6B
	 8KLy7dzDG31ylvQZMya9M7jMZIcIayMVjHZQqnYZRebhva+9sS5uPU+JY4VsCW/aNN
	 l3hYmzqywiRPA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 0/4] Netfilter updates for net-next
Date: Thu, 10 Jul 2025 02:46:35 +0200
Message-Id: <20250710004639.2849930-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains an initial small batch of Netfilter
updates for net-next:

1) Remove DCCP conntrack support, keep DCCP matches around in order to
   avoid breakage when loading ruleset, add Kconfig to wrap the code
   so it can be disabled by distributors.

2) Remove buggy code aiming at shrinking netlink deletion event, then
   re-add it correctly in another patch. This is to prevent -stable to
   pick up on a fix that breaks old userspace. From Phil Sutter.

3) Missing WARN_ON_ONCE() to check for lockdep_commit_lock_is_held()
   to uncover bugs. From Fedor Pchelkin.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-07-10

Thanks.

----------------------------------------------------------------

The following changes since commit 8b98f34ce1d8c520403362cb785231f9898eb3ff:

  net: ipv6: Fix spelling mistake (2025-07-02 15:42:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-07-10

for you to fetch changes up to 4fb15cea66043006a89269af77209a2703c961fd:

  netfilter: nf_tables: adjust lockdep assertions handling (2025-07-10 00:47:18 +0200)

----------------------------------------------------------------
netfilter pull request 25-07-10

----------------------------------------------------------------
Fedor Pchelkin (1):
      netfilter: nf_tables: adjust lockdep assertions handling

Pablo Neira Ayuso (1):
      netfilter: conntrack: remove DCCP protocol support

Phil Sutter (2):
      netfilter: nf_tables: Drop dead code from fill_*_info routines
      netfilter: nf_tables: Reintroduce shortened deletion notifications

 Documentation/networking/nf_conntrack-sysctl.rst |   1 -
 arch/arm/configs/omap2plus_defconfig             |   1 -
 arch/loongarch/configs/loongson3_defconfig       |   1 -
 arch/m68k/configs/amiga_defconfig                |   1 -
 arch/m68k/configs/apollo_defconfig               |   1 -
 arch/m68k/configs/atari_defconfig                |   1 -
 arch/m68k/configs/bvme6000_defconfig             |   1 -
 arch/m68k/configs/hp300_defconfig                |   1 -
 arch/m68k/configs/mac_defconfig                  |   1 -
 arch/m68k/configs/multi_defconfig                |   1 -
 arch/m68k/configs/mvme147_defconfig              |   1 -
 arch/m68k/configs/mvme16x_defconfig              |   1 -
 arch/m68k/configs/q40_defconfig                  |   1 -
 arch/m68k/configs/sun3_defconfig                 |   1 -
 arch/m68k/configs/sun3x_defconfig                |   1 -
 arch/mips/configs/fuloong2e_defconfig            |   1 -
 arch/mips/configs/ip22_defconfig                 |   1 -
 arch/mips/configs/loongson2k_defconfig           |   1 -
 arch/mips/configs/loongson3_defconfig            |   1 -
 arch/mips/configs/malta_defconfig                |   1 -
 arch/mips/configs/malta_kvm_defconfig            |   1 -
 arch/mips/configs/maltaup_xpa_defconfig          |   1 -
 arch/mips/configs/rb532_defconfig                |   1 -
 arch/mips/configs/rm200_defconfig                |   1 -
 arch/powerpc/configs/cell_defconfig              |   1 -
 arch/s390/configs/debug_defconfig                |   1 -
 arch/s390/configs/defconfig                      |   1 -
 arch/sh/configs/titan_defconfig                  |   1 -
 include/linux/netfilter/nf_conntrack_dccp.h      |  38 --
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h   |   3 -
 include/net/netfilter/nf_conntrack.h             |   2 -
 include/net/netfilter/nf_conntrack_l4proto.h     |  13 -
 include/net/netfilter/nf_reject.h                |   1 -
 include/net/netns/conntrack.h                    |  13 -
 net/netfilter/Kconfig                            |  20 +-
 net/netfilter/Makefile                           |   1 -
 net/netfilter/nf_conntrack_core.c                |   8 -
 net/netfilter/nf_conntrack_netlink.c             |   1 -
 net/netfilter/nf_conntrack_proto.c               |   6 -
 net/netfilter/nf_conntrack_proto_dccp.c          | 826 -----------------------
 net/netfilter/nf_conntrack_standalone.c          |  92 ---
 net/netfilter/nf_nat_core.c                      |   6 -
 net/netfilter/nf_nat_proto.c                     |  43 --
 net/netfilter/nf_tables_api.c                    |  56 +-
 net/netfilter/nfnetlink_cttimeout.c              |   5 -
 net/netfilter/nft_exthdr.c                       |   8 +
 46 files changed, 48 insertions(+), 1122 deletions(-)
 delete mode 100644 include/linux/netfilter/nf_conntrack_dccp.h
 delete mode 100644 net/netfilter/nf_conntrack_proto_dccp.c
