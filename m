Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433C946B83;
	Thu, 11 Apr 2024 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878952; cv=none; b=kQfKO95+XoQ268P2y0Pt/oG/S8oTdpNBDUaWiFixyCuw+zujB2+UM921z4KnMePk2dBgB0OdVgKXzX670mDLF+kNkfjL/SSOoZ5+p2MoZ1EhPVPTPWgLt0CHXGJcZqGOc+spFwp9zj38OrmhODiOwmzHGINKIV+N2fsX+n0h44M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878952; c=relaxed/simple;
	bh=AbJWDUPe32ZT+YJq80rf/hwNLhNNOxKQCfrR0vMxsvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IS1MiqCMWlv/j2/ktwnv9z0Pk6cmASabjT2hb2cHe3WcaUGVGiLTNyJ0kDqthJaRBczSb56Zon6NxGejyPq+Aiw7T0x1XeVJEKHjjVY/T7iArymHLIY2HQEntJJPYEyoxxQ2Fl9vFgL8wWBmDuI8fg9uSfo/iVnu2Po7fi9YTZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv43f-0000t2-GX; Fri, 12 Apr 2024 01:42:19 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 00/15] selftests: move netfilter tests to net
Date: Fri, 12 Apr 2024 01:36:05 +0200
Message-ID: <20240411233624.8129-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First patch in this series moves selftests/netfilter/
to selftests/net/netfilter/.

Passing this via net-next rather than nf-next for this reason.

Main motivation is that a lot of these scripts only work on my old
development VM, I hope that placing this in net/ will get these
tests to get run in more regular intervals (and tests get more robust).

Changes are:

- make use of existing 'setup_ns' and 'busywait' helpers
- fix shellcheck warnings
- add more SKIP checks to avoid failures
- get rid of netcat in favor of socat, too many test
  failures due to 'wrong' netcat flavor
- do not assume rp_filter sysctl is off

I have more patches that fix up the remaining test scripts,
but the series was too large to send them at once (34 patches).

After all scripts are fixed up, tests pass on both my Debian
and Fedora test machines.

If you want me to route this via a different tree, e.g. nf-next,
please let me know.

MAINTAINERS is updated to reflect that future updates should be handled
via netfilter-devel@.

