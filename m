Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2703D1AA4;
	Fri,  3 Jul 2026 12:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083438; cv=none; b=YBCWlITqiroiUieKKv9YtFT3+xWQv3cMlno5kk0aig40uAjP52ZeTdlOc+D59SdkSAzgAjazfiRWEmLDwIFirnP46ppik5y2JmIW9WI9WC5sS82qQDr6+N/de16ecMn8Nf9dF9z18qcVCJwH7SOyo0MV7Zepyug+wUW3GLac4dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083438; c=relaxed/simple;
	bh=Qh2AebDPP6V334mO4EbGUQK1Q97xupx09IiP6HcnOU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l26r8nVxcnaeX3OyJcCFnX10l2ZjyRoFkOpwX6wplDmY1ZrSOoBAIYvzcDwzagTZYNvLKHPQE5q5cIIR2TZGtkiC4I0oDup/W4lVgel2BcA/ih9pO8AU5SZkujgwCToL3HcszIoq0DH8DPWr78fnM3JV1XB0R+3NBiNltThu3kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4511360687; Fri, 03 Jul 2026 14:57:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 0/9] netfilter: updates for net
Date: Fri,  3 Jul 2026 14:57:00 +0200
Message-ID: <20260703125709.16493-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*, all
for ancient problems.  Patch 7 raised drive-by sashiko findings,
but those are not related to the change itself.

1) Rebuild the nf_nat_sip data pointer to prevent stale access after SKB
reallocation. Restrict UDP mangling to UDP streams to avoid TCP packet
corruption.

2) Prevent undefined behavior in xt_u32 caused by invalid shift counts.
From Wyatt Feng.

3) Use u64 variables to prevent incorrect comparisons on links exceeding
34 Gbps in xt_rateest.  From Feng Wu.

4) Cap the number of expectations per master during nfnetlink_cthelper
updates. From Pablo Neira Ayuso.

5) Mark malformed IPv6 extension headers for hotdrop in ip6tables.
From Zhixing Chen.

6) Skip the end element of an open interval during the get command when its
closest match is the interval's start element. Also from Pablo Neira Ayuso.

7) Fix PMTU calculation for GUE/GRE tunnels in IPVS during ICMP fragmentation
error handling. Include additional tunnel header length when computing the
new MTU. From Yizhou Zhao.

8) Reset full ip_vs_seq structures in ip_vs_conn_new. Also from Yizhou Zhao.

9) Reject invalid shift parameters in xt_connmark. Also from Wyatt Feng.

Please, pull these changes from:
The following changes since commit d335dcc6f521571d57117b8deeebc940836e5450:

  gue: validate REMCSUM private option length (2026-07-03 09:34:53 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-07-03

for you to fetch changes up to 1b47026fb4b35bac850ad6e8a4ad7fc018e09ebc:

  netfilter: xt_connmark: reject invalid shift parameters (2026-07-03 14:45:21 +0200)

----------------------------------------------------------------
netfilter pull request nf-26-07-03

----------------------------------------------------------------

Feng Wu (1):
  netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()

Florian Westphal (1):
  netfilter: nf_nat_sip: reload possible stale data pointer

Pablo Neira Ayuso (2):
  netfilter: nfnetlink_cthelper: cap to maximum number of expectation
    per master on updates
  netfilter: nft_set_rbtree: get command skips end element with open
    interval

Wyatt Feng (2):
  netfilter: xt_u32: reject invalid shift counts
  netfilter: xt_connmark: reject invalid shift parameters

Yizhou Zhao (2):
  ipvs: fix PMTU for GUE/GRE tunnel ICMP errors
  ipvs: reset full ip_vs_seq structs in ip_vs_conn_new

Zhixing Chen (1):
  netfilter: ip6tables: mark malformed IPv6 extension headers for hotdrop

 net/ipv6/netfilter/ip6t_ah.c       |  5 +++++
 net/ipv6/netfilter/ip6t_hbh.c      |  1 +
 net/ipv6/netfilter/ip6t_rt.c       |  3 ++-
 net/netfilter/ipvs/ip_vs_conn.c    |  4 ++--
 net/netfilter/ipvs/ip_vs_core.c    |  6 +++---
 net/netfilter/nf_nat_sip.c         | 11 +++++++++++
 net/netfilter/nf_tables_api.c      |  3 +++
 net/netfilter/nfnetlink_cthelper.c |  2 ++
 net/netfilter/nft_set_rbtree.c     |  8 ++++++--
 net/netfilter/xt_connmark.c        | 14 ++++++++++++--
 net/netfilter/xt_rateest.c         |  2 +-
 net/netfilter/xt_u32.c             | 12 +++++++++++-
 12 files changed, 59 insertions(+), 12 deletions(-)

-- 
2.54.0

