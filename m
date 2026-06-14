Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDBE2D7DEA;
	Sun, 14 Jun 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781437572; cv=none; b=Wfy6HsVQdzzgVAgEX9TMspIY4gEgQXRVwmRCkewpS6Tqb++PJk6zObUPd9YG6cBBr16TiWYvLjWyIvOkTZyz8G+niLKypL6g7I+GZv2cOcCAG7vz/To79LBAxhdmGwfsI6Bg75di7s2VKAaOI5Rrjs6zHk0tAY5Nsky5+l4Wt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781437572; c=relaxed/simple;
	bh=OeCQHgTLmeKfFMUJ3oDG4FrfsFUBJ0omY3kTV8JPXmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GohWQiM3wFDZU02ndMbyeG6BrjhLrmESa6ZTXfiaxT/b3mFPlyMCYKTEs2YFAnH8q/TYPWfS5akI+KS6bmWD2XuwN7uV1qqzYoeD4XdQi4iuYhEZhcLL3uubqm6MrkVX8tzuoPKn0Riy2JItzZbq6O0jFLtaTfemZHx65cGzOGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hMH1ZJtU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hMH1ZJtU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 763B8600B5;
	Sun, 14 Jun 2026 13:46:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781437568;
	bh=WpoAJnA4utPblqfZ2mrlKZxDRn+znqnvT8EN6fuLuEE=;
	h=From:To:Cc:Subject:Date:From;
	b=hMH1ZJtUivuYp1LCmJCZQ/Tca36RV6Du+DvGHy8oNVxVhhLgYsSlcEvNF/q/NIewt
	 5sF1Uyk6ZXVILMzbpzt3ywOmUulKcvJSjw062wYmMOZJP4aHBC3PsWHSs0pPMvCgSH
	 UjgK4YiVsAzB63qHDOmFgo5yafPSdFhaNOqF/KwibV9wj6CldZnTT/2S2MZ92Vbwt7
	 +YtUxFywpJ1jHCsJjKblUnw6LsXkrPta5zHdFM3Kvc6zZ3f4a2lnEBSLUg/RtPkng3
	 jxKswtpIMXPb67WgU0D/3fh34frkpKgQIa/gK4nWex6oYXmed4Kbbo58Mq4waocR4P
	 hU5MvdoomSJIQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 00/11] Netfilter/IPVS updates for net-next
Date: Sun, 14 Jun 2026 13:45:54 +0200
Message-ID: <20260614114605.474783-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS updates for net-next.
More specifically, this contains conncount rework to address AI related
reports, assorted Netfiter updates and two small incremental updates on
IPVS:

1) Replace old obsolete workqueues (system_wq, system_unbound_wq)
   in IPVS, from Marco Crivellari.

2) Replace WARN_ON{_ONCE} by DEBUG_NET_WARN_ON_ONCE in nf_tables.
   In the recent years, reporters say that the use of WARN_ON{_ONCE}
   in conjunction with panic_on_warn=1 results in DoS. Let's replace
   it by DEBUG_NET_WARN_ON_ONCE so this is only exercised by test
   infrastructure and fuzzers, while also providing context to AI
   agents. From Fernando F. Mancera.

Five patches from Florian Westphal to address AI reports in the conncount
infrastructures:

3) Fix missing rcu read lock section when calling
   __ovs_ct_limit_get_zone_limit().

4) Add a dedicate lock per rbtree tree, this increases memory
   usage but it should improve scalability.

5) Add a helper function to find the rbtree node, no functional
   changes are intented.

6) Add sequence counter to detect concurrent tree modifications
   and retry lookups.

7) Add locks to GC conncount walk and address other nitpicks.

Then, several assorted updates:

8) Defensive Tree-wide addition of NULL checks for ct extensions.

9) Bail out if flowtable bypass cannot be fully set up from the
   flow offload expression, instead of lazy building a likely
   incomplete one.

10) Fix documentation for the new conn_max sysctl toggle in IPVS.

11) Add nf_dev_xmit_recursion*() helpers and use them, to address
    recent AI reports.

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-06-14

Thanks.

----------------------------------------------------------------

The following changes since commit 4ed4f607e1cb6041db46ca5cd3200987d7d1eff2:

  Merge tag 'batadv-next-pullrequest-20260605' of https://git.open-mesh.org/batadv (2026-06-08 15:40:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-06-14

