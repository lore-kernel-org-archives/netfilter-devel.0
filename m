From: pablo@netfilter.org
Subject: [PATCH 0/2] netfilter updates for davem's net tree
Date: Wed, 12 Oct 2011 19:32:50 +0200
Message-ID: <1318440772-21058-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33742 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1JLRjp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:39:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

The following patches are two bugfixes for your net tree. One
regarding the conntrack event infrastructure with GRE traffic
and one fix to resolve one deadlock in the IPVS state
synchronization.

You can pull these changes from (my nf branch):

git://1984.lsi.us.es/net nf

Florian Westphal (1):
  netfilter: nf_conntrack: fix event flooding in GRE protocol tracker

Hans Schillstrom (1):
  ipvs: netns shutdown/startup dead-lock

 include/net/ip_vs.h                    |    1 +
 net/netfilter/ipvs/ip_vs_ctl.c         |  131 +++++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_sync.c        |    6 ++
 net/netfilter/nf_conntrack_proto_gre.c |    4 +-
 4 files changed, 89 insertions(+), 53 deletions(-)

-- 
1.7.2.5

