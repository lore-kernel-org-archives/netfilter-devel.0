From: pablo@netfilter.org
Subject: [PATCH] netfilter: netfilter fixes for 2.6.39-rc7 (2nd round)
Date: Sun, 15 May 2011 17:57:56 +0200
Message-ID: <1305475077-3283-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760075Ab1EOP6N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 May 2011 11:58:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

following are one late fix for 2.6.39-rc7 from the IPVS guys.

Please pull from:

git://1984.lsi.us.es/net-2.6 pablo/nf-2.6-updates

Thanks!

Hans Schillstrom (1):
  IPVS: fix netns if reading ip_vs_* procfs entries

 net/netfilter/ipvs/ip_vs_app.c  |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c |    4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

-- 
1.7.2.5

