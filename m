From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset patches against net-2.6/nf-2.6, updated
Date: Tue, 24 May 2011 10:20:16 +0200
Message-ID: <1306225219-1498-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:59131 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab1EXIUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:20:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here follows three patches against net-2.6/nf-2.6, please apply them
(and discard the patches I sent on last Friday).

Best regards,
Jozsef

Jozsef Kadlecsik (3):
  netfilter: ipset: Use proper timeout value to jiffies conversion
  netfilter: ipset: remove unused variable from type_pf_tdel()
  netfilter: ipset: fix ip_set_flush return code

 include/linux/netfilter/ipset/ip_set_ahash.h   |    4 ++--
 include/linux/netfilter/ipset/ip_set_timeout.h |   18 ++++++++++--------
 net/netfilter/ipset/ip_set_core.c              |    2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