for you to fetch changes up to 2354e975932dabb06fad239f07a3b68fd1809737:

  netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them (2026-06-14 13:07:03 +0200)

----------------------------------------------------------------
netfilter pull request 26-06-14

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: use DEBUG_NET_WARN_ON_ONCE in packet and control paths

Florian Westphal (5):
      netfilter: nf_conncount: callers must hold rcu read lock
      netfilter: nf_conncount: use per nf_conncount_data spinlocks
      netfilter: nf_conncount: split count_tree_node rbtree walk into helper
      netfilter: nf_conncount: add sequence counter to detect tree modifications
      netfilter: nf_conncount: gc and rcu fixes

Julian Anastasov (1):
      ipvs: fix doc syntax for conn_max sysctl

Marco Crivellari (1):
      ipvs: Replace use of system_unbound_wq with system_dfl_long_wq

Pablo Neira Ayuso (3):
      netfilter: conntrack: check NULL when retrieving ct extension
      netfilter: flowtable: bail out if forward path cannot be discovered
      netfilter: nf_dup_netdev: add nf_dev_xmit_recursion*() helpers and use them

 Documentation/networking/ipvs-sysctl.rst    |  23 ++-
 include/net/netfilter/nf_conntrack_helper.h |   2 +
 include/net/netfilter/nf_dup_netdev.h       |  34 +++-
 net/ipv4/netfilter/nf_nat_h323.c            |  12 ++
 net/ipv4/netfilter/nf_nat_pptp.c            |  14 +-
 net/netfilter/ipvs/ip_vs_conn.c             |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |  10 +-
 net/netfilter/nf_conncount.c                | 230 +++++++++++++++++-----------
 net/netfilter/nf_conntrack_broadcast.c      |   3 +
 net/netfilter/nf_conntrack_expect.c         |  33 ++--
 net/netfilter/nf_conntrack_ftp.c            |   6 +
 net/netfilter/nf_conntrack_h323_main.c      |  18 +++
 net/netfilter/nf_conntrack_pptp.c           |   9 ++
 net/netfilter/nf_conntrack_proto_gre.c      |   9 ++
 net/netfilter/nf_conntrack_sane.c           |   3 +
 net/netfilter/nf_conntrack_seqadj.c         |  17 +-
 net/netfilter/nf_conntrack_sip.c            |  41 ++++-
 net/netfilter/nf_dup_netdev.c               |  15 +-
 net/netfilter/nf_flow_table_path.c          |  81 +++++-----
 net/netfilter/nf_nat_sip.c                  |  12 ++
 net/netfilter/nf_tables_api.c               |  38 +++--
 net/netfilter/nf_tables_core.c              |   8 +-
 net/netfilter/nf_tables_offload.c           |   2 +-
 net/netfilter/nf_tables_trace.c             |   6 +-
 net/netfilter/nfnetlink_cthelper.c          |   6 +
 net/netfilter/nft_ct.c                      |   2 +-
 net/netfilter/nft_ct_fast.c                 |   2 +-
 net/netfilter/nft_exthdr.c                  |   2 +-
 net/netfilter/nft_fib.c                     |   2 +-
 net/netfilter/nft_fwd_netdev.c              |  17 +-
 net/netfilter/nft_inner.c                   |   2 +-
 net/netfilter/nft_lookup.c                  |   2 +-
 net/netfilter/nft_masq.c                    |   2 +-
 net/netfilter/nft_meta.c                    |  10 +-
 net/netfilter/nft_payload.c                 |   6 +-
 net/netfilter/nft_redir.c                   |   2 +-
 net/netfilter/nft_reject.c                  |   8 +-
 net/netfilter/nft_rt.c                      |   2 +-
 net/netfilter/nft_set_hash.c                |   2 +-
 net/netfilter/nft_set_pipapo.c              |   2 +-
 net/netfilter/nft_set_rbtree.c              |   6 +-
 net/netfilter/nft_socket.c                  |   8 +-
 net/netfilter/nft_tunnel.c                  |   2 +-
 net/netfilter/nft_xfrm.c                    |   6 +-
 net/openvswitch/conntrack.c                 |   2 +-
 45 files changed, 494 insertions(+), 229 deletions(-)
