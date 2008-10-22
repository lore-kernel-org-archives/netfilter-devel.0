From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/03: netfilter -stable fixes
Date: Wed, 22 Oct 2008 19:41:27 +0200 (MEST)
Message-ID: <20081022174126.21341.38231.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58280 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbYJVRl2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:41:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following three patches for -stable fix some netfilter issues:

- a regression in the iprange match, causing mismatches with inversion
- a memory leak in the SNMP NAT helper
- a lost #ifdef, allowing user-triggerable WARN_ONs with NETFILTER_DEBUG
  (and some minor runtime misbehaviour)

Please apply, thanks.


 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 ++
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 +
 net/netfilter/xt_iprange.c                     |    8 ++++----
 3 files changed, 7 insertions(+), 4 deletions(-)

Patrick McHardy (3):
      netfilter: xt_iprange: fix range inversion match
      netfilter: snmp nat leaks memory in case of failure
      netfilter: restore lost #ifdef guarding defrag exception
