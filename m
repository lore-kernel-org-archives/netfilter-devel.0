From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/08: SIP conntrack TCP/T.38 FAX support
Date: Thu, 11 Feb 2010 08:39:36 +0100 (MET)
Message-ID: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35438 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0BKHji (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:39:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following is the final version of my SIP conntrack TCP/T.38 FAX patches.

I've done some more testing and everything appears to work fine, so I'll
commit them to the nf-next tree sometime today. If anyone has comments
or wants to add a Tested-by: tag, please do so within the next hours.

The only change since the last posting is removal of some debugging code.


 include/linux/netfilter/nf_conntrack_sip.h  |   19 ++-
 include/net/netfilter/nf_conntrack.h        |    2 +-
 include/net/netfilter/nf_conntrack_expect.h |    1 +
 include/net/netfilter/nf_nat_helper.h       |   32 ++-
 net/ipv4/netfilter/nf_nat_helper.c          |   39 ++--
 net/ipv4/netfilter/nf_nat_sip.c             |  158 ++++++++-----
 net/netfilter/nf_conntrack_expect.c         |    9 +
 net/netfilter/nf_conntrack_netlink.c        |    4 +
 net/netfilter/nf_conntrack_sip.c            |  327 +++++++++++++++++++++------
 9 files changed, 433 insertions(+), 158 deletions(-)

Patrick McHardy (8):
      netfilter: ctnetlink: dump expectation helper name
      netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
      netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
      netfilter: nf_conntrack_sip: pass data offset to NAT functions
      netfilter: nf_conntrack_sip: add TCP support
      netfilter: nf_nat: support mangling a single TCP packet multiple times
      netfilter: nf_nat_sip: add TCP support
      netfilter: nf_conntrack_sip: add T.38 FAX support
