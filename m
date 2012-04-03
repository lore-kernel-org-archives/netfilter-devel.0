From: pablo@netfilter.org
Subject: [PATCH 0/3] netfilter fixes for 3.4-rc1
Date: Tue,  3 Apr 2012 11:50:55 +0200
Message-ID: <1333446658-2335-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55607 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2DCJve (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:51:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

The following patches contain a couple of small fixes for Netfilter:

* One compilation warning fix for xt_LOG from Jan Beulich.

* Fix compilation issues of user-land ipset with kernel header file
  from Jan Engelhardt via Jozsef Kadlecsik.

* Fix one compilation warning in the recent changes done in xt_CT to
  support the extended cttimeout infrastracture, spotted by Eric
  Dumazet.

You can pull them from:

git://1984.lsi.us.es/net master

Thanks!

Jan Beulich (1):
  netfilter: xt_LOG: don't use xchg() for simple assignment

Jan Engelhardt (1):
  netfilter: ipset: avoid use of kernel-only types

Pablo Neira Ayuso (1):
  netfilter: xt_CT: remove a compile warning

 include/linux/netfilter/xt_set.h |    4 ++--
 include/net/netfilter/xt_log.h   |    2 +-
 net/netfilter/xt_CT.c            |    2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

-- 
1.7.2.5

