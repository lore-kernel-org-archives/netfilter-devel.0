From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4] conntrack event subsystem updates for 2.6.31
Date: Sat, 02 May 2009 16:18:37 +0200
Message-ID: <20090502141522.8067.436.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50033 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZEBOSp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2009 10:18:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This is the first bunch of patches oriented to the event caching
system, I still have a couple more here but I'm still getting them
into shape.

These patches simplify the event caching system by removing a couple
of event which has no clients and they remove the use of the notifier
call chain by a simple indirection which is protected using RCU.

Please, apply!

---

Pablo Neira Ayuso (4):
      netfilter: conntrack: replace notify chain by function pointer
      netfilter: conntrack: simplify event caching system
      netfilter: conntrack: remove events flags from userspace exposed file
      netfilter: conntrack: don't report events on module removal


 include/linux/netfilter/nf_conntrack_common.h  |   69 ---------------
 include/net/netfilter/nf_conntrack.h           |    2 
 include/net/netfilter/nf_conntrack_ecache.h    |  113 ++++++++++++++++++++----
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    1 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 
 net/netfilter/nf_conntrack_core.c              |   29 ++----
 net/netfilter/nf_conntrack_ecache.c            |  101 ++++++++++++++++++---
 net/netfilter/nf_conntrack_ftp.c               |    2 
 net/netfilter/nf_conntrack_netlink.c           |   44 ++++-----
 net/netfilter/nf_conntrack_proto_tcp.c         |    1 
 10 files changed, 210 insertions(+), 153 deletions(-)

