Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCB28B3F8;
	Thu, 17 Jul 2025 09:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745899; cv=none; b=FU4bVn1SGV+e28m4SK1CNQ2p0is1Qv07F/vGlRExTahMG0Td/qzrhs7ZEF6RDQARM9JjCdFssxUyxAdu/SO7uo8/hlFmBuFVKJG0e6iHqnXzhH2I11xQYbD5RMFlDMevidxE2dYn6h3uubkDpUa+529bwl4Dw2ttt7IkxEYhPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745899; c=relaxed/simple;
	bh=WtnybkwodSajCbtbb9Pn/1XbTgRj88tSievYzNnCtP4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bybo+OBNns7UTVDH6JdJyYg5gw03gbwMXvduZdAjHEqXT3OvDq1kNej74sVlhsDcw4hungw/ra3AyQvrirxwmlOWUZvTAFek8WBRwrOn//suGHIaXsld9xMtvT3E9TDLXfZ8ggfmdUQs7wjkANdVlypf3gCfwk4d7SS/IwOg/3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wo4hWISE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Cy7H138B; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wo4hWISE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Cy7H138B"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E79B5602B5; Thu, 17 Jul 2025 11:51:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745887;
	bh=RcnMvOQNPMK7IxiXge45OKtQXiHJTPDtjW4C6hGbAYQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Wo4hWISEyAqPz3oNY+lHcpqYBgsdbuhSxmMlnYjvSjRLl5+kVJ7D6F7XmFOLkSQv2
	 v+DiV5F+C3SzOxCn2n38jGXtKRoq1jKy3hrWSUulTceXkSycN95w9AORxHQJS0NGya
	 Y7InAAo5wEydv6FVxj4YQcmXTJdOLPDRidjBgRsXYnC7pWVtHS4Pmr7KGl/kWEeABd
	 I8H9sfwowYrcctfJgchM/DlGtmKyDZcU6GHgvqPE0LoZsWMRTkT2bQTy3SeIn02TN+
	 LsBiXt2RJy72lrseQ8n6uovUrgN8aaAfwVNIPQ31Jm1tooT/u26iFP78DDZEW9JfPV
	 AlummIhGpWYgw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5AE4602AD;
	Thu, 17 Jul 2025 11:51:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752745886;
	bh=RcnMvOQNPMK7IxiXge45OKtQXiHJTPDtjW4C6hGbAYQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Cy7H138BR/0/H61o/r8Z3zuFxnDDsdKEBw1XpzWDyAFehNijBSp4ZAz97bOFLL/uw
	 cLvUcUPyF5YyoCYExa9ag36UaE5EBY6iam2r4U4xZ/V1wHpW0rdiEwrtXw9uNBN/p7
	 vbNBVvgpg9gqeda24GcsmZHN7lQQb75vgyUzpbRebq4ZFYNhwDgM4nuLGSW278jiP5
	 xDevWdQEZYwz/1SZJlzVJdAhjFbPv3buDke1r45fW3u7HD3XQPA31oNE/U7Ge+2VhB
	 VY6jcrI/XoO1vIlWhATJPeX03zLxs7L0IVZZsf/TfuuBqxUvwA+CE+l2RXnAqBtSOy
	 mzgQj4ueBU8Iw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/7] Netfilter fixes for net
Date: Thu, 17 Jul 2025 11:51:15 +0200
Message-Id: <20250717095122.32086-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
