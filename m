From: pablo@netfilter.org
Subject: [PATCH 0/4] netfilter patches for nf-next-2.6
Date: Thu,  9 Jun 2011 20:40:58 +0200
Message-ID: <1307644862-3091-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab1FISlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:41:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Patrick,

These are the patches that I collected for nf-next-2.6.
Please, take recent Jozsef's patches directly from him.

Eric Dumazet (1):
  netfilter: nf_conntrack: remove one synchronize_net()

Jan Engelhardt (1):
  netfilter: nf_conntrack: provide config option to disable ancient
    procfs parts

Jesper Juhl (1):
  ipvs: Avoid undefined order of evaluation in assignments to struct
    nf_conn *

Kevin Cernekee (1):
  netfilter: nf_conntrack_sip: Handle Cisco 7941/7945 IP phones

 include/linux/netfilter/nf_conntrack_sip.h     |    3 ++
 net/ipv4/netfilter/Kconfig                     |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 -
 net/ipv4/netfilter/nf_nat_sip.c                |   26 +++++++++++++++++++++--
 net/netfilter/Kconfig                          |   10 +++++++++
 net/netfilter/ipvs/ip_vs_nfct.c                |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                |    8 +++---
 net/netfilter/nf_conntrack_expect.c            |   12 +++++-----
 net/netfilter/nf_conntrack_sip.c               |   17 +++++++++++++++
 net/netfilter/nf_conntrack_standalone.c        |    4 +-
 10 files changed, 67 insertions(+), 18 deletions(-)

-- 
1.7.2.5