Florian Westphal (15):
  selftests: netfilter: move to net subdir
  selftests: netfilter: bridge_brouter.sh: move to lib.sh infra
  selftests: netfilter: br_netfilter.sh: move to lib.sh infra
  selftests: netfilter: conntrack_icmp_related.sh: move to lib.sh infra
  selftests: netfilter: conntrack_tcp_unreplied.sh: move to lib.sh infra
  selftests: netfilter: conntrack_sctp_collision.sh: move to lib.sh infra
  selftests: netfilter: conntrack_vrf.sh: move to lib.sh infra
  selftests: netfilter: conntrack_ipip_mtu.sh" move to lib.sh infra
  selftests: netfilter: place checktool helper in lib.sh
  selftests: netfilter: ipvs.sh: move to lib.sh infra
  selftests: netfilter: nf_nat_edemux.sh: move to lib.sh infra
  selftests: netfilter: nft_conntrack_helper.sh: test to lib.sh infra
  selftests: netfilter: nft_fib.sh: move to lib.sh infra
  selftests: netfilter: nft_flowtable.sh: move test to lib.sh infra
  selftests: netfilter: nft_nat.sh: move to lib.sh infra

 MAINTAINERS                                   |   1 +
 .../selftests/{ => net}/netfilter/.gitignore  |   4 +-
 .../testing/selftests/net/netfilter/Makefile  |  44 ++
 .../{ => net}/netfilter/audit_logread.c       |   0
 .../selftests/net/netfilter/br_netfilter.sh   | 163 ++++++
 .../selftests/net/netfilter/bridge_brouter.sh | 122 +++++
 tools/testing/selftests/net/netfilter/config  |  37 ++
 .../{ => net}/netfilter/connect_close.c       |   0
 .../netfilter/conntrack_dump_flush.c          |   2 +-
 .../netfilter/conntrack_icmp_related.sh       | 179 +++----
 .../netfilter/conntrack_ipip_mtu.sh}          |  44 +-
 .../net/netfilter/conntrack_sctp_collision.sh |  87 ++++
 .../net/netfilter/conntrack_tcp_unreplied.sh  | 153 ++++++
 .../{ => net}/netfilter/conntrack_vrf.sh      | 101 ++--
 tools/testing/selftests/net/netfilter/ipvs.sh | 211 ++++++++
 tools/testing/selftests/net/netfilter/lib.sh  |  10 +
 .../selftests/net/netfilter/nf_nat_edemux.sh  |  97 ++++
 .../nf-queue.c => net/netfilter/nf_queue.c}   |   0
 .../{ => net}/netfilter/nft_audit.sh          |   0
 .../{ => net}/netfilter/nft_concat_range.sh   |   0
 .../net/netfilter/nft_conntrack_helper.sh     | 171 +++++++
 .../selftests/{ => net}/netfilter/nft_fib.sh  |  71 +--
 .../{ => net}/netfilter/nft_flowtable.sh      | 108 ++--
 .../selftests/{ => net}/netfilter/nft_meta.sh |   0
 .../selftests/{ => net}/netfilter/nft_nat.sh  | 480 ++++++++----------
 .../{ => net}/netfilter/nft_nat_zones.sh      |   0
 .../{ => net}/netfilter/nft_queue.sh          |  18 +-
 .../{ => net}/netfilter/nft_synproxy.sh       |   0
 .../{ => net}/netfilter/nft_zones_many.sh     |   0
 .../selftests/{ => net}/netfilter/rpath.sh    |   0
 .../{ => net}/netfilter/sctp_collision.c      |   0
 .../{ => net}/netfilter/xt_string.sh          |   0
 tools/testing/selftests/netfilter/Makefile    |  21 -
 .../selftests/netfilter/bridge_brouter.sh     | 146 ------
 .../selftests/netfilter/bridge_netfilter.sh   | 188 -------
 tools/testing/selftests/netfilter/config      |   9 -
 .../netfilter/conntrack_sctp_collision.sh     |  89 ----
 .../netfilter/conntrack_tcp_unreplied.sh      | 167 ------
 tools/testing/selftests/netfilter/ipvs.sh     | 228 ---------
 .../selftests/netfilter/nf_nat_edemux.sh      | 127 -----
 .../netfilter/nft_conntrack_helper.sh         | 197 -------
 .../selftests/netfilter/nft_trans_stress.sh   | 151 ------
 tools/testing/selftests/netfilter/settings    |   1 -
 43 files changed, 1493 insertions(+), 1934 deletions(-)
 rename tools/testing/selftests/{ => net}/netfilter/.gitignore (92%)
 create mode 100644 tools/testing/selftests/net/netfilter/Makefile
 rename tools/testing/selftests/{ => net}/netfilter/audit_logread.c (100%)
 create mode 100755 tools/testing/selftests/net/netfilter/br_netfilter.sh
 create mode 100755 tools/testing/selftests/net/netfilter/bridge_brouter.sh
 create mode 100644 tools/testing/selftests/net/netfilter/config
 rename tools/testing/selftests/{ => net}/netfilter/connect_close.c (100%)
 rename tools/testing/selftests/{ => net}/netfilter/conntrack_dump_flush.c (99%)
 rename tools/testing/selftests/{ => net}/netfilter/conntrack_icmp_related.sh (52%)
 rename tools/testing/selftests/{netfilter/ipip-conntrack-mtu.sh => net/netfilter/conntrack_ipip_mtu.sh} (89%)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_sctp_collision.sh
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_tcp_unreplied.sh
 rename tools/testing/selftests/{ => net}/netfilter/conntrack_vrf.sh (66%)
 create mode 100755 tools/testing/selftests/net/netfilter/ipvs.sh
 create mode 100644 tools/testing/selftests/net/netfilter/lib.sh
 create mode 100755 tools/testing/selftests/net/netfilter/nf_nat_edemux.sh
 rename tools/testing/selftests/{netfilter/nf-queue.c => net/netfilter/nf_queue.c} (100%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_audit.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_concat_range.sh (100%)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_conntrack_helper.sh
 rename tools/testing/selftests/{ => net}/netfilter/nft_fib.sh (78%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_flowtable.sh (88%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_meta.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_nat.sh (62%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_nat_zones.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_queue.sh (95%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_synproxy.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/nft_zones_many.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/rpath.sh (100%)
 rename tools/testing/selftests/{ => net}/netfilter/sctp_collision.c (100%)
 rename tools/testing/selftests/{ => net}/netfilter/xt_string.sh (100%)
 delete mode 100644 tools/testing/selftests/netfilter/Makefile
 delete mode 100755 tools/testing/selftests/netfilter/bridge_brouter.sh
 delete mode 100644 tools/testing/selftests/netfilter/bridge_netfilter.sh
 delete mode 100644 tools/testing/selftests/netfilter/config
 delete mode 100755 tools/testing/selftests/netfilter/conntrack_sctp_collision.sh
 delete mode 100755 tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh
 delete mode 100755 tools/testing/selftests/netfilter/ipvs.sh
 delete mode 100755 tools/testing/selftests/netfilter/nf_nat_edemux.sh
 delete mode 100755 tools/testing/selftests/netfilter/nft_conntrack_helper.sh
 delete mode 100755 tools/testing/selftests/netfilter/nft_trans_stress.sh
 delete mode 100644 tools/testing/selftests/netfilter/settings

-- 
2.43.2
