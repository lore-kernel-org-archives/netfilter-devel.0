Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9854223DE5;
	Thu, 26 Mar 2026 12:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529522; cv=none; b=ephlQo688KYVii37jas1CtBrgNH3MVha4+XkDoWNxZUSt6wvDxGOzyrElZ25woDVKHqkT4L6by07LOzAVDD0WAiNXbIZW/obPaBV/xsMNPlha3Tbfml4UAwwMJwiGAMj6gHhiJHJY6pULWtd+ni7k6mzt6TedZ7kerPQ/fQFgfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529522; c=relaxed/simple;
	bh=dPC/hvLnNoNXoxkA4KSZj0+7YgMbqD3vYvvIHDhxhSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q0iBJJNEsTThma6F7DuBk5OYPMBM1haQJRPL3Gw3j05Qn99C1gfVtPnJKc+H0vFouf+O5cI3tNRBOuLp9V7k3gLgz5BTYkiqAm43MxyBIv2crtIihw0N5djFa/z13rjtdeHs8Hv8alWJEEb0mJtayIVGsO4K0F+bL16gNY/vI9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=olmGsxPi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="olmGsxPi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C496600B9;
	Thu, 26 Mar 2026 13:51:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529517;
	bh=E8eNA3bazW6Ue0u1coFCWFhTTGqfs8lOi/pQ1L9C+lM=;
	h=From:To:Cc:Subject:Date:From;
	b=olmGsxPisARA/x5wbR4h1G7cPUJIwXru0owU85+eP+dDHXQkpdW8KYPLTeSmyqyA7
	 Gkn59VkhKNUvXytqpu54UczlvJPRxYn5Dt8Nc5Ff7OmNvXzdiA4acgmW/wkyNG4ydJ
	 J+Wh+noHD9RhFIuDo2mOjQhBwfCp3SLKZsR0PUK14i4EdurgvO0Q9AbrUSAhJyUQll
	 scNT6wgU9bL1JlpOiIgC9MyYYuYPgd+mUDH/7HBZ2RvqigvaU2Uvs/2dnWOtZGohgU
	 /oafkkyNiMMbzl9v64/gZ40hkfUIFclu/cT7OOGT/8G6Weprrl0gHyMBVaz4vcFfh+
	 js+yJNlz6yJjg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v3 00/12] Netfilter for net
Date: Thu, 26 Mar 2026 13:51:41 +0100
Message-ID: <20260326125153.685915-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v3, I kept back an ipset fix and another to tigthen the xtables
interface to reject invalid combinations with the NFPROTO_ARP family.
They need a bit more discussion. I fixed the issues reported by AI on
patch 9 (add #ifdef to access ct zone, update nf_conntrack_broadcast
and patch 10 (use better Fixes: tag). Thanks!

-o-

Hi,

The following patchset contains Netfilter fixes for *net*.
 
Note that most bugs fixed here stem from 2.6 days, the large PR is not
due to an increase in regressions.
 
1) Fix incorrect reject of set updates with nf_tables pipapo set
   avx2 backend.  This comes with a regression test in patch 2.
   From Florian Westphal.
 
2) nfnetlink_log needs to zero padding to prevent infoleak to userspace,
   from Weiming Shi.
  
3) xtables ip6t_rt module never validated that addrnr length is within the
   allowed array boundary. Reject bogus values.  From Ren Wei.
 
4) Fix high memory usage in rbtree set backend that was unwanted side-effect
   of the recently added binary search blob. From Pablo Neira Ayuso.
 
5) Patches 5 to 10, also from Pablo, address long-standing RCU safety bugs
   in conntracks handling of expectations: We can never safely defer
   a conntrack extension area without holding a reference. Yet expectation
   handling does so in multiple places.  Fix this by avoiding the need to
   look into the master conntrack to begin with and by extending locked
   sections in a few places.

11) Fix use of uninitialized rtp_addr in the sip conntrack helper,
    also from Weiming Shi.
 
12) Add stricter netlink policy checks in ctnetlink, from David Carlier.
    This avoids undefined behaviour when userspace provides huge wscale
    value.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-03-26

Thanks.

----------------------------------------------------------------

The following changes since commit c4ea7d8907cf72b259bf70bd8c2e791e1c4ff70f:

  net: mana: fix use-after-free in add_adev() error path (2026-03-24 21:07:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-03-26

for you to fetch changes up to 8f15b5071b4548b0aafc03b366eb45c9c6566704:

  netfilter: ctnetlink: use netlink policy range checks (2026-03-26 13:28:17 +0100)

----------------------------------------------------------------
netfilter pull request 26-03-26

----------------------------------------------------------------
David Carlier (1):
      netfilter: ctnetlink: use netlink policy range checks

Florian Westphal (2):
      netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry
      selftests: netfilter: nft_concat_range.sh: add check for flush+reload bug

Pablo Neira Ayuso (6):
      netfilter: nft_set_rbtree: revisit array resize logic
      netfilter: nf_conntrack_expect: honor expectation helper field
      netfilter: nf_conntrack_expect: use expect->helper
      netfilter: ctnetlink: ensure safe access to master conntrack
      netfilter: nf_conntrack_expect: store netns and zone in expectation
      netfilter: nf_conntrack_expect: skip expectations in other netns via proc

Ren Wei (1):
      netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()

Weiming Shi (2):
      netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD
      netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

 include/net/netfilter/nf_conntrack_core.h          |  5 ++
 include/net/netfilter/nf_conntrack_expect.h        | 20 ++++-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 +
 net/ipv6/netfilter/ip6t_rt.c                       |  4 +
 net/netfilter/nf_conntrack_broadcast.c             |  8 +-
 net/netfilter/nf_conntrack_ecache.c                |  2 +
 net/netfilter/nf_conntrack_expect.c                | 39 +++++++--
 net/netfilter/nf_conntrack_h323_main.c             | 12 +--
 net/netfilter/nf_conntrack_helper.c                | 11 +--
 net/netfilter/nf_conntrack_netlink.c               | 75 ++++++++++--------
 net/netfilter/nf_conntrack_proto_tcp.c             | 10 +--
 net/netfilter/nf_conntrack_sip.c                   | 18 +++--
 net/netfilter/nfnetlink_log.c                      |  8 +-
 net/netfilter/nft_set_pipapo_avx2.c                | 20 ++---
 net/netfilter/nft_set_rbtree.c                     | 92 ++++++++++++++++++----
 .../selftests/net/netfilter/nft_concat_range.sh    | 70 +++++++++++++++-
 16 files changed, 296 insertions(+), 102 deletions(-)
