Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAADF49;
	Thu, 10 Jul 2025 01:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752109636; cv=none; b=go1vu/sXo1nPbBiw/H/QZG0M6K4finCjfCdK9waEsxIY/ncThHSoxjlIN/0Ax1tzdM9RKD3pq1Q4rLnpVBIraueRDSB9+Ss/16a+mwle+OmM8IUtzXp9B9eIN/vGJL4ONGYNy+MuZDeF6mBh4Bfr7ED+g/KWdQLTTOzTTuA948M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752109636; c=relaxed/simple;
	bh=JcagzBhV/WkYL7Dv0uY29arNV/8AlBCp3O+wN8ZJ058=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sqU0qjBmAekzLdJAsBJta0nZ/ciChmh+1w7mE7T3aEHV+f9ciNSTiV1utpnnULqtrWqK7FeSTN1AOx5ez5h/4axsmoxHDGSfVDi+rszFLFrXLX/2AOtuaBuqGso+14R/o6P12F0SfNUE55AB3uctIfotrIMcPDed/HQkBRnn8ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IN+L8tua; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qGbcuAKr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IN+L8tua";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qGbcuAKr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7CFA5600B9; Thu, 10 Jul 2025 03:07:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109633;
	bh=w6XmEuhpTv7HHvzzZ3iieUA2kapE0MkevhP5AFdNIWM=;
	h=From:To:Cc:Subject:Date:From;
	b=IN+L8tuaem1UlyAR78kkgGH5IMVKlmV9FU/xs2vg2iENdgU24oj7VEu63d6Hpdg8p
	 FcAjOQOqaFdmKOuk6wVzXm2WHHscCRpRwvDW6VMcrKpJeiRTwIFEorN/HrORX8EB/s
	 bQ4QoHeW3i0iqcWRJd6ggNqpK0qUqhE3NZIpdwbPL0X/uSaDJmYJqbticorcHgq01S
	 SE+yS/HsmaqR8LLQRbMB48XwPK1muLuEOgui7tf0+1Kx1Wa6SoFrsJBXkvofnNmGEc
	 zBSHEKmWASWJRmdYkUDT/bBMLIyfRjAm23PTKFwJfxDFd8y9SxY1ZOM4G2u7bBcaT/
	 QwsetckO8iRsw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D855E600B9;
	Thu, 10 Jul 2025 03:07:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752109630;
	bh=w6XmEuhpTv7HHvzzZ3iieUA2kapE0MkevhP5AFdNIWM=;
	h=From:To:Cc:Subject:Date:From;
	b=qGbcuAKrh2+hTvU/67POaq9D44IJ+T2lo5e26l0BC9sUtPhUVOBGbSyu8tpoH/dXm
	 AkgrhXqc4X/t8BFvocx3ZFOSoqfi5b6OFznvLRdcx8pHK6BgxjqFj/ABh6Zx4+PrUu
	 WwEiu1iRABhWuC2H+pAIlOVsj2jLppOZIEhZ8yFn9dQwNA0jw2a3cIucETwTQ3DtdT
	 kWDah3tkSzloFhiDNTr8xLOghWILwUBNy/ZNWzuoR4EkK32NoYOeTAb0Nfkeby1+5z
	 vuPy1h5ARmNqWCFcRc8fE2jbBa7HH/zuIQL6gY4V1QYBXbg1bRddrpAR2Mg98WY09T
	 C7Lu/UvCPLOgA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Netfilter updates for net-next (v2)
Date: Thu, 10 Jul 2025 03:07:02 +0200
Message-Id: <20250710010706.2861281-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: missing Signed-off-by: tags in patch 2/4 and 3/4.

-o-

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

Thanks

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-07-10

Thanks.

----------------------------------------------------------------

The following changes since commit 8b98f34ce1d8c520403362cb785231f9898eb3ff:

  net: ipv6: Fix spelling mistake (2025-07-02 15:42:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-07-10

for you to fetch changes up to 8df1b40de76979bb8e975201d07b71103d5de820:

  netfilter: nf_tables: adjust lockdep assertions handling (2025-07-10 03:01:22 +0200)

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
