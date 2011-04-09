From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] netfilter: ipset: fixes
Date: Sat,  9 Apr 2011 22:02:59 +0200
Message-ID: <1302379382-32338-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37777 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab1DIUDF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:03:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This batch contains and important bugfix and two small patches for ipset. Please
apply them.

Best regards,
Jozsef

Jozsef Kadlecsik (3):
  netfilter: ipset: bitmap:ip,mac type requires "src" for MAC
  netfilter: ipset: Whitespace fixes: some space before tab slipped in.
  netfilter: ipset: set match and SET target fixes

 net/netfilter/ipset/ip_set_bitmap_ipmac.c |    4 ++++
 net/netfilter/ipset/ip_set_list_set.c     |    4 ++--
 net/netfilter/xt_set.c                    |   18 ++++++++++++++++--
 3 files changed, 22 insertions(+), 4 deletions(-)

