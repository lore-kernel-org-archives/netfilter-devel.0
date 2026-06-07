Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2622EA749;
	Sun,  7 Jun 2026 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825803; cv=none; b=eVgWcZiTnQDcuUeIu2sU2ZMIQVZay/mleEpGOwf659wVN82omu3lnqmIlJCH3h5yH0CPqB7B+feSoRfiOcKorsieyv8hHWAhn7SpHVH+FnC8XdCy9PP+Dd7IM9F/VaoDwvFGOH7u/e05GFrbzHVD4iD9hUWJryMmhIbFs92+0RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825803; c=relaxed/simple;
	bh=rJ7eETTzifsaXgtHdZ7aVsiEUvTTjl/OQRlBUx2AgYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W5JQD8VlWDISPDkBPf4PzEeIefp1PpAAdBs7KlRosAcmR6BxtW2RtCuwNSaIvORJb7NbI6j4WERPrHGZyUCs+FYK97cpnBkXctErK1JNoDTTV5DjAEi/7lnAMY8g2sU0jirBlhJw+CJCV31juGEeWldjRl0sFazoyRCSjKemWDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IlogekaJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IlogekaJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 056DB6017D;
	Sun,  7 Jun 2026 11:49:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825799;
	bh=Zx8NOYTyLWz4MZPw2rSfn+u9IpYmGSzWjRHYcGFzBCg=;
	h=From:To:Cc:Subject:Date:From;
	b=IlogekaJh1nesqZXg3estCX5X01MCk9NxDx4R7foPPi5/x3qLS+0Tn6fSkkbXmpS3
	 iIB+wFRrow+wjghZHh6Tpj9EuPxYHXWlSuHBLaoBgl2K0WYg4RSyDAe1nPd96dxCoV
	 t31FGkz2HyFppkTE9LEoYzSOTNxWaDCdovIsyM20CgeMeTnJK9Dst64U7295GEr0wY
	 fS96UVfMWhvOjYmthU2Sb057lwGlScOcvXpxq1/JRt/MtCBEXQFEr1rRiTLYA74CEe
	 rsU4j6HFJ3p8vEiEZItZRnlEk7Bfly1KM8G7oqhynMgmuM8T5Jil2841oUqvz7I88Y
	 X0KkAzSrIhc2g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Date: Sun,  7 Jun 2026 11:49:39 +0200
Message-ID: <20260607094954.48892-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter/IPVS updates for net-next,
this contains updates to address sashiko reports in IPVS and Netfilter
on possible pre-existing issues. This also includes a series to add
refcount for ct helper and timeout to deal with a corner case scenario
with unconfirmed conntracks flying to nfqueue.

1) Add a conn_max sysctl to IPVS to limit the maximum number of
   connections, from Julian Anastasov.

2) Use get_unaligned_be16() to access TCP MSS in nfnetlink_osf,
   from Fernando Fernandez Mancera.

3) Use {READ,WRITE}_ONCE to access helper flags from nfnetlink_helper.

Several patches for the synproxy infrastructure, from Fernando
Fernandez Mancera:

4) Drop packet if TCP timestamp adjustment fails.

5) Continue parsing of TCP timestamp to deal with possible duplicates.

6) Use {get,put}_unaligned_be32() to acess the TCP timestamp.

7) Hold ct->lock to initialize nf_ct_seqadj_init().

Updates for the ct timeout infrastructure, to deal with a corner case
for unconfirmed conntracks flying to nfqueue:

8) Add a refcount to track ct timeout policy use by ct extension,
   release the timeout until the last ct extension drops the refcnt
   on it.

Similar update for the ct helper infrastructure:

9) Dynamic allocation of ct helpers, as a preparation for adding
   refcount to track ct extension use.

10) Move destroy_sibling_or_exp() to nf_conntrack_proto_gre, so
    pptp conntrack helper module removal does not make this code
    unreachable via the helper->destroy callback. This is another
    dependency for the new refcount coming in this series.

11) Add a refcount to track use of it from the ct extension, then
    ct helper and timeout is reachable to the connection until
    it goes away.

12) Remove the genid infrastructure in ct extensions. The primary
    goal was to detect that a ct extension such as ct timeout and
    ct helper went stale for unconfirmed conntrack, either because
    object or module was removed. This deactivates all ct extensions
    though for this unconfirmed conntrack.

13) Call nf_ct_gre_keymap_destroy() if this is a master conntrack
    with a pptp helper only.

