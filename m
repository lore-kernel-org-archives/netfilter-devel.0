Received: from smtp-out.freemail.hu (fmfe38.freemail.hu [46.107.16.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A81A9B43;
	Sun,  5 Jan 2025 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736120356; cv=none; b=RGYcbc1Qqctp1G+vbg0P2zeNPPd5XEcNBLNjWYWYinn8ctP8389S8fxrfODlk1hFw8+7edjaqwnxYFeFJLyVQma3W4/SuQnocMuBj8gyD8bWp0BEYaVUOXfGpCyQBzNH0k/aWeFWIl3jep3snzDPoUVaCFjNCOfCdqnt1gsS63o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736120356; c=relaxed/simple;
	bh=LLMBnuDYVA/hX7CMle6zeHun8lrx9y+uZRxv8HmmMvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KjEmzV9Eoz99TZtmy64CAoeaZgxVjj9n3sEga6UmVaKtKhO+lp+OJkm8/UaKZGTyBIyPQM1mWVDxZlVtCVhK5yZWiNadUYWE1hBBKexchdz4gs/sA6NP8PBW+oNhKaututHmG6Pcijyxc3cv0aQArt35197T6g1iAIPprZ6ugTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=hTlX9wTh reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="hTlX9wTh"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRD9n4sF9zYG9;
	Mon, 06 Jan 2025 00:32:13 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH v7 0/3] netfilter: x_tables: Merge xt_*.c files
Date: Mon,  6 Jan 2025 00:31:54 +0100
Message-ID: <20250105233157.6814-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736119934;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2065; bh=ljj4sLehPcKiEryj8eN2UfhppCqQPdtovrO1tiQm5VM=;
	b=hTlX9wThgvdH5LSYPcAU5KWAAFXo93pFVO4VeKeYtTWFNtgHxkJyTNkbrlO/k7Rp
	L+c51MvHfzBvhXzCMeYV6oK7tlfhxyOuRCtChQnMgMcN7CH2ZquZ8zJk9tRFRcgS9Ms
	GVCyRsmlNSiqLfP/JRx3CxMw6RssVPeOWnf1iBRHlbzvm1A6sNk31SxE5PTZz5Lmh9v
	7ixBAUI8Kd72acgjYctAoavCRmR/DlC3AFLH95ao4RQGjB7Iv5iGoWq2l1PzhIc/0n8
	VqbvNF4K9JfDYyAp/C4tqFpJur8eFPCUWHNCDW1KIenh6lr/d4o5ar7yHYzgthxWm6w
	vfjTj9sAHQ==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge and refactoring xt_*.h, ipt_*.h and ip6t_*.h header and xt_*.c
source files, which has same upper and lower case name format. Combining
these modules should provide some decent code size and memory savings.

Benjamin Szőke (3):
  netfilter: x_tables: Merge xt_*.h and ipt_*.h files which has same
    name.
  netfilter: x_tables: Merge xt_*.c files which has same name.
  netfilter: x_tables: Adjust code style for xt_*.h/c and ipt_*.h files.

 include/uapi/linux/netfilter/xt_CONNMARK.h  |   8 +-
 include/uapi/linux/netfilter/xt_DSCP.h      |  22 +-
 include/uapi/linux/netfilter/xt_MARK.h      |   8 +-
 include/uapi/linux/netfilter/xt_RATEEST.h   |  12 +-
 include/uapi/linux/netfilter/xt_TCPMSS.h    |  14 +-
 include/uapi/linux/netfilter/xt_connmark.h  |   7 +-
 include/uapi/linux/netfilter/xt_dscp.h      |  26 +-
 include/uapi/linux/netfilter/xt_mark.h      |   6 +-
 include/uapi/linux/netfilter/xt_rateest.h   |  19 +-
 include/uapi/linux/netfilter/xt_tcpmss.h    |  16 +-
 include/uapi/linux/netfilter_ipv4/ipt_ECN.h |  29 +-
 include/uapi/linux/netfilter_ipv4/ipt_TTL.h |  25 +-
 include/uapi/linux/netfilter_ipv4/ipt_ecn.h |  26 ++
 include/uapi/linux/netfilter_ipv4/ipt_ttl.h |  26 +-
 include/uapi/linux/netfilter_ipv6/ip6t_HL.h |  26 +-
 include/uapi/linux/netfilter_ipv6/ip6t_hl.h |  25 +-
 net/ipv4/netfilter/ipt_ECN.c                |   2 +-
 net/netfilter/Kconfig                       |  84 +++++
 net/netfilter/Makefile                      |  12 +-
 net/netfilter/xt_DSCP.c                     | 161 ---------
 net/netfilter/xt_HL.c                       | 159 ---------
 net/netfilter/xt_RATEEST.c                  | 248 --------------
 net/netfilter/xt_TCPMSS.c                   | 345 -------------------
 net/netfilter/xt_dscp.c                     | 160 ++++++++-
 net/netfilter/xt_hl.c                       | 160 ++++++++-
 net/netfilter/xt_rateest.c                  | 255 +++++++++++++-
 net/netfilter/xt_tcpmss.c                   | 353 +++++++++++++++++++-
 27 files changed, 1120 insertions(+), 1114 deletions(-)
 delete mode 100644 net/netfilter/xt_DSCP.c
 delete mode 100644 net/netfilter/xt_HL.c
 delete mode 100644 net/netfilter/xt_RATEEST.c
 delete mode 100644 net/netfilter/xt_TCPMSS.c

-- 
2.43.5

