From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 00/11] TProxy for IPv6
Date: Wed, 26 Aug 2009 16:03:28 +0200
Message-ID: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58543 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbZH2Pu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 2D5E211E156
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ Sorry if this reaches you twice, I sent to the wrong address the first time ]

I've just pushed a set of patches that implement TProxy for IPv6 to

http://git.balabit.hu/bazsi/tproxy-2.6.git

The patches are also posted in reply to this mail.

Although some work is still needed, basic testing shows that it works all
right.  

The accompanying iptables patches are available at

http://git.balabit.hu/bazsi/iptables-tproxy.git

There are some things left to do:

  * the recognition of related ICMPv6 packets missing (from xt_socket.c)

  * I should probably split xt_TPROXY/xt_socket to IPv4 and IPv6 modules, as
    right now those depend on both stacks at the same time.

I'm on a holiday right now, thus I might not respond to comments in a timely
manner, however I'm interested in any comments/feedback nevertheless.

Harry, I didn't remember that you actually wanted to work on TProxy for
IPv6, I just vaguely remembered that there was someone asking for IPv6
support, thus I implemented this without being in the know.  If you started
hacking, I hope that we didn't completely duplicate effort.  I'd appreciate
help in the missing bits and/or testing whichever fits you best.

Also, I have written a Python test script to test TProxy functionality
automatically both for IPv4 and IPv6, I can post that as well if anyone is
interested.


Balazs Scheidler (11):
  TProxy: kick out TIME_WAIT sockets in case a new connection comes in
    with the same tuple
  TProxy: add lookup type checks for UDP in nf_tproxy_get_sock_v4()
  TProxy: reuse a 32bit hole in struct ipv6_pinfo
  TProxy: split off ipv6 defragmentation to a separate module
  TProxy: added const specifiers to udp lookup functions
  TProxy: added udp6_lib_lookup function
  TProxy: implement IPv6 "local" routing type
  TProxy: allow non-local binds of IPv6 sockets if IP_TRANSPARENT is
    enabled
  TProxy: added IPv6 socket lookup function to nf_tproxy_core
  TProxy: added IPv6 support to the TPROXY target
  TProxy: added IPv6 support to the socket match

 include/linux/ipv6.h                           |    3 +-
 include/linux/netfilter/xt_TPROXY.h            |   15 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    6 +
 include/net/netfilter/nf_tproxy_core.h         |  192 +++++++++++++++++++-
 include/net/udp.h                              |    3 +
 net/ipv6/af_inet6.c                            |    2 +-
 net/ipv6/netfilter/Makefile                    |    5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   58 +------
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   12 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |  109 +++++++++++
 net/ipv6/route.c                               |    6 +-
 net/ipv6/udp.c                                 |   16 ++-
 net/netfilter/nf_tproxy_core.c                 |   35 ----
 net/netfilter/xt_TPROXY.c                      |  239 +++++++++++++++++++++---
 net/netfilter/xt_socket.c                      |  113 +++++++++++-
 15 files changed, 675 insertions(+), 139 deletions(-)
 create mode 100644 include/net/netfilter/ipv6/nf_defrag_ipv6.h
 create mode 100644 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c


