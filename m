Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841FD271450;
	Tue, 17 Feb 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345973; cv=none; b=q22m1TWeDmABvBeHaMAZHwGFXf+bimuIct0QOHFvK3JR67YIWc746iU2MmmcH9oevhrUjRonCsvfkF/ycl676IOzUPYcN5Zh5HOsaqACrK/FqUKu4lLjM1sRO6eqhTX1wD+d1350pUIRKAKIr3HJ/AUHeIfXLC8CJ1xoOmJ+Kpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345973; c=relaxed/simple;
	bh=oTfWvgJSP+kRBXBVtFhEiDAaB1etC6iuyyxj7gdvcSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=po6xRZ93DJEOJC+wwbF+87cHu3j+Eswd67ZE7QtxSyGwdV3NJR9R+l/zcRXREM6ycVQ4FMwbhynSp8Gbbbgl1JLtrFCMGoauj72t6ooSYROv7lVEEE5AXaKsAGeUe4uLyD8aCnU/JuMOOff91IGbt5EECdb/GWHX9HuOVvpknPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 355F660683; Tue, 17 Feb 2026 17:32:43 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 00/10] netfilter: updates for net
Date: Tue, 17 Feb 2026 17:32:23 +0100
Message-ID: <20260217163233.31455-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*:

1) Add missing __rcu annotations to NAT helper hook pointers in Amanda, FTP,
   IRC, SNMP and TFTP helpers.  From Sun Jian.

2-4):
 - Add global spinlock to serialize nft_counter fetch+reset operations.
 - Use atomic64_xchg() for nft_quota reset instead of read+subtract pattern.
   Note AI review detects a race in this change but it isn't new. The
   'racing' bit only exists to prevent constant stream of 'quota expired'
   notifications.
 - Revert commit_mutex usage in nf_tables reset path, it caused
   circular lock dependency.  All from Brian Witte.

5) Fix uninitialized l3num value in nf_conntrack_h323 helper.

6) Fix musl libc compatibility in netfilter_bridge.h UAPI header. This
   change isn't nice (UAPI headers should not include libc headers), but
   as-is musl builds may fail due to redefinition of struct ethhdr.

7) Fix protocol checksum validation in IPVS for IPv6 with extension headers,
   from Julian Anastasov.

8) Fix device reference leak in IPVS when netdev goes down. Also from
   Julian.

9) Remove WARN_ON_ONCE when accessing forward path array, this can
   trigger with sufficiently long forward paths.  From Pablo Neira Ayuso.

10) Fix use-after-free in nf_tables_addchain() error path, from Inseo An.

Please, pull these changes from:
The following changes since commit 77c5e3fdd2793f478e6fdae55c9ea85b21d06f8f:

  Merge branch 'selftests-forwarding-fix-br_netfilter-related-test-failures' (2026-02-17 13:34:41 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-02-17

for you to fetch changes up to 71e99ee20fc3f662555118cf1159443250647533:

  netfilter: nf_tables: fix use-after-free in nf_tables_addchain() (2026-02-17 15:04:20 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-02-17

----------------------------------------------------------------
Brian Witte (3):
  netfilter: nft_counter: serialize reset with spinlock
  netfilter: nft_quota: use atomic64_xchg for reset
  netfilter: nf_tables: revert commit_mutex usage in reset path

Florian Westphal (1):
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value

Inseo An (1):
  netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Julian Anastasov (2):
  ipvs: skip ipv6 extension headers for csum checks
  ipvs: do not keep dest_dst if dev is going down

Pablo Neira Ayuso (1):
  net: remove WARN_ON_ONCE when accessing forward path array

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Sun Jian (1):
  netfilter: annotate NAT helper hook pointers with __rcu

 include/linux/netfilter/nf_conntrack_amanda.h |   2 +-
 include/linux/netfilter/nf_conntrack_ftp.h    |   2 +-
 include/linux/netfilter/nf_conntrack_irc.h    |   2 +-
 include/linux/netfilter/nf_conntrack_snmp.h   |   2 +-
 include/linux/netfilter/nf_conntrack_tftp.h   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 net/core/dev.c                                |   2 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c         |  18 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c          |  21 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c          |  20 +-
 net/netfilter/ipvs/ip_vs_xmit.c               |  46 +++-
 net/netfilter/nf_conntrack_amanda.c           |  14 +-
 net/netfilter/nf_conntrack_ftp.c              |  14 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_conntrack_irc.c              |  13 +-
 net/netfilter/nf_conntrack_snmp.c             |   8 +-
 net/netfilter/nf_conntrack_tftp.c             |   7 +-
 net/netfilter/nf_tables_api.c                 | 249 +++---------------
 net/netfilter/nft_counter.c                   |  20 +-
 net/netfilter/nft_quota.c                     |  13 +-
 20 files changed, 166 insertions(+), 303 deletions(-)

-- 
2.52.0
