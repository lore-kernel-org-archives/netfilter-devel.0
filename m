From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/06: netfilter fixes
Date: Mon, 18 Aug 2008 18:51:48 +0200 (MEST)
Message-ID: <20080818165147.18978.92208.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59339 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYHRQvu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:51:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

the following patches for 2.6.27 contain fixes for some netfilter issue=
s:

- a fix for inverted destination address matching in the addrtype match

- a fix to make linux/netfilter.h directly includable in userspace by
  moving necessary includes outside of #ifdef __KERNEL__

- three ctnetlink fixes for sleep inside locked section and double
  helper assignment

- a change to use secure_ipv4_port_ephemeral() for NAT port randomizati=
on
  to avoid concerns about leaking prng state

Please apply, thanks.


 drivers/char/random.c                    |    1 +
 include/linux/netfilter.h                |    4 +-
 net/ipv4/netfilter/ipt_addrtype.c        |    2 +-
 net/ipv4/netfilter/nf_nat_proto_common.c |    8 +++++-
 net/netfilter/nf_conntrack_netlink.c     |   36 ++++++++++++++++------=
-------
 5 files changed, 30 insertions(+), 21 deletions(-)

Anders Grafstr=F6m (1):
      netfilter: ipt_addrtype: Fix matching of inverted destination add=
ress type

Matt Kraai (1):
      netfilter: Move linux/in.h and linux/in6.h inclusions outside of =
#ifdef __KERNEL__

Pablo Neira Ayuso (3):
      netfilter: ctnetlink: fix double helper assignation for NAT'ed co=
nntracks
      netfilter: ctnetlink: fix sleep in read-side lock section
      netfilter: ctnetlink: sleepable allocation with spin lock bh

Stephen Hemminger (1):
      nf_nat: use secure_ipv4_port_ephemeral() for NAT port randomizati=
on
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
