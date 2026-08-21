Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D8D36E47A;
	Fri, 21 Aug 2026 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326727; cv=none; b=f3bdbQWtc2LSLHNcuvDh9mcK6Mh6RGcdwBWAnr+R8sEhZgjbzZcDgSkOTtYAuYKQFLQIcVTrg9F0aOUkPRcillZID5KHYMNn3rpuUQtw/I15g/6Qa/qerYzsiOgaUafE0nvYhUxRMk5je0Vx6IEXO1KtOgjFJNQhmm3vCcmY95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326727; c=relaxed/simple;
	bh=3jZmNsRLR1N69MNEjiefGgQAMz866Y6TFaqjVD55PdM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YDIBrHFFCVAqTQvM7Poi+gXA2Y/uAOUjEJ6ngg3J9aSqH6pbCh/0WRXbIZRlQe01GeyTR18k7yD4DqFDjLK+0h5fpZxlVBJJ/0OWlg5b7tmwB3aqtAZTVi24nGN4vMKvW1fv6/Nd07zvyosqaRdkDT6txK+OFqQ/XjYN9tN3gbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q8wZH3Kb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q8wZH3Kb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787326722;
	bh=m12sC6/tpC6rZgNOSmuh8dsRAXHki2ExYYGhiuH9PNM=;
	h=From:To:Cc:Subject:Date:From;
	b=Q8wZH3KbC8ETSFgbLkzgj5Sf6jaDe467QAVLLD9gZ5MzgDC31g1qXPtY2TB2+Idhk
	 V5AFHuXE/cCzHaaAUs2wnCsRh7jEfjks5HTa/7Z4xNmCVqav9QBha16CPAO3+hpX5r
	 fRHHYXK+2GF5Y4RN33pqKpeYs5A5A0XxgiW1Fcwi3mt142K3WMLQ+mdsuxBp3aGDNo
	 9tYEDThxFTglJq/AHJLWmkFh6IQBSnkPpSekMOgfxh0xNDiR6GLTF3nZe69p+TuvO4
	 x3hvD/PXiXb7iPHPJwSz0GiW7vDb11z4Ea8a1pBoB22BsXysk+zFesxFPCQvDzvowy
	 kysPslxHcFyCg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 82E3F6007C;
	Fri, 21 Aug 2026 17:38:41 +0200 (CEST)
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
Subject: [PATCH net 00/10] Netfilter fixes for net
Date: Fri, 21 Aug 2026 17:38:23 +0200
Message-ID: <20260821153833.245589-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
 
The following patchset contains Netfilter fixes for net:
 
1) Use DEBUG_NET_WARN_ON_ONCE() instead of WARN_ON() from the tproxy
   datapath, a recent bug found a way to reach WARN_ON from datapath
   due to insufficient validation of xt_TPROTO checkentry.
   From Fernando F. Mancera.
 
2) Similar to previous patch to replace WARN_ON_ONCE by
   DEBUG_NET_WARN_ON_ONCE() for connlimit. Not known issue, but
   since this patch has been around for a while, let's merge it.
   Also from Fernando.

3) Move nf_tables harware offload commit path after chain blob
   and audit to reduce chances of leaving the hardware in
   inconsistent state.

4) Add missing vzeroupper to nf_tables pipapo AVX2 to address
   performace degradation to later user of SSE code,
   from Eric Biggers.

5) Remove pr_debug() in x_tables extensions, a recent bogus found a
   way to print a unsanitized string in xt_IDLETIMER, many of these
   pr_debug() calls are there for historical reasons.

6) Use pr_info_ratelimited() in x_tables .checkentry.

7) Fix an imbalance in module refcount due to incorrect override
   expression logic with sets. Remove unnecessary clone in control
   plane, use the existing expressions provided by set or dynset
   expression. Release override expressions only.

9) Tigthen nf_tables device name removal, it is possible to remove
   prefix strings with exact device name. From Fernando F. Mancera.

9) Set on the set dead bit earlier, otherwise it is possible to
   call .commit on deleted sets. This also addresses the
   re-introduction of a bug.

10) Remove leftover definition of the local set_update_list.
    A recent patch made it per-netns but did not remove this which
    is now unused.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-08-21

Thanks.

----------------------------------------------------------------

The following changes since commit 746fc0787f616da418ffc04a110296fe95d53491:

  net: usb: cdc_ncm: add Apple MacBook Pro USB product ID 0x1902 (2026-08-20 14:47:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-08-21

for you to fetch changes up to 878ca6f9739ab460a185fd1f0e64c8ef026057e4:

  netfilter: nf_tables: remove leftover set_update_list (2026-08-21 17:12:59 +0200)

----------------------------------------------------------------
netfilter pull request 26-08-21

----------------------------------------------------------------
Eric Biggers (1):
      netfilter: nft_set_pipapo_avx2: add missing vzeroupper

Fernando Fernandez Mancera (3):
      netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
      netfilter: conncount: use DEBUG_NET_WARN_ON_ONCE on reaching count limit
      netfilter: nf_tables: fix device name and prefix match in hook lookup

Pablo Neira Ayuso (6):
      netfilter: nf_tables: move hardware offload step after building the chain blob
      netfilter: x_tables: remove pr_debug
      netfilter: xt_cgroup: use pr_info_ratelimited()
      netfilter: nf_tables: skip double clone set expressions on element insert
      netfilter: nf_tables: set on dead bit when performing early element removal
      netfilter: nf_tables: remove leftover set_update_list

 include/net/netfilter/nf_tables.h   |  2 -
 net/ipv4/netfilter/ipt_ah.c         | 10 +----
 net/ipv4/netfilter/nf_tproxy_ipv4.c |  2 +-
 net/ipv6/netfilter/ip6t_ah.c        | 27 +-----------
 net/ipv6/netfilter/ip6t_frag.c      | 41 +-----------------
 net/ipv6/netfilter/ip6t_hbh.c       | 40 ++++--------------
 net/ipv6/netfilter/ip6t_mh.c        |  3 --
 net/ipv6/netfilter/ip6t_rt.c        |  6 +--
 net/ipv6/netfilter/nf_tproxy_ipv6.c |  2 +-
 net/netfilter/nf_conncount.c        |  3 +-
 net/netfilter/nf_tables_api.c       | 84 +++++++++++++++++--------------------
 net/netfilter/nft_dynset.c          | 25 ++++++-----
 net/netfilter/nft_set_pipapo_avx2.c | 17 ++++----
 net/netfilter/xt_IDLETIMER.c        | 68 ++++++------------------------
 net/netfilter/xt_LOG.c              |  4 +-
 net/netfilter/xt_MASQUERADE.c       |  4 +-
 net/netfilter/xt_NETMAP.c           |  4 +-
 net/netfilter/xt_REDIRECT.c         |  4 +-
 net/netfilter/xt_cgroup.c           | 10 ++---
 net/netfilter/xt_esp.c              | 10 +----
 net/netfilter/xt_ipcomp.c           |  8 +---
 net/netfilter/xt_iprange.c          | 32 ++------------
 net/netfilter/xt_ipvs.c             |  1 -
 net/netfilter/xt_multiport.c        |  4 --
 net/netfilter/xt_sctp.c             | 19 +--------
 net/netfilter/xt_tcpudp.c           |  8 +---
 26 files changed, 117 insertions(+), 321 deletions(-)
