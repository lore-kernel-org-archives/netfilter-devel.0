From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/13] ipset kernel patches v3
Date: Mon, 31 Jan 2011 23:52:55 +0100
Message-ID: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:53436 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722Ab1AaWxK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:53:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here follows the updated ipset kernel patches. The list of changes compared
to the previous one:

- Separate ipset errnos completely from system ones and bump protocol
  version
- Use better error codes in xt_set.c
- Fix sparse warning about shadowed definition
- bitmap:ip type: flavour specific adt functions
- bitmap:port type: flavour specific adt functions
- Move the type specificic attribute validation to the core
- Use vzalloc() instead of __vmalloc()
- Use meaningful error messages in xt_set.c
- Constified attribute cannot be written
- Send (N)ACK at dumping only when NLM_F_ACK is set
- Correct the error codes: use ENOENT and EMSGSIZE

[Because the protocol changed (NLM_F_ACK is used at dumping and error codes
are changed), the protocol version number is incremented.]

Best regards,
Jozsef

Jozsef Kadlecsik (13):
  NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros
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

 include/linux/netfilter/ipset/ip_set.h         |  452 +++++++
 include/linux/netfilter/ipset/ip_set_ahash.h   | 1074 +++++++++++++++
 include/linux/netfilter/ipset/ip_set_bitmap.h  |   31 +
 include/linux/netfilter/ipset/ip_set_getport.h |   11 +
 include/linux/netfilter/ipset/ip_set_hash.h    |   26 +
 include/linux/netfilter/ipset/ip_set_list.h    |   27 +
 include/linux/netfilter/ipset/ip_set_timeout.h |  127 ++
 include/linux/netfilter/ipset/pfxlen.h         |   35 +
 include/linux/netfilter/nfnetlink.h            |    3 +-
 include/linux/netfilter/xt_set.h               |   55 +
 include/net/netlink.h                          |    9 +
 net/netfilter/Kconfig                          |   14 +
 net/netfilter/Makefile                         |    4 +
 net/netfilter/ipset/Kconfig                    |  121 ++
 net/netfilter/ipset/Makefile                   |   24 +
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  588 +++++++++
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  655 ++++++++++
 net/netfilter/ipset/ip_set_bitmap_port.c       |  520 ++++++++
 net/netfilter/ipset/ip_set_core.c              | 1662 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_getport.c           |  136 ++
 net/netfilter/ipset/ip_set_hash_ip.c           |  467 +++++++
 net/netfilter/ipset/ip_set_hash_ipport.c       |  547 ++++++++
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  565 ++++++++
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  631 +++++++++
 net/netfilter/ipset/ip_set_hash_net.c          |  461 +++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |  581 +++++++++
 net/netfilter/ipset/ip_set_list_set.c          |  584 +++++++++
 net/netfilter/ipset/pfxlen.c                   |  291 +++++
 net/netfilter/xt_set.c                         |  359 +++++
 29 files changed, 10059 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/netfilter/ipset/ip_set.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_bitmap.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_getport.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_hash.h
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
 create mode 100644 net/netfilter/ipset/ip_set_getport.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipport.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportnet.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_net.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_netport.c
 create mode 100644 net/netfilter/ipset/ip_set_list_set.c
 create mode 100644 net/netfilter/ipset/pfxlen.c
 create mode 100644 net/netfilter/xt_set.c

