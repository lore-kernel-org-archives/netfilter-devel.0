From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] TCP conntrack fixes in TCP option handling
Date: Tue, 30 Aug 2011 15:35:39 +0200
Message-ID: <1314711341-28392-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:60135 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab1H3Nfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:35:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Michael M. Builov reported several problems with the TCP option handling
code in the TCP connection tracking code. The next patches, based on his
suggestions, solve all the issues. Please apply them as bugfixes.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  Incorrect handling of invalid TCP option in TCP connection tracking
  Wrong multiplication of TCPOLEN_TSTAMP_ALIGNED in tcp_sack skips
    fastpath

 net/netfilter/nf_conntrack_proto_tcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

