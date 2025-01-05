Received: from smtp-out.freemail.hu (fmfe28.freemail.hu [46.107.16.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0691448E3;
	Sun,  5 Jan 2025 23:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736119649; cv=none; b=QPhCMab8OOCZH+ByG7pXzFGDv9/VMexSuYW+TStllxPzN4Syf7hAULRyV4O0RobWyvcu3i1yQ+qKZ4luzzlVD6BKE68iKqSOpxDuZuDEwYiDCRx248JZCoLcVl7JnnUYUvw/ihaLIo2tKh42i9P6zWannFHAOjMUO/sHTVgUvFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736119649; c=relaxed/simple;
	bh=b4Xlpn4xY22Hrm7sN1J4WJTJh9JVnslnxbACFyHRKv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OXqzk5tda+trE96+t5CMXxIVAH0l2XfMbEFrn8cNqZlVW/oGJx/12z2zHq7XVJOYD13VZ9sj8liSTSVYCUFsTwTRY4u8MbcpoAX5/pB/IFjwqz1HqUQD69MYAdhjJpQeal08gzC02YjWFjTxUlDOslSynQPuoxViBsMihvdpx70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=duzNuhzp reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="duzNuhzp"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRCtp4XgGz15T9;
	Mon, 06 Jan 2025 00:19:14 +0100 (CET)
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
Subject: [PATCH v6 0/3] netfilter: x_tables: Merge xt_*.c source files which has same name.
Date: Mon,  6 Jan 2025 00:18:57 +0100
Message-ID: <20250105231900.6222-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736119155;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2235; bh=MMxCPOIVvWiJrrqO4m9wxpLQBvyRSOcUO6+lnHBYZsE=;
	b=duzNuhzpADKOm92EtpABVd/uTBfo6tF6KZOoZhuf85agqPaZYMUv1mEZCgiu/2wJ
	CCRuLD3Lo+ohKDvPvwxs3Zs7aUEcVk7YVy22cireerPv3H/PuorgLRbb56+bwck2WGi
	EYBtEFfC45Uiu1wK27su25CX4phCMyseiEGFOVfyqeUOpwcXSIvUvJmopgBhuTyiyED
	ZfU/xxcXHB/als7IMI+lsu3X5T1CG5APmeqexmO54+kaYhcLn7OmXsMB0WC4SVrZXvq
	AVlHkOO25eJjoW32CKhv3YMviIInsrPHH3SNZZ85ViNkXguywvFsWwhy3OklhHF3I7/
	ByXlpXVHiA==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge and refactoring xt_*.h, ipt_*.h and ip6t_*.h header and xt_*.c
source files, which has same upper and lower case name format. Combining
these modules should provide some decent code size and memory savings.

- netfilter: x_tables: Merge xt_*.h and ipt_*.h files
- netfilter: x_tables: Merge xt_*.c files which has same
- netfilter: x_tables: Adjust code style for xt_*.h/c

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

