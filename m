From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4] We all need more expectations
Date: Tue, 21 Sep 2010 11:34:03 +0200
Message-ID: <20100921092843.3279.6914.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0IUJeK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:34:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patches are focuses on conntrack expectations. The first
one is an improvement for the situation in which the expectation table
is full for conntrack NAT helpers. Then, another quite simple to include
a missing attribute validation. To conclude, a couple of patches oriented
to support user-space conntrack helpers.

Hope that you like them.

---

Pablo Neira Ayuso (4):
      netfilter: nf_nat: better error handling of nf_ct_expect_related() in helpers
      netfilter: ctnetlink: missing validation of CTA_EXPECT_ZONE attribute
      netfilter: ctnetlink: allow to specify the expectation flags
      netfilter: ctnetlink: add support for user-space expectation helpers


 include/linux/netfilter/nf_conntrack_common.h |    5 ++
 include/linux/netfilter/nfnetlink_conntrack.h |    1 
 include/net/netfilter/nf_conntrack_expect.h   |    3 -
 net/ipv4/netfilter/nf_nat_amanda.c            |    9 ++++
 net/ipv4/netfilter/nf_nat_ftp.c               |    9 ++++
 net/ipv4/netfilter/nf_nat_h323.c              |   53 ++++++++++++++++++++++---
 net/ipv4/netfilter/nf_nat_irc.c               |    9 ++++
 net/ipv4/netfilter/nf_nat_sip.c               |   27 +++++++++++--
 net/netfilter/nf_conntrack_expect.c           |   40 ++++++++++++-------
 net/netfilter/nf_conntrack_netlink.c          |   38 ++++++++++++------
 10 files changed, 149 insertions(+), 45 deletions(-)
