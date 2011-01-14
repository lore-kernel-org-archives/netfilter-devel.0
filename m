From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/12] ipset kernel patches
Date: Sat, 15 Jan 2011 00:23:44 +0100
Message-ID: <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:35710 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1ANXX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:23:58 -0500
In-Reply-To: yes
References: yes
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Please review and consider for applying the following patches, which
are the kernel part of the ipset 5.x release.

Best regards,
Jozsef

Jozsef Kadlecsik (12):
  IP set core support
  bitmap:ip set type support
  bitmap:ip,mac type support
  bitmap:port set type support
  hash:ip set type support
  hash:ip,port set type support
  hash:ip,port,ip set type support
  hash:ip,port,net set type support
  hash:net set type support
  hash:net,port set type support
  list:set set type support
  "set" match and "SET" target support

 include/linux/netfilter/ipset/ip_set.h         |  522 ++++++++
 include/linux/netfilter/ipset/ip_set_ahash.h   | 1074 ++++++++++++++++
 include/linux/netfilter/ipset/ip_set_bitmap.h  |   31 +
 include/linux/netfilter/ipset/ip_set_getport.h |  126 ++
 include/linux/netfilter/ipset/ip_set_hash.h    |   26 +
 include/linux/netfilter/ipset/ip_set_kernel.h  |   15 +
 include/linux/netfilter/ipset/ip_set_list.h    |   27 +
 include/linux/netfilter/ipset/ip_set_timeout.h |  127 ++
 include/linux/netfilter/ipset/pfxlen.h         |   16 +
 include/linux/netfilter/nfnetlink.h            |    3 +-
 include/linux/netfilter/xt_set.h               |   55 +
 net/netfilter/Kconfig                          |   14 +
 net/netfilter/Makefile                         |    4 +
 net/netfilter/ipset/Kconfig                    |  121 ++
 net/netfilter/ipset/Makefile                   |   24 +
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  728 +++++++++++
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  661 ++++++++++
 net/netfilter/ipset/ip_set_bitmap_port.c       |  649 ++++++++++
 net/netfilter/ipset/ip_set_core.c              | 1556 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_ip.c           |  485 ++++++++
 net/netfilter/ipset/ip_set_hash_ipport.c       |  570 +++++++++
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  591 +++++++++
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  657 ++++++++++
 net/netfilter/ipset/ip_set_hash_net.c          |  486 ++++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |  606 +++++++++
 net/netfilter/ipset/ip_set_list_set.c          |  589 +++++++++
 net/netfilter/ipset/pfxlen.c                   |  289 +++++
 net/netfilter/xt_set.c                         |  370 ++++++
 28 files changed, 10421 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/ipset/ip_set.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_bitmap.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_getport.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_hash.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_kernel.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_list.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_timeout.h
 create mode 100644 include/linux/netfilter/ipset/pfxlen.h
 create mode 100644 include/linux/netfilter/xt_set.h
 create mode 100644 net/netfilter/ipset/Kconfig
 create mode 100644 net/netfilter/ipset/Makefile
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_ip.c
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_ipmac.c
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_port.c
 create mode 100644 net/netfilter/ipset/ip_set_core.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipport.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportnet.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_net.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_netport.c
 create mode 100644 net/netfilter/ipset/ip_set_list_set.c
 create mode 100644 net/netfilter/ipset/pfxlen.c
 create mode 100644 net/netfilter/xt_set.c

