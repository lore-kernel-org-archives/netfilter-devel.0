Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115134B192;
	Fri, 10 Apr 2026 11:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820239; cv=none; b=EAP1pz5NBsatzHP3vETMgndJbC4sAsUCmOAqeQIPeDqttV2ov89oITKAj03zzTPz9xA0UhqtTz7duoN6S8+Qrh43+CTH8FAnSVCvlYTM3L3npydW+JjfL28jdEyJDdvsfiOGazMrlv2pawsDsPooLharfumnIh007wH6/Jxucl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820239; c=relaxed/simple;
	bh=vtIR3FIYzpiDeiCkHJL8ZnOcVyGXuOxYTDfFbWfMPAY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qx64VYf02YVQwgha/TEkNAjzPlrI95gomOyt5xhzD9qUGKHCkO5V/j0WmxYbyB5ldN1XPG7H7ybrZubYDf2YCC41unR0k0ZYfOflVNXElJqGzbEA1lfPSbB6tCOfwoquF1Es+nfGk6rIeOYOLdvrr/HDqdcA0CV6iire9bq4OyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 443B26065F; Fri, 10 Apr 2026 13:23:56 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/11] netfilter: updates for net-next
Date: Fri, 10 Apr 2026 13:23:41 +0200
Message-ID: <20260410112352.23599-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for *net-next*:

1-3) IPVS updates from Julian Anastasov to enhance visibility into
     IPVS internal state by exposing hash size, load factor etc and
     allows userspace to tune the load factor used for resizing hash
     tables.

4) reject empty/not nul terminated device names from xt_physdev.
   This isn't a bug fix; existing code doesn't require a c-string.
   But clean this up anyway because conceptually the interface name
   definitely should be a c-string.

5) Switch nfnetlink to skb_mac_header helpers that didn't exist back
   when this code was written.  This gives us additional debug checks
   but is not intended to change functionality.

6) Let the xt ttl/hoplimit match reject unknown operator modes.
   This is a cleanup, the evaluation function simply returns false when
   the mode is out of range.  From Marino Dzalto.

7) xt_socket match should enable defrag after all other checks. This
   bug is harmless, historically defrag could not be disabled either
   except by rmmod.

8) remove UDP-Lite conntrack support, from Fernando Fernandez Mancera.

9) Avoid a couple -Wflex-array-member-not-at-end warnings in the old
   xtables 32bit compat code, from Gustavo A. R. Silva.

10) nftables fwd expression should drop packets when their ttl/hl has
    expired.  This is a bug fix deferred, its not deemed important
    enough for -rc8.
11) Add additional checks before assuming the mac header is an ethernet
    header, from Zhengchuan Liang.


Please, pull these changes from:
The following changes since commit 42f9b4c6ef19e71d2c7d9bfd3c5037d4fe434ad7:

  tools: ynl: tests: fix leading space on Makefile target (2026-04-09 20:41:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-04-10

for you to fetch changes up to 62443dc21114c0bbc476fa62973db89743f2f137:

  netfilter: require Ethernet MAC header before using eth_hdr() (2026-04-10 12:16:27 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-26-04-10

----------------------------------------------------------------

Fernando Fernandez Mancera (1):
  netfilter: conntrack: remove UDP-Lite conntrack support

Florian Westphal (4):
  netfilter: x_physdev: reject empty or not-nul terminated device names
  netfilter: nfnetlink: prefer skb_mac_header helpers
  netfilter: xt_socket: enable defrag after all other checks
  netfilter: nft_fwd_netdev: check ttl/hl before forwarding

Gustavo A. R. Silva (1):
  netfilter: x_tables: Avoid a couple -Wflex-array-member-not-at-end warnings

Julian Anastasov (3):
  ipvs: show the current conn_tab size to users
  ipvs: add ip_vs_status info
  ipvs: add conn_lfactor and svc_lfactor sysctl vars

Marino Dzalto (1):
  netfilter: xt_HL: add pr_fmt and checkentry validation

Zhengchuan Liang (1):
  netfilter: require Ethernet MAC header before using eth_hdr()

 Documentation/networking/ipvs-sysctl.rst      |  37 +++
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |   3 -
 include/net/netfilter/nf_conntrack_l4proto.h  |   7 -
 net/ipv6/netfilter/ip6t_eui64.c               |   7 +-
 net/netfilter/Kconfig                         |  11 -
 net/netfilter/ipset/ip_set_bitmap_ipmac.c     |   5 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c       |   9 +-
 net/netfilter/ipset/ip_set_hash_mac.c         |   5 +-
 net/netfilter/ipvs/ip_vs_ctl.c                | 247 +++++++++++++++++-
 net/netfilter/nf_conntrack_core.c             |   8 -
 net/netfilter/nf_conntrack_proto.c            |   3 -
 net/netfilter/nf_conntrack_proto_udp.c        | 108 --------
 net/netfilter/nf_conntrack_standalone.c       |   2 -
 net/netfilter/nf_log_syslog.c                 |   8 +-
 net/netfilter/nf_nat_core.c                   |   6 -
 net/netfilter/nf_nat_proto.c                  |  20 --
 net/netfilter/nfnetlink_cttimeout.c           |   1 -
 net/netfilter/nfnetlink_log.c                 |  19 +-
 net/netfilter/nfnetlink_queue.c               |  25 +-
 net/netfilter/nft_ct.c                        |   1 -
 net/netfilter/nft_fwd_netdev.c                |  10 +
 net/netfilter/x_tables.c                      |  12 +-
 net/netfilter/xt_hl.c                         |  27 ++
 net/netfilter/xt_mac.c                        |   4 +-
 net/netfilter/xt_physdev.c                    |  22 ++
 net/netfilter/xt_socket.c                     |  23 +-
 26 files changed, 399 insertions(+), 231 deletions(-)

-- 
2.52.0

