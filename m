Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089B1291C35;
	Thu, 17 Jul 2025 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752746299; cv=none; b=LFM0Wwts+xH+M0z1pmEOyqGe44OHfggQiWeiEEsHmLj/TMqWSsl6MnOQawA54XxD+hF+rgV0Dq9yFipUA4BVMObMm6TCzPPy9Z3EvS6Ef8y9NnVC0V8so8uF+PmCinmSeI83DWBJ63ZYCNC07aA9JnQmbmeJVHdxJCVCoGMtoQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752746299; c=relaxed/simple;
	bh=IitlOvrP9UBYpXrZVQEVsXlUBKMU5UVgWLqMcPYE3sg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s5zWU2wDfI12TW5bC59S1HY6QAMhEuYe8De/7Io0forGhIu+iwnURp6FOPDJ4CSWvRjHycoz7fEdzeeXL6wmMVD6KbL6Qd/moF1JXX04Jm1CAkzOwAsuV/pIy76iHmQvojz6tSooMOsEc19kZFxbmoA8DOzCFM9HFnGJntQeCVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=btzKArSC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p3mPJg6i; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="btzKArSC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p3mPJg6i"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7AAE26027C; Thu, 17 Jul 2025 11:58:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752746294;
	bh=88JEEQLgSPqzOHz03uNrXUThhGHY1rzhxSXA0VAghhI=;
	h=From:To:Cc:Subject:Date:From;
	b=btzKArSCmH/03vM3RFIJTIL1fIrwPcu/kO6nSFrOw9FWPJKapK/lTwg8kUoGAfRi/
	 b5rLML+yoJIhC/10uS1/Ib2x4MClmeG/JAPvcC2DZztfXQskqPkWTGWIAJUf3vMI8G
	 Zi/EnPvAUnd/bC6qTQtjeb8KtNzPXscc7ywLHTJRbjj24d0/xrHZusi9JkgQ67XmXf
	 1enjlAmnaIkPXFCIhkSW7fY4JOPbZVW0qdwMcFbNDBrp+Lcpvo/szSEdzT4vkIHLYF
	 Vded7fMljN/J4/RqeSOnVoUVBwMw3Klf/MJCD5tdplEPcYFwdP5U28qQSlWvj2f6Bd
	 CV6CMjG52mBWA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 460CA6027C;
	Thu, 17 Jul 2025 11:58:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752746292;
	bh=88JEEQLgSPqzOHz03uNrXUThhGHY1rzhxSXA0VAghhI=;
	h=From:To:Cc:Subject:Date:From;
	b=p3mPJg6iJRMZVnPshj1bXbqusc3eNNkkai3kk0fVkt4JPOy/Htps8Ed5yxUeYmyQ9
	 tBDBHAI5NL+J4+OQzdQSfRnXaTK1QJUYCznN854raQ+xC4FtYVoQtVIcBkm8v/tFPv
	 Fz2mdmAWb1BYUk4fWEqHgjKM2uGF3wdZ+GWmI67UQscpCjjhCV4iQgvMq6oDS4EQKM
	 fZi8cPJ/fNSEKAaNpYqtqVZwX1fwS2M1BCjE53h5GvNHfRiuRJg9RQkz1NtwT5Mg/n
	 9Tu26keoR+ov3ReS6hDeLmlTRA7twbT1OipO4EJBrvqI4Br0yADjOHO6/Kgfyy7SDu
	 yYRakWk+GVu7w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v2 0/7] Netfilter fixes for net
Date: Thu, 17 Jul 2025 11:58:08 +0200
Message-Id: <20250717095808.41725-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: Include conntrack fix in cover letter.

-o-

Hi,

The following batch contains Netfilter fixes for net:

1) Three patches to enhance conntrack selftests for resize and clash
   resolution, from Florian Westphal.

2) Expand nft_concat_range.sh selftest to improve coverage from error
   path, from Florian Westphal.

3) Hide clash bit to userspace from netlink dumps until there is a
   good reason to expose, from Florian Westphal.

4) Revert notification for device registration/unregistration for
   nftables basechains and flowtables, we decided to go for a better
   way to handle this through the nfnetlink_hook infrastructure which
   will come via nf-next, patch from Phil Sutter.

5) Fix crash in conntrack due to race related to SLAB_TYPESAFE_BY_RCU
   that results in removing a recycled object that is not yet in the
   hashes. Move IPS_CONFIRM setting after the object is in the hashes.
   From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-07-17

Thanks.

----------------------------------------------------------------

The following changes since commit 7727ec1523d7973defa1dff8f9c0aad288d04008:

  net: emaclite: Fix missing pointer increment in aligned_read() (2025-07-11 16:37:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-07-17

for you to fetch changes up to 2d72afb340657f03f7261e9243b44457a9228ac7:

  netfilter: nf_conntrack: fix crash due to removal of uninitialised entry (2025-07-17 11:23:33 +0200)

----------------------------------------------------------------
netfilter pull request 25-07-17

----------------------------------------------------------------
Florian Westphal (6):
      selftests: netfilter: conntrack_resize.sh: extend resize test
      selftests: netfilter: add conntrack clash resolution test case
      selftests: netfilter: conntrack_resize.sh: also use udpclash tool
      selftests: netfilter: nft_concat_range.sh: send packets to empty set
      netfilter: nf_tables: hide clash bit from userspace
      netfilter: nf_conntrack: fix crash due to removal of uninitialised entry

Phil Sutter (1):
      Revert "netfilter: nf_tables: Add notifications for hook changes"

 include/net/netfilter/nf_conntrack.h               |  15 +-
 include/net/netfilter/nf_tables.h                  |   5 -
 include/uapi/linux/netfilter/nf_tables.h           |  10 --
 include/uapi/linux/netfilter/nfnetlink.h           |   2 -
 net/netfilter/nf_conntrack_core.c                  |  26 ++-
 net/netfilter/nf_tables_api.c                      |  59 -------
 net/netfilter/nf_tables_trace.c                    |   3 +
 net/netfilter/nfnetlink.c                          |   1 -
 net/netfilter/nft_chain_filter.c                   |   2 -
 tools/testing/selftests/net/netfilter/.gitignore   |   1 +
 tools/testing/selftests/net/netfilter/Makefile     |   3 +
 .../selftests/net/netfilter/conntrack_clash.sh     | 175 +++++++++++++++++++++
 .../selftests/net/netfilter/conntrack_resize.sh    |  97 +++++++++++-
 .../selftests/net/netfilter/nft_concat_range.sh    |   3 +
 tools/testing/selftests/net/netfilter/udpclash.c   | 158 +++++++++++++++++++
 15 files changed, 468 insertions(+), 92 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_clash.sh
 create mode 100644 tools/testing/selftests/net/netfilter/udpclash.c
