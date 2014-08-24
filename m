From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/4] ipset patches for nf-next
Date: Sun, 24 Aug 2014 19:49:39 +0200
Message-ID: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52356 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaHXR4I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:56:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next series of patches:

- Dan Carpenter reported that the static checker emits a warning
  about integer overflows in ip_set_list_set.c, fixed by me
- missing-field-initializer warnings resolved, from Mark Rustad
- In netnet and netportnet hash types the range support for IPv4
  was broken, fixed by Sergey Popovich
- A smatch warning about IPSET_ATTR_MARKMASK validation is fixed
  by Vytas Dauksa.

You can pull the changes from

        git://blackhole.kfki.hu/nf-next master

Thanks,
Jozsef
----------------------------------------------------------------
The following changes since commit afc5be3079796b024823bad42dc5ebf716453575:

  netfilter: nft_meta: Add cpu attribute support (2014-08-24 14:08:46 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 1b05756c48ea07ced9604ef01d11194d936da163:

  netfilter: ipset: Fix warn: integer overflows 'sizeof(*map) + size * set->dsize' (2014-08-24 19:33:10 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix warn: integer overflows 'sizeof(*map) + size * set->dsize'

Mark Rustad (1):
      netfilter: ipset: Resolve missing-field-initializer warnings

Sergey Popovich (1):
      netfilter: ipset: netnet,netportnet: Fix value range support for IPv4

Vytas Dauksa (1):
      netfilter: ipset: Removed invalid IPSET_ATTR_MARKMASK validation

 include/linux/netfilter/ipset/ip_set_list.h  |  1 +
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  4 ++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  4 ++--
 net/netfilter/ipset/ip_set_bitmap_port.c     |  4 ++--
 net/netfilter/ipset/ip_set_hash_gen.h        |  2 +-
 net/netfilter/ipset/ip_set_hash_ip.c         |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipport.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  8 ++++----
 net/netfilter/ipset/ip_set_hash_netnet.c     | 13 +++++++------
 net/netfilter/ipset/ip_set_hash_netportnet.c |  6 ++++--
 net/netfilter/ipset/ip_set_list_set.c        |  4 +++-
 11 files changed, 34 insertions(+), 28 deletions(-)
