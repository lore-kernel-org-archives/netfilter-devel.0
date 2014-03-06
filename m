From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/8] ipset patches for nf-next
Date: Thu,  6 Mar 2014 10:23:40 +0100
Message-ID: <1394097828-27901-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53947 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbaCFJXw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:23:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next series of patches:

* Follow the manual page behavior for the SET target at list:set
  type of sets when the set contains both inet and inet6 type of sets,
  from Sergey Popovich
* Fix coccinelle warnings about 0/1 return values instead of false/true,
  from Fengguang Wu
* Introduce the hash:ip,mark hash type from Vytas Dauksa
* Add markmask option to hash:ip,mark type from Vytas Dauksa
* Prepare the kernel for create option flags when no extension is needed
  from Jozsef Kadlecsik
* Fix ABI breakage by the markmask option patch, from Florian Westphal
* Move registration message to init from net_init from Ilia Mirkin
* Add forceadd kernel support for hash set types from Josh Hunt.

You can pull the changes from

	git://blackhole.kfki.hu/nf-next master

Thanks,
Jozsef
----------------------------------------------------------------

The following changes since commit 0768b3b3d228c5acf2075f40f3d25cda30011d4f:

  netfilter: nf_tables: add optional user data area to rules (2014-02-27 16:56:00 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 07cf8f5ae2657ac495b906c68ff3441ff8ba80ba:

  netfilter: ipset: add forceadd kernel support for hash set types (2014-03-06 09:31:43 +0100)

----------------------------------------------------------------
Fengguang Wu (1):
      netfilter: ipset: Add hash: fix coccinelle warnings

Florian Westphal (1):
      netfilter: ipset: kernel: uapi: fix MARKMASK attr ABI breakage

Ilia Mirkin (1):
      netfilter: ipset: move registration message to init from net_init

Josh Hunt (1):
      netfilter: ipset: add forceadd kernel support for hash set types

Jozsef Kadlecsik (1):
      netfilter: ipset: Prepare the kernel for create option flags when no extension is needed

Sergey Popovich (1):
      netfilter: ipset: Follow manual page behavior for SET target on list:set

Vytas Dauksa (2):
      netfilter: ipset: add hash:ip,mark data type to ipset
      netfilter: ipset: add markmask for hash:ip,mark data type

 include/linux/netfilter/ipset/ip_set.h       |   15 +-
 include/uapi/linux/netfilter/ipset/ip_set.h  |   12 +
 net/netfilter/ipset/Kconfig                  |    9 +
 net/netfilter/ipset/Makefile                 |    1 +
 net/netfilter/ipset/ip_set_core.c            |    8 +-
 net/netfilter/ipset/ip_set_hash_gen.h        |   43 ++++
 net/netfilter/ipset/ip_set_hash_ip.c         |    3 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  321 ++++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ipport.c     |    3 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |    3 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |    3 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    3 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |    3 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |   10 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |    3 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |    3 +-
 16 files changed, 423 insertions(+), 20 deletions(-)
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipmark.c
