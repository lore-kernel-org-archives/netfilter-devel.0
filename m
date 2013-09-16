From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/4] ipset patches for nf
Date: Mon, 16 Sep 2013 20:47:55 +0200
Message-ID: <1379357279-13361-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:56912 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3IPSsA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:48:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Next follows the ipset related fixes for the nf tree. Please consider applying them.

Best regards,
Jozsef

The following changes since commit d830f0fa1dd7ca447c38aec82cd44230e0b7ca75:
  Phil Oester (1):
        netfilter: nf_nat_proto_icmpv6:: fix wrong comparison in icmpv6_manip_pkt

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

Jozsef Kadlecsik (3):
      netfilter: ipset: Skip really non-first fragments for IPv6 when getting port/protocol
      netfilter: ipset: Consistent userspace testing with nomatch flag
      netfilter: ipset: Validate the set family and not the set type family at swapping

Oliver Smith (1):
      netfilter: ipset: Fix serious failure in CIDR tracking

 include/linux/netfilter/ipset/ip_set.h      |    6 +++-
 net/netfilter/ipset/ip_set_core.c           |    5 +--
 net/netfilter/ipset/ip_set_getport.c        |    4 +-
 net/netfilter/ipset/ip_set_hash_gen.h       |   28 +++++++++++++++-----------
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    4 +-
 net/netfilter/ipset/ip_set_hash_net.c       |    4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c  |    4 +-
 net/netfilter/ipset/ip_set_hash_netport.c   |    4 +-
 8 files changed, 32 insertions(+), 27 deletions(-)
