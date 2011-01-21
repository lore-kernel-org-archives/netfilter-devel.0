From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/13] ipset kernel patches v2
Date: Fri, 21 Jan 2011 15:01:53 +0100
Message-ID: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37595 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1AUOCI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:02:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here follows the updated ipset kernel patches. The terse list of the changes is

- Fix trailing whitespaces and pr_* messages
- Un-inline functions which are not small enough
- Fix module loading at create/header commands
- Fix wrong kzalloc flag in type_pf_expire
- The get_ip*_port functions are too large to be inlined, moved into the core
- Add missing __GFP_HIGHMEM flag to __vmalloc
- Enforce network-ordered data in the netlink protocol
- Use annotated types and fix sparse warnings
- Move ip_set_alloc, ip_set_free and ip_set_get_ipaddr* into the core
- NETMASK*, HOSTMASK* macros are too generic, replace with inline functions
- Use static LIST_HEAD() for ip_set_type_list
- Move NLA_PUT_NET* macros to include/net/netlink.h
- The module parameter max_sets should be unsigned int
- Get rid of ip_set_kernel.h
- Fix the placement style of boolean operators at continued lines

Vast of the changes are based on Patrick's review. I did not introduce nla_strcmp
and nla_strlcpy in the ip_set_rename function, because nla_strcmp would be called
in a loop and that is not optimal. Eric suggested to use vzalloc instead of
__vmalloc, however the former hasn't got a gfp_t argument, so I kept __vmalloc.

Two bugs are fixed compared to the previous version: the module-autoloading
issue and the wrong kzalloc flag in type_pf_expire. Therefore I'll release
a new ipset package today too.

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

 include/linux/netfilter/ipset/ip_set.h         |  449 +++++++
 include/linux/netfilter/ipset/ip_set_ahash.h   | 1074 ++++++++++++++++
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
 net/netfilter/ipset/ip_set_bitmap_ip.c         |  732 +++++++++++
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |  666 ++++++++++
 net/netfilter/ipset/ip_set_bitmap_port.c       |  649 ++++++++++
 net/netfilter/ipset/ip_set_core.c              | 1620 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_getport.c           |  135 ++
 net/netfilter/ipset/ip_set_hash_ip.c           |  484 +++++++
 net/netfilter/ipset/ip_set_hash_ipport.c       |  565 +++++++++
 net/netfilter/ipset/ip_set_hash_ipportip.c     |  584 +++++++++
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  650 ++++++++++
 net/netfilter/ipset/ip_set_hash_net.c          |  480 +++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |  601 +++++++++
 net/netfilter/ipset/ip_set_list_set.c          |  594 +++++++++
 net/netfilter/ipset/pfxlen.c                   |  291 +++++
 net/netfilter/xt_set.c                         |  370 ++++++
 29 files changed, 10430 insertions(+), 1 deletions(-)
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

