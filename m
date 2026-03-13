Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D333A6B95;
	Fri, 13 Mar 2026 15:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773414387; cv=none; b=Wn6/MHgB2Ie+2j5S72pXLuc0osMYzVl9GpiVxNwOXwJqEWg5Gw7sQL73DCjBK+6jmiVWRrxYIC5pOJ9G8eM5uRZ1Fw4U2ITcX/8SaAFL/5h65egjFZgt/sMlaC7Y9Y0sVEBW2THXV9r8mCY2ffWJSPoYssW9JkGlmx9QA3zF48M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773414387; c=relaxed/simple;
	bh=mxE/FP0WPQNqDu2SQfhVYa4SidG+iYAPdbY+issJl3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Tbut7eDN7FlCSEMuyWHk//nsmS8z3aHvs8Qnsez0SY9GYYAQh/TZoTleX2Rc+9nLVBYav6cvopvb6kmHkqoiDG+Rx4rtPU0zdbJVxhl2HUxOoJu3MmMWKQHQhiu5iNxqi10En33VKFBii7Xmnod0tT3gI0UMibCGPuR4skQguxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8F8216047A; Fri, 13 Mar 2026 16:06:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 00/11] netfilter: updates for net
Date: Fri, 13 Mar 2026 16:06:03 +0100
Message-ID: <20260313150614.21177-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is a much earlier pull request than usual, due to the large
backlog.  We are aware of several unfixed issues, in particular in
ctnetlink, patches are being worked on.

The following patchset contains Netfilter fixes for *net*:

1) fix a use-after-free in ctnetlink, from Hyunwoo Kim, broken
   since v3.10.
2) add missing netlink range checks in ctnetlink, broken since v2.6
   days.
3) fix content length truncation in sip conntrack helper,
   from Lukas Johannes Möller.  Broken since 2.6.34.
4) Revert a recent patch to add stronger checks for overlapping ranges
   in nf_tables rbtree set type.
   Patch is correct, but several nftables version have a bug (now fixed)
   that trigger the checks incorrectly.
5) Reset mac header before the vlan push to avoid warning splat (and
   make things functional). From Eric Woudstra.
6) Add missing bounds check in H323 conntrack helper, broken since this
   helper was added 20 years ago, from Jenny Guanni Qu.
7) Fix a memory leak in the dynamic set infrastructure, from Pablo Neira
   Ayuso.  Broken since v5.11.
8+9) a few spots failed to purge skbs queued to userspace via nfqueue,
   this causes RCU escape / use-after-free. Also from Pablo. broken
   since v3.4 added the CT target to xtables.
10) Fix undefined behaviour in xt_time, use u32 for a shift-by-31
    operation, not s32, from Jenny Guanni Qu.
11) H323 conntrack helper lacks a check for length variable becoming
    negative after decrement, causes major out-of-bounds read due to
    cast to unsigned size later, also from Jenny.
    Both issues exist since 2.6 days.

Please, pull these changes from:
The following changes since commit 99600f79b28c83c68bae199a3d8e95049a758308:

  mpls: add missing unregister_netdevice_notifier to mpls_init (2026-03-12 19:25:59 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-03-13

for you to fetch changes up to f173d0f4c0f689173f8cdac79991043a4a89bf66:

  netfilter: nf_conntrack_h323: check for zero length in DecodeQ931() (2026-03-13 15:31:15 +0100)

----------------------------------------------------------------
netfilter pull request nf-26-03-13

----------------------------------------------------------------
Eric Woudstra (1):
      netfilter: nf_flow_table_ip: reset mac header before vlan push

Florian Westphal (2):
      netfilter: conntrack: add missing netlink policy validations
      netfilter: revert nft_set_rbtree: validate open interval overlap

Hyunwoo Kim (1):
      netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()

Jenny Guanni Qu (3):
      netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
      netfilter: xt_time: use unsigned int for monthday bit shift
      netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()

Lukas Johannes Möller (1):
      netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()

Pablo Neira Ayuso (3):
      nf_tables: nft_dynset: fix possible stateful expression memleak in error path
      netfilter: nft_ct: drop pending enqueued packets on removal
      netfilter: xt_CT: drop pending enqueued packets on template removal

 include/net/netfilter/nf_tables.h       |  6 +--
 net/netfilter/nf_conntrack_h323_asn1.c  |  4 ++
 net/netfilter/nf_conntrack_netlink.c    | 28 +++++++++-
 net/netfilter/nf_conntrack_proto_sctp.c |  3 +-
 net/netfilter/nf_conntrack_sip.c        |  6 ++-
 net/netfilter/nf_flow_table_ip.c        |  1 +
 net/netfilter/nf_tables_api.c           | 25 +++------
 net/netfilter/nft_ct.c                  |  4 ++
 net/netfilter/nft_dynset.c              | 10 +++-
 net/netfilter/nft_set_rbtree.c          | 71 ++++---------------------
 net/netfilter/xt_CT.c                   |  4 ++
 net/netfilter/xt_time.c                 |  4 +-
 12 files changed, 75 insertions(+), 91 deletions(-)
-- 
2.52.0
