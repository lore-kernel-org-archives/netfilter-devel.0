Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BD1309DDF;
	Wed, 25 Mar 2026 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444302; cv=none; b=VHH6zPkj9HfMV6qQxr4rgrZwHSVAfO/AIt+VPtmKwK0Lcn4+R6s7F26zh4/gw743DpokKueFOHuSMpgM1OZE6zy7f+WNUuJr5QZhM/VKY07bKGtYsPCdj3ZP3oqUcLwgClIZVD6rKAV63LLQZW1Vq9EeBk2RjVyIo155revK16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444302; c=relaxed/simple;
	bh=3AmlJPot+VL+VEaLAr7y61rdZG26HyCu2M4NIujBSLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOdKAYRQOVF7L8hzXsjb1gtbJKnsJglVzcjCdy/z8eFuoJjL/P1++tKD7xgflhqhJBUT8q8ZWlyvXPjwSuw4B3PsGErRpaXLBqHSrg25MXgS5WAghQJffI9tLMR5JboaUZBa8yfU0zT5KiHXF5rGCaGRqZg78KDbr/tcRsFLfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 540316080C; Wed, 25 Mar 2026 14:11:33 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 00/14] netfilter: updates for net
Date: Wed, 25 Mar 2026 14:10:54 +0100
Message-ID: <20260325131108.23045-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net*.
Note that most bugs fixed here stem from 2.6 days, the large PR
is not due to an increase in regressions.

1) Fix incorrect reject of set updates with nf_tables pipapo set
   avx2 backend.  This comes with a regression test in patch 2.

3) Fix a syzkaller reported data race in ipset, from Jozsef Kadlecsik.

4) nfnetlink_log needs to zero padding to prevent infoleak to userspace,
   from Weiming Shi.

5) pay more attention to xtables hook masks + NFPROTO_UNSPEC.
   UNSPEC+hook_mask is only valid for ipv4, ipv6 and bridge families.
   This can cause a crash because arp family has different meaning for
   hook constants. We need to reject rule adds when we have a match that
   sets both a hook mask and proto_unspec, unless the requesting family
   is one of ip/ip6/bridge. Also from Weiming Shi.

6) xtables ip6t_rt module never validated that addrnr length is within the
   allowed array boundary. Reject bogus values.  From Ren Wei.

7) Fix high memory usage in rbtree set backend that was unwanted side-effect
   of the recently added binary search blob. From Pablo Neira Ayuso.

Patches 8 to 12, also from Pablo, address long-standing RCU safety bugs
in conntracks handling of expectations: We can never safely defer
a conntrack extension area without holding a reference. Yet expectation
handling does so in multiple places.  Fix this by avoiding the need to
look into the master conntrack to begin with and by extending locked
sections in a few places.

13) fix use of uninitialized rtp_addr in the sip conntrack helper,
    also from Weiming Shi.

14) Add stricter netlink policy checks in ctnetlink, from David Carlier.
    This avoids undefined behaviour when userspace provides huge wscale
    value.

Please, pull these changes from:
The following changes since commit c4ea7d8907cf72b259bf70bd8c2e791e1c4ff70f:

  net: mana: fix use-after-free in add_adev() error path (2026-03-24 21:07:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-03-25

for you to fetch changes up to 65182deffd243cb451c7e1f532e7de1ed59afbeb:

  netfilter: ctnetlink: use netlink policy range checks (2026-03-25 13:36:45 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-03-25

----------------------------------------------------------------
David Carlier (1):
  netfilter: ctnetlink: use netlink policy range checks

Florian Westphal (2):
  netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
  selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug

Jozsef Kadlecsik (1):
  netfilter: ipset: Fix data race between add and list header in all hash types

Pablo Neira Ayuso (6):
  netfilter: nft_set_rbtree: revisit array resize logic
  netfilter: nf_conntrack_expect: honor expectation helper field
  netfilter: nf_conntrack_expect: use expect->helper
  netfilter: ctnetlink: ensure safe access to master conntrack
  netfilter: nf_conntrack_expect: store netns and zone in expectation
  netfilter: nf_conntrack_expect: skip expectations in other netns via proc

Ren Wei (1):
  netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()

Weiming Shi (3):
  netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD
  netfilter: x_tables: reject unsupported families in xt_check_match/xt_check_target
  netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

 include/net/netfilter/nf_conntrack_core.h     |  5 +
 include/net/netfilter/nf_conntrack_expect.h   | 20 +++-
 .../linux/netfilter/nf_conntrack_common.h     |  4 +
 net/ipv6/netfilter/ip6t_rt.c                  |  4 +
 net/netfilter/ipset/ip_set_core.c             |  4 +-
 net/netfilter/nf_conntrack_broadcast.c        |  2 +-
 net/netfilter/nf_conntrack_ecache.c           |  2 +
 net/netfilter/nf_conntrack_expect.c           | 30 +++++-
 net/netfilter/nf_conntrack_h323_main.c        | 12 +--
 net/netfilter/nf_conntrack_helper.c           | 11 ++-
 net/netfilter/nf_conntrack_netlink.c          | 73 ++++++++-------
 net/netfilter/nf_conntrack_proto_tcp.c        | 10 +-
 net/netfilter/nf_conntrack_sip.c              | 18 ++--
 net/netfilter/nfnetlink_log.c                 |  8 +-
 net/netfilter/nft_set_pipapo_avx2.c           | 20 ++--
 net/netfilter/nft_set_rbtree.c                | 92 +++++++++++++++----
 net/netfilter/x_tables.c                      | 36 ++++++++
 net/netfilter/xt_devgroup.c                   |  5 +
 .../net/netfilter/nft_concat_range.sh         | 70 +++++++++++++-
 19 files changed, 323 insertions(+), 103 deletions(-)

-- 
2.52.0