sashiko.dev reports one more relevant issue when unsetting the helper
via ctnetlink that I will address in a follow up patch.

Then, two more assorted updates:

14) Avoid a unlikely underflow in bridge VLAN untag, only possible
    if buggy bridge VLAN filtering is buggy, remove WARN_ON_ONCE
    while at it. From David Carlier.

15) Use get_unaligned_be32() in nf_conntrack_tcp to access sack
    extension, from Rosen Penev.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-06-07

Thanks.

----------------------------------------------------------------

The following changes since commit bfa3d89cc15c09f7d1581c834a5ed725189ec19f:

  Merge tag 'batadv-next-pullrequest-20260603' of https://git.open-mesh.org/batadv (2026-06-04 19:14:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-06-07

for you to fetch changes up to d3bf9eae486490832bd08fd62ab0ac601f346bd4:

  netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack() (2026-06-07 11:13:47 +0200)

----------------------------------------------------------------
netfilter pull request 26-06-07

----------------------------------------------------------------
David Carlier (1):
      netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

Fernando Fernandez Mancera (5):
      netfilter: nfnetlink_osf: fix mss parsing on big-endian architectures
      netfilter: synproxy: drop packets if timestamp adjustment fails
      netfilter: synproxy: adjust duplicate timestamp options
      netfilter: synproxy: fix unaligned memory access in timestamp adjustment
      netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock

Julian Anastasov (1):
      ipvs: add conn_max sysctl to limit connections

Pablo Neira Ayuso (7):
      netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
      netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount
      netfilter: nf_conntrack_helper: dynamically allocate struct nf_conntrack_helper
      netfilter: nf_conntrack_pptp: move GRE specific cleanup to GRE tracker
      netfilter: nf_conntrack_helper: add refcounting from datapath
      netfilter: conntrack: revert ct extension genid infrastructure
      netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp

Rosen Penev (1):
      netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()

 Documentation/networking/ipvs-sysctl.rst       |  35 +++++++
 include/net/ip_vs.h                            |  22 +++++
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   4 +
 include/net/netfilter/nf_conntrack_extend.h    |  12 ---
 include/net/netfilter/nf_conntrack_helper.h    |  42 ++++++---
 include/net/netfilter/nf_conntrack_timeout.h   |  27 +++++-
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c    |  27 +++---
 net/netfilter/ipvs/ip_vs_conn.c                |  10 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |  53 +++++++++++
 net/netfilter/nf_conntrack_amanda.c            |  39 +++-----
 net/netfilter/nf_conntrack_core.c              |  92 +++++-------------
 net/netfilter/nf_conntrack_extend.c            |  32 +------
 net/netfilter/nf_conntrack_ftp.c               |   5 +-
 net/netfilter/nf_conntrack_h323_main.c         | 107 +++++++++------------
 net/netfilter/nf_conntrack_helper.c            | 125 +++++++++++++++++--------
 net/netfilter/nf_conntrack_irc.c               |   5 +-
 net/netfilter/nf_conntrack_netbios_ns.c        |  20 ++--
 net/netfilter/nf_conntrack_netlink.c           |  28 ++++--
 net/netfilter/nf_conntrack_ovs.c               |   9 +-
 net/netfilter/nf_conntrack_pptp.c              |  83 +++-------------
 net/netfilter/nf_conntrack_proto.c             |  15 ++-
 net/netfilter/nf_conntrack_proto_gre.c         |  61 ++++++++++++
 net/netfilter/nf_conntrack_proto_tcp.c         |  10 +-
 net/netfilter/nf_conntrack_sane.c              |   5 +-
 net/netfilter/nf_conntrack_seqadj.c            |   2 +
 net/netfilter/nf_conntrack_sip.c               |   5 +-
 net/netfilter/nf_conntrack_snmp.c              |  21 ++---
 net/netfilter/nf_conntrack_tftp.c              |   5 +-
 net/netfilter/nf_conntrack_timeout.c           |  27 +++++-
 net/netfilter/nf_flow_table_path.c             |   3 +-
 net/netfilter/nf_synproxy_core.c               |  40 ++++----
 net/netfilter/nfnetlink_cthelper.c             |  79 ++++++++--------
 net/netfilter/nfnetlink_cttimeout.c            | 112 ++++++++++------------
 net/netfilter/nfnetlink_osf.c                  |   6 +-
 net/netfilter/nft_ct.c                         |  10 +-
 net/netfilter/xt_CT.c                          |   3 -
 36 files changed, 653 insertions(+), 528 deletions(-)
