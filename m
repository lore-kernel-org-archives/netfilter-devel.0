From: pablo@netfilter.org
Subject: Netfilter updates for 3.2-rc
Date: Fri, 23 Dec 2011 15:04:42 +0100
Message-ID: <1324649083-6548-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44746 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1LWOFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:05:05 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

Please, apply the following fix for the connbytes match from
Florian Westphal.

You can pull it from:

git://1984.lsi.us.es/net nf

Thanks!

P.S: Updates for net-next will come by this weekend.

Florian Westphal (1):
  netfilter: xt_connbytes: handle negation correctly

 net/netfilter/xt_connbytes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.2.5

