From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] Handle invalid packets in conntrack consistently
Date: Fri,  6 Apr 2012 16:57:31 +0200
Message-ID: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52203 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab2DFO5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:57:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

As it was discussed, at the moment conntrack handles invalid packets
differently: IPv6 conntrack marks the packets as INVALID and lets
the user to drop them by an explicit rule, while IPv4 conntrack
simply drops such packets.

The next two patches bring conntrack in sync by changing IPv4 conntrack
behaviour to follow IPv6 conntrack. Invalid packet logging support is
also added.

The patches are follow-up of the second version of the patch I sent on
Tuesday, with the cover letter subject "Drop malformed IPv4 packets in
conntrack, 2nd try".

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  net: netfilter: prepare conntrack for consistent invalid packet
    handling
  net: netfilter: handle invalid packets consistently in conntrack

 include/net/netfilter/nf_conntrack.h           |    3 +-
 include/net/netfilter/nf_conntrack_l3proto.h   |    5 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   29 ++++++++++++++++-------
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   11 ++++++--
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    9 ++++---
 net/netfilter/nf_conntrack_l3proto_generic.c   |    3 +-
 net/netfilter/xt_connlimit.c                   |    2 +-
 9 files changed, 43 insertions(+), 23 deletions(-)

