Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D191F4720;
	Tue,  7 Jan 2025 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275990; cv=none; b=jNM1gTpUFzKOtP9inhexJ568j3WdxCRgQN8+/1y0w1TeF6vBChbKCY1OJajGPI399NYkZ4QhF7sgLL4Zct1H80e2KnUZ7nu4ZS1GnlwhPq29EjEr6gQilIcmoh32x5IaFII06mAvGPrueXPBkDWYfoTpyIgjFM1aDYoRHDUfyLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275990; c=relaxed/simple;
	bh=GOng8ZIGtTSQgvNaD7xzP/6JyDKAysORsRiFtxSnCkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gWXJlgAVdMgk7MvAvrILGFdKq20oqVLi62uvNTBZ5RxSLSSTvSDoPyIFJJHpUz1DUVgWuuEsll5Qm1Hm0tpT55Al0sOs/GPcibXDX+vdsSQ5Ny4UYXyTqksxP8sMH+mz9wSK5JRiCLBGXw/XMdNvhRcl9IubK0t5Ktku/cPdhU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=HzFqlysy reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="HzFqlysy"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKmN6zsLzycR;
	Tue, 07 Jan 2025 19:47:32 +0100 (CET)
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
Subject: [PATCH 0/6] netfilter: x_tables: Merge xt_*.c files which has same name.
Date: Tue,  7 Jan 2025 19:47:18 +0100
Message-ID: <20250107184724.56223-1-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275653;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=2170; bh=rmTvNQXtFqt/OwQrK0u7GcxP5ZmAjOkhc4/8HI0TN0Y=;
	b=HzFqlysyJfPets51os+nLxoZlMcTrzMX5QcM0W/1uPWOC7NQPTi+VdkoBHqpKEN9
	YL/YagdcWUn5OaS+d5lz6DAwrEA3pR3Gas6odwwtfAI8ZdUBAUCNTYRwCTkCF5z3ZWX
	Bdzl+QV7kZg91jtvQcNXk4wKnXF7hOuuql0Kv/oHMHdE+BoNw0OVo8BxhwVy4/fgrE2
	yJi2ylkDjfnMTRd9JBxmgpR/0OQSHa8APhcs7pOEosghsdIVnXQRxc9xV6fMpaWwGGx
	XS/86z1oFm2GNDD3yroiusswZbAsGAC051HE2PW7XOWI6PwaI7goOJ10skdWbrp1d6F
	ud+3GQFu2w==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_*.c source files, which has same upper and
lowercase name format. Combining these modules should
provide some decent code size and memory savings.

test-build:
$ mkdir build
$ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
$ make O=./build/ ARCH=x86 -j 16

x86_64-before:
text    data     bss     dec     hex filename
 716     432       0    1148     47c xt_dscp.o
1142     432       0    1574     626 xt_DSCP.o
 593     224       0     817     331 xt_hl.o
 934     224       0    1158     486 xt_HL.o
1099     120       0    1219     4c3 xt_rateest.o
2126     365       4    2495     9bf xt_RATEEST.o
 747     224       0     971     3cb xt_tcpmss.o
2824     352       0    3176     c68 xt_TCPMSS.o
total data: 2373

x86_64-after:
text    data     bss     dec     hex filename
1709     848       0    2557     9fd xt_dscp.o
1352     448       0    1800     708 xt_hl.o
3075     481       4    3560     de8 xt_rateest.o
3423     576       0    3999     f9f xt_tcpmss.o
total data: 2353

Build as a module it can provide 50% reduction in
run-time memory use.

x86_64-before:
$ lsmod
xt_TCPMSS              12288  0
xt_tcpmss              12288  0

x86_64-after:
$ lsmod
xt_tcpmss              12288  0

Benjamin Szőke (6):
  netfilter: x_tables: Format code of xt_*.c files.
  netfilter: x_tables: Merge xt_DSCP.c to xt_dscp.c
  netfilter: x_tables: Merge xt_HL.c to xt_hl.c
  netfilter: x_tables: Merge xt_RATEEST.c to xt_rateest.c
  netfilter: x_tables: Merge xt_TCPMSS.c to xt_tcpmss.c
  netfilter: x_tables: Adjust code style of xt_*.c files.

 net/netfilter/Kconfig      |  84 +++++++++
 net/netfilter/Makefile     |  12 +-
 net/netfilter/xt_DSCP.c    | 161 -----------------
 net/netfilter/xt_HL.c      | 159 -----------------
 net/netfilter/xt_RATEEST.c | 248 --------------------------
 net/netfilter/xt_TCPMSS.c  | 345 ------------------------------------
 net/netfilter/xt_dscp.c    | 159 ++++++++++++++++-
 net/netfilter/xt_hl.c      | 163 +++++++++++++++--
 net/netfilter/xt_rateest.c | 255 +++++++++++++++++++++++++--
 net/netfilter/xt_tcpmss.c  | 352 +++++++++++++++++++++++++++++++++++--
 10 files changed, 972 insertions(+), 966 deletions(-)
 delete mode 100644 net/netfilter/xt_DSCP.c
 delete mode 100644 net/netfilter/xt_HL.c
 delete mode 100644 net/netfilter/xt_RATEEST.c
 delete mode 100644 net/netfilter/xt_TCPMSS.c

-- 
2.43.5

