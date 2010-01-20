From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/07: SIP TCP & T.38 support
Date: Wed, 20 Jan 2010 20:18:26 +0100 (MET)
Message-ID: <20100120191824.25922.36663.sendpatchset@x2.localnet>
Cc: flo@degnet.de, Patrick McHardy <kaber@trash.net>,
	madduck@debian.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43276 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0ATTS3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:18:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The attached patches add TCP and T.38 FAX support to the SIP conntrack helper.

The patches are still work-in-progress, but they already work fine in all
my tests and I know some people have been waiting for these features, so
here's a snapshot of my current tree for anyone interested in testing.

They're based on the nf-next-2.6.git tree, but they also apply to the 2.6.32
release (might not compile though :).

Please report any test results.


 include/linux/netfilter/nf_conntrack_sip.h  |   19 ++-
 include/net/netfilter/nf_conntrack.h        |    2 +-
 include/net/netfilter/nf_conntrack_expect.h |    1 +
 include/net/netfilter/nf_nat_helper.h       |   32 ++-
 net/ipv4/netfilter/nf_nat_helper.c          |   39 ++--
 net/ipv4/netfilter/nf_nat_sip.c             |  158 ++++++++-----
 net/netfilter/nf_conntrack_expect.c         |    9 +
 net/netfilter/nf_conntrack_sip.c            |  333 +++++++++++++++++++++------
 8 files changed, 435 insertions(+), 158 deletions(-)

Patrick McHardy (7):
      netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
      netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
      netfilter: nf_conntrack_sip: pass data offset to NAT functions
      netfilter: nf_conntrack_sip: add TCP support
      netfilter: nf_nat: support mangling a single TCP packet multiple times
      netfilter: nf_nat_sip: add TCP support
      netfilter: nf_conntrack_sip: add T.38 FAX support
