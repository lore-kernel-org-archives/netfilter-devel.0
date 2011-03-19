From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] netfilter:ipset fixes
Date: Sat, 19 Mar 2011 10:00:16 +0100
Message-ID: <1300525218-18471-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:50588 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab1CSJAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:00:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Please apply the next two patches for ipset:

- fix address ranges at hash:*port* types
- fix checking the type revision at create command

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter:ipset: fix address ranges at hash:*port* types
  netfilter:ipset: fix checking the type revision at create command

 include/linux/netfilter/ipset/ip_set_getport.h |   10 +++++++
 net/netfilter/ipset/ip_set_core.c              |   20 +++++++++++---
 net/netfilter/ipset/ip_set_hash_ipport.c       |   34 +++++++-----------------
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   34 +++++++-----------------
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   34 +++++++-----------------
 net/netfilter/ipset/ip_set_hash_netport.c      |   30 +++++---------------
 6 files changed, 64 insertions(+), 98 deletions(-)

