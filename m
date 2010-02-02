From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/02: netfilter fixes
Date: Tue,  2 Feb 2010 17:27:37 +0100 (MET)
Message-ID: <20100202162736.24867.67227.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33292 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0BBQ1i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:27:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following two patches fix two bugs in netfilter:

- an off-by-one in SIP conntrack short header parsing, causing mismatches
  with UAs not inserting a space after the colon

- a missing initialization in ctnetlink when dumping an expectation mask,
  causing an invalid layer 4 protocol number to be used

Please apply or pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git master

Thanks!


 net/netfilter/nf_conntrack_netlink.c |    3 ++-
 net/netfilter/nf_conntrack_sip.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Patrick McHardy (2):
      netfilter: nf_conntrack_sip: fix off-by-one in compact header parsing
      netfilter: ctnetlink: fix expectation mask dump
