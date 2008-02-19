From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/07]: Netfilter fixes
Date: Tue, 19 Feb 2008 17:25:44 +0100 (MET)
Message-ID: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50460 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYBSQZq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following are a few netfilter fixes for 2.6.25, fixing a BUG() when
mangling non-linear skbs in {ip,ip6,nfnetlink}_queue, a compilation
error in busybox, IPv6 address range matching in xt_iprange, missing
unidef'ing of xt_policy.h. Additionally there is a patch to remove
an unnecessary member from the xt_hashlimit matchinfo, which we need
to do know before it hits a release.

Please apply, thanks.


 include/linux/netfilter.h              |    2 +-
 include/linux/netfilter/Kbuild         |    2 +-
 include/linux/netfilter/xt_hashlimit.h |    1 -
 net/bridge/netfilter/ebt_dnat.c        |    2 +-
 net/bridge/netfilter/ebt_redirect.c    |    2 +-
 net/bridge/netfilter/ebt_snat.c        |    2 +-
 net/ipv4/netfilter/arpt_mangle.c       |    2 +-
 net/ipv4/netfilter/ip_queue.c          |   12 +++++++-----
 net/ipv6/netfilter/ip6_queue.c         |   10 ++++++----
 net/netfilter/nfnetlink_queue.c        |   10 ++++++----
 net/netfilter/xt_hashlimit.c           |    3 ---
 net/netfilter/xt_iprange.c             |    2 +-
 net/netfilter/xt_u32.c                 |   11 +++++------
 13 files changed, 31 insertions(+), 30 deletions(-)

Jan Engelhardt (2):
      [NETFILTER]: xt_hashlimit: remove unneeded struct member
      [NETFILTER]: xt_iprange: fix subtraction-based comparison

Joonwoo Park (1):
      [NETFILTER]: Fix incorrect use of skb_make_writable

Patrick McHardy (2):
      [NETFILTER]: {ip,ip6,nfnetlink}_queue: fix SKB_LINEAR_ASSERT when mangling packet data
      [NETFILTER]: Use __u32 in struct nf_inet_addr

Pavel Emelyanov (1):
      [NETFILTER]: xt_u32: drop the actually unused variable from u32_match_it

Robert P. J. Day (1):
      [NETFILTER]: Make sure xt_policy.h is unifdef'ed.
