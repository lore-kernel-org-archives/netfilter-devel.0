From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] Drop malformed IPv4 packets in conntrack, 2nd try
Date: Tue,  3 Apr 2012 22:02:00 +0200
Message-ID: <1333483321-16868-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34360 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab2DCUCE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:02:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patch as a bugfix for netfilter/conntrack.
Thanks to Eric for spotting a typo in the previous version.

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  netfilter: conntrack: drop malformed IPv4 packets

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

