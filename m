From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset fix for nf/net
Date: Sat, 13 Apr 2013 14:51:13 +0200
Message-ID: <1365857474-4943-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Yoann JUET <yoann.juet@univ-nantes.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:36840 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3DMMvP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:51:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Since the last batch of ipset related patches there have been a bugreport
and the next patch fixes it. Please consider applying it.

Best regards,
Jozsef

The following changes since commit c2d421e171868586939c328dfb91bab840fe4c49:
  Florian Westphal (1):
        netfilter: nf_nat: fix race when unloading protocol modules

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

Jozsef Kadlecsik (1):
      netfilter: ipset: bitmap:ip,mac: fix listing with timeout

 net/netfilter/ipset/ip_set_bitmap_ipmac.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)
