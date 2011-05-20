From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset patches against net-2.6/nf-2.6
Date: Fri, 20 May 2011 20:51:41 +0200
Message-ID: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:35950 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419Ab1ETSvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 14:51:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave and Patrick,

Here follows two patches against net-2.6/nf-2.6, please apply them.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter: ipset: Use proper timeout value to jiffies conversion
  netfilter: ipset: remove unused variable from type_pf_tdel()

 include/linux/netfilter/ipset/ip_set_ahash.h   |    4 ++--
 include/linux/netfilter/ipset/ip_set_timeout.h |   18 ++++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

