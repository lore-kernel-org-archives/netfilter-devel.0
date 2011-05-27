From: pablo@netfilter.org
Subject: [PATCH 0/5] Netfilter updates for net-2.6
Date: Fri, 27 May 2011 13:44:52 +0200
Message-ID: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57144 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab1E0LpP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 07:45:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

the following patches contain Netfilter updates for net-2.6.
The highlights are:

- Fix several warning for ebtables by yourself.

- Fix one bug in IPVS FTP helper from Hans Schillstrom.

- Three fixes for the new ipset subsystem from Jozsef.

Please pull from:

git://1984.lsi.us.es/net-2.6 pablo/nf-2.6-updates

Thanks!

David Miller (1):
  netfilter: Fix several warnings in compat_mtw_from_user().

Hans Schillstrom (1):
  IPVS: bug in ip_vs_ftp, same list heaad used in all netns.

Jozsef Kadlecsik (3):
  netfilter: ipset: Use proper timeout value to jiffies conversion
  netfilter: ipset: remove unused variable from type_pf_tdel()
  netfilter: ipset: fix ip_set_flush return code

 include/linux/netfilter/ipset/ip_set_ahash.h   |    4 +-
 include/linux/netfilter/ipset/ip_set_timeout.h |   18 ++++++++-------
 include/net/ip_vs.h                            |    3 +-
 net/bridge/netfilter/ebtables.c                |    6 +++-
 net/netfilter/ipset/ip_set_core.c              |    2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                 |   27 ++++++++++++++++-------
 6 files changed, 38 insertions(+), 22 deletions(-)

-- 
1.7.2.5

