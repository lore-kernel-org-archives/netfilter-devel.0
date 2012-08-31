From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] TCP conntrack patches
Date: Fri, 31 Aug 2012 21:55:52 +0200
Message-ID: <1346442954-29047-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Wrobel <wrr@mixedbit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:40188 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab2HaTz4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:55:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Jan Wrobel wrote a nice article on off-path TCP attacks (see
http://arxiv.org/abs/1201.2074). He discovered two weaknesses
in netfilter TCP conntrack, which make such attacks easier.
The next two patches fixes the issues.

Please review them and consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter: Mark SYN/ACK packets as invalid from original direction
  netfilter: Validate the sequence number of dataless ACK packets as
    well

 net/netfilter/nf_conntrack_proto_tcp.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)
