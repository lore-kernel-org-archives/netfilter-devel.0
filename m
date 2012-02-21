From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] netfilter: fix soft lockup when netlink adds new entries
Date: Tue, 21 Feb 2012 14:53:56 +0100
Message-ID: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Zambo Marcell <marcell.zambo@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59952 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab2BUNyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:54:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please review the next patch and push forward as a bugfix.

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  netfilter: fix soft lockup when netlink adds new entries

 net/netfilter/nf_conntrack_netlink.c |   43 ++++++++++++---------------------
 1 files changed, 16 insertions(+), 27 deletions(-)

