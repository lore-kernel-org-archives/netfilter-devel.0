From: pablo@netfilter.org
Subject: [PATCH] netfilter fixes for 2.6.37 (one leftover patch)
Date: Wed, 12 Jan 2011 20:36:37 +0100
Message-ID: <1294860998-15883-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53297 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1ALTgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:36:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

I found one leftover patch from November 22th that was applied
to Patrick's tree (nf-next-2.6) but it didn't ever take its way
to reach net-2.6.

Can you still pass it to Linus?

You can pull it from:

git://1984.lsi.us.es/net-2.6 master

KOVACS Krisztian (1):
  netfilter: fix compilation when conntrack is disabled but tproxy is
    enabled

 include/linux/skbuff.h                         |   15 +++++++++++++++
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   10 ----------
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |   10 ++++++++++
 net/core/skbuff.c                              |    2 ++
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    8 +++++++-
 5 files changed, 34 insertions(+), 11 deletions(-)

